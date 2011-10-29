#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Intelligently and interactively installs dot files from the same directory using
symbolic links from the home directory.
"""

import os
import sys

files_to_ignore = (
    "deploy.py",
    "LICENSE",
    "README.md"
)

def main():
    home_dir = os.environ['HOME']
    repo_dir = os.path.dirname(os.path.realpath(__file__))

    print "Home directory: %s" % home_dir
    print "Repo directory: %s" % repo_dir

    dot_files = os.listdir(repo_dir)
    dot_files.sort()

    replace_all = False

    for dot_file in dot_files:
        if dot_file.startswith('.') or dot_file in files_to_ignore:
            continue

        full_dot_file = os.path.join(repo_dir, dot_file)
        proposed_link_file = os.path.join(home_dir, '.' + dot_file)

        if os.path.exists(proposed_link_file):
            if os.path.islink(proposed_link_file):
                if os.readlink(proposed_link_file) == full_dot_file:
                    print 'Skipping already deployed dot file: %s' % proposed_link_file
                    continue

            if replace_all:
                answer = 'y'
            else:
                answer = raw_input('Overwrite? %s [ynaq]: ' % proposed_link_file).strip()

            if answer == 'q':
                print 'Quitting without overwriting %s' % proposed_link_file
                sys.exit()
            elif answer == 'n':
                print 'Skipping %s' % proposed_link_file
                continue
            elif answer in ('a', 'y'):
                if answer == 'a':
                    replace_all = True

                print full_dot_file + ' => ' + proposed_link_file
                os.remove(proposed_link_file)
                os.symlink(full_dot_file, proposed_link_file)
            else:
                print 'Did not understand input. Quitting.'
                sys.exit()

        else:
            print full_dot_file + ' => ' + proposed_link_file
            os.symlink(full_dot_file, proposed_link_file)

if __name__ == '__main__':
    main()
