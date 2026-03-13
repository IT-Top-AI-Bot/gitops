apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ include "tg-bot.fullname" . }}
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "tg-bot.labels" . | nindent 4 }}
