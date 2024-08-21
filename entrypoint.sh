#!/bin/bash

variables=("SMTP_HOST" \
            "REFRESH_TIME" \
            "SMTP_PORT" \
            "SMTP_USER" \
            "SMTP_PASSWORD" \
            "SMTP_TO" \
            "FEED")

for var in "${variables[@]}"; do
  if [ -z "${!var}" ]; then
    echo "Variable $var is not set!"
    exit 1
  fi
done

if [ "$USE_TLS" == "True" ]; then
    sed -i 's/smtp-ssl = False/smtp-ssl = True/' /root/.config/rss2email.cfg
fi
if [[ "$(r2e list)" != *"$FEED"* ]]; then
    r2e add docker_init $FEED
fi
sed -i -e 's/from = user@rss2email.invalid/from = '$SMTP_USER'/' \
    -e 's/to = admin@example.com/to = '$SMTP_TO'/' \
    -e 's/smtp-username = username/smtp-username = '$SMTP_USER'/' \
    -e 's/smtp-password = password/smtp-password = '$SMTP_PASSWORD'/' \
    -e 's/smtp-server = smtp.example.net/smtp-server = '$SMTP_HOST'/' \
    -e 's/smtp-port = 465/smtp-port = '$SMTP_PORT'/' \
/root/.config/rss2email.cfg

while true; do r2e run; echo "$(date +"%Y-%m-%d %H:%M:%S,%3N") [INFO] There are no new RSS feeds. Sleep $REFRESH_TIME seconds..."; sleep $REFRESH_TIME; done