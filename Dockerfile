FROM centos:6.4

ENV basearch=x86_64
ENV OPENSSL_VER=1.0.2
ENV OPENSSL_PATCH=u

SHELL ["/bin/bash", "-c"]

RUN cd /etc/yum.repos.d \
    && cp CentOS-Base.repo CentOS-Base.repo.bk
COPY CentOS-Base.repo /etc/yum.repos.d/

RUN wget http://artfiles.org/openssl.org/source/old/${OPENSSL_VER}/openssl-${OPENSSL_VER}${OPENSSL_PATCH}.tar.gz \
    && tar -xzvf openssl-${OPENSSL_VER}${OPENSSL_PATCH}.tar.gz \
    && rm openssl-${OPENSSL_VER}${OPENSSL_PATCH}.tar.gz \
    && cd openssl-${OPENSSL_VER}${OPENSSL_PATCH} \
    && yum update \
    && yum install -y gcc \
    && ./config --prefix=/usr/local --openssldir=/usr/local/openssl \
    && make \
    && make install \
    && mv /usr/bin/openssl /usr/bin/openssl-1.0.0 \
    && ln -s /usr/local/bin/openssl /usr/bin/openssl \
    && wget http://archive.kernel.org/centos-vault/6.8/os/${basearch}/Packages/nss-3.21.0-8.el6.${basearch}.rpm \
    && wget http://archive.kernel.org/centos-vault/6.8/os/${basearch}/Packages/nss-util-3.21.0-2.el6.${basearch}.rpm \
    && wget http://archive.kernel.org/centos-vault/6.8/os/${basearch}/Packages/nss-softokn-3.14.3-23.el6_7.${basearch}.rpm \
    && wget http://archive.kernel.org/centos-vault/6.8/os/${basearch}/Packages/nss-softokn-freebl-3.14.3-23.el6_7.${basearch}.rpm \
    && wget http://archive.kernel.org/centos-vault/6.8/os/${basearch}/Packages/nss-sysinit-3.21.0-8.el6.${basearch}.rpm \
    && wget http://archive.kernel.org/centos-vault/6.8/os/${basearch}/Packages/nss-tools-3.21.0-8.el6.${basearch}.rpm \
    && wget http://archive.kernel.org/centos-vault/6.8/os/${basearch}/Packages/nspr-4.11.0-1.el6.${basearch}.rpm \
    && rpm -Uvh nss-*.rpm nspr-4.11.0-1.el6.${basearch}.rpm \
    && wget http://archive.kernel.org/centos-vault/6.8/os/${basearch}/Packages/ca-certificates-2015.2.6-65.0.1.el6_7.noarch.rpm \
    && wget http://archive.kernel.org/centos-vault/6.8/os/${basearch}/Packages/p11-kit-0.18.5-2.el6_5.2.${basearch}.rpm \
    && wget http://archive.kernel.org/centos-vault/6.8/os/${basearch}/Packages/p11-kit-trust-0.18.5-2.el6_5.2.${basearch}.rpm \
    && rpm -Uvh p11-kit-*rpm \
    && rpm -Uvh ca-certificates-*rpm \
    && rm -f *.rpmy \
    && yum clean all

COPY Epel.repo /etc/yum.repos.d/

RUN yum update \
    && yum clean all

CMD [ "/bin/bash"]