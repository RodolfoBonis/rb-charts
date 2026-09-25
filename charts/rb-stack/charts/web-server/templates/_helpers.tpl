{{/*
Get the app name from parent chart
*/}}
{{- define "web-server.appName" -}}
{{- ((.Values.global).name) | default .Release.Name }}
{{- end }}

{{/*
Get the namespace from parent chart
*/}}
{{- define "web-server.namespace" -}}
{{- ((.Values.global).name) | default .Release.Namespace }}
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
environment: {{ ((.Values.global).environment) | default "prod" }}
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
{{- ((.Values.global).name) | default .Release.Name }}
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
{{- $appName := include "web-server.appName" . -}}
{{- $suffix := "web" -}}
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
Service name
*/}}
{{- define "web-server.serviceName" -}}
{{- $appName := include "web-server.appName" . -}}
{{- $suffix := "web" -}}
{{- if hasKey .Values "suffix" -}}
{{- $suffix = .Values.suffix -}}
{{- end -}}
{{- if $suffix -}}
{{- printf "%s-%s-svc" $appName $suffix -}}
{{- else -}}
{{- printf "%s-svc" $appName -}}
{{- end -}}
{{- end }}

{{/*
Security context field resolution.
Precedence per field: web-server override (.Values.securityContext) -> shared
global.securityContext -> secure default. Presence is tested with `hasKey`, NOT
`default`/`merge`: Sprig's `default` and mergo (behind `merge`) both treat 0 and
false as EMPTY, which silently coerced runAsUser: 0 back to 1000 and
readOnlyRootFilesystem: false back to true — making it impossible to run a
container as root or with a writable root filesystem. `hasKey` honors any
explicit value, including 0 and false.
*/}}
{{- define "web-server.podSecurityContext" -}}
{{- $g := (.Values.global).securityContext | default dict -}}
{{- $l := .Values.securityContext | default dict -}}
runAsNonRoot: {{ if hasKey $l "runAsNonRoot" }}{{ $l.runAsNonRoot }}{{ else if hasKey $g "runAsNonRoot" }}{{ $g.runAsNonRoot }}{{ else }}true{{ end }}
runAsUser: {{ if hasKey $l "runAsUser" }}{{ $l.runAsUser }}{{ else if hasKey $g "runAsUser" }}{{ $g.runAsUser }}{{ else }}1000{{ end }}
runAsGroup: {{ if hasKey $l "runAsGroup" }}{{ $l.runAsGroup }}{{ else if hasKey $g "runAsGroup" }}{{ $g.runAsGroup }}{{ else }}1000{{ end }}
fsGroup: {{ if hasKey $l "fsGroup" }}{{ $l.fsGroup }}{{ else if hasKey $g "fsGroup" }}{{ $g.fsGroup }}{{ else }}1000{{ end }}
{{- end }}

{{/*
Container security context
*/}}
{{- define "web-server.containerSecurityContext" -}}
{{- $g := (.Values.global).securityContext | default dict -}}
{{- $l := .Values.securityContext | default dict -}}
readOnlyRootFilesystem: {{ if hasKey $l "readOnlyRootFilesystem" }}{{ $l.readOnlyRootFilesystem }}{{ else if hasKey $g "readOnlyRootFilesystem" }}{{ $g.readOnlyRootFilesystem }}{{ else }}true{{ end }}
allowPrivilegeEscalation: {{ if hasKey $l "allowPrivilegeEscalation" }}{{ $l.allowPrivilegeEscalation }}{{ else if hasKey $g "allowPrivilegeEscalation" }}{{ $g.allowPrivilegeEscalation }}{{ else }}false{{ end }}
{{- end }}
