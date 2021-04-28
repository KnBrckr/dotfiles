# RPM

## View RPM contents

  %# List files
  % rpm -ql --noartifact RPM

  %# List configuration files
  % rpm -qc RPM

  %# Dump all file meta-data contained in RPM
  % rpm -q --dump --noartifact RPM

  %# Display RPM scripts
  % rpm -q --scripts RPM

## RPM variables

  %# Display all variables
  % rpm --showrc
