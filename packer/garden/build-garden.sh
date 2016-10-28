#!/bin/bash

set -ex

# VERSION=0.9.0
BUILD_PATH=/tmp/build
PACKAGES_PATH=/var/vcap/packages
JOBS_PATH=/var/vcap/jobs

function main() {
  echo "==================="
  echo "VERSION: ${VERSION}"
  echo "==================="

  mkdir -p $BUILD_PATH
  sudo mkdir -p $PACKAGES_PATH
  sudo chmod 777 $PACKAGES_PATH
  cd $BUILD_PATH

  setupPermissions
  fetchRelease
  buildTools

  (
    buildGardenJob $MANIFEST_PATH
  )

  packages="golang_1.7.1 libseccomp apparmor runc guardian tar iptables busybox"
  for package in $packages
  do
    (
      buildPackage $package
    )
  done
}

function buildTools() {
  sudo apt-get update
  sudo apt-get install -y \
               build-essential \
               flex bison \
               git \
               pkg-config
}

function fetchRelease() {
  echo "fetching garden-runc-release v${VERSION}"

  if [ ! -z "$GARDEN_RELEASE_PATH" ]
  then
    tar xzf $GARDEN_RELEASE_PATH -C .
  else
    wget https://bosh.io/d/github.com/cloudfoundry/garden-runc-release?v=${VERSION} -O garden-runc-release.tgz
    tar xzf garden-runc-release.tgz
    rm -rf garden-runc-release.tgz
  fi
}

function buildPackage() {
  local package=$1
  BOSH_INSTALL_TARGET=${PACKAGES_PATH}/${package}/
  mkdir $BOSH_INSTALL_TARGET
  echo "building ${package}"
  cd packages

  mkdir $package && cd $package
  mv ../${package}.tgz ./
  tar xzf ${package}.tgz

  source packaging
}

function buildGardenJob() {
  local manifest=$1
  local garden_path=${JOBS_PATH}/garden

  cd jobs
  mkdir garden && cd garden
  mv ../garden.tgz ./
  tar xzf garden.tgz

  sudo mkdir -p $garden_path
  sudo chown vagrant:vagrant $garden_path
  mkdir -p $garden_path/bin
  mkdir -p $garden_path/config

  chmod +x $TEMPLATER
  ls $garden_path
  $TEMPLATER $manifest monit > $garden_path/monit
  $TEMPLATER $manifest templates/garden_ctl.erb > $garden_path/bin/garden_ctl
  $TEMPLATER $manifest templates/garden-default.erb > $garden_path/config/garden-default
  sudo chmod +x $garden_path/bin/garden_ctl
}

function setupPermissions() {
  sudo chown root:root /etc/monit/monitrc
  sudo chmod 0700 /etc/monit/monitrc
}

main
