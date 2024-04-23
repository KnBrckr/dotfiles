# dnf based package management

## List package contents

	% dnf repoquery -l <package>

## List repositories

	% dnf repolist

## Add epel repolist

    % dnf install epel-release

## Monitoring Linux security updates

List available security updates:

    $ dnf updateinfo list --security

    --with-cve will include CVE details

    $ dnf -q updateinfo list sec # displays only relevant data

List patches for a package

    % dnf updateinfo list openssl

Update security packages

    $ dnf upgrade --security

To include packages needed to fix the given advisory or advisories, in updates:

    $ dnf upgrade --advisory ELSA-xxxx-xxxx
    $ dnf upgrade --advisories ELSA-xxxx-xxxx,ELSA-yyyy-yyyy

To include packages needed to fix the given CVE(s), in updates:

    $ dnf upgrade --cve CVE-xxxx-xxxx,CVE-yyyy-yyyy

## Collect list of packages providing required shared libraries

    ldd lib/* | egrep -v "kbrucker|linux-vdso.so" | sed "s/(0x[a-f0-9]*)//; /^lib\//d; s/.*=>//" | sort | uniq | xargs rpm -q --whatprovides --qf "%{NAME}\n" | sort | uniq | xargs dnf updateinfo list

## Dependencies based on RPM (but has false positives based on library names):

    repoquery --requires --resolve datatrak2flx-oss-2.0.0-6535-bf-kbrucker-Debug.rpm
