<h1 align="center">Welcome to Tesla Root Info 👋</h1>
<p>
  <img alt="Version" src="https://img.shields.io/badge/version-1.0-blue.svg?cacheSeconds=2592000" />
  <a href="https://github.com/Lunars/tesla/wiki">
    <img alt="Documentation" src="https://img.shields.io/badge/documentation-yes-brightgreen.svg" target="_blank" />
  </a>
</p>

> Helpful tools, scripts, and information about what you can do with root access.

## Install

```sh
ssh tesla1@cid
sudo su
mkdir -p /var/root/lunars
curl -SL https://github.com/Lunars/tesla/tarball/master -o lunars.zip
tar xvf ./lunars.zip -C /var/root/lunars/
rm ./lunars.zip
mv /var/root/lunars/*/* /var/root/lunars/
rm -rf /var/root/lunars/Lunars-tesla*
```

## Usage

```sh
ssh tesla1@cid
sudo su
crontab -e
```

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
