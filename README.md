# mytoolbx

**Continuously deliver my toolbx container image**

A Containerfile and GitHub action for continuously building and publishing my Toolbx images to be used with [toolbx](https://containertoolbx.org/)

This image is going to experiment with what a "born from cloud native" UNIX terminal experience would look like.

- Starts with the latest Ubuntu 22.04 image from the [Toolbx Community Images](https://github.com/toolbx-images/images)
- Adds some quality of life
  - `python3`

## How to use

```bash
toolbox create -i ghcr.io/aussielunix/mytoolbx:latest -c mytoolbx
toolbox enter mytoolbx
```

:TODO: how to update toolbx container

## Verification

These images are signed with sisgstore's [cosign](https://docs.sigstore.dev/cosign/overview/). You can verify the signature by downloading the `cosign.pub` key from this repo and running the following command:

```bash
cosign verify --key cosign.pub ghcr.io/aussielunix/mytoolbx
```

## TODO

* Add owncloud client appimage

