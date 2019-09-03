<h1 style="text-align:center;">Welcome to the Tesla Jailbreak Repo 👋</h1>
<p>
  <img alt="Version" src="https://img.shields.io/badge/version-1.0-blue.svg?cacheSeconds=2592000" />
  <a href="https://github.com/Lunars/tesla/wiki">
    <img alt="Documentation" src="https://img.shields.io/badge/documentation-yes-brightgreen.svg" target="_blank" />
  </a>
</p>

> Helpful tools, scripts, and information about what you can do with root access to your Tesla Model S / X.

## Prerequisite

You must already have rooted your Tesla. This is the only prerequisite. 

## Install

```sh
# Connect to your Tesla via SSH
ssh tesla1@cid
sudo su

# Run the install script which downloads this repo and creates the cron entry
curl -sL "https://git.io/fjMvw?$(date +%s)" > install && bash install
```

## Usage

Read the scripts in the [src/scripts](https://github.com/Lunars/tesla/tree/master/src/scripts) folder to determine which ones you want to enable. 

Modify the relevant script in `/var/root/lunars/src/scripts/*` to enable the script or update variables. Some scripts are already enabled by default.

## Author

👤 **Matt**

* Github: [@geczy](https://github.com/geczy)
* Discord: coder#6681

## 🤝 Contributing

Contributions, issues and feature requests are welcome!<br />Feel free to check [issues page](https://github.com/Lunars/tesla/issues).

## Show your support

Give a ⭐️ if this project helped you!

## 📝 License

This project is licensed under the [GNU General Public License v3.0](https://github.com/Lunars/tesla/blob/master/LICENSE).
