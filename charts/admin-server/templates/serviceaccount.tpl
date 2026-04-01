apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ include "admin-server.fullname" . }}
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "admin-server.labels" . | nindent 4 }}
