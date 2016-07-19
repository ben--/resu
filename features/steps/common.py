from behave import given, then
import os
import shutil
import subprocess as sp

TINI_VERSION = 'v0.9.0'

@given(u'a docker with resu and tini')
def step_impl(context):
    docker_dir = 'docker'
    docker_name = 'resu/acceptance-test-run'
    shutil.rmtree(docker_dir, ignore_errors=True)
    os.mkdir(docker_dir)
    shutil.copy('../build/resu', os.path.join(docker_dir, 'resu'))
    with open(os.path.join(docker_dir, 'Dockerfile'), 'w') as f:
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
    assert 0 == sp.call(['docker', 'build', '-t', docker_name, docker_dir], stdout=sp.PIPE)
    context.docker_name = docker_name

@then(u'a "{}" error message is printed')
def step_impl(context, expected_error):
    context.stderr.should.contain(expected_error)

@then(u'the command exits with an error code')
def step_impl(context):
    assert 0 != context.returncode

@then(u'the command exits without error')
def step_impl(context):
    assert 0 == context.returncode
