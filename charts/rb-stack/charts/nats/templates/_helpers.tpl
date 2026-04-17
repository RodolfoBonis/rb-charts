{{/*
Get the app name from parent chart
*/}}
{{- define "nats.appName" -}}
{{- ((.Values.global).name) | default .Release.Name }}
{{- end }}

{{/*
Get the namespace from parent chart
*/}}
{{- define "nats.namespace" -}}
{{- ((.Values.global).name) | default .Release.Namespace }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "nats.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
app: {{ include "nats.appName" . }}-nats
app.kubernetes.io/name: {{ include "nats.appName" . }}-nats
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: messaging
app.kubernetes.io/managed-by: {{ .Release.Service }}
environment: {{ ((.Values.global).environment) | default "prod" }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "nats.selectorLabels" -}}
app: {{ include "nats.appName" . }}-nats
app.kubernetes.io/name: {{ include "nats.appName" . }}-nats
app.kubernetes.io/component: messaging
{{- end }}

{{/*
Service account name
*/}}
{{- define "nats.serviceAccountName" -}}
{{- ((.Values.global).name) | default .Release.Name }}
{{- end }}

{{/*
Deployment name
*/}}
{{- define "nats.deploymentName" -}}
{{- printf "%s-nats" (include "nats.appName" .) }}
{{- end }}

{{/*
Service name
*/}}
{{- define "nats.serviceName" -}}
{{- printf "%s-nats-svc" (include "nats.appName" .) }}
{{- end }}

{{/*
PVC name
*/}}
{{- define "nats.pvcName" -}}
{{- printf "%s-nats-pvc" (include "nats.appName" .) }}
{{- end }}
