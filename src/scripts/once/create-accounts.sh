#!/bin/bash

# Adds your pub key to 3 users. tesla, yourUsername, and root

# You can save multiple authorized keys by supplying them here as an array
rsa[0]="ssh-rsa first example"
rsa[1]="ssh-rsa second example"

# Setup your own username / password
exampleUser="yourUsername"
examplePass="myCarIsRooted"

if [ "$examplePass" == "myCarIsRooted" ]; then
  echo "Script not yet setup, quitting"
  exit 1
fi

if [ "${rsa}" == "ssh-rsa first example" ]; then
  echo "Script not yet setup, quitting"
  exit 1
fi

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
      useradd -c "Car OWNER account DO NOT REMOVE" -s /bin/bash -u 10369 -G tesla -G root $exampleUser
      # Make this user sudo
      usermod -a -G admin,sudo,log $exampleUser
      mkdir /home/$exampleUser 2>&1
      chown $exampleUser:$exampleUser /home/$exampleUser
      usermod -aG sudo $exampleUser
      echo $exampleUser:$examplePass | chpasswd
  fi

  # Add the ssh keys to each user
  for t in "${rsa[@]}"; do
    echo "$t" >> /home/$exampleUser/.ssh/authorized_keys
    echo "$t" >> /home/tesla/.ssh/authorized_keys
    echo "$t" >> /root/.ssh/authorized_keys
  done

fi
