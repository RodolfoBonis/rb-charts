# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Helm chart repository for standardized K3s deployments. The main chart is `rb-stack`, an umbrella chart that provides:
- Simplified naming convention: `name` = namespace = serviceaccount = labels
- Vault secrets via External Secrets Operator (ESO)
- Cloudflare exposure for external access
- pfSense DNS integration for internal network access

## Common Commands

```bash
# Update dependencies
cd charts/rb-stack
helm dependency update

# Lint the chart
helm lint .

# Preview generated templates
helm template test . \
  --set name=test-app \
  --set global.name=test-app \
  --set environment=prod \
  --set global.environment=prod \
  --set vault.basePath=k3s/test-app \
  --set web-server.enabled=true \
  --set web-server.image.repository=nginx \
  --set postgres.enabled=true \
  --debug
```

## Chart Architecture

```
charts/rb-stack/           # Main umbrella chart
├── Chart.yaml             # Dependencies: web-server, postgres, redis, mongodb
├── values.yaml            # Default values with global settings
├── templates/             # Parent chart templates
│   ├── _helpers.tpl       # Template helpers (naming, labels, Vault paths)
│   ├── namespace.yaml
│   ├── serviceaccount.yaml
│   ├── rolebinding.yaml
│   ├── secretstore.yaml   # ESO SecretStore for Vault
│   └── externalsecret-*.yaml  # ESO ExternalSecrets (app, db, redis)
└── charts/                # Subcharts
    ├── web-server/        # Deployment, Service, Ingress, HPA, ConfigMap
    ├── postgres/          # StatefulSet-like Deployment, PVC, Service
    ├── redis/             # Deployment, PVC (optional), Service
    └── mongodb/           # Deployment, PVC, Service
```

## Key Conventions

- **Naming**: The `name` value cascades everywhere - namespace, serviceaccount, labels, secret names
- **Global values**: Use `global.name` and `global.environment` to pass values to subcharts
- **Vault paths**: Secrets fetched from `{vault.basePath}/{environment}/{component}` (app, db, redis)
- **Secret names**: `{name}-secret`, `{name}-db-secret`, `{name}-redis-secret`
- **Internal access**: Enable `internalAccess.enabled` + `internalAccess.hostname` for LoadBalancer + pfSense DNS

## CI/CD

Charts are published to ChartMuseum at `https://charts.rodolfodebonis.com.br` via GitHub Actions on push to main. The workflow runs `helm lint` and `helm template` validation before publishing.
