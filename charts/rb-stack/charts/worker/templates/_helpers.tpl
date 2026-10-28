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
{{- $sc := ((.Values.global).securityContext) | default dict -}}
runAsNonRoot: {{ ternary true $sc.runAsNonRoot (kindIs "invalid" $sc.runAsNonRoot) }}
runAsUser: {{ $sc.runAsUser | default 1000 }}
runAsGroup: {{ $sc.runAsGroup | default 1000 }}
fsGroup: {{ $sc.fsGroup | default 1000 }}
{{- end }}

{{/*
Container security context. Booleans respect an explicit false (`| default true` would turn
false into true).
*/}}
{{- define "worker.containerSecurityContext" -}}
{{- $sc := ((.Values.global).securityContext) | default dict -}}
readOnlyRootFilesystem: {{ ternary true $sc.readOnlyRootFilesystem (kindIs "invalid" $sc.readOnlyRootFilesystem) }}
allowPrivilegeEscalation: {{ ternary false $sc.allowPrivilegeEscalation (kindIs "invalid" $sc.allowPrivilegeEscalation) }}
{{- end }}
