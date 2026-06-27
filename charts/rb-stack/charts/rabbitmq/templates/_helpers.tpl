{{/*
App name from parent chart (name = namespace = labels convention)
*/}}
{{- define "rabbitmq.appName" -}}
{{- ((.Values.global).name) | default .Release.Name }}
{{- end }}

{{- define "rabbitmq.namespace" -}}
{{- ((.Values.global).name) | default .Release.Namespace }}
{{- end }}

{{- define "rabbitmq.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
app: {{ include "rabbitmq.appName" . }}-rabbitmq
app.kubernetes.io/name: {{ include "rabbitmq.appName" . }}-rabbitmq
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: broker
app.kubernetes.io/managed-by: {{ .Release.Service }}
environment: {{ ((.Values.global).environment) | default "prod" }}
{{- end }}

{{- define "rabbitmq.selectorLabels" -}}
app: {{ include "rabbitmq.appName" . }}-rabbitmq
app.kubernetes.io/name: {{ include "rabbitmq.appName" . }}-rabbitmq
app.kubernetes.io/component: broker
{{- end }}

{{- define "rabbitmq.serviceAccountName" -}}
{{- ((.Values.global).name) | default .Release.Name }}
{{- end }}

{{- define "rabbitmq.fullname" -}}
{{- printf "%s-rabbitmq" (include "rabbitmq.appName" .) }}
{{- end }}

{{- define "rabbitmq.serviceName" -}}
{{- printf "%s-rabbitmq-svc" (include "rabbitmq.appName" .) }}
{{- end }}

{{- define "rabbitmq.headlessName" -}}
{{- printf "%s-rabbitmq-headless" (include "rabbitmq.appName" .) }}
{{- end }}

{{- define "rabbitmq.configName" -}}
{{- printf "%s-rabbitmq-config" (include "rabbitmq.appName" .) }}
{{- end }}

{{- define "rabbitmq.tlsSecretName" -}}
{{- .Values.tls.secretName | default (printf "%s-amqps-tls" (include "rabbitmq.fullname" .)) }}
{{- end }}
