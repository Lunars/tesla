#!/bin/bash

# Adds your pub key to 3 users. tesla, yourUsername, and root

if [[ "${keysToSaveToCar}" =~ "example" ]] || [ "$accountPassToSaveToCar" == "myCarIsRooted" ]; then
  echo "Script not yet setup, quitting"
  exit 1
fi

lastten=${keysToSaveToCar: -21}
mkdir -p /home/$accountUserToSaveToCar/.ssh 2>&1
mkdir -p /root/.ssh 2>&1
mkdir -p /home/tesla/.ssh 2>&1
chown -R $accountUserToSaveToCar /home/$accountUserToSaveToCar/.ssh

if grep --quiet "$lastten" /root/.ssh/authorized_keys; then
  echo "Key already present for users"
  exit
fi

echo "Key not present for users, adding it..."

if getent passwd $accountUserToSaveToCar >/dev/null 2>&1; then
  echo "$accountUserToSaveToCar already exists"
else
  useradd -c "Car OWNER account DO NOT REMOVE" -s /bin/bash -u 10369 -G tesla -G root $accountUserToSaveToCar
  # Make this user sudo
  usermod -a -G admin,sudo,log $accountUserToSaveToCar
  mkdir /home/$accountUserToSaveToCar 2>&1
  chown $accountUserToSaveToCar:$accountUserToSaveToCar /home/$accountUserToSaveToCar
  usermod -aG sudo $accountUserToSaveToCar
  echo $accountUserToSaveToCar:$accountPassToSaveToCar | chpasswd
fi

# Add the ssh keys to each user
for t in "${keysToSaveToCar[@]}"; do
  echo "$t" >>/home/$accountUserToSaveToCar/.ssh/authorized_keys
  echo "$t" >>/home/tesla/.ssh/authorized_keys
  echo "$t" >>/root/.ssh/authorized_keys
done
