#!/usr/bin/env bash

set -o nounset
set -o errexit

testApp="https://github.com/csonuryilmaz/TextPad.git"
export GRADLE_OPTS="-Dorg.gradle.daemon=false"

# Workflow step input variables (component.yml>inputs)
export AC_REPOSITORY_DIR="$HOME/app/workflow_data/tjrdzp35.isa/_appcircle_temp/Repository"
#export AC_REPOSITORY_DIR=""
export AC_CACHE_LABEL="master/app-deps"
export AC_TOKEN_ID="x"

rm -rf $HOME/.gradle

if [ ! -z $AC_REPOSITORY_DIR ]; then
  rm -rf $AC_REPOSITORY_DIR

  mkdir -p $AC_REPOSITORY_DIR
  git clone $testApp $AC_REPOSITORY_DIR

  if [ ! -L "/setup" ]; then
    sudo ln -sf $HOME /setup
  fi
fi

START_TIME=$SECONDS
echo ""
echo "@@[section:begin] Step started: Cache Pull"
ruby main.rb
echo "@@[section:end] Step completed: Cache Pull"
ELAPSED_TIME=$(($SECONDS - $START_TIME))
echo "took $ELAPSED_TIME s"

if [ ! -z $AC_REPOSITORY_DIR ]; then
  cd $AC_REPOSITORY_DIR
  chmod +x ./gradlew && ./gradlew --build-cache app:assembleDebug
fi
