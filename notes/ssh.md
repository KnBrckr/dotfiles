# ssh configuration

## Linux Desktop

Make use of keyring - eg. `dnf install seahorse`

## Using ssh-agent

https://unix.stackexchange.com/questions/90853/how-can-i-run-ssh-add-automatically-without-a-password-prompt

In profile:

    if [ -z "$SSH_AUTH_SOCK" ] ; then
      eval `ssh-agent -s`
      ssh-add
    fi

In logout:

    if [ -n "$SSH_AUTH_SOCK" ] ; then
      eval `/usr/bin/ssh-agent -k`
    fi

## ssh-agent with systemd (WSL or server environment)

In .zshrc, etc:
    export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

In ~/.ssh/config

    AddKeysToAgent yes

Onetime setup on host:

    systemctl --user enable ssh-agent
    systemctl --user start ssh-agent
