# Dockerfile

This repo contains the only one Dockerfile I use.

## Images

- `base`
- `rust-base`
- `python-base`

> The value of the `IMAGE_NAME` variable in this README should be one of these.

## Platforms

- macOS aarch64
- Ubuntu amd64 (I believe it works for all Linux distributions.)

## Usage

```shell
docker build --target ${IMAGE_NAME} -t ${IMAGE_NAME} . --network=host
docker run -it --network=host ${IMAGE_NAME}
```

> Note that you may still not be able to use them as I do even if they build and run on your machine. Actually it depends on how you use docker. Things should be good if you are using VSCode's Remote extension; otherwise I don't know what will happen. For example, I use SSH and GPG forwarding provided by VSCode's Remote extension so you can barely see relevant configurations in the Dockerfile.

## GPU Support

### Nvidia

You have to use Nvidia's container runtime for their GPU. Learn more on how to install that from Nvidia's official [guide](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/index.html#)

After that the command should be:

```shell
docker run -it --network=host --runtime=nvidia --gpus all ${IMAGE_NAME}
```

### Apple Silicon

Congratulations. Now you'd have to buy a Nvidia card.

> I've heard that there may be some way to enable this feature (partially), but some say that it makes little sense considering that most ML infrastructures (e.g. training/inferencing frameworks) are already forced to optimize for Apple's CPU.

## Why only one Dockerfile?

I'd love a more modular structure too. I've tried

- one Dockerfile for one target image,

    but Docker doesn't allow importing one Dockerfile to another so the contents are mostly duplicated between dependant and its dependency, e.g. `rust-base` and `base`,
- `docker-compose` with `depends-on` specified,
    
    but they ignore this config while building, and [claim it a feature](https://github.com/docker/compose/issues/5228).
