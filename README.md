# containers
various containers

#### how to build
```bash

$ [OPTIONAL_VAR=value] make <folder-name> [section=<section to build; defaults to all>]

```
ex:
1. use a specific dns server
```bash

$ BUILD_DNS_SERVERS=8.8.8.8 make f29-rpm-builder section=build
```
2. use docker as build tool instead of buildah
```bash

$ CONTAINER_CMD=docker make f29-rpm-builder section=build
```
Note:
  some targets are available only for specific build tool; ex: publish-local is available only for buildah

3. to publish on public repository you need to specify `PUBLISH_USERNAME` and `PUBLISH_PASSWORD`; 
```bash
$ PUBLISH_USERNAME="<username>" \
  PUBLISH_PASSWORD="<password>" \
  make folder-name section=publish
```
or
```bash
$ CREDENTIALS_FILE=path-to-credentials-file \
  make folder-name section=publish
```
4.
optional, you can specify another server and repo to publish to: `PUBLISH_SERVER`, `PUBLISH_REPOSITORY` 
or a different image `PUBLISH_IMAGE`
```bash
$ PUBLISH_SERVER="you server address" \
  PUBLISH_REPOSITORY="your server repository" \
  PUBLISH_IMAGE="image name to publish" \
  make folder-name section=publish
```
