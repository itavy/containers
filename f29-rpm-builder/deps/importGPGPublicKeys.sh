#!/usr/bin/env bash
set -euxo pipefail


if [[ -z ${1+x} ]]; then
  echo "Set default import path: ${HOME}/.ssh"
  gpg_public_keys_import_path=${HOME}/.ssh
else
  gpg_public_keys_import_path=${1}
fi

if [[ -z ${2+x} ]]; then
  echo "Set default import pattern: *-GPG-KEY"
  gpg_public_keys_import_pattern=*-GPG-KEY
else
  gpg_public_keys_import_pattern=${2}
fi

GPG_PUBLIC_KEYS=$(find ${gpg_public_keys_import_path} -name ${gpg_public_keys_import_pattern})
for GPG_KEY in ${GPG_PUBLIC_KEYS}; do
  /usr/bin/gpg2 --import ${GPG_KEY}
  sudo rpm --import ${GPG_KEY}
done
