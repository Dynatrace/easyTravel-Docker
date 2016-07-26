FROM java:8

MAINTAINER Martin Etmajer <martin.etmajer@dynatrace.com>, Rafal Psciuk <rafal.psciuk@dynatrace.com>

ENV ET_HOME /easytravel
ADD build/loadgen.tar.gz ${ET_HOME}

ENV ET_RUNTIME_DEPS "netcat"
RUN  apt-get update && \
     apt-get install -y --no-install-recommends ${ET_RUNTIME_DEPS} && \
     rm -rf /var/lib/apt/lists/* /tmp/*

COPY build/scripts/run-problem-patterns.sh /usr/local/bin
COPY build/scripts/wait-for-cmd.sh /usr/local/bin
COPY build/scripts/run-process.sh /

WORKDIR ${ET_HOME}

ENTRYPOINT /run-process.sh