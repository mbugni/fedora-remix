FROM registry.fedoraproject.org/fedora:39
RUN dnf --assumeyes --setopt='tsflags=nodocs' --setopt='install_weak_deps=False' \
install bash-completion distribution-gpg-keys kiwi-cli kiwi-systemdeps && \
dnf --assumeyes clean all && \
rm /etc/rpm/* -rf