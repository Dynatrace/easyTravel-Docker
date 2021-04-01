FROM alpine:3.7

MAINTAINER Rafal Psciuk <rafal.psciuk@dynatrace.com>, Tomasz Wieremjewicz <tomasz.wieremjewicz@dynatrace.com>

ENV MONGODB_DB /data/db/easyTravel
ENV MONGODB_SRC /tmp/easyTravel-mongodb-db.tar.gz
ENV SCRIPT_DIR /usr/bin

RUN apk add --no-cache mongodb

EXPOSE 27017 28017

# Deploy easyTravel database
RUN mkdir -p ${MONGODB_DB}

COPY build/easyTravel-mongodb-db.tar.gz /tmp
ADD  build/scripts/runmongo.sh ${SCRIPT_DIR}

RUN chgrp -R 0 ${MONGODB_DB} && chmod -R g=u ${MONGODB_DB}	

USER 1001101
	
CMD ${SCRIPT_DIR}/runmongo.sh