#!/usr/bin/env bash
/usr/bin/createrepo ${NCI_RPM_BUILD_ROOT}/RPMS
sudo dnf makecache
