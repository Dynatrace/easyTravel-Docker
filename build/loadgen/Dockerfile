FROM alpine:3.3

MAINTAINER Martin Etmajer <martin.etmajer@dynatrace.com>, Rafal Psciuk <rafal.psciuk@dynatrace.com>

ENV ET_HOME /easytravel
ENV ET_RUNTIME_DEPS "openjdk8-jre-base"
RUN apk add --no-cache ${ET_RUNTIME_DEPS}
ADD build/loadgen.tar.gz ${ET_HOME}

WORKDIR ${ET_HOME}

CMD java -jar uemload.jar --autorun true --server http://www