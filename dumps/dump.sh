#!/usr/bin/env sh

# Usage: bash ./dump.sh
# Usage: bash ./dump.sh raw

# Returns two URLs for your car's config

dataValuesFileName="./export.dump"
internalDatFileName="./internaldat.dump"
format="csv" # options: csv, json

curl -s "http://localhost:4035/get_data_values?format=$format&show_invalid=false" >> ${dataValuesFileName}
access-internal-dat.pl --get ${internalDatFileName}

if [[ "$@" != "raw" ]]; then
	sed -i '/^BLUETOOTH_pairedDeviceInfo/ d' ${dataValuesFileName}
	sed -i '/^BLUETOOTH_pairedDeviceInfoString/ d' ${dataValuesFileName}
	sed -i '/^CONN_cellIMEI/ d' ${dataValuesFileName}
	sed -i '/^CONN_cellInterfaceIP/ d' ${dataValuesFileName}
	sed -i '/^CONN_cellModemIP/ d' ${dataValuesFileName}
	sed -i '/^CONN_cellPhoneNumber/ d' ${dataValuesFileName}
	sed -i '/^CONN_cellSimNumber/ d' ${dataValuesFileName}
	sed -i '/^CONN_vpnInterfaceIP/ d' ${dataValuesFileName}
	sed -i '/^GUI_navLocalizedCurrentStreetName/ d' ${dataValuesFileName}
	sed -i '/^GUI_odometer/ d' ${dataValuesFileName}
	sed -i '/^GUI_PINToDrivePassword/ d' ${dataValuesFileName}
	sed -i '/^GUI_valetModePassword/ d' ${dataValuesFileName}
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
	sed -i '/^MEDIA_slackerPassword/ d' ${dataValuesFileName}
	sed -i '/^MEDIA_slackerTeslaPassword/ d' ${dataValuesFileName}
	sed -i '/^MEDIA_slackerTeslaUsername/ d' ${dataValuesFileName}
	sed -i '/^MEDIA_slackerUsername/ d' ${dataValuesFileName}
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
	sed -i '/^TEL_deviceId/ d' ${dataValuesFileName}
	sed -i '/^TEL_tripId/ d' ${dataValuesFileName}
	sed -i '/^VAPI_hiResOdometer/ d' ${dataValuesFileName}
	sed -i '/^VAPI_odometer/ d' ${dataValuesFileName}
	sed -i '/^WIFI_macAddress/ d' ${dataValuesFileName}
	sed -i '/^WIFI_network/ d' ${dataValuesFileName}
fi

if [[ "$@" != "raw" ]]; then
	sed -i '/^vin/ d' ${internalDatFileName}
	sed -i '/^birthday/ d' ${internalDatFileName}
	sed -i '/^#/ d' ${internalDatFileName}
fi

internalDatURL=$(cat ${internalDatFileName} | socat - tcp:termbin.com:9999)
dataValuesURL=$(cat ${dataValuesFileName} | socat - tcp:termbin.com:9999)

rm -rf ${dataValuesFileName}
rm -rf ${internalDatFileName}

echo "internal.dat $internalDatURL"
echo "export.$format $dataValuesURL"
