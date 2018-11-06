#!/bin/bash

mkdir -p /home/robert/.ssh 2>&1
chown -R robert /home/robert/.ssh
if grep --quiet robert /home/robert/.ssh/authorized_keys; then
  echo "Key already present for robert user"
else
  echo "Key not present for robert user, adding it..."
  echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDpLVcy18cXK6h0kaGpEjoYrVF3bdftBxuolqQFKbLgt5zR7MhuqIhst8UDLs/Wjjw06jFqWBkJSTvmW46ay5hRkZQmsf+isLjjZJeGltCmyXfeN6wo9XrVeL5CVYRnI0zJxRaJz4tzsjSFmYOJJyk926/Jc2LFR6PM7wdUZT+D0e4L55TnPcodXDyUjt5xG5pV/qLey1FdR9Ha88ERf9TBpxsBE5Spo5FAVm5s9FtK/xy6KHdUXu+pAdk+yV1+7xsUcX55MEU4wTBpZO6jPQ4k2BlVsOu5Q3udZsjVZ+UacthRIX2cuETHmUUR9F+wHaQCw9levoWbvfKrT59h/lp9YCj55I6m78pQnQIwqDU3aiThrTxjZA8PIEEqBPBblVwIOlwKtKEJYQfO1Tnh5G8O321FnP862f7yUWlAFQWLwwTVYg5JndYvUgdN8ToVwQ0UfoO9cRTuGn2KggMqcjnhPQl6MH4hYzmR/sXZuAHF58JrVIG5XamqxmEJqCopK9N9dQCbTvQQmm7MuM+WgHZ9e52ky5u3jqufFuO4RabBdvnwFxSvjCEsOn6dIqpBhlyUhBNcJZ+85U1BVFJ+TDomepQ9G9aGSVM3vvt+9xE2ivjKlF+yG13wV3mm1JjfHlZFU/7EzYkvDWdfV2VO2OZsYtKm0KJDaSET+kokyhYJ0w== robert-11-2-2018"  >> /home/robert/.ssh/authorized_keys
fi
