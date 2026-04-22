apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "mock-journal-api.fullname" . }}-files
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "mock-journal-api.labels" . | nindent 4 }}
data:
{{- range $path, $_ := .Files.Glob "stubs/__files/*" }}
  {{ base $path }}: |
{{ $.Files.Get $path | indent 4 }}
{{- end }}
