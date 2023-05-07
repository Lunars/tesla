#!/bin/bash

# This script returns two URLs for your car's configuration.
# The optional `raw` argument leaves all sensitive information in the dump.

# Set the file names for the data values and internal dat.
dataValuesFileName="./export.dump"
internalDatFileName="./internaldat.dump"

# Check if `ldvs` command is available, otherwise use `lvs`.
if command -v ldvs &>/dev/null; then
	ldvs >>${dataValuesFileName}
elif command -v lvs &>/dev/null; then
	lvs >>${dataValuesFileName}
else
	echo "Error: Neither ldvs nor lvs command is available."
	exit 1
fi

# Check if `access-internal-dat.pl` command is available.
if command -v access-internal-dat.pl &>/dev/null; then
	# Use `access-internal-dat.pl` script to get internal dat and store it in a file.
	access-internal-dat.pl --get ${internalDatFileName}
else
	# If `access-internal-dat.pl` is not available, read the contents of `/var/etc/gateway.cfg` and save it to the file.
	cat /var/etc/gateway.cfg >${internalDatFileName}
fi

# If the `raw` argument is not passed, remove sensitive information from the data values file.
if [[ "$*" != "raw" ]]; then
	sed -i '/^BLUETOOTH_address/ d' ${dataValuesFileName}
	sed -i '/^BLUETOOTH_pairedDeviceInfo/ d' ${dataValuesFileName}
	sed -i '/^WIFI_network/ d' ${dataValuesFileName}
fi

# If the `raw` argument is not passed, remove sensitive information from the internal dat file.
if [[ "$*" != "raw" ]]; then
	sed -i '/^vin/ d' ${internalDatFileName}
	sed -i '/^birthday/ d' ${internalDatFileName}
	sed -i '/^#/ d' ${internalDatFileName}
fi

# Upload the internal dat file to transfer.sh and store the URL.
internalDatURL=$(curl --upload-file ${internalDatFileName} https://transfer.sh/internaldat.txt)

# Upload the data values file to transfer.sh and store the URL.
dataValuesURL=$(curl --upload-file ${dataValuesFileName} https://transfer.sh/export.csv)

# Output the URLs for the internal dat and data values files.
echo "internal.dat $internalDatURL"
echo "export.csv $dataValuesURL"

# Remove the temporary files.
rm -rf ${internalDatFileName}
rm -rf ${dataValuesFileName}
