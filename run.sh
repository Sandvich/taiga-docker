#!/usr/bin/env bash

service postgresql start
service rabbitmq-server start
su -c "python3 /home/taiga/taiga-back/manage.py start" taiga
