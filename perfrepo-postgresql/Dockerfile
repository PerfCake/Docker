FROM fedora:22
MAINTAINER Pavel Macík "pavel.macik@gmail.com"

ENV PERFREPO_VERSION="1.4" PGDATA="/var/lib/pgsql/data/" PG_NAME="perfrepo" PG_USER="perfrepo" PG_PASSWD="perfrepo"

# Building perfrepo-web.war from sources taken from GitHub
RUN curl "https://raw.githubusercontent.com/PerfCake/PerfRepo/v$PERFREPO_VERSION/model/src/main/sql/db_schema_creation.sql" > /tmp/db_schema_creation.sql

# install postgresql
RUN dnf install -y postgresql-server postgresql-contrib

USER postgres
RUN initdb --encoding=UTF8 \
    && pg_ctl -w start \
    && psql --command "CREATE USER $PG_USER WITH SUPERUSER PASSWORD '$PG_PASSWD';" \
    && createdb --owner=$PG_USER $PG_NAME \
    && psql --username=$PG_USER -f /tmp/db_schema_creation.sql \
    && echo "listen_addresses='*'" >> $PGDATA/postgresql.conf \
    && echo "host all all 0.0.0.0/0  md5" >> $PGDATA/pg_hba.conf

# Cleaning environment
USER root
RUN rm -rf /tmp/* \
    && dnf clean all

EXPOSE 5432

USER postgres
CMD ["/usr/bin/postgres", "-D", "/var/lib/pgsql/data"]