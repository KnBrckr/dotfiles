# WSL

https://docs.microsoft.com/en-us/windows/wsl/install-win10
https://docs.microsoft.com/en-us/windows/wsl/initialize-distro

Use Ubuntu 20.04

## Upgrade & Update pkgs

	% sudo apt update && sudo apt upgrade

https://www.nextofwindows.com/how-to-upgrade-existing-wsl-wsl2-ubuntu-18-04-to-20-04

## Shutdown

From powershell:
	wsl.exe --shutdown

## VS Code + WSL

https://code.visualstudio.com/docs/cpp/config-wsl

## Setting Solarized colors in WSL terminal

Colors in order of squares in terminal options:

SOLARIZED HEX     16/8 TERMCOL  XTERM/HEX   L*A*B      RGB         HSB
--------- ------- ---- -------  ----------- ---------- ----------- -----------
base03    #002b36  8/4 brblack  234 #1c1c1c 15 -12 -12   0  43  54 193 100  21
blue      #268bd2  4/4 blue      33 #0087ff 55 -10 -45  38 139 210 205  82  82
green     #859900  2/2 green     64 #5f8700 60 -20  65 133 153   0  68 100  60
cyan      #2aa198  6/6 cyan      37 #00afaf 60 -35 -05  42 161 152 175  74  63
red       #dc322f  1/1 red      160 #d70000 50  65  45 220  50  47   1  79  86
magenta   #d33682  5/5 magenta  125 #af005f 50  65 -05 211  54 130 331  74  83
yellow    #b58900  3/3 yellow   136 #af8700 60  10  65 181 137   0  45 100  71
base2     #eee8d5  7/7 white    254 #e4e4e4 92 -00  10 238 232 213  44  11  93
base02    #073642  0/4 black    235 #262626 20 -12 -12   7  54  66 192  90  26
base0     #839496 12/6 brblue   244 #808080 60 -06 -03 131 148 150 186  13  59
base01    #586e75 10/7 brgreen  240 #585858 45 -07 -07  88 110 117 194  25  46
base1     #93a1a1 14/4 brcyan   245 #8a8a8a 65 -05 -02 147 161 161 180   9  63
orange    #cb4b16  9/3 brred    166 #d75f00 50  50  55 203  75  22  18  89  80
violet    #6c71c4 13/5 brmagenta 61 #5f5faf 50  15 -45 108 113 196 237  45  77
base00    #657b83 11/7 bryellow 241 #626262 50 -07 -07 101 123 131 195  23  51
base3     #fdf6e3 15/7 brwhite  230 #ffffd7 97  00  10 253 246 227  44  10  99

## Secure XWindows server

https://stackoverflow.com/questions/66768148/how-to-setup-vcxsrv-for-use-with-wsl2

```
% sudo apt install -y xauth coreutils gawk gnome-terminal
% xauth list # this should be an empty list
% magiccookie=$(echo '{some-pass-phrase}'|tr -d '\n\r'|md5sum|gawk '{print $1}')
% xauth add host.docker.internal:0 . $magiccookie
% cp ~/.Xauthority /mnt/c/Users/{WindowsUserName}
% export DISPLAY=host.docker.internal:0
```

Should show xauth key

```
> 'C:\Program Files\VcXsrv\xauth' list
```

Setup shortcut with command:

```
"C:\Program Files\VcXsrv\vcxsrv.exe" -multiwindow -clipboard -nowgl -auth "c:\Users\kbrucker\.Xauthority"
```

-nowgl is required to get OpenGL 3.x libraries vs. v1.4 that WGL uses.

## Xserver timeouts workaround

Ref: https://github.com/microsoft/WSL/issues/5339#issuecomment-771030005

	sudo sysctl -w net.ipv4.tcp_keepalive_intvl=60 net.ipv4.tcp_keepalive_probes=5 net.ipv4.tcp_keepalive_time=300

Setup as an suid script and include in bashrc to set on login.
Or add to /etc/sudoer:
kbrucker localhost=NOPASSWD: /usr/sbin/sysctl
