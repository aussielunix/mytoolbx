ARG SOURCE_IMAGE_NAME="${SOURCE_IMAGE_NAME:-wolfi-toolbox}"
ARG SOURCE_IMAGE_REGISTRY="${SOURCE_IMAGE_REGISTRY:-ghcr.io/ublue-os}"
ARG SOURCE_IMAGE="${SOURCE_IMAGE_REGISTRY}/${SOURCE_IMAGE_NAME}"

FROM $SOURCE_IMAGE:latest

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the Toolbox or Distrobox commands" \
      summary="A new cloud-native terminal experience powered by Wolfi and Homebrew" \
      maintainer="Mick Pollard <mick@aussielunix.io>"

COPY ./extra-packages /toolbox-packages
COPY ./files /

# Update image, Install Packages, and move /home/linuxbrew
RUN apk update && \
    apk upgrade && \
    grep -v '^#' /toolbox-packages | xargs apk add && \
    mv /home/linuxbrew /home/homebrew && \
    rm /toolbox-packages

# Install custom CA cert
COPY aussielunix_Root_CA_168848365996868199089383065266162030969.crt /
RUN cat /aussielunix_Root_CA_168848365996868199089383065266162030969.crt >> /etc/ssl/certs/ca-certificates.crt \
	&& rm -f /aussielunix_Root_CA_168848365996868199089383065266162030969.crt

# Patch /usr/bin/entrypoint
RUN sed -i '/missing_packages=0/,/# Workaround for when sudo is missing,/ s/^/#/' /usr/bin/entrypoint && \
    sed -i '/elif command -v apt-get/,/# Set SHELL to the install path inside the container/ s/^/#/' /usr/bin/entrypoint && \
    sed -i '/# Set SHELL to the install path inside the container/a touch /.containersetupdone' /usr/bin/entrypoint

# Use and configure bash, retrieve bash-prexec
RUN curl https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh -o /tmp/bash-prexec && \
    mkdir -p /usr/share/ && \
    cp /tmp/bash-prexec /usr/share/bash-prexec && \
    rm -rf /tmp/*
