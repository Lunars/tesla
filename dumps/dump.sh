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
	sed -i '/^BLUETOOTH_pairedDeviceInfoString/ d' ${dataValuesFileName}
	sed -i '/^CONN_cellEid/ d' ${dataValuesFileName}
	sed -i '/^CONN_cellIMEI/ d' ${dataValuesFileName}
	sed -i '/^CONN_cellInterfaceIP/ d' ${dataValuesFileName}
	sed -i '/^CONN_cellModemIP/ d' ${dataValuesFileName}
	sed -i '/^CONN_cellPhoneNumber/ d' ${dataValuesFileName}
	sed -i '/^CONN_cellSimNumber/ d' ${dataValuesFileName}
	sed -i '/^CONN_vpnInterfaceIP/ d' ${dataValuesFileName}
	sed -i '/^DAS_lastKnownPhoneGpsLocation/ d' ${dataValuesFileName}
	sed -i '/^GUI_homeAddressJson/ d' ${dataValuesFileName}
	sed -i '/^GUI_homeLocation/ d' ${dataValuesFileName}
	sed -i '/^GUI_navLocalizedCurrentStreetName/ d' ${dataValuesFileName}
	sed -i '/^GUI_odometer/ d' ${dataValuesFileName}
	sed -i '/^GUI_PINToDrivePassword/ d' ${dataValuesFileName}
	sed -i '/^GUI_valetModePassword/ d' ${dataValuesFileName}
	sed -i '/^GUI_vehicleName/ d' ${dataValuesFileName}
	sed -i '/^GUI_workLocation/ d' ${dataValuesFileName}
	sed -i '/^LINK_wifiAvailableNetworks/ d' ${dataValuesFileName}
	sed -i '/^LINK_wifiKnownNetworks/ d' ${dataValuesFileName}
	sed -i '/^LINK_wifiSsid/ d' ${dataValuesFileName}
	sed -i '/^LOC_correctedLat/ d' ${dataValuesFileName}
	sed -i '/^LOC_correctedLng/ d' ${dataValuesFileName}
	sed -i '/^LOC_estimatedLat/ d' ${dataValuesFileName}
	sed -i '/^LOC_estimatedLngNative/ d' ${dataValuesFileName}
	sed -i '/^LOC_estimatedLngWGS/ d' ${dataValuesFileName}
	sed -i '/^LOC_estimatedLocation/ d' ${dataValuesFileName}
	sed -i '/^LOC_estimatedLon/ d' ${dataValuesFileName}
	sed -i '/^LOC_geoLat/ d' ${dataValuesFileName}
	sed -i '/^LOC_geoLocation/ d' ${dataValuesFileName}
	sed -i '/^LOC_geoLon/ d' ${dataValuesFileName}
	sed -i '/^MEDIA_authToken/ d' ${dataValuesFileName}
	sed -i '/^MEDIA_rdioPassword/ d' ${dataValuesFileName}
	sed -i '/^MEDIA_rdioTeslaPassword/ d' ${dataValuesFileName}
	sed -i '/^MEDIA_rdioTeslaUsername/ d' ${dataValuesFileName}
	sed -i '/^MEDIA_rdioTeslaUsername/ d' ${dataValuesFileName}
	sed -i '/^MEDIA_rdioUsername/ d' ${dataValuesFileName}
	sed -i '/^MEDIA_slackerPassword/ d' ${dataValuesFileName}
	sed -i '/^MEDIA_slackerTeslaPassword/ d' ${dataValuesFileName}
	sed -i '/^MEDIA_slackerTeslaUsername/ d' ${dataValuesFileName}
	sed -i '/^MEDIA_slackerUsername/ d' ${dataValuesFileName}
	sed -i '/^MEDIA_spotifyCredentialsBlob/ d' ${dataValuesFileName}
	sed -i '/^MEDIA_spotifyPassword/ d' ${dataValuesFileName}
	sed -i '/^MEDIA_spotifyTeslaPassword/ d' ${dataValuesFileName}
	sed -i '/^MEDIA_spotifyTeslaUsername/ d' ${dataValuesFileName}
	sed -i '/^MEDIA_spotifyUsername/ d' ${dataValuesFileName}
	sed -i '/^MEDIA_teslaPassword/ d' ${dataValuesFileName}
	sed -i '/^MEDIA_teslaUsername/ d' ${dataValuesFileName}
	sed -i '/^MEDIA_tuneInPassword/ d' ${dataValuesFileName}
	sed -i '/^MEDIA_tuneInUsername/ d' ${dataValuesFileName}
	sed -i '/^NAV_vehicleCity/ d' ${dataValuesFileName}
	sed -i '/^NAV_vehicleLatitude/ d' ${dataValuesFileName}
	sed -i '/^NAV_vehicleLocation/ d' ${dataValuesFileName}
	sed -i '/^NAV_vehicleLongitude/ d' ${dataValuesFileName}
	sed -i '/^NAV_vehicleState/ d' ${dataValuesFileName}
	sed -i '/^RADIO_TextXMRadioIDCode/ d' ${dataValuesFileName}
	sed -i '/^SPOTIFY_loggedInUsername/ d' ${dataValuesFileName}
	sed -i '/^TEL_deviceId/ d' ${dataValuesFileName}
	sed -i '/^TEL_tripId/ d' ${dataValuesFileName}
	sed -i '/^VAPI_hiResOdometer/ d' ${dataValuesFileName}
	sed -i '/^VAPI_keys/ d' ${dataValuesFileName}
	sed -i '/^VAPI_odometer/ d' ${dataValuesFileName}
	sed -i '/^WIFI_macAddress/ d' ${dataValuesFileName}
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
