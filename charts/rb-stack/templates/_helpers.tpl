{{/*
Expand the name of the chart.
*/}}
{{- define "rb-stack.name" -}}
{{- .Values.name | default .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "rb-stack.fullname" -}}
{{- .Values.name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "rb-stack.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "rb-stack.labels" -}}
helm.sh/chart: {{ include "rb-stack.chart" . }}
{{ include "rb-stack.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
environment: {{ .Values.environment }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "rb-stack.selectorLabels" -}}
app: {{ include "rb-stack.fullname" . }}
app.kubernetes.io/name: {{ include "rb-stack.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "rb-stack.serviceAccountName" -}}
{{- .Values.name }}
{{- end }}

{{/*
Create the namespace
*/}}
{{- define "rb-stack.namespace" -}}
{{- .Values.name }}
{{- end }}

{{/*
Create the Vault role name
*/}}
{{- define "rb-stack.vaultRole" -}}
{{- printf "%s-role" .Values.name }}
{{- end }}

{{/*
Create the SecretStore name
*/}}
{{- define "rb-stack.secretStoreName" -}}
{{- printf "%s-vault-secretstore" .Values.name }}
{{- end }}

{{/*
Create the app secret name
*/}}
{{- define "rb-stack.appSecretName" -}}
{{- printf "%s-secret" .Values.name }}
{{- end }}

{{/*
Create the db secret name
*/}}
{{- define "rb-stack.dbSecretName" -}}
{{- printf "%s-db-secret" .Values.name }}
{{- end }}

{{/*
Create the redis secret name
*/}}
{{- define "rb-stack.redisSecretName" -}}
{{- printf "%s-redis-secret" .Values.name }}
{{- end }}

{{/*
Create Vault path for a component
*/}}
{{- define "rb-stack.vaultPath" -}}
{{- $basePath := .basePath -}}
{{- $environment := .environment -}}
{{- $component := .component -}}
{{- printf "%s/%s/%s" $basePath $environment $component }}
{{- end }}

{{/*
Pod security context
*/}}
{{- define "rb-stack.podSecurityContext" -}}
runAsNonRoot: {{ .Values.securityContext.runAsNonRoot }}
runAsUser: {{ .Values.securityContext.runAsUser }}
runAsGroup: {{ .Values.securityContext.runAsGroup }}
fsGroup: {{ .Values.securityContext.fsGroup }}
{{- end }}

{{/*
Container security context
*/}}
{{- define "rb-stack.containerSecurityContext" -}}
readOnlyRootFilesystem: {{ .Values.securityContext.readOnlyRootFilesystem }}
allowPrivilegeEscalation: {{ .Values.securityContext.allowPrivilegeEscalation }}
{{- end }}
