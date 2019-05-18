#!/usr/bin/env bash

service taiga enable
service taiga start
service postgresql enable
service postgresql start
service rabbitmq-server enable
service rabbitmq-server start
