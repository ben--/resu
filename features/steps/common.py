from behave import given, then
import os
import shutil
import subprocess as sp

@given(u'a docker with resu and tini')
def step_impl(context):
    docker_name = 'resu-testrun-docker'
    os.mkdir(docker_name)
    shutil.copy('../build/resu', os.path.join(docker_name, 'resu'))
    with open(os.path.join(docker_name, 'Dockerfile'), 'w') as f:
        f.write("""
FROM debian:8.1

ENV TINI_VERSION v0.9.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

ADD resu /sbin/resu
""")
    assert 0 == sp.call(['docker', 'build', '-t', docker_name, docker_name])
    context.docker_name = docker_name

@then(u'the command exits with an error code')
def step_impl(context):
    raise NotImplementedError(u'STEP: Then the command exits with an error code')
