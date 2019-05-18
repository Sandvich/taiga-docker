#!/usr/bin/env bash

systemctl enable taiga
service start taiga
systemctl enable postgresql
systemctl start postgresql
systemctl enable rabbitmq-server
systemctl start rabbitmq-server
