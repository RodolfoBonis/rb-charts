{{/*
Get the app name from parent chart
*/}}
{{- define "mongodb.appName" -}}
{{- .Values.global.name | default .Release.Name }}
{{- end }}

{{/*
Get the namespace from parent chart
*/}}
{{- define "mongodb.namespace" -}}
{{- .Values.global.name | default .Release.Namespace }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mongodb.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
app: {{ include "mongodb.appName" . }}-mongodb
app.kubernetes.io/name: {{ include "mongodb.appName" . }}-mongodb
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: database
app.kubernetes.io/managed-by: {{ .Release.Service }}
environment: {{ .Values.global.environment | default "prod" }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "mongodb.selectorLabels" -}}
app: {{ include "mongodb.appName" . }}-mongodb
app.kubernetes.io/name: {{ include "mongodb.appName" . }}-mongodb
app.kubernetes.io/component: database
{{- end }}

{{/*
Service account name
*/}}
{{- define "mongodb.serviceAccountName" -}}
{{- .Values.global.name | default .Release.Name }}
{{- end }}

{{/*
Secret name for database
*/}}
{{- define "mongodb.secretName" -}}
{{- printf "%s-db-secret" (include "mongodb.appName" .) }}
{{- end }}

{{/*
Deployment name
*/}}
{{- define "mongodb.deploymentName" -}}
{{- printf "%s-mongodb" (include "mongodb.appName" .) }}
{{- end }}

{{/*
Service name
*/}}
{{- define "mongodb.serviceName" -}}
{{- printf "%s-mongodb-svc" (include "mongodb.appName" .) }}
{{- end }}

{{/*
PVC name
*/}}
{{- define "mongodb.pvcName" -}}
{{- printf "%s-mongodb-pvc" (include "mongodb.appName" .) }}
{{- end }}
