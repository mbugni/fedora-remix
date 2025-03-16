FROM registry.fedoraproject.org/fedora-minimal:41
RUN microdnf --assumeyes --setopt='tsflags=nodocs' --setopt='install_weak_deps=False' \
install bash-completion distribution-gpg-keys python3-pip kiwi-systemdeps-iso-media && \
pip3 install --exists-action=i --break-system-packages kiwi==v10.2.13 && \
microdnf --assumeyes clean all && \
rm /etc/rpm/* -rf