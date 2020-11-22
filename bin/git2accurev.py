#!/usr/bin/python3
'''
File: git2accurev.py
Description: import git repository to Accurev

Usage: python git2accurev.py git-range

Will update Accurev based on git history specified in git range
'''

import subprocess
import tempfile
import os
import sys

# Retrive get log for the provided range
def getGitLog(range=''):
    command = ['git', 'log', '--format=%h%n%cd%n%B%x00']
    if range != '':
        command.append(range)
    gitLog = subprocess.run(command,
                            stdout=subprocess.PIPE,
                            stderr=subprocess.PIPE)
    if gitLog.returncode != 0:
        print("git log failed -- exiting")
        exit(1)
    return gitLog.stdout.decode().split('\0')


def checkout(commit):
    if subprocess.run(['git', 'checkout', commit]).returncode != 0:
        print("git checkout failed -- exiting")
        exit(1)


# Use AccuRev stat command to retrieve a list of files matching requested status
# -x => Files to be added
# -mD => Files to be undeleted
# -m => Modified files
# -M => Files to be deleted
def ac_stat(type):
    stat = subprocess.run(['accurev.exe', 'stat', type, '-fl'],
                          stdout=subprocess.PIPE,
                          stderr=subprocess.PIPE)
    if stat.returncode != 0:
        print("accurev stat failed -- exiting")
        exit(1)
    return stat.stdout.decode()

# Run the requested accurev command
def ac_run(stat_option, command, comment_file):

    # Get list of files to be included in operation
    files = ac_stat(stat_option)
    if (len(files) > 0):
        # Create temp file containing list of files
        fl = mktemp(files)
        result = subprocess.run(['accurev.exe', command, '-c', '@' +
                                comment_file.replace('/mnt/c', ''), '-l', fl.replace('/mnt/c', '')])
        os.unlink(fl)
        # accurev undefunct will fail with a CRC error if the file has been modified.
        if command != 'undefunct' and result.returncode != 0:
            print("accurev command ", command, " failed -- exiting")
            exit(1)

# Create a temp file with the provided contents
def mktemp(contents):
    temp_fd, temp_path = tempfile.mkstemp(dir=os.environ.get('WINTMP'))
    with open(temp_path, "w") as f:
        f.write(contents)
    os.close(temp_fd)
    return temp_path

# Apply changes from a git commit to AccuRev preserving the git comment
# One git commit may translate into up to four separate AccuRev commits
# as AccuRev treats as separate actions adding a new file (add), undeleting 
# a file (undefunct), updating an existing file (keep), or deleting a file
# (defunct)
def migrate(comment_file):
    ac_run('-x', 'add', comment_file)
    ac_run('-mD', 'undefunct', comment_file)
    ac_run('-m', 'keep', comment_file)
    ac_run('-M', 'defunct', comment_file)

#
# Main Routine
#

# A git range must be provided
if len(sys.argv) > 1:
    range = sys.argv[1]
else:
    print("usage: %s <git-range>", sys.argv[0])
    print("Please specify git commit range to add to accurev")
    exit(1)

# WINTMP used to create tmp files access by windows accurev.exe CLI.
if os.environ.get('WINTMP') == None:
    print("Please define environment variable WINTMP to reference temp directory in Windows user environment")
    print("eg. export WINTMP=/mnt/c/Users/<username>/tmp")
    exit(1)

# Collect git log for the provided range
log = getGitLog(range)

# Reverse the log order to start from the oldest commit
for commit in reversed(log):
    lines = commit.strip().splitlines()
    if len(lines) == 0:
        continue

    commit = lines.pop(0)
    date = lines.pop(0)
    comment_file = mktemp("\n".join(lines))

    checkout(commit)
    migrate(comment_file)
    os.unlink(comment_file)
