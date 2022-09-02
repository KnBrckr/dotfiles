# Networking

## Show bound UDP ports

  % netstat -n --udp --listen
  % netstat -nul

## Report on port connectivity using netcat

  % nc -zv <ip> <port>    # TCP
  % nc -u -zv <ip> <port> # UDP

## nping is a part of nmap package

### Send SYN TCP packet

  % sudo nping --tcp --dest-port 4001 -c1 128.0.0.1

### Send TPC Connect

  % sudo nping --tcp-connect -p 4001 -c1 127.0.0.1

## Firewall
	% firewall-cmd --state
	% firewall-cmd --list-services
	% firewall-cmd --list-ports

### Adding ports to firewall

	% firewall-cmd --permanent --add-port=4001/tcp
	% firewall-cmd --permanent --add-port=3601/udp
  % firewall-cmd --reload
