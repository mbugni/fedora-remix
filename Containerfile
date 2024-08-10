FROM registry.fedoraproject.org/fedora-minimal:39
RUN microdnf --assumeyes --setopt='tsflags=nodocs' --setopt='install_weak_deps=False' \
install bash-completion distribution-gpg-keys python3-pip kiwi-systemdeps-iso-media && \
pip3 install kiwi==v10.1.1 --break-system-packages && \
microdnf --assumeyes clean all && \
rm /etc/rpm/* -rf