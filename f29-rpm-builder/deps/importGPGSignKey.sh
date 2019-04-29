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
EOF
tmp_pub_key=/tmp/pub.key
gpg2 --export -a "${user_id}" > ${tmp_pub_key}
sudo rpm --import ${tmp_pub_key}
rm -rf ${tmp_pub_key}
