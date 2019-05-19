#!/usr/bin/env bash

# Check if this is a first run or not
if [ ! test -f /first_done ]; then
    # Set up postgres
    mkdir -p $PG_DATA
    chown -R postgres:postgres $PG_BASE
    su -c "/usr/lib/postgresql/10/bin/initdb -D $PG_DATA" postgres
    service postgresql start
    su  -c "createuser taiga && createdb taiga -O taiga --encoding='utf-8' \
                            --locale=en_US.utf8 --template=template0" postgres
    
    # Set up taiga DB
	cd /home/taiga/taiga-back
	chown -R taiga /home/taiga
	su -c "python3 /home/taiga/taiga-back/manage.py migrate --noinput && \
	python3 /home/taiga/taiga-back/manage.py loaddata initial_user && \
	python3 /home/taiga/taiga-back/manage.py loaddata initial_project_templates && \
	python3 /home/taiga/taiga-back/manage.py compilemessages && \
	python3 /home/taiga/taiga-back/manage.py collectstatic --noinput" taiga
	
    touch /first_done
fi

service postgresql start
service rabbitmq-server start
su -c "python3 /home/taiga/taiga-back/manage.py start" taiga
