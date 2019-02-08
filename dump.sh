#!/usr/bin/env sh

# Usage: ./dump.sh, ./dump.sh raw
# Returns two URLs for your car's config

dataValuesFileName="~/export.dump"
internalDatFileName="~/internaldat.dump"

curl -s "http://localhost:4035/get_data_values?format=csv&show_invalid=true" >> ${dataValuesFileName}

if [[ "$@" != "raw" ]]; then
	sed -i '/^BLUETOOTH_pairedDeviceInfo/ d' ${dataValuesFileName}
	sed -i '/^BLUETOOTH_pairedDeviceInfoString/ d' ${dataValuesFileName}
	sed -i '/^CONN_cellIMEI/ d' ${dataValuesFileName}
	sed -i '/^CONN_cellInterfaceIP/ d' ${dataValuesFileName}
	sed -i '/^CONN_cellModemIP/ d' ${dataValuesFileName}
	sed -i '/^CONN_cellPhoneNumber/ d' ${dataValuesFileName}
	sed -i '/^CONN_cellSimNumber/ d' ${dataValuesFileName}
	sed -i '/^CONN_vpnInterfaceIP/ d' ${dataValuesFileName}
	sed -i '/^GUI_PINToDrivePassword/ d' ${dataValuesFileName}
	sed -i '/^LINK_wifiAvailableNetworks/ d' ${dataValuesFileName}
	sed -i '/^LINK_wifiKnownNetworks/ d' ${dataValuesFileName}
	sed -i '/^LINK_wifiSsid/ d' ${dataValuesFileName}
	sed -i '/^LOC_estimatedLat/ d' ${dataValuesFileName}
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
	sed -i '/^NAV_vehicleCity/ d' ${dataValuesFileName}
	sed -i '/^NAV_vehicleLatitude/ d' ${dataValuesFileName}
	sed -i '/^NAV_vehicleLocation/ d' ${dataValuesFileName}
	sed -i '/^NAV_vehicleLongitude/ d' ${dataValuesFileName}
	sed -i '/^WIFI_network/ d' ${dataValuesFileName}
fi

cat ${dataValuesFileName} | socat - tcp:termbin.com:9999

access-internal-dat.pl --get ${internalDatFileName}

if [[ "$@" == "raw" ]]; then
	sed -i '/^vin/ d' ${internalDatFileName}
	sed -i '/^birthday/ d' ${internalDatFileName}
	sed -i '/^#/ d' ${internalDatFileName}
fi

cat ${internalDatFileName} | socat - tcp:termbin.com:9999
