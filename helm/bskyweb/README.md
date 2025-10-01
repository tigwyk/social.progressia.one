# Helm Charts for BSky Services

This directory contains Helm charts for deploying the Progressia.one Bluesky services on Kubernetes.

## Charts

### bskyweb (Root Chart)
- **Service**: Main Bluesky web application
- **Domain**: social.progressia.one  
- **Image**: registry.digitalocean.com/progressiaone/social.progressia.one:latest
- **Port**: 8100
- **Location**: Root helm directory (`./`)

### bskyembed
- **Service**: Embed service for Bluesky posts
- **Domain**: embed.progressia.one
- **Image**: registry.digitalocean.com/progressiaone/embed.progressia.one:latest
- **Port**: 3000
- **Location**: `./bskyembed/`

### bskylink
- **Service**: Link shortening/redirect service
- **Domain**: go.progressia.one
- **Image**: registry.digitalocean.com/progressiaone/go.progressia.one:latest
- **Port**: 3000
- **Storage**: Includes persistent volume for data storage
- **Location**: `./bskylink/`

## Prerequisites

- Kubernetes cluster
- Helm 3.x
- nginx-ingress-controller installed
- cert-manager installed (for TLS certificates)

## Installation

### Install bskyweb (main service)

```bash
helm install bskyweb .
```

### Install bskyembed

```bash
helm install bskyembed ./bskyembed
```

### Install bskylink

```bash
helm install bskylink ./bskylink
```

### Install all services

```bash
# Install all three services
helm install bskyweb .
helm install bskyembed ./bskyembed  
helm install bskylink ./bskylink
```

### Install with custom values

```bash
# For bskyweb
helm install bskyweb . -f custom-values.yaml

# For bskyembed
helm install bskyembed ./bskyembed -f custom-values.yaml

# For bskylink
helm install bskylink ./bskylink -f custom-values.yaml
```

## Configuration

### Common configurations

All charts support:
- Custom resource limits/requests
- Replica count adjustment
- Image pull secrets
- Node selectors and tolerations
- Custom environment variables

### bskyweb specific

```yaml
replicaCount: 2
image:
  tag: "v1.0.0"  # Override latest
resources:
  limits:
    cpu: 1000m
    memory: 1Gi
bskyweb:
  args:
    - "/usr/bin/bskyweb"
    - "serve"
    - "--appview-host=https://custom.api.host"
```

### bskyembed specific

```yaml
replicaCount: 2
image:
  tag: "v1.0.0"  # Override latest
resources:
  limits:
    cpu: 1000m
    memory: 1Gi
```

### bskylink specific

```yaml
replicaCount: 2
persistence:
  enabled: true
  size: 5Gi
  storageClass: "fast-ssd"
env:
  - name: CUSTOM_VAR
    value: "custom-value"
```

## TLS/SSL Configuration

All charts are configured to use Let's Encrypt for SSL certificates via cert-manager:
- **Cluster Issuer**: `letsencrypt-prod`
- **TLS Secrets**: 
  - bskyweb: `social-progressia-one-tls`
  - bskyembed: `embed-progressia-one-tls`
  - bskylink: `go-progressia-one-tls`

Make sure cert-manager is properly configured with the `letsencrypt-prod` cluster issuer.

## Monitoring and Health Checks

All services include:
- **bskyweb**: Liveness and readiness probes on `/` with configurable delays
- **bskyembed & bskylink**: HTTP GET on `/` with 30s initial delay for liveness, 5s for readiness

## Upgrade

```bash
helm upgrade bskyweb .
helm upgrade bskyembed ./bskyembed
helm upgrade bskylink ./bskylink
```

## Uninstall

```bash
helm uninstall bskyweb
helm uninstall bskyembed
helm uninstall bskylink
```

**Note**: For bskylink, the persistent volume claim will remain after uninstall. Delete manually if needed:

```bash
kubectl delete pvc <release-name>-bskylink-data
# For example: kubectl delete pvc bskylink-data
```
