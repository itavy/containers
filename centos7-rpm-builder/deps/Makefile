REQUIRED_PACKAGES ?= rpm-build redhat-rpm-config gcc sudo pinentry rpm-sign createrepo yum-utils

.PHONY: all
all: | add-custom-repos refresh-repo-metadata install-packages add-mock-user \
	configure-sudo setup-rpm-env add-various-helpers setup-entry-point clean

.PHONY: add-custom-repos
add-custom-repos:
	mv /tmp/deps/itavy.repo /etc/yum.repos.d/itavy.repo

.PHONY: refresh-repo-metadata
refresh-repo-metadata:
	yum makecache fast -y

.PHONY: install-packages
install-packages:
	yum install -y epel-release
	yum install -y $(REQUIRED_PACKAGES)
	yum groupinstall -y "Development Tools"

.PHONY: add-mock-user
add-mock-user:
	groupadd --gid 1000 mock
	groupadd --gid 1001 mockbuild
	useradd \
    --uid 1000 \
    --groups wheel,mockbuild \
    --gid 1000 \
    --shell /bin/bash \
    --comment "Fedora 29 Mock Build user" \
    mockbuild
	mkdir /home/mockbuild/.ssh
	chown -R mockbuild. /home/mockbuild/.ssh
	chmod -R 700 /home/mockbuild/.ssh

.PHONY: configure-sudo
configure-sudo:
	mv /tmp/deps/sudoers /etc/sudoers

.PHONY: setup-rpm-env
setup-rpm-env:
	mkdir /home/mockbuild/bin
	$(shell mkdir -p /home/mockbuild/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS})
	echo '%_topdir /home/mockbuild/rpmbuild' > /home/mockbuild/.rpmmacros
	chown -R mockbuild. /home/mockbuild/bin /home/mockbuild/.rpmmacros /home/mockbuild/rpmbuild
	chmod -R o-w /home/mockbuild/bin /home/mockbuild/.rpmmacros /home/mockbuild/rpmbuild

.PHONY: setup-entry-point
setup-entry-point:
	mv /tmp/deps/entrypoint.sh /entrypoint.sh
	chmod +x /entrypoint.sh

.PHONY: add-various-helpers
add-various-helpers: add-import-gpg-master-key add-import-gpg-public-keys add-buildHelpers

.PHONY: add-import-gpg-master-key
add-import-gpg-master-key:
	mv /tmp/deps/importGPGSignKey.sh /usr/local/bin/importGPGSignKey.sh
	chmod +x /usr/local/bin/importGPGSignKey.sh

.PHONY: add-import-gpg-public-keys
add-import-gpg-public-keys:
	mv /tmp/deps/importGPGPublicKeys.sh /usr/local/bin/importGPGPublicKeys.sh
	chmod +x /usr/local/bin/importGPGPublicKeys.sh

.PHONY: add-buildHelpers
add-buildHelpers:
	mv /tmp/deps/updateRPMRepo.sh /usr/local/bin/updateRPMRepo.sh
	chmod +x /usr/local/bin/updateRPMRepo.sh
	mv /tmp/deps/installRequiredBuildDeps.sh /usr/local/bin/installRequiredBuildDeps.sh
	chmod +x /usr/local/bin/installRequiredBuildDeps.sh

.PHONY: clean
clean:
	yum clean all
	rm -rf /var/cache/yum
	rm -rf /tmp/deps

