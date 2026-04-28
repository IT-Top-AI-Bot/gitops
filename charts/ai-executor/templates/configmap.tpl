apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "ai-executor.fullname" . }}-config
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "ai-executor.labels" . | nindent 4 }}
data:
  SPRING_PROFILES_ACTIVE: {{ .Values.config.springProfile | quote }}
  SERVER_PORT: {{ .Values.config.serverPort | quote }}
  S3_BUCKET: {{ .Values.config.s3Bucket | quote }}
  HOMEWORK_DOWNLOAD_ALLOWED_HOSTS: {{ .Values.config.homeworkDownloadAllowedHosts | quote }}
  CONFIG_SERVER_HOST: {{ .Values.config.configServer.host | quote }}
  CONFIG_SERVER_PORT: {{ .Values.config.configServer.port | quote }}
  OTEL_EXPORTER_OTLP_ENDPOINT: {{ .Values.config.otel.endpoint | quote }}
