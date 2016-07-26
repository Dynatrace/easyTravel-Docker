FROM alpine:edge

MAINTAINER Martin Etmajer <martin.etmajer@dynatrace.com>, Rafal Psciuk <rafal.psciuk@dynatrace.com>

ENV MONGODB_DB /data/db/easyTravel

RUN echo http://dl-4.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
    apk add --no-cache mongodb

EXPOSE 27017 28017

# Deploy easyTravel database
RUN mkdir -p ${MONGODB_DB}

ADD build/easyTravel-mongodb-db.tar.gz ${MONGODB_DB}
RUN chown -R root:root ${MONGODB_DB}

CMD mongod --rest --httpinterface --smallfiles --dbpath ${MONGODB_DB}
