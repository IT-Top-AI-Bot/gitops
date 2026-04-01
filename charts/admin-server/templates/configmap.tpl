apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "admin-server.fullname" . }}-config
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "admin-server.labels" . | nindent 4 }}
data:
  SPRING_PROFILES_ACTIVE: {{ .Values.config.springProfile | quote }}
  SERVER_PORT: {{ .Values.config.serverPort | quote }}
  OTEL_EXPORTER_OTLP_ENDPOINT: {{ .Values.config.otel.endpoint | quote }}
