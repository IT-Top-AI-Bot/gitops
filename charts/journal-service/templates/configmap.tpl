apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "journal-service.fullname" . }}-config
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "journal-service.labels" . | nindent 4 }}
data:
  SPRING_PROFILES_ACTIVE: {{ .Values.config.springProfile | quote }}
  SERVER_PORT: {{ .Values.config.serverPort | quote }}
  JOURNAL_BASE_URL: {{ .Values.config.journal.baseUrl | quote }}
  JOURNAL_SYNC_INTERVAL: {{ .Values.config.journal.syncInterval | quote }}
  CONFIG_SERVER_HOST: {{ .Values.config.configServer.host | quote }}
  CONFIG_SERVER_PORT: {{ .Values.config.configServer.port | quote }}
  OTEL_EXPORTER_OTLP_ENDPOINT: {{ .Values.config.otel.endpoint | quote }}
