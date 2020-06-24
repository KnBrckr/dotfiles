'''
File: git2accurev.py
Description: import git repository to Accurev

Usage: python git2accurev.py [git-range]

Will update Accurev based on git history specified in git range
'''

import subprocess
import tempfile
import os
import sys


def getGitLog(range=''):
    command = ['git', 'log', '--format=%h%n%cd%n%B%x00']
    if range != '':
        command.append(range)
    gitLog = subprocess.run(command,
                            stdout=subprocess.PIPE,
                            stderr=subprocess.PIPE)
    if gitLog.returncode != 0:
        exit(1)
    return gitLog.stdout.decode().split('\0')


def checkout(commit):
    if subprocess.run(['git', 'checkout', commit]).returncode != 0:
        exit(1)


def ac_stat(type):
    stat = subprocess.run(['accurev.exe', 'stat', type, '-fl'],
                          stdout=subprocess.PIPE,
                          stderr=subprocess.PIPE)
    if stat.returncode != 0:
        exit(1)
    return stat.stdout.decode()


def ac_run(stat_option, command, comment_file):
    files = ac_stat(stat_option)
    if (len(files) > 0):
        fl = mktemp(files)
        result = subprocess.run(['accurev.exe', command, '-c', '@' +
                                comment_file.replace('/mnt/c', ''), '-l', fl.replace('/mnt/c', '')])
        os.unlink(fl)
        # accurev undefunct will fail with a CRC error if the returning file has been modified.
        if command != 'undefunct' and result.returncode != 0:
            exit(1)

def mktemp(contents):
    temp_fd, temp_path = tempfile.mkstemp(dir='/mnt/c/Users/kbrucker/tmp')
    with open(temp_path, "w") as f:
        f.write(contents)
    os.close(temp_fd)
    return temp_path


def migrate(comment_file):
    ac_run('-x', 'add', comment_file)
    ac_run('-mD', 'undefunct', comment_file)
    ac_run('-m', 'keep', comment_file)
    ac_run('-M', 'defunct', comment_file)

if len(sys.argv) > 1:
    range = sys.argv[1]
else:
    range = ''

log = getGitLog(range)

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
