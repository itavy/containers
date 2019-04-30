FROM centos:7

ARG GIT_COMMIT_HASH
ARG BUILD_TIME
ARG DNS_SERVER

COPY deps /tmp/deps

LABEL maintainer="Octavian Ionescu <itavyg@gmail.com>"

ENV NCI_RPM_BUILD_ROOT=/home/mockbuild/rpmbuild \
  LC_ALL=en_US.utf8 \
  LANG=en_US.utf8

RUN set -euxo pipefail \
  # hack for https://github.com/containers/buildah/issues/1223
  && if [[ "$DNS_SERVER" != "" ]]; then echo "nameserver $DNS_SERVER" > /etc/resolv.conf; fi \
  && echo "deltarpm=0" >> /etc/yum.conf \
  && echo "metadata_expire=90m" >> /etc/yum.conf \
  && echo "minrate=300000" >> /etc/yum.conf \
  && echo "timeout=10" >> /etc/yum.conf \
  && yum clean all \
  && yum install -y make \
  && make -C /tmp/deps

USER mockbuild

WORKDIR "/home/mockbuild/rpmbuild/SPECS"

VOLUME ["/home/mockbuild/rpmbuild/SPECS", "/home/mockbuild/rpmbuild/RPMS", "/home/mockbuild/rpmbuild/SRPMS"]

ENTRYPOINT ["/entrypoint.sh"]

CMD ["bash"]
