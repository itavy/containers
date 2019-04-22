FROM fedora:29

ARG GIT_COMMIT_HASH
ARG BUILD_TIME
ARG DNS_SERVER

COPY deps /tmp/deps

LABEL maintainer="Octavian Ionescu <itavyg@gmail.com>"

ENV NCI_RPM_BUILD_ROOT=/home/mockbuild/rpmbuild \
  LC_ALL=en_US.utf8 \
  LANG=en_US.utf8 \
  DISTRO_FLAVOR=f \
  DISTRO_VER=29

RUN set -euxo pipefail \
  # hack for https://github.com/containers/buildah/issues/1223
  && if [[ "$DNS_SERVER" != "" ]]; then echo "nameserver $DNS_SERVER" > /etc/resolv.conf; fi \
  && echo "deltarpm=False" >> /etc/dnf/dnf.conf \
  && echo "fastestmirror=True" >> /etc/dnf/dnf.conf \
  && echo "minrate=300k" >> /etc/dnf/dnf.conf \
  && echo "timeout=10" >> /etc/dnf/dnf.conf \
  && dnf clean all \
  && dnf install -y make \
  && make -C /tmp/deps

USER mockbuild

WORKDIR "/home/mockbuild/rpmbuild/SPECS"

VOLUME ["/home/mockbuild/rpmbuild/SPECS", "/home/mockbuild/rpmbuild/RPMS", "/home/mockbuild/rpmbuild/SRPMS"]

ENTRYPOINT ["/entrypoint.sh"]

CMD ["bash"]
