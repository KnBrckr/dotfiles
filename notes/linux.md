# Linux

## Creating Users

  % useradd -m  -s /bin/zsh -c "Ken Brucker"  -g users -G wheel kbrucker
  % passwd kbrucker


## Enable Core files

	% ulimit -S -c unlimited

## ssh-agent with systemd

In .zshrc, etc:
    export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

In ~/.ssh/config

    AddKeysToAgent yes

Onetime setup on host:

    systemctl --user enable ssh-agent
    systemctl --user start ssh-agent
