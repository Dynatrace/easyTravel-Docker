FROM alpine:3.7

MAINTAINER Rafal Psciuk <rafal.psciuk@dynatrace.com>, Tomasz Wieremjewicz <tomasz.wieremjewicz@dynatrace.com>

ENV MONGODB_DB /data/db/easyTravel

RUN apk add --no-cache mongodb

EXPOSE 27017 28017

# Deploy easyTravel database
RUN mkdir -p ${MONGODB_DB}

ADD build/easyTravel-mongodb-db.tar.gz ${MONGODB_DB}
RUN chown -R root:root ${MONGODB_DB}

CMD mongod --rest --httpinterface --smallfiles --dbpath ${MONGODB_DB}
