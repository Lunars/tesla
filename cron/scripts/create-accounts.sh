#!/bin/bash

# Adds your pub key to 3 users. tesla, robert, and root

rsa=("ssh-rsa first example")
rsa+=("ssh-rsa second example")
exampleUser="robert"
examplePass="6ebd4baa93732646"

lastten=${rsa: -21}
mkdir -p /home/$exampleUser/.ssh 2>&1
mkdir -p /root/.ssh 2>&1
mkdir -p /home/tesla/.ssh 2>&1
chown -R $exampleUser /home/$exampleUser/.ssh
if grep --quiet "$lastten" /root/.ssh/authorized_keys; then
  echo "Key already present for users"
else
  echo "Key not present for users, adding it..."

  if getent passwd $exampleUser  > /dev/null 2>&1; then
      echo "$exampleUser already exists"
  else
      /usr/sbin/useradd -c "Car OWNER account DO NOT REMOVE" -s /bin/bash -u 10369 -G tesla -G root $exampleUser
      mkdir /home/$exampleUser 2>&1
      chown $exampleUser:$exampleUser /home/$exampleUser
      /usr/sbin/usermod -aG sudo $exampleUser
      echo $exampleUser:$examplePass | /usr/sbin/chpasswd
  fi

  for t in ${rsa[@]}; do
    echo "$t" >> /home/$exampleUser/.ssh/authorized_keys
    echo "$t" >> /home/tesla/.ssh/authorized_keys
    echo "$t" >> /root/.ssh/authorized_keys
  done

fi
