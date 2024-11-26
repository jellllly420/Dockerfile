# Dockerfiles

This Repo contains all my template Dockerfiles for daily use.

Note that there is no gurantee for their portability, e.g., I use SSH and GPG forwarding provided by VSCode's Remote extension, which means you cannot use your host's keys inside a container except you are using VSCode.

The Dockerfile in root directory is for an all-in-one dev container. You can use it by:

```shell
docker build -t dev:latest . --network=host
docker run -it --network=host dev:latest
```
