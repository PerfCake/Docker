FROM fedora:22
MAINTAINER Pavel Macík "pavel.macik@gmail.com"

ENV PERFREPO_VERSION="1.4" AS_ADMIN="admin" AS_PASSWD="Admin.1234"

# Installing temporary utils
RUN dnf install -y maven wget unzip

# Building perfrepo-web.war from sources taken from GitHub
ADD settings.xml /tmp/settings.xml
RUN cd $HOME \
    && wget -O perfrepo-src.zip https://github.com/PerfCake/PerfRepo/archive/v$PERFREPO_VERSION.zip \
    && unzip perfrepo-src.zip \
    && mvn -s /tmp/settings.xml -f PerfRepo-$PERFREPO_VERSION/pom.xml package -DskipTests \
    && mv -vf PerfRepo-$PERFREPO_VERSION/web/target/perfrepo-web.war . \
    && rm -rvf PerfRepo-$PERFREPO_VERSION $HOME/.m2/repository perfrepo.zip
# -- $HOME/perfrepo-web.war is left to be deployed to JBoss AS7

# Installing JBoss AS7
RUN cd $HOME \
    && wget -O jboss-as7.zip http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.zip \
    && unzip jboss-as7.zip \
    && jboss-as-7.1.1.Final/bin/add-user.sh --silent=true $AS_ADMIN $AS_PASSWD \
    && rm -rvf jboss-as7.zip
# -- JBoss AS7 is installed in $HOME/jboss-as-7.1.1.Final

# Cleaning environment and installing Java 8
RUN dnf remove -y maven wget unzip \
    && dnf install -y java-1.8.0-openjdk

CMD ["$HOME/jboss-as-7.1.1.Final/bin/standalone.sh", "-c", "standalone.xml", "-b", "0.0.0.0", "-bmanagement=0.0.0.0"]