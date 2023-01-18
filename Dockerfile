FROM centos:6.4 as liveos

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
    && rm -f *.rpm \
    && yum remove -y firefox thunderbird gnome-* pulseaudio* abyssinica-fonts.x* anaconda-yum-plugins.noarch* \
    at-spi.x* authconfig-gtk.x* autofs.x* avahi-auto* avahi-glib* avahi-ui* bluez-libs* celt* cifs* cjkuni* comps-extras* \
    ConsoleKit-x11* control-center* cracklib-python* createrepo* ctapi-common* dbus-x11* dejavu-* deltarpm.x* \
    DeviceKit-power* device-mapper-multipath* device-mapper-persistent* dmz-cursor* dnsmasq* docbook* enchant* evince* exempi* \
    fcoe-utils* flac* fontpack* fprint* fuse* gamin-pyton* GConf2* gdm-libs* geniso* glx-utils* gnutls-utils* \
    gtk2-eng* gtksource* gtk-vnc* guchar* hesiod* iscsi-init* isomd* jomolhari* keyutils.x* khmeros* kurdit* libao* \
    libarchive* libart* libasync* libata* libavc* libbono* libcacard* libcdio* libconfig* libcroco* libdae* libdmx* libdv*  \
    liberation* libevent* libexif* libfprint* libglade* libgnome* libgphoto* libgsf* libgss* libgtop* libhba* libical*  \
    libIDL* libiec* libipt* libmcpp* libopen* libraw* libreport-newt* librsvg* libsample* libselinux-python* libshout*  \
    libsmb* libsnd* libspectre* libtall* libtdb* libtirp* libtool* libuser-python* libv4l* libvirt* libwacom* libwnck*  \
    libXdmc* libxk* libXmu* libXres* libXScrn* libxslt* libXvMC* libXxf8* lldpad* lockdev* log4cpp* lohit* madan*  \
    makebootfat* mcpp* memtest* Modem* mozilla* mtdev* mtools* NetworkManager* nfs4* nfs* nsplug* obex* openct* openob*  \
    openssh-ask* ORBit* PackageKit* paktype* pcsc* plymouth-graphics* plymouth-plugin* plymouth-system* plymouth-theme*  \
    plymouth-utils* polkit-* poppler-glib* ppp* pycairo* pygobject* pygtk* pykick* pyorbit* pypart* pyxf86* rarian*  \
    rdesk* redhat-book* redhat-menu* rpcbind* rtkit* samba* sgml* shared* sil* smc* smp* sound* spee* spice*  \
    squashfs* startup* stix* syslinux* taglib* thai* tibet* tiger* ttmkf* udisk* un-core* unique* usbred*  \
    usermode-gtk* vlgo* vte* wacom* wav* wdae* wodim* wpa* wqy* xcb* xdg* xkey* xvattr* yajl* \
    && yum clean all

COPY Epel.repo /etc/yum.repos.d/

# Building the images with all of the extra packages removed from live
FROM scratch as centos-base

ENV basearch=x86_64

SHELL ["/bin/bash", "-c"]

COPY --from=liveos / /

RUN yum update \
    && yum clean all

CMD [ "/bin/bash"]