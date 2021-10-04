#!/bin/bash

export DOCKER_SCAN_SUGGEST=false

run_in_docker() {
    local args=("$@")
    local docker_run_args=("${args[@]:0:$(( ${#args[@]} - 1 ))}")
    MKDO_DOCKER_IMAGE="${args[$(( ${#args[@]} - 1 ))]}"

    local do_script="$(basename -- ${BASH_SOURCE[1]})"
    local source_dir="$(dirname "$do_dir")"

    if [[ $MKDO_DOCKER_IMAGE != ${MKDO_DOCKER_CONTAINER-} ]]; then
        echo "Base Docker: $MKDO_DOCKER_IMAGE"
        docker build ${DOCKER_QUIET-} \
            --force-rm --rm=true \
            -t "$MKDO_DOCKER_IMAGE" \
            -< "$do_dir/$do_script.Dockerfile"

        create_user "$MKDO_DOCKER_IMAGE"

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

    local user_docker_dir="$do_dir/.mkdo-$(echo "$user_docker" | sed -e 's,/,-,g')"
    if [[ -e "$user_docker_dir" ]]; then
        rm -rf "$user_docker_dir"
    fi
    mkdir "$user_docker_dir"

    if [[ ${2-} = --with-docker ]]; then
        local docker_version=$(docker version --format '{{.Server.Version}}' | sed -e 's/-/~/g')

        if [[ "${docker_version}" =~ ~rc[0-9]+$ ]]; then
            cat > "$user_docker_dir/docker.list" <<EOF
deb https://apt.dockerproject.org/repo debian-jessie testing
EOF
        else
        cat > "$user_docker_dir/docker.list" <<EOF
deb https://apt.dockerproject.org/repo debian-jessie main
EOF
        fi
        local docker_in_docker="
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
 && apt-key adv \
        --keyserver hkp://p80.pool.sks-keyservers.net:80 \
        --recv-keys 58118E89F3A912897C070ADBF76221572C52609D \

COPY docker.list /etc/apt/sources.list.d/docker.list

RUN apt-get update \
 && apt-cache policy docker-engine \
 && apt-get install -y --no-install-recommends \
        docker-engine=\$(apt-cache madison docker-engine | awk '{print \$3}' | grep $docker_version)
"
        if [[ $(uname -s) = Linux ]]; then
            local outer_docker_gid=$(getent group docker | cut -f 3 -d :)
            local docker_in_docker="$docker_in_docker
RUN $(upsert_group $outer_docker_gid docker_in_docker)
RUN usermod -aG docker_in_docker $user"
        else
            # FIXME: No docs behind this magical group -- may change with Docker for Mac beta...
            local docker_in_docker="$docker_in_docker
RUN groupadd --gid 50 docker_in_docker
RUN usermod -aG docker_in_docker $user"
        fi
    fi

    cat > "$user_docker_dir/Dockerfile" <<EOF
FROM $root_docker

RUN getent group $group && groupdel $group || true
RUN $(upsert_group $gid $group)
RUN useradd $user --uid $uid --gid $gid

${docker_in_docker-}

USER $user
EOF

    echo "User Docker: $user_docker"
    docker build ${DOCKER_QUIET-} \
        --force-rm --rm=true \
        -t "$user_docker" \
        "$user_docker_dir"
}
