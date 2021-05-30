ARG releasever=latest

FROM registry.fedoraproject.org/fedora:${releasever}

RUN dnf -y install lorax-lmc-novirt && \
    dnf clean all && \
    mkdir /results
