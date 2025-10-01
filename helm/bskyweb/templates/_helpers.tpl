{{/*
Expand the name of the chart.
*/}}
{{- define "bskyweb.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "bskyweb.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "bskyweb.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "bskyweb.labels" -}}
helm.sh/chart: {{ include "bskyweb.chart" . }}
{{ include "bskyweb.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "bskyweb.selectorLabels" -}}
app.kubernetes.io/name: {{ include "bskyweb.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "bskyweb.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "bskyweb.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the proper image name
*/}}
{{- define "bskyweb.image" -}}
{{- $registryName := .Values.image.registry -}}
{{- $repositoryName := .Values.image.repository -}}
{{- $tag := .Values.image.tag | default .Chart.AppVersion | toString -}}
{{- if .Values.global -}}
{{- if .Values.global.imageRegistry -}}
{{- $registryName = .Values.global.imageRegistry -}}
{{- end -}}
{{- end -}}
{{- if $registryName -}}
{{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- else -}}
{{- printf "%s:%s" $repositoryName $tag -}}
{{- end -}}
{{- end }}

{{/*
Return the proper image pull secrets
*/}}
{{- define "bskyweb.imagePullSecrets" -}}
{{- $pullSecrets := list -}}
{{- if .Values.global -}}
{{- range .Values.global.imagePullSecrets -}}
{{- $pullSecrets = append $pullSecrets (dict "name" .) -}}
{{- end -}}
{{- else if .Values.imagePullSecrets -}}
{{- range .Values.imagePullSecrets -}}
{{- $pullSecrets = append $pullSecrets . -}}
{{- end -}}
{{- end -}}
{{- if (not (empty $pullSecrets)) -}}
imagePullSecrets:
{{- range $pullSecrets }}
- name: {{ .name }}
{{- end }}
{{- end -}}
{{- end }}

