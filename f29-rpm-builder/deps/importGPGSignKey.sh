#!/usr/bin/env bash
set -euxo pipefail

if [[ -z ${1+x} ]]; then
  echo "Set default import master key: ${HOME}/.ssh/RPM-GPG-KEY.key"
  gpg_master_key=${HOME}/.ssh/RPM-GPG-KEY.key
else
  gpg_master_key=${1}
fi

if [[ ! -f ${gpg_master_key} ]]; then
  echo "${gpg_master_key} does not exits: not importing!"
  exit 0
fi

user_id=$(gpg2 --no-default-keyring --list-packets ${gpg_master_key} | grep ":user ID packet:" | gawk -F: '{print $3}' | sed -e 's/^[[:space:]]*//' -e 's/^"//' -e 's/"$//')
/usr/bin/gpg2 --import ${gpg_master_key}
cat  << EOF >> ${HOME}/.rpmmacros
%_signature gpg
%_gpg_path ${HOME}/.gnupg
%_gpg_name $user_id
%_gpgbin /usr/bin/gpg2
%__gpg_sign_cmd %{__gpg} gpg --force-v3-sigs --batch --verbose --no-armor --passphrase-fd 3 --no-secmem-warning -u "%{_gpg_name}" -sbo %{__signature_filename} --digest-algo sha256 %{__plaintext_filename}'
EOF
