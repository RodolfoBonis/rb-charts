{{/*
Get the app name from parent chart
*/}}
{{- define "web-server.appName" -}}
{{- .Values.global.name | default .Release.Name }}
{{- end }}

{{/*
Get the namespace from parent chart
*/}}
{{- define "web-server.namespace" -}}
{{- .Values.global.name | default .Release.Namespace }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "web-server.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
app: {{ include "web-server.appName" . }}
app.kubernetes.io/name: {{ include "web-server.appName" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: web-server
app.kubernetes.io/managed-by: {{ .Release.Service }}
environment: {{ .Values.global.environment | default "prod" }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "web-server.selectorLabels" -}}
app: {{ include "web-server.appName" . }}
app.kubernetes.io/name: {{ include "web-server.appName" . }}
app.kubernetes.io/component: web-server
{{- end }}

{{/*
Service account name
*/}}
{{- define "web-server.serviceAccountName" -}}
{{- .Values.global.name | default .Release.Name }}
{{- end }}

{{/*
Secret name for app
*/}}
{{- define "web-server.secretName" -}}
{{- printf "%s-secret" (include "web-server.appName" .) }}
{{- end }}

{{/*
Deployment name
*/}}
{{- define "web-server.deploymentName" -}}
{{- printf "%s-web" (include "web-server.appName" .) }}
{{- end }}

{{/*
Service name
*/}}
{{- define "web-server.serviceName" -}}
{{- printf "%s-web-svc" (include "web-server.appName" .) }}
{{- end }}

{{/*
Pod security context
*/}}
{{- define "web-server.podSecurityContext" -}}
runAsNonRoot: {{ .Values.global.securityContext.runAsNonRoot | default true }}
runAsUser: {{ .Values.global.securityContext.runAsUser | default 1000 }}
runAsGroup: {{ .Values.global.securityContext.runAsGroup | default 1000 }}
fsGroup: {{ .Values.global.securityContext.fsGroup | default 1000 }}
{{- end }}

{{/*
Container security context
*/}}
{{- define "web-server.containerSecurityContext" -}}
readOnlyRootFilesystem: {{ .Values.global.securityContext.readOnlyRootFilesystem | default true }}
allowPrivilegeEscalation: {{ .Values.global.securityContext.allowPrivilegeEscalation | default false }}
{{- end }}
