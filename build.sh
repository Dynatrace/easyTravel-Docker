#!/bin/bash
export ET_SRC_URL="http://dexya6d9gs5s.cloudfront.net/latest/dynatrace-easytravel-src.zip"

export ET_DEPLOY_HOME="./build"
export ET_CF_DEPLOY_HOME="frontend/build"
export ET_BB_DEPLOY_HOME="backend/build"
export ET_LG_DEPLOY_HOME="loadgen/build"

export DOCKER_CONTAINER_BUILD_SH_PREFIX="./app/easyTravel"

./app/easyTravel/build-in-docker.sh

mkdir -p ./build/mongodb/build && \
cp ./app/easyTravel/deploy/data/easyTravel-mongodb-db.tar.gz ./build/mongodb/build

for folder in `ls -d build/*/`; do
  pushd ${folder}
  ./build.sh
  popd
done
