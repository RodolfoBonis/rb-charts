{{/*
Get the app name from parent chart
*/}}
{{- define "worker.appName" -}}
{{- ((.Values.global).name) | default .Release.Name }}
{{- end }}

{{/*
Get the namespace from parent chart
*/}}
{{- define "worker.namespace" -}}
{{- ((.Values.global).name) | default .Release.Namespace }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "worker.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
app: {{ include "worker.appName" . }}
app.kubernetes.io/name: {{ include "worker.appName" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: worker
app.kubernetes.io/managed-by: {{ .Release.Service }}
environment: {{ ((.Values.global).environment) | default "prod" }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "worker.selectorLabels" -}}
app: {{ include "worker.appName" . }}
app.kubernetes.io/name: {{ include "worker.appName" . }}
app.kubernetes.io/component: worker
{{- end }}

{{/*
Service account name
*/}}
{{- define "worker.serviceAccountName" -}}
{{- ((.Values.global).name) | default .Release.Name }}
{{- end }}

{{/*
App secret name (shared with web-server)
*/}}
{{- define "worker.secretName" -}}
{{- printf "%s-secret" (include "worker.appName" .) }}
{{- end }}

{{/*
Deployment name
*/}}
{{- define "worker.deploymentName" -}}
{{- $appName := include "worker.appName" . -}}
{{- $suffix := "worker" -}}
{{- if hasKey .Values "suffix" -}}
{{- $suffix = .Values.suffix -}}
{{- end -}}
{{- if $suffix -}}
{{- printf "%s-%s" $appName $suffix -}}
{{- else -}}
{{- $appName -}}
{{- end -}}
{{- end }}

{{/*
Pod security context
*/}}
{{- define "worker.podSecurityContext" -}}
runAsNonRoot: {{ (((.Values.global).securityContext).runAsNonRoot) | default true }}
runAsUser: {{ (((.Values.global).securityContext).runAsUser) | default 1000 }}
runAsGroup: {{ (((.Values.global).securityContext).runAsGroup) | default 1000 }}
fsGroup: {{ (((.Values.global).securityContext).fsGroup) | default 1000 }}
{{- end }}

{{/*
Container security context
*/}}
{{- define "worker.containerSecurityContext" -}}
readOnlyRootFilesystem: {{ (((.Values.global).securityContext).readOnlyRootFilesystem) | default true }}
allowPrivilegeEscalation: {{ (((.Values.global).securityContext).allowPrivilegeEscalation) | default false }}
{{- end }}
