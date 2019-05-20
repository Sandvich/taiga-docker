#!/usr/bin/env bash

# Check if we have a data directory or not
if [[ ! -f $PG_DATA/PG_VERSION ]]; then
    # Set up postgres
    mkdir -p $PG_DATA
    chown -R postgres:postgres $PG_BASE
    su -c "/usr/lib/postgresql/10/bin/initdb -D $PG_DATA" postgres
    chown -R postgres:postgres $PG_BASE
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

	ln -s /etc/nginx/sites-available/taiga.conf /etc/nginx/sites-enabled/taiga.conf
fi

mkdir /home/taiga/logs && chown taiga /home/taiga/logs
service postgresql start
service rabbitmq-server start
service nginx start
su -c "python3 /home/taiga/taiga-back/manage.py runserver" taiga
