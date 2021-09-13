#!/bin/bash
set -e

export ET_DEPLOY_HOME="images"
export ET_CF_DEPLOY_HOME="frontend/build"
export ET_ACF_DEPLOY_HOME="angularfrontend/build"
export ET_BB_DEPLOY_HOME="backend/build"
export ET_LG_DEPLOY_HOME="loadgen/build"
export ET_HLG_DEPLOY_HOME="headlessloadgen/build"
export ET_MG_DEPLOY_HOME="mongodb/build"
export ET_MGC_DEPLOY_HOME="mongodb-content-creator/build"
export ET_PS_DEPLOY_HOME="pluginservice/build"

./build-in-docker.sh

for folder in `ls -d $ET_DEPLOY_HOME/*/`; do
  pushd ${folder}
  ./build.sh
  popd
done
