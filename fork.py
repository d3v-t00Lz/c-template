#!/usr/bin/env python3

import argparse
import os
import sys


MESSAGE = """\
Successfully forked

To add this to an empty Github/Gitlab/etc...:
$ git remote add origin $GIT_CLONE_URL_GOES_HERE
$ git push -u origin master

Update the TODOs in {name}.spec if you plan to use
"RPM packaging
"""

def _(x):
    print(x)
    retcode = os.system(x)
    assert not retcode, retcode

def parse_args():
    parser = argparse.ArgumentParser(
        description="Forks the project into a new project."
    )
    parser.add_argument(
        'name',
        help='The new project name',
    )
    return parser.parse_args()

def main():
    file_path = os.path.abspath(__file__)
    dirname = os.path.dirname(file_path)
    os.chdir(dirname)

    args = parse_args()
    name = args.name
    assert name
    assert name.islower(), name
    assert name.replace("_", "").isalpha(), name
    assert len(name) < 20, len(name)

    # Replace 'ctemplate' with $name in files
    _(
        "find Makefile .gitignore "
        "-type f "
        "| xargs sed -i 's/ctemplate/{name}/gI'".format(name=name)
    )
    _('mv ctemplate.spec {}.spec'.format(name))
    _('rm -rf .git')
    _('git init .')
    _('git add .')
    _('git commit -am "Initial commit"')
    print(MESSAGE.format(name=name))

if __name__ == "__main__":
    main()
