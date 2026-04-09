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
  MISTRAL_MODEL: {{ .Values.config.mistralModel | quote }}
  MISTRAL_VISION_MODEL: {{ .Values.config.mistralVisionModel | quote }}
  GEMINI_MODEL: {{ .Values.config.geminiModel | quote }}
  GEMINI_VISION_MODEL: {{ .Values.config.geminiVisionModel | quote }}
  CONFIG_SERVER_HOST: {{ .Values.config.configServer.host | quote }}
  OTEL_EXPORTER_OTLP_ENDPOINT: {{ .Values.config.otel.endpoint | quote }}
