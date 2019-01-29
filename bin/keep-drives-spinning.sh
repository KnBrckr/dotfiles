#! /bin/bash
#
# While someone is at the keyboard (screen is not locked) keep drives spinning to avoid hard pauses
# when drives spin up for access.

export PATH=$PATH:/opt/local/bin

# Use Screen Saver as a proxy for someone at the keyboard
PID=`pgrep ScreenSaverEngine`

# If VLC is running
if [ "$PID" == '' ] ; then
	timestamp=$(date)
	echo -n "${timestamp} - "
	echo -n "Keyboard occupied, spin plates: "
	
	disk_plist_file=$(mktemp $TMPDIR/keep-spinning.XXXX)
	diskutil list -plist > $disk_plist_file
	
	# Use plutil to convert plist to json
	# Then use jq to extract the VolumesFromDisks section of plist data, convert that to an array and set $volumes
	IFS=$'\n' read -r -d '' -a volumes < <(set -o pipefail; plutil -convert json -o - $disk_plist_file | jq -r '.VolumesFromDisks | .[]' && printf '\0')

	# Walk mounted drives to keep them running
	for DIR in "${volumes[@]}"
	do
		path="/Volumes/${DIR}"
		if [[ ${DIR} != "Macintosh HD" ]] && [[ -d $path ]]
		then
			echo -n "'${DIR}' "
			touch "${path}/.keep-spinning"
		fi
	done
	
	echo ""
	
	rm $disk_plist_file
fi
