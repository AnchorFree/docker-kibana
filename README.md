# General description

This container provide Kibana container for logging solution. Kibana helps you read logs from Elasticsearch cluster and easy to navigate throw it.

### File description

 * bin/run.sh - shell wrapper for Kibana entrypoint. It casts `kibana.tpl` config template file
 * config/kibana.tpl - Kibana config template file
 * Dockerfile - docker container make file
 * Makefile - helps you build and push docker images to Docker Hub

## Container installation

 1. Clone this repository
 2. Build and push Kibana image

```bash
make all && make prod
```
 3. [packer-elk](https://github.com/AnchorFree/packer-elk) repository helps you with container creation on host
