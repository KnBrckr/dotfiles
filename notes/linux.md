# Linux

## Creating Users

  % useradd -m  -s /bin/zsh -c "Ken Brucker"  -g users -G wheel kbrucker
  % passwd kbrucker


## Enable Core files

	% ulimit -S -c unlimited
