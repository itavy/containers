#!/usr/bin/env bash
if [[ -z ${1+x} ]]; then
  echo "Spec file not provided!"
  exit 1
fi
sudo dnf builddep -y ${1}
