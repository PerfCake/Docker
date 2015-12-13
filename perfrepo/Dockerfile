FROM fedora:22
MAINTAINER Pavel Macík "pavel.macik@gmail.com"

ENV PERFREPO_VERSION="1.4" AS_ADMIN="admin" AS_PASSWD="Admin.1234" JBOSS_HOME="/root/jboss-eap-6.4/"
# Installing temporary utils
RUN dnf install -y java-1.8.0-openjdk-devel maven wget unzip

# Building perfrepo-web.war from sources taken from GitHub
ADD settings.xml /tmp/settings.xml
RUN cd /root \
    && wget -O perfrepo-src.zip https://github.com/PerfCake/PerfRepo/archive/v$PERFREPO_VERSION.zip \
    && unzip perfrepo-src.zip \
    && cp -vf PerfRepo-$PERFREPO_VERSION/model/src/main/sql/db_schema_creation.sql /tmp/db_schema_creation.sql \
    && mvn -s /tmp/settings.xml -f PerfRepo-$PERFREPO_VERSION/pom.xml package -DskipTests \
    && mv -vf PerfRepo-$PERFREPO_VERSION/web/target/perfrepo-web.war . \
    && rm -rvf PerfRepo-$PERFREPO_VERSION /root/.m2/repository perfrepo-src.zip
# -- /root/perfrepo-web.war is left to be deployed to JBoss AS7

# Installing JBoss EAP 6.4
RUN cd /root \
    && wget -O jboss-eap-6.4.zip "https://doc-10-4c-docs.googleusercontent.com/docs/securesc/ha0ro937gcuc7l7deffksulhg5h7mbp1/o76rmutlis13l61k5ddnp4qajt9tuuss/1450029600000/05497719580723152573/*/0B1XF84T3N8iCNjhEWVM1QjEzMlU?e=download" \
    && echo "012ece485885174b7759e86953c50af6 jboss-eap-6.4.zip" | md5sum -c \
    && unzip jboss-eap-6.4.zip \
    && $JBOSS_HOME/bin/add-user.sh --silent=true $AS_ADMIN $AS_PASSWD \
    && rm -rvf jboss-eap-6.4.zip \
    && mkdir -p $JBOSS_HOME/modules/system/layers/base/org/postgresql/main \
    && wget -O $JBOSS_HOME/modules/system/layers/base/org/postgresql/main/postgresql-jdbc.jar https://jdbc.postgresql.org/download/postgresql-9.4-1206-jdbc41.jar
ADD module.xml $JBOSS_HOME/modules/system/layers/base/org/postgresql/main/module.xml

# Use jboss-cli to configure EAP
ADD eap-perfrepo.cli /tmp/eap-perfrepo.cli
RUN cd /root \
    && $JBOSS_HOME/bin/standalone.sh & sleep 10 \
    && $JBOSS_HOME/bin/jboss-cli.sh -c --file=/tmp/eap-perfrepo.cli \
    && sed -i -e 's/pool-name=\"PerfRepoDS\" enabled=\"false\"/pool-name=\"PerfRepoDS\" enabled=\"true\"/g' $JBOSS_HOME/standalone/configuration/standalone.xml \
    && mv -vf /root/perfrepo-web.war $JBOSS_HOME/standalone/deployments/
# -- JBoss EAP is installed in /root/jboss-eap-6.4

# Cleaning environment and installing Java 8
RUN dnf remove -y java-1.8.0-openjdk-devel maven wget unzip \
    && dnf install -y java-1.8.0-openjdk-headless \
    && rm -rf /tmp/* && dnf clean all

EXPOSE 8080

CMD ["/root/jboss-eap-6.4/bin/standalone.sh", "-b", "0.0.0.0"]