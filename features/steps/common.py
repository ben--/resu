from behave import given, then
import os
import shutil
import subprocess as sp

TINI_VERSION = 'v0.9.0'

@given(u'a docker with resu and tini')
def step_impl(context):
    docker_name = 'resu-testrun-docker'
    shutil.rmtree(docker_name, ignore_errors=True)
    os.mkdir(docker_name)
    shutil.copy('../build/resu', os.path.join(docker_name, 'resu'))
    with open(os.path.join(docker_name, 'Dockerfile'), 'w') as f:
        f.write("""
FROM debian:8.5

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
 && rm -rf /var/lib/apt/lists/* \
 && apt-get clean

RUN curl -L https://github.com/krallin/tini/releases/download/{}/tini > /tini \
 && chmod +x /tini
ENTRYPOINT ["/tini", "--"]

ADD resu /sbin/resu
""".format(TINI_VERSION))
    assert 0 == sp.call(['docker', 'build', '-t', docker_name, docker_name])
    context.docker_name = docker_name

@then(u'the command exits with an error code')
def step_impl(context):
    assert 0 != context.returncode

@then(u'the command exits without error')
def step_impl(context):
    assert 0 == context.returncode
