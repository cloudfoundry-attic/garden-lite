#!/bin/bash

(
  export VERSION="$(cat $VERSION_PATH)"

  cd garden-lite-git/packer/ubuntu-plus-garden
  packer build ./packer.json
)
