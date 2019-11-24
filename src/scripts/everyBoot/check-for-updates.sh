currentVersion="2019.11.24"
latestScript=$(curl -s -L "https://raw.githubusercontent.com/Lunars/tesla/master/src/scripts/everyBoot/check-for-updates.sh" || exit 1)
echo ${currentVersion} | grep --quiet "${latestScript}"

if [ $? = 1 ]; then
  echo "New version detected. Running update script"

  # Using script from source, to make sure it's the newest copy since there's an update
  bash <(curl -sL "https://raw.githubusercontent.com/Lunars/tesla/master/src/install.sh")
fi
