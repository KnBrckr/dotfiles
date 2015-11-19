#!/opt/local/bin/perl
#
# Displays network traffic for each active 'en' interface
#
# Designed to be used in geektool.  Each time script runs traffic stats will be gathered and compared to 
# results from previous run if they are available
#

# Temp file for Traffic data
$traffic_file = $ENV{TMPDIR} . 'netspeed.geektool.data';

use JSON;

$tLast = restoreTraffic();
$tNow = getTraffic();
saveTraffic($tNow);

# First run, no traffic data saved
if (! $tLast) {
	print "No saved data available: ";
	exit;
}

# Runs too close together, exit
$secs = $tNow->{time} - $tLast->{time};
if ($secs < 1) {
	print "Insufficient time elapsed since last run";
	exit;
}

printf("\tDown\t\t\tUp\n");
foreach $interface (sort (keys %{$tNow->{iface}})) {
  $ips = getIp($interface);
  $kin = ($tNow->{iface}->{$interface}[0] - $tLast->{iface}->{$interface}[0]) / 1024 / $secs;
  $kout = ($tNow->{iface}->{$interface}[1] - $tLast->{iface}->{$interface}[1]) / 1024 / $secs;
  printf "%s:\t%0.2f Kb/sec\t%0.2f Kb/sec\t%s\n", $interface, $kin, $kout, $ips;
}

sub getTraffic() {
  my %traffic;
	$traffic{time} = time();
  my @netstat = `netstat -ibn`;
  foreach my $line (@netstat) {
    next unless $line =~ /^en/;
    my @fields = split(/\s+/,$line);
    # Get In and Out bytes for the interface
    $traffic{iface}{$fields[0]} = [ $fields[6], $fields[9] ];
  }
  
  return \%traffic;
}

sub saveTraffic($) {
	my ($traffic) = @_;
	
	open (my $out, ">", $traffic_file) or die "Can't open data file: $!";
	print $out to_json($traffic);
	close $out or die "$out: $!";
}

sub restoreTraffic() {
	open (my $in, "<", $traffic_file) or return 0;
	$data = <$in>;		
	close $in or die "$in: $!";
	# Possible for a empty file to be created
	return $data ? from_json($data) : 0;
}

sub getIp($) {
	my ($interface) = @_;
  chomp(my $ip = `ipconfig getifaddr $interface 2> /dev/null`);
  return $ip;
}
