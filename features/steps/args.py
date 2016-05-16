from behave import when

import subprocess as sp

@when(u'the user runs resu with no arguments')
def step_impl(context):
    context.returncode = sp.call(['docker', 'run', '--rm', 'resu-testrun-docker', '/sbin/resu'])
