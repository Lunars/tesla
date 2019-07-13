# Welcome to the Tesla root information dump

We're focused on documenting helpful tools, scripts, and information about what you can do with root access. 

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
```

2. Install crontab

```bash
ssh tesla1@cid
sudo su
crontab -e
# Add your changes to crontab from https://github.com/Lunars/tesla/blob/master/cron/crontab
```
