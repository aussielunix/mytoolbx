FROM docker.io/library/ubuntu:22.04

LABEL com.github.containers.toolbox="true" \
      name="ubuntu-toolbox" \
      version="22.04" \
      usage="This image is meant to be used with the toolbox command" \
      summary="Base image for creating Ubuntu toolbox containers" \
      maintainer="Mick Pollard <mick@aussielunix.io>"

# Install extra packages as well as libnss-myhostname
COPY extra-packages /

# Install custom CA cert
COPY aussielunix_Root_CA_168848365996868199089383065266162030969.crt /usr/local/share/ca-certificates/

RUN sed -Ei '/apt-get (update|upgrade)/s/^/#/' /usr/local/sbin/unminimize \
    && apt-get update -yq \
    && apt-get -yq dist-upgrade \
    && DEBIAN_FRONTEND=noninteractive apt-get -yq install \
      libnss-myhostname ubuntu-minimal ubuntu-standard \
      $(cat extra-packages | xargs) \
    && yes | /usr/local/sbin/unminimize && echo '' \
    && apt-get clean \
    && rm /extra-packages \
    && mkdir /usr/share/empty \
    && update-ca-certificates --verbose --fresh
