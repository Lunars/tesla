#!/bin/sh

# minimum miles/h at which volume will start to auto adjust
MIN_SPEED=10
# step size in miles/h at which volume adjusts by $VOLUME_INCREMENT (8 for example will cause volume to adjust up/down every 8 mph)
VOLUME_SPEED_STEP=8
# amount of volume that will increase or decrease per $VOLUME_SPEED_STEP - integer value (x10000) since sh doesn't support floating point calculations
# tesla default is 0.333 per scroll (GUI_audioVolumeIncrement). we use half that (x10000) to make auto volume adjustments smooth
VOLUME_INCREMENT=1665

function get_volume_int() {
  lv GUI_audioVolume | awk -F\" '{ printf "%d", $2 * 10000 }'
}
function get_speed_int() {
  lv VAPI_vehicleSpeed | awk -F\" '{ printf "%d", $2 }'
}

INIT_VOLUME=$(get_volume_int)
PREV_VOLUME=$INIT_VOLUME
INIT_SPEED=$(get_speed_int)
PREV_SPEED=$INIT_SPEED

while true; do
  CURRENT_VOLUME=$(get_volume_int)
  CURRENT_SPEED=$(get_speed_int)
  if ((PREV_VOLUME != CURRENT_VOLUME)); then
    INIT_VOLUME=$CURRENT_VOLUME
    PREV_VOLUME=$INIT_VOLUME
    INIT_SPEED=$CURRENT_SPEED
    PREV_SPEED=$INIT_SPEED
  elif ((CURRENT_VOLUME > 0 && (CURRENT_SPEED > MIN_SPEED || PREV_SPEED >= MIN_SPEED))); then
    SPEED_DIFF=$((CURRENT_SPEED - PREV_SPEED))
    # avoid volume adjustments while driving at somewhat constant speed and minimize sdv calls
    if ((SPEED_DIFF > 3 || SPEED_DIFF < -3)); then
      OFFSET_CURRENT_SPEED=$((CURRENT_SPEED > MIN_SPEED ? CURRENT_SPEED - MIN_SPEED : 0))
      OFFSET_INIT_SPEED=$((INIT_SPEED > MIN_SPEED ? INIT_SPEED - MIN_SPEED : 0))
      NEW_VOLUME=$((INIT_VOLUME + (VOLUME_INCREMENT * ((OFFSET_CURRENT_SPEED - OFFSET_INIT_SPEED) / VOLUME_SPEED_STEP))))
      if ((NEW_VOLUME <= 0)); then
        NEW_VOLUME=$VOLUME_INCREMENT
      fi
      sdv GUI_audioVolume $(echo $NEW_VOLUME | awk '{printf "%.4f", $1 / 10000}')
      PREV_VOLUME=$(get_volume_int)
      PREV_SPEED=$CURRENT_SPEED
    fi
  fi
  if ((CURRENT_SPEED == 0)) && [[ $(lv VAPI_driverPresent) != '"true"' ]]; then
    /bin/sleep 60
  else
    /bin/sleep 1.5
  fi
done
