#!/bin/sh
tar -xf /tmp/easyTravel-mongodb-db.tar.gz -C ${MONGODB_DB}
mongod --rest --httpinterface --smallfiles --dbpath ${MONGODB_DB} --auth
