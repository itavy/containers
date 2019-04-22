REQUIRED_PACKAGES ?= rpm-build redhat-rpm-config gcc sudo pinentry

.PHONY: all
all: | install-packages add-mock-user configure-sudo setup-rpm-env add-various-helpers setup-entry-point clean

.PHONY: install-packages
install-packages:
	dnf install -y $(REQUIRED_PACKAGES)
	dnf groupinstall -y "Development Tools"

.PHONY: add-mock-user
add-mock-user:
	groupadd --gid 1000 mock
	useradd \
    --uid 1000 \
    --groups wheel \
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
add-various-helpers: add-import-gpg-master-key add-import-gpg-public-keys

.PHONY: add-import-gpg-master-key
add-import-gpg-master-key:
	mv /tmp/deps/importGPGSignKey.sh /usr/local/bin/importGPGSignKey.sh
	chmod +x /usr/local/bin/importGPGSignKey.sh

.PHONY: add-import-gpg-public-keys
add-import-gpg-public-keys:
	mv /tmp/deps/importGPGPublicKeys.sh /usr/local/bin/importGPGPublicKeys.sh
	chmod +x /usr/local/bin/importGPGPublicKeys.sh

.PHONY: clean
clean:
	dnf clean all
	rm -rf /var/cache/yum
	rm -rf /tmp/deps

