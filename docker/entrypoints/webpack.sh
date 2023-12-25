#!/bin/sh
set -e

rm -rf /app/tmp/pids/server.pid
rm -rf /app/tmp/cache/*

apk update && apk add --no-cache \
  openssl \
  tar \
  build-base \
  tzdata \
  postgresql-dev \
  postgresql-client \
  nodejs-current \
  yarn \
  git \

export NODE_OPTIONS=--openssl-legacy-provider

yarn install

echo "Waiting for yarn and bundle integrity to match lockfiles...."
YARN="yarn check --integrity"
BUNDLE="bundle check"

until $YARN && $BUNDLE
do
  sleep 2;
done

echo "Ready to run webpack development server."

exec "$@"
