apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: {{ include "tg-bot.fullname" . }}-secrets
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "tg-bot.labels" . | nindent 4 }}
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: {{ .Values.secretStore.name }}
    kind: {{ .Values.secretStore.kind }}
  target:
    name: {{ include "tg-bot.fullname" . }}-secrets
    creationPolicy: Owner
  data:
    - secretKey: TELEGRAM_BOT_TOKEN
      remoteRef:
        key: {{ .Values.vault.secretPath }}
        property: TELEGRAM_BOT_TOKEN
    - secretKey: TELEGRAM_BOT_USERNAME
      remoteRef:
        key: {{ .Values.vault.secretPath }}
        property: TELEGRAM_BOT_USERNAME
