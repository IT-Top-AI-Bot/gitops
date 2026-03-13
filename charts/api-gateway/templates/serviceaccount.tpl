apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ include "api-gateway.fullname" . }}
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "api-gateway.labels" . | nindent 4 }}
