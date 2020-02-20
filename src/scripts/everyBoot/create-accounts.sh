#!/bin/sh

# Adds your pub key to 3 users. tesla, yourUsername, and root

if [[ "$keyToSaveToCar" =~ "example" ]] || [ -z "$keyToSaveToCar" ] || [ "$accountPassToSaveToCar" == "myCarIsRooted" ]; then
  echo "Script not yet setup, quitting"
  exit 1
fi

lastten=${keyToSaveToCar: -21}
mkdir -p /home/$accountUserToSaveToCar/.ssh 2>&1
mkdir -p /root/.ssh 2>&1
mkdir -p /home/tesla/.ssh 2>&1
chown -R $accountUserToSaveToCar /home/$accountUserToSaveToCar/.ssh

if getent passwd $accountUserToSaveToCar >/dev/null 2>&1; then
  echo "$accountUserToSaveToCar already exists"
else
  useradd -c "Car OWNER account DO NOT REMOVE" -s /bin/sh -u 10369 -G tesla -G root $accountUserToSaveToCar
  # Make this user sudo
  usermod -a -G admin,sudo,log $accountUserToSaveToCar
  mkdir /home/$accountUserToSaveToCar 2>&1
  chown $accountUserToSaveToCar:$accountUserToSaveToCar /home/$accountUserToSaveToCar
  usermod -aG sudo $accountUserToSaveToCar
  echo $accountUserToSaveToCar:$accountPassToSaveToCar | chpasswd
fi

# Add the ssh keys to each user
touch /root/.ssh/authorized_keys

grep --quiet "$lastten" /home/$accountUserToSaveToCar/.ssh/authorized_keys && echo "Already added key to /home/$accountUserToSaveToCar" || echo "$keyToSaveToCar" >>/home/$accountUserToSaveToCar/.ssh/authorized_keys
grep --quiet "$lastten" /home/tesla/.ssh/authorized_keys && echo "Already added key to /home/tesla" || echo "$keyToSaveToCar" >>/home/tesla/.ssh/authorized_keys
grep --quiet "$lastten" /root/.ssh/authorized_keys && echo "Already added key to /root" || echo "$keyToSaveToCar" >>/root/.ssh/authorized_keys
