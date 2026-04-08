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
  MISTRAL_PROXY_HOST: {{ .Values.config.mistral.proxyHost | quote }}
  MISTRAL_PROXY_PORT: {{ .Values.config.mistral.proxyPort | quote }}
  GEMINI_MODEL: {{ .Values.config.geminiModel | quote }}
  GEMINI_VISION_MODEL: {{ .Values.config.geminiVisionModel | quote }}
  GEMINI_PROXY_HOST: {{ .Values.config.gemini.proxyHost | quote }}
  GEMINI_PROXY_PORT: {{ .Values.config.gemini.proxyPort | quote }}
  CONFIG_SERVER_HOST: {{ .Values.config.configServer.host | quote }}
  OTEL_EXPORTER_OTLP_ENDPOINT: {{ .Values.config.otel.endpoint | quote }}
