<h1 style="text-align:center;">Welcome to the Tesla Jailbreak Repo 👋</h1>
<p>
  <img alt="Version" src="https://img.shields.io/badge/version-1.0-blue.svg?cacheSeconds=2592000" />
  <a href="https://github.com/Lunars/tesla/wiki" target="_blank">
    <img alt="Documentation" src="https://img.shields.io/badge/documentation-yes-brightgreen.svg" />
  </a>
</p>

> Helpful tools, scripts, and information about what you can do with root access to your Tesla Model S / X.

## Prerequisite

You must have already rooted your Tesla. This is the only prerequisite.

These scripts were designed for MCU1, Tegra. They are not guaranteed to work on Intel MCU2

## Install

```sh
# Connect to your Tesla via SSH
ssh tesla1@cid
sudo su

# Run the install script which downloads this repo and creates the cron entry
bash <(curl -sL "https://raw.githubusercontent.com/Lunars/tesla/master/src/install.sh")
```

## Updating

Lunars will automatically check for updates when your car boots up. So hold the two scroll wheels to reboot and it will check on boot up.

Or, you can simply run the install steps. Lunars will automatically know to update your current installation.

During update, only the following will be preserved. Any changes to the lunars directory otherwise will be wiped and updated to the latest Github copy.

1. config.sh # New scripts will automatically be added and commented out by default
2. tesla.ovpn
3. overwrite-files

## Usage

Fill in the variables on [/var/lunars/config.sh](https://github.com/Lunars/tesla/blob/master/src/config.sh) and uncomment the scripts you want to run. Some scripts are already enabled by default.

## Author

👤 **Matt**

* Github: [@geczy](https://github.com/geczy)
* Discord: coder#6681
* Telegram: https://t.me/mattpew

## 🤝 Contributing

Contributions, issues and feature requests are welcome!<br />Feel free to check [issues page](https://github.com/Lunars/tesla/issues).

## Show your support

[Consider sponsoring](https://github.com/sponsors/Lunars) to help future updates. 
Give a ⭐️ if this project helped you!

## 📝 License

This project is licensed under the [GNU General Public License v3.0](https://github.com/Lunars/tesla/blob/master/LICENSE).
