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
  TELEGRAM_BOT_WEBHOOK_HOST: {{ .Values.config.webhookHost | quote }}
  PROXY_HOST: {{ .Values.config.proxyHost | quote }}
  PROXY_PORT: {{ .Values.config.proxyPort | quote }}
