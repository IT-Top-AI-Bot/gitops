apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "config-server.fullname" . }}-config
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "config-server.labels" . | nindent 4 }}
data:
  SPRING_PROFILES_ACTIVE: {{ .Values.config.springProfile | quote }}
  SERVER_PORT: {{ .Values.config.serverPort | quote }}
  SPRING_BOOT_ADMIN_CLIENT_URL: {{ .Values.config.adminServer.url | quote }}
  SPRING_BOOT_ADMIN_CLIENT_INSTANCE_SERVICE_BASE_URL: {{ .Values.config.adminServer.serviceBaseUrl | quote }}
  OTEL_EXPORTER_OTLP_ENDPOINT: {{ .Values.config.otel.endpoint | quote }}
