# mytoolbx

**Continuously deliver my daily driver Linux terminal environment**

A Containerfile and GitHub action for continuously building and publishing my daily driver Linux terminal environment.  
This OCI container image is to be run as a [distrobox](https://github.com/89luca89/distrobox) using [podman](https://podman.io/) and a systemd [quadlet](https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html)

- Starts with the minimalist [Wolfi OS](https://github.com/chainguard-images/images/tree/main/images/wolfi-base)
- adds Homebrew (for Linux)
- adds my custom CA Cert
- adds a few native packages - remember most packages will be installed using homebrew at runtime

## How to use

- Drop a systemd [quadlet](https://github.com/ublue-os/toolboxes/blob/main/quadlets/wolfi-toolbox/wolfi-dx-distrobox-quadlet.container) file into `~/.config/containers/systemd`
- `systemctl --user daemon-reload`
- `systemctl --user enable --now container-mytoolbx.service`  # name of the service matches the quadlet file with the suffix of `.container` replaced with `.service`
- To get automatic updates you will need to enable `podman-auto-update.timer` which by default will auto-update at midnight

## Verification

These images are signed with sisgstore's [cosign](https://docs.sigstore.dev/cosign/overview/). You can verify the signature by downloading the `cosign.pub` key from this repo and running the following command:

```bash
cosign verify --key cosign.pub ghcr.io/aussielunix/mytoolbx
```

## Attribution

This would not be possible without the work being done in the [Universal Blue](https://github.com/ublue-os/toolboxes/tree/main/toolboxes/wolfi-toolbox) project.
