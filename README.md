# rb-charts

Standardized Helm charts for K3s deployments with:
- **Simplified configuration**: `name` = namespace = serviceaccount = labels
- **Vault secrets via ESO**: Automatic `dataFrom` extraction with optional key remapping
- **Cloudflare exposure**: Optional external access via `cloudflare.io/expose` annotation
- **pfSense DNS integration**: Internal network access for databases via LoadBalancer

## Quick Start

### 1. Add the Helm repository

```bash
helm repo add rb-charts https://charts.rodolfodebonis.com.br
helm repo update
```

### 2. Create a values file

```yaml
# values-prod.yaml
name: myapp
environment: prod

vault:
  basePath: k3s/myapp

web-server:
  enabled: true
  image:
    repository: 718446585908.dkr.ecr.sa-east-1.amazonaws.com/rodolfobonis/myapp
    tag: "1.0.0"
  port: 3000
  expose: true
  host: myapp.rodolfodebonis.com.br

postgres:
  enabled: true
  storage: 5Gi
  internalAccess:
    enabled: true
    hostname: myapp-postgres.rb.lab
```

### 3. Deploy with ArgoCD

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: myapp-prod
  namespace: argocd
spec:
  sources:
    - repoURL: https://charts.rodolfodebonis.com.br
      chart: rb-stack
      targetRevision: "0.1.0"
      helm:
        valueFiles:
          - $values/apps/myapp/values-prod.yaml
    - repoURL: https://github.com/RodolfoBonis/k3s-apps.git
      targetRevision: main
      ref: values
  destination:
    server: https://kubernetes.default.svc
    namespace: myapp
  syncPolicy:
    automated:
      selfHeal: true
      prune: true
    syncOptions:
      - CreateNamespace=true
```

## Chart: rb-stack

### Components

| Component | Description | Default |
|-----------|-------------|---------|
| web-server | Web application deployment with ingress | disabled |
| postgres | PostgreSQL database with PVC | disabled |
| redis | Redis cache with optional persistence | disabled |
| mongodb | MongoDB database with PVC | disabled |

### Configuration

#### Global Settings

| Parameter | Description | Default |
|-----------|-------------|---------|
| `name` | Application name (sets namespace, SA, labels) | `""` |
| `environment` | Environment (prod, stg, dev) | `prod` |
| `vault.basePath` | Vault KV path prefix | `""` |
| `vault.server` | Vault server URL | `https://vault.rodolfodebonis.com.br` |
| `vault.remap` | Key remapping per component | `{}` |

#### Web Server

| Parameter | Description | Default |
|-----------|-------------|---------|
| `web-server.enabled` | Enable web server | `false` |
| `web-server.replicas` | Number of replicas | `1` |
| `web-server.image.repository` | Container image | `""` |
| `web-server.image.tag` | Image tag | `latest` |
| `web-server.port` | Container port | `3000` |
| `web-server.expose` | Enable Cloudflare exposure | `false` |
| `web-server.host` | Ingress hostname | `""` |
| `web-server.hpa.enabled` | Enable HPA | `false` |
| `web-server.monitoring.enabled` | Enable Prometheus | `false` |

#### PostgreSQL

| Parameter | Description | Default |
|-----------|-------------|---------|
| `postgres.enabled` | Enable PostgreSQL | `false` |
| `postgres.image.tag` | PostgreSQL version | `17.2` |
| `postgres.port` | PostgreSQL port | `5432` |
| `postgres.storage` | PVC size | `2Gi` |
| `postgres.internalAccess.enabled` | Enable LoadBalancer + pfSense DNS | `false` |
| `postgres.internalAccess.hostname` | Internal hostname (e.g., myapp-postgres.rb.lab) | `""` |

#### Redis

| Parameter | Description | Default |
|-----------|-------------|---------|
| `redis.enabled` | Enable Redis | `false` |
| `redis.image.tag` | Redis version | `7-alpine` |
| `redis.port` | Redis port | `6379` |
| `redis.persistence.enabled` | Enable persistence | `false` |
| `redis.storage` | PVC size | `1Gi` |
| `redis.internalAccess.enabled` | Enable LoadBalancer + pfSense DNS | `false` |

#### MongoDB

| Parameter | Description | Default |
|-----------|-------------|---------|
| `mongodb.enabled` | Enable MongoDB | `false` |
| `mongodb.image.tag` | MongoDB version | `7.0` |
| `mongodb.port` | MongoDB port | `27017` |
| `mongodb.storage` | PVC size | `5Gi` |
| `mongodb.internalAccess.enabled` | Enable LoadBalancer + pfSense DNS | `false` |

## Vault Secrets Structure

The chart expects secrets in Vault at:
```
{vault.basePath}/{environment}/app    → {name}-secret
{vault.basePath}/{environment}/db     → {name}-db-secret
{vault.basePath}/{environment}/redis  → {name}-redis-secret
```

Example for `myapp` in `prod`:
```
k3s/myapp/prod/app    → myapp-secret
k3s/myapp/prod/db     → myapp-db-secret
k3s/myapp/prod/redis  → myapp-redis-secret
```

### Setting up Vault

```bash
# Create secrets
vault kv put k3s/myapp/prod/app \
  API_KEY=your_api_key \
  CLIENT_SECRET=your_secret

vault kv put k3s/myapp/prod/db \
  POSTGRES_USER=myapp \
  POSTGRES_PASSWORD=secret123 \
  POSTGRES_DB=myapp_db

# Create policy
vault policy write myapp-policy - <<EOF
path "k3s/data/myapp/*" {
  capabilities = ["read"]
}
EOF

# Create role
vault write auth/kubernetes/role/myapp-role \
  bound_service_account_names=myapp \
  bound_service_account_namespaces=myapp \
  policies=myapp-policy \
  ttl=24h
```

## Key Remapping

To rename Vault keys in the Kubernetes secret:

```yaml
vault:
  basePath: k3s/myapp
  remap:
    app:
      DB_PASSWORD: DATABASE_SECRET  # Vault key → K8s key
    db:
      POSTGRES_PASSWORD: DB_PASS
```

## Internal Network Access

Enable `internalAccess` to expose databases via LoadBalancer with pfSense DNS:

```yaml
postgres:
  enabled: true
  internalAccess:
    enabled: true
    hostname: myapp-postgres.rb.lab
```

This creates:
- Service type: `LoadBalancer` (MetalLB assigns IP)
- Annotation: `dns.pfsense.org/enabled: "true"`
- Annotation: `dns.pfsense.org/hostname: "myapp-postgres.rb.lab"`

Access from internal network: `psql -h myapp-postgres.rb.lab -U user -d database`

## Development

```bash
# Lint chart
cd charts/rb-stack
helm dependency update
helm lint .

# Template preview
helm template test . \
  --set name=test-app \
  --set environment=prod \
  --set vault.basePath=k3s/test-app \
  --set web-server.enabled=true \
  --set web-server.image.repository=nginx \
  --set web-server.host=test.example.com \
  --debug
```

## License

MIT
