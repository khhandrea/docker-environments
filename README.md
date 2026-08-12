# Docker environments

Docker environments for experiments.

This repository holds **image definitions only**. Each project keeps its own
`docker-compose.yaml` and `.env`, because mounts and GPU assignment are
project-specific while the image is shared.

## Building

Always pass `GIT_COMMIT` so the image records which commit produced it:

```bash
cd {ENVIRONMENT}
docker build \
  --build-arg GIT_COMMIT=$(git rev-parse HEAD) \
  -t khhandrea/{ENVIRONMENT}_env:{VERSION} .
docker push khhandrea/{ENVIRONMENT}_env:{VERSION}
```

Bump `{VERSION}` instead of overwriting an existing tag — old experiments
reference the tag they were run with.

## Verifying which commit an image was built from

```bash
docker image inspect khhandrea/{ENVIRONMENT}_env:{VERSION} \
  --format '{{index .Config.Labels "org.opencontainers.image.revision"}}'
```

`unknown` means the image predates this convention (or was built without the
build arg); for those, the image creation time is the only clue:

```bash
docker image inspect ... --format '{{.Created}}'
git log --format='%h %ci %s'
```

## Usage from a project

```bash
cd {PROJECT}
docker compose up -d
docker exec -it -u user {CONTAINER} bash
```

The entrypoint activates the conda environment, so `docker compose run` and
`docker exec` both land in it without a manual `conda activate`.

## Environments

- `diffusion_policy`: docker environment for workspaces regarding diffusion policy
  - conda env `diffusion_policy`, CUDA 11.8, MuJoCo 2.1.0 (`mujoco_py`) + 2.3.5
  - published as `khhandrea/diffusion_policy_env`
