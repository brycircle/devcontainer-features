# devcontainer features

> **Fork notice:** This is a fork of [ChristopherMacGown/devcontainer-features](https://github.com/ChristopherMacGown/devcontainer-features).
> It retains only the `direnv` feature, which has been updated to support Alpine Linux images in addition to Debian/Ubuntu.

This repository contains the `direnv` devcontainer feature.

## Collected Features

### direnv

[direnv](https://github.com/direnv/direnv) augments shells to load and unload
environment variables based on the current working directory.

#### usage
```json 
"features": {
    "ghcr.io/brycircle/devcontainer-features/direnv:1": {}
}
```
Additional options can be found in the [feature documentation](src/direnv/README.md).
