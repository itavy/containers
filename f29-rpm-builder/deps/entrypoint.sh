#!/usr/bin/env bash

/usr/local/bin/importGPGSignKey.sh ${HOME}/.ssh/RPM-GPG-KEY.key
/usr/local/bin/importGPGPublicKeys.sh ${HOME}/.ssh *-GPG-KEY

exec "$@"
