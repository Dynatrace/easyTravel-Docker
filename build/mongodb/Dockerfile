FROM mvertes/alpine-mongo

MAINTAINER Martin Etmajer <martin.etmajer@dynatrace.com>, Rafal Psciuk <rafal.psciuk@dynatrace.com>

RUN mkdir -p /data/db/easyTravel

# Deploy easyTravel database
ADD build/easyTravel-mongodb-db.tar.gz /data/db/easyTravel/

CMD mongod --auth --rest --httpinterface --smallfiles --dbpath /data/db/easyTravel