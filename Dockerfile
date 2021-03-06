# vim:set ft=dockerfile:
FROM ubuntu:18.04

ENV PG_VERSION 10
ENV PG_BASE /var/lib/postgresql
ENV PG_PASSWORD_FILE ${PG_BASE}/pwfile
ENV PG_DATA ${PG_BASE}/${PG_VERSION}/main
ENV PG_CONFIG_DIR /etc/postgresql/${PG_VERSION}/main
ENV PG_CONFIG_FILE ${PG_CONFIG_DIR}/postgresql.conf
ENV PG_BINDIR /usr/lib/postgresql/${PG_VERSION}/bin

RUN apt-get update && apt-get upgrade -y && \
	apt-get install -y --no-install-recommends locales && locale-gen en_US.UTF-8 && update-locale en_US.UTF-8 && \
	apt-get install -y --no-install-recommends \
		postgresql-$PG_VERSION \
		postgresql-client-$PG_VERSION \
		postgresql-$PG_VERSION-plv8 \
		postgresql-plpython-$PG_VERSION \
		python python3 pwgen

RUN rm -rf "$PG_BASE" && mkdir -p "$PG_BASE" && chown -R postgres:postgres "$PG_BASE" \
	&& mkdir -p /var/run/postgresql/$PG_VERSION.main.pg_stat_tmp \
	&& chown -R postgres:postgres /var/run/postgresql && chmod g+s /var/run/postgresql \
	&& chown -R postgres:postgres $PG_BASE

RUN echo "host all  all    0.0.0.0/0  md5" >> $PG_CONFIG_DIR/pg_hba.conf \
	&& echo "host all  all    ::/0  md5" >> $PG_CONFIG_DIR/pg_hba.conf \
	&& echo "listen_addresses='*'" >> $PG_CONFIG_FILE

# Prereqs
RUN apt-get install -y build-essential binutils-doc autoconf flex bison libjpeg-dev \
					libfreetype6-dev zlib1g-dev libzmq3-dev libgdbm-dev libncurses5-dev \
					automake libtool curl git tmux gettext nginx \
					nginx rabbitmq-server redis-server \
					python3 python3-pip python3-dev \
					libxml2-dev libxslt-dev \
					libssl-dev libffi-dev \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /tmp/*

# Set up non-taiga services
RUN adduser taiga && adduser taiga sudo
RUN service rabbitmq-server start && \
	rabbitmqctl add_user taiga ef808c4429e5395e0938967afed15727eaf3bfa68cc40e3165f1f3353f4b2ce9 && \
	rabbitmqctl add_vhost taiga && \
	rabbitmqctl set_permissions -p taiga taiga ".*" ".*" ".*"

# Grab taiga code
RUN cd /home/taiga && git clone https://github.com/taigaio/taiga-back.git taiga-back && \
	cd taiga-back && git checkout stable && pip3 install -r requirements.txt
RUN cd /home/taiga && git clone https://github.com/taigaio/taiga-front-dist.git taiga-front-dist && \
	cd taiga-front-dist && git checkout stable

# Set up taiga code
COPY start.sh /start.sh
COPY --chown=taiga local.py /home/taiga/taiga-back/settings/local.py
COPY --chown=taiga conf.json /home/taiga/taiga-front-dist/dist/conf.json
COPY taiga.conf /etc/nginx/sites-enabled/taiga.conf
RUN chmod +x /start.sh && ln -s /etc/nginx/sites-enabled/taiga.conf /etc/nginx/sites-available/taiga.conf

VOLUME $PG_DATA

EXPOSE 8001
CMD /start.sh