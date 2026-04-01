apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ include "config-server.fullname" . }}
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "config-server.labels" . | nindent 4 }}
