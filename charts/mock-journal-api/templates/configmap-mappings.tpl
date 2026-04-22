apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "mock-journal-api.fullname" . }}-mappings
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "mock-journal-api.labels" . | nindent 4 }}
data:
{{- range $path, $_ := .Files.Glob "stubs/mappings/*.json" }}
  {{ base $path }}: |
{{ $.Files.Get $path | indent 4 }}
{{- end }}
