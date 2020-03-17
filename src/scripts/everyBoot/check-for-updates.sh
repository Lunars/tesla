currentVersion="2020.03.17"
latestScript=$(curl --max-time 5 --connect-timeout 0 -s -L "https://raw.githubusercontent.com/Lunars/tesla/master/src/scripts/everyBoot/check-for-updates.sh" || exit 1)
latestVersion=$(echo "${latestScript}" | cut -d '"' -f2 | head -1)

if [ -n "$latestScript" ] && [ "$currentVersion" != "$latestVersion" ]; then
  echo "New version detected. Running update script"

  # Using script from source, to make sure it's the newest copy since there's an update
  bash <(curl -sL "https://raw.githubusercontent.com/Lunars/tesla/master/src/install.sh")
fi
