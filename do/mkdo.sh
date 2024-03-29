#!/bin/bash

export DOCKER_SCAN_SUGGEST=false

run_in_docker() {
    local args=("$@")

    if [ ${args[0]} = --with-docker-in-docker ]; then
        local docker_in_docker=--with-docker-in-docker
        local docker_run_args=( \
            --volume="/var/run/docker.sock:/var/run/docker.sock" \
            "${args[@]:1:$(( ${#args[@]} - 2 ))}" \
        )
    else
        local docker_in_docker=
        local docker_run_args=("${args[@]:0:$(( ${#args[@]} - 1 ))}")
    fi

    MKDO_DOCKER_IMAGE="${args[$(( ${#args[@]} - 1 ))]}"

    local do_script="$(basename -- ${BASH_SOURCE[1]})"
    local source_dir="$(dirname "$do_dir")"

    if [[ $MKDO_DOCKER_IMAGE != ${MKDO_DOCKER_CONTAINER-} ]]; then
        echo "Base Docker: $MKDO_DOCKER_IMAGE"
        docker build ${DOCKER_QUIET-} \
            --force-rm --rm=true \
            -t "$MKDO_DOCKER_IMAGE" \
            -< "$do_dir/$do_script.Dockerfile"

        create_user "$MKDO_DOCKER_IMAGE" ${docker_in_docker}

        local tty=
        if [[ -t 1 ]]; then
            tty=-t
        fi
        docker run $tty \
            --env "MKDO_DOCKER_CONTAINER=$MKDO_DOCKER_IMAGE" \
            --env "source_dir=$source_dir" \
            --rm \
            --sig-proxy=true \
            "${docker_run_args[@]}" \
            "$MKDO_DOCKER_IMAGE"-user \
            "$do_dir/$do_script"
        exit $?
    fi
}

upsert_group()
{
    local gid="$1"
    local group="$2"
    echo "getent group $gid && groupmod --new-name $group \$(getent group $gid | cut -f 1 -d :) || groupadd --gid $gid $group"
}

create_user() {
    local user="$(id -nu)"
    local group="$(id -ng)"
    local uid=$(id -u)
    local gid=$(id -g)

    local root_docker="$1"
    local user_docker="$1-user"

    if [[ ${2-} = --with-docker-in-docker ]]; then
        # FIXME: ensure outer/inner docker version match...

        local docker_in_docker="
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        docker.io
"
        if [[ $(uname -s) = Linux ]]; then
            local outer_docker_gid=$(getent group docker | cut -f 3 -d :)
            local docker_in_docker="$docker_in_docker
RUN $(upsert_group $outer_docker_gid docker_in_docker)
RUN usermod -aG docker_in_docker $user"
        else
            # FIXME: No docs behind this magical group and not clear whether it
            #        is relevant any more.
            # A magical one-time chown of /var/run/docker.sock *inside* a
            # running docker fixed permissions
            local docker_in_docker="$docker_in_docker
RUN groupadd --gid 50 docker_in_docker
RUN usermod -aG docker_in_docker $user"
        fi
    fi

    echo "User Docker: $user_docker"
    docker build ${DOCKER_QUIET-} \
        --force-rm --rm=true \
        -t "$user_docker" \
        -<<EOF
FROM $root_docker

RUN getent group $group && groupdel $group || true
RUN $(upsert_group $gid $group)
RUN useradd $user --uid $uid --gid $gid --create-home

${docker_in_docker-}

USER $user
EOF
}
