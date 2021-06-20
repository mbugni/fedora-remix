ARG releasever=latest

FROM registry.fedoraproject.org/fedora:${releasever}

RUN rm /etc/rpm/* -f && \
    dnf -y install glibc-all-langpacks lorax-lmc-novirt && \
    dnf clean all && \
    mkdir /results
