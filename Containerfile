ARG FEDORA_VERSION
FROM registry.fedoraproject.org/fedora-minimal:${FEDORA_VERSION}
ENTRYPOINT ["/bin/sh","-c"]
RUN microdnf --assumeyes --setopt='tsflags=nodocs' --setopt='install_weak_deps=False' \
install bash-completion distribution-gpg-keys python3-pip kiwi-systemdeps-iso-media && \
pip3 install --exists-action=i --break-system-packages kiwi==10.2.* && \
microdnf --assumeyes clean all && \
rm /etc/rpm/* -rf