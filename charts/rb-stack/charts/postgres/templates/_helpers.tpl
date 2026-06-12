{{/*
Get the app name from parent chart
*/}}
{{- define "postgres.appName" -}}
{{- ((.Values.global).name) | default .Release.Name }}
{{- end }}

{{/*
Get the namespace from parent chart
*/}}
{{- define "postgres.namespace" -}}
{{- ((.Values.global).name) | default .Release.Namespace }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "postgres.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
app: {{ include "postgres.appName" . }}-postgres
app.kubernetes.io/name: {{ include "postgres.appName" . }}-postgres
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: database
app.kubernetes.io/managed-by: {{ .Release.Service }}
environment: {{ ((.Values.global).environment) | default "prod" }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "postgres.selectorLabels" -}}
app: {{ include "postgres.appName" . }}-postgres
app.kubernetes.io/name: {{ include "postgres.appName" . }}-postgres
app.kubernetes.io/component: database
{{- end }}

{{/*
Service account name
*/}}
{{- define "postgres.serviceAccountName" -}}
{{- ((.Values.global).name) | default .Release.Name }}
{{- end }}

{{/*
Secret name for database
*/}}
{{- define "postgres.secretName" -}}
{{- printf "%s-db-secret" (include "postgres.appName" .) }}
{{- end }}

{{/*
Deployment name
*/}}
{{- define "postgres.deploymentName" -}}
{{- printf "%s-postgres" (include "postgres.appName" .) }}
{{- end }}

{{/*
Service name
*/}}
{{- define "postgres.serviceName" -}}
{{- printf "%s-postgres-svc" (include "postgres.appName" .) }}
{{- end }}

{{/*
PVC name
*/}}
{{- define "postgres.pvcName" -}}
{{- printf "%s-postgres-pvc" (include "postgres.appName" .) }}
{{- end }}

{{/*
CNPG: nome do Cluster
*/}}
{{- define "postgres.cnpgClusterName" -}}
{{- printf "%s-postgres" (include "postgres.appName" .) }}
{{- end }}

{{/*
CNPG: service read-write gerado pelo operator
*/}}
{{- define "postgres.cnpgRwServiceName" -}}
{{- printf "%s-rw" (include "postgres.cnpgClusterName" .) }}
{{- end }}

{{/*
CNPG: database (default = app name)
*/}}
{{- define "postgres.cnpgDatabase" -}}
{{- .Values.cnpg.database | default (include "postgres.appName" .) }}
{{- end }}

{{/*
CNPG: owner role (default = app name)
*/}}
{{- define "postgres.cnpgOwner" -}}
{{- .Values.cnpg.owner | default (include "postgres.appName" .) }}
{{- end }}

{{/*
CNPG: secret (basic-auth) com username/password do owner
*/}}
{{- define "postgres.cnpgOwnerSecret" -}}
{{- .Values.cnpg.ownerSecret.name | default (printf "%s-cnpg-app" (include "postgres.appName" .)) }}
{{- end }}
