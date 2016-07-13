from behave import when
import sure

import shlex
import subprocess as sp

@when(u'the user runs "{}"')
def step_impl(context, command):
    args = shlex.split(command)
    p = sp.Popen(['docker', 'run', '--rm', 'resu-testrun-docker'] + args,
                 stdout=sp.PIPE, stderr=sp.PIPE)
    context.stdout, context.stderr = p.communicate()
    context.returncode = p.returncode

@then(u'a usage message is printed')
def step_impl(context):
    context.stdout.should.match(r'usage: resu .*')

@then(u'a usage message is printed on stderr')
def step_impl(context):
    context.stderr.should.match(r'usage: resu .*')

@then(u'the command prints the output "{}"')
def step_impl(context, expected_output):
    context.stdout.rstrip().should.equal(expected_output)
