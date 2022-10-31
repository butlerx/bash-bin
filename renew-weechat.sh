#!/bin/bash

certbot renew -q

cat /etc/letsencrypt/live/notthe.cloud/privkey.pem /etc/letsencrypt/live/notthe.cloud/fullchain.pem >/home/butlerx/.weechat/ssl/relay.pem
chown butlerx:butlerx /home/butlerx/.weechat/ssl/relay.pem
