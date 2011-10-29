#!/usr/bin/env python
# -*- coding: utf-8 -*-
'''
Intelligently and interactively installs dot files from the same directory using
symbolic links from the home directory.
'''

import os
import sys
import shutil

files_to_ignore = (
    'deploy.py',
    'LICENSE',
    'README.md'
)

possible_ssh_private_key_files = (
    'id_rsa',
    'id_dsa'
)

def main():
    home_dir = os.path.expanduser('~')
    repo_dir = os.path.dirname(os.path.realpath(__file__))

    print 'Home directory: %s' % home_dir
    print 'Repo directory: %s' % repo_dir

    dot_files = os.listdir(repo_dir)
    dot_files.sort()

    replace_all = False

    for dot_file in dot_files:
        if dot_file.startswith('.') or dot_file in files_to_ignore:
            continue

        # git shouldn't have a private key (correctly so)
        # so it needs to be moved aside and restored after
        if dot_file == '.ssh':
            for key_file in possible_ssh_private_key_files:
                full_key_file = os.path.join(home_dir, '.ssh', key_file)
                temp_key_file = os.path.join(home_dir, key_file)
                if os.path.exists(full_key_file):
                    os.rename(full_key_file, temp_key_file)

        full_dot_file = os.path.join(repo_dir, dot_file)
        proposed_link_file = os.path.join(home_dir, '.' + dot_file)

        try:
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
                    try:
                        os.remove(proposed_link_file)
                    except OSError:
                        shutil.rmtree(proposed_link_file)
                    os.symlink(full_dot_file, proposed_link_file)
                else:
                    print 'Did not understand input. Quitting.'
                    sys.exit()

            else:
                print full_dot_file + ' => ' + proposed_link_file
                os.symlink(full_dot_file, proposed_link_file)

        finally:
            if dot_file == '.ssh':
                for key_file in possible_ssh_private_key_files:
                    full_key_file = os.path.join(home_dir, '.ssh', key_file)
                    temp_key_file = os.path.join(home_dir, key_file)
                    if os.path.exists(temp_key_file):
                        os.rename(temp_key_file, full_key_file)


if __name__ == '__main__':
    main()

