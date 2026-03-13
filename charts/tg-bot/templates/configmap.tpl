apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "tg-bot.fullname" . }}-config
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "tg-bot.labels" . | nindent 4 }}
data:
  SPRING_PROFILES_ACTIVE: {{ .Values.config.springProfile | quote }}
  SERVER_PORT: {{ .Values.config.serverPort | quote }}
  BACKEND_BASE_URL: {{ .Values.config.backendBaseUrl | quote }}
