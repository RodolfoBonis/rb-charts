{{/*
Get the app name from parent chart
*/}}
{{- define "redis.appName" -}}
{{- .Values.global.name | default .Release.Name }}
{{- end }}

{{/*
Get the namespace from parent chart
*/}}
{{- define "redis.namespace" -}}
{{- .Values.global.name | default .Release.Namespace }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "redis.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
app: {{ include "redis.appName" . }}-redis
app.kubernetes.io/name: {{ include "redis.appName" . }}-redis
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: cache
app.kubernetes.io/managed-by: {{ .Release.Service }}
environment: {{ .Values.global.environment | default "prod" }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "redis.selectorLabels" -}}
app: {{ include "redis.appName" . }}-redis
app.kubernetes.io/name: {{ include "redis.appName" . }}-redis
app.kubernetes.io/component: cache
{{- end }}

{{/*
Service account name
*/}}
{{- define "redis.serviceAccountName" -}}
{{- .Values.global.name | default .Release.Name }}
{{- end }}

{{/*
Secret name for redis
*/}}
{{- define "redis.secretName" -}}
{{- printf "%s-redis-secret" (include "redis.appName" .) }}
{{- end }}

{{/*
Deployment name
*/}}
{{- define "redis.deploymentName" -}}
{{- printf "%s-redis" (include "redis.appName" .) }}
{{- end }}

{{/*
Service name
*/}}
{{- define "redis.serviceName" -}}
{{- printf "%s-redis-svc" (include "redis.appName" .) }}
{{- end }}

{{/*
PVC name
*/}}
{{- define "redis.pvcName" -}}
{{- printf "%s-redis-pvc" (include "redis.appName" .) }}
{{- end }}
