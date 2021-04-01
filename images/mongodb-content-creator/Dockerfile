FROM debian:buster

LABEL maintainer="Rafal Psciuk <rafal.psciuk@dynatrace.com>, Tomasz Wieremjewicz <tomasz.wieremjewicz@dynatrace.com>"

ENV ET_RUNTIME_DEPS "default-jre netcat wget"
RUN  apt-get update && \
     apt-get install -y --no-install-recommends ${ET_RUNTIME_DEPS} && \
     rm -rf /var/lib/apt/lists/* /tmp/*

ENV ET_HOME /easytravel
ADD build/mongo-db_content-creator-latest.tar.gz ${ET_HOME}

COPY build/resources/logback.xml ${ET_HOME}/resources
COPY build/scripts/wait-for-cmd.sh /usr/local/bin
RUN chmod a+x /usr/local/bin/wait-for-cmd.sh
COPY build/scripts/run-process.sh /
RUN chmod a+x /run-process.sh

WORKDIR ${ET_HOME}/mongo-db_content-creator-latest

ENTRYPOINT /run-process.sh
