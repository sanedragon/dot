#!/usr/bin/env python
"""
Intelligently links files in this directory to corresponding dot files in the
home directory.
"""
import os
import sys

files_to_ignore = (
    "deploy.py",
    "LICENSE",
    "README.md"
)

def main():
    home_directory = os.environ['HOME']
    script_directory = os.path.dirname(os.path.realpath(__file__))

    files = get_files().sort()
    for file in files_to_ignore:
        files.remove(file)

def get_files(script_directory):
    """
    Get list of files in the current directory.
    """
    pass

def replace_file():
    """
    Remove existing dot file and replace with a link to a corresponding file
    in this directory.
    """
    pass

if __name__ == '__main__':
    pass
