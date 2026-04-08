apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ include "ai-executor.fullname" . }}
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "ai-executor.labels" . | nindent 4 }}
