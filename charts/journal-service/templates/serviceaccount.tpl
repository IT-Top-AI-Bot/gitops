apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ include "journal-service.fullname" . }}
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "journal-service.labels" . | nindent 4 }}
