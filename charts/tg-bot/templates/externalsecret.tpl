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
    - secretKey: TELEGRAM_WEBHOOK_SECRET_TOKEN
      remoteRef:
        key: {{ .Values.vault.secretPath }}
        property: TELEGRAM_WEBHOOK_SECRET_TOKEN
    - secretKey: CONFIG_SERVER_USERNAME
      remoteRef:
        key: {{ .Values.vault.secretPath }}
        property: CONFIG_SERVER_USERNAME
    - secretKey: CONFIG_SERVER_PASSWORD
      remoteRef:
        key: {{ .Values.vault.secretPath }}
        property: CONFIG_SERVER_PASSWORD
    - secretKey: ADMIN_TELEGRAM_IDS
      remoteRef:
        key: {{ .Values.vault.secretPath }}
        property: ADMIN_TELEGRAM_IDS

