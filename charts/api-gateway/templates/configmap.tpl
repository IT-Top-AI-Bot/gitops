apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "api-gateway.fullname" . }}-config
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "api-gateway.labels" . | nindent 4 }}
data:
  SPRING_PROFILES_ACTIVE: {{ .Values.config.springProfile | quote }}
  SERVER_PORT: {{ .Values.config.serverPort | quote }}
  CONFIG_SERVER_HOST: {{ printf "%s:%s" .Values.config.configServer.host (.Values.config.configServer.port | toString) | quote }}
  OTEL_EXPORTER_OTLP_ENDPOINT: {{ .Values.config.otel.endpoint | quote }}
