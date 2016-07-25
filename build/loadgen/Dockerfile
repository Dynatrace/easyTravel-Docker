FROM alpine:3.3

MAINTAINER Martin Etmajer <martin.etmajer@dynatrace.com>, Rafal Psciuk <rafal.psciuk@dynatrace.com>

ENV ET_HOME /easytravel
ADD build/loadgen.tar.gz ${ET_HOME}

ENV ET_RUNTIME_DEPS "bash netcat-openbsd openjdk8-jre-base"
RUN apk add --no-cache ${ET_RUNTIME_DEPS}

COPY build/scripts/run-problem-patterns.sh /usr/local/bin
COPY build/scripts/wait-for-cmd.sh /usr/local/bin
COPY build/scripts/run-process.sh /

WORKDIR ${ET_HOME}

ENTRYPOINT /run-process.sh