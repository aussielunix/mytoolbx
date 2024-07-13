ARG SOURCE_IMAGE_NAME="${SOURCE_IMAGE_NAME:-wolfi-base}"
ARG SOURCE_IMAGE_REGISTRY="${SOURCE_IMAGE_REGISTRY:-cgr.dev/chainguard}"
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

# Get Distrobox-host-exec and host-spawn
##RUN git clone https://github.com/89luca89/distrobox.git --single-branch /tmp/distrobox && \
##    cp /tmp/distrobox/distrobox-host-exec /usr/bin/distrobox-host-exec && \
##    cp /tmp/distrobox/distrobox-export /usr/bin/distrobox-export && \
##    cp /tmp/distrobox/distrobox-init /usr/bin/entrypoint && \
##    wget https://github.com/1player/host-spawn/releases/download/$(cat /tmp/distrobox/distrobox-host-exec | grep host_spawn_version= | cut -d "\"" -f 2)/host-spawn-$(uname -m) -O /usr/bin/host-spawn && \
##    chmod +x /usr/bin/host-spawn && \
##    rm -drf /tmp/distrobox && \
##    ln -fs /bin/sh /usr/bin/sh

# Enable password less sudo
# using sudoers instead of toolbox filename here, so that in case of rootful
# distroboxes, the NOPASSWD can be deactivated for security reasons.
RUN echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/sudoers

# Copy the os-release file
RUN cp -p /etc/os-release /usr/lib/os-release

# Configure Locales and get bash-prexec
RUN mkdir -p /usr/share/ \
    && printf 'LANG=en_AU.utf8\nexport LANG\n' > /etc/profile.d/locale.sh \
    && printf 'LANG="en_AU.UTF-8"' > /etc/locale.conf
