# Welcome to the Tesla root information dump

We're focused on documenting helpful tools, scripts, and information about what you can do with root access. 

You can find more information in our Wiki 

https://github.com/Lunars/tesla/wiki

---

## How to 

1. Save scripts to CID

```bash
ssh tesla1@cid
sudo su
mkdir -p /var/root/lunars
curl -SL https://github.com/Lunars/tesla/tarball/master -o lunars.zip
tar xvf ./lunars.zip -C /var/root/lunars/
rm ./lunars.zip
mv /var/root/lunars/*/* /var/root/lunars/
rm -rf /var/root/lunars/Lunars-tesla*
```

2. Install crontab, [examples found here](https://github.com/Lunars/tesla/blob/master/cron/crontab)

```bash
ssh tesla1@cid
sudo su
crontab -e
```

## Contact

Repo owner is `coder#6681` on discord
