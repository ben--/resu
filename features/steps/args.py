from behave import when
import sure

import subprocess as sp

@when(u'the user runs "{}"')
def step_impl(context, command):
    args = command.split(' ')
    p = sp.Popen(['docker', 'run', '--rm', 'resu-testrun-docker'] + args,
                 stdout=sp.PIPE, stderr=sp.PIPE)
    context.stdout, context.stderr = p.communicate()
    context.returncode = p.returncode

@then(u'a usage message is printed')
def step_impl(context):
    context.stdout.should.match(r'usage: resu .*')
