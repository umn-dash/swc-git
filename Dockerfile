# The following very specific base image tag is from the LATIS JupyterHub service, to prevent this error:
# jupyterhub version 2.1.1 != jupyterhub-singleuser version 2.2.2. This could cause failure to authenticate and result in redirect loops!
FROM jupyter/scipy-notebook@sha256:41911b6f333f464a05b503636e6fb03005f2c11e72c272476c49eaf57770fa80

MAINTAINER David Naughton <naughton@umn.edu>

USER root
# Remove the manpage blacklist, install man, install manpages
RUN rm /etc/dpkg/dpkg.cfg.d/excludes && \
    apt update -y && \
    apt install -y less && \
    dpkg -l | grep ^ii | cut -d' ' -f3 | xargs apt install -yq --no-install-recommends --reinstall man && \
    apt clean && \
    mv /usr/bin/man.REAL /usr/bin/man && \
    rm -rf /var/lib/apt/lists/*

USER $NB_UID

RUN mkdir "/home/${NB_USER}/Desktop" && \
    chmod -R g+rw "/home/${NB_USER}/Desktop"
