apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: {{ include "journal-service.fullname" . }}-secrets
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "journal-service.labels" . | nindent 4 }}
spec:
  refreshInterval: "1h"
  secretStoreRef:
    name: {{ .Values.secretStore.name }}
    kind: {{ .Values.secretStore.kind }}
  target:
    name: {{ include "journal-service.fullname" . }}-secrets
    creationPolicy: Owner
  data:
    - secretKey: SPRING_DATASOURCE_URL
      remoteRef:
        key: {{ .Values.vault.secretPath }}
        property: db-url
    - secretKey: SPRING_DATASOURCE_USERNAME
      remoteRef:
        key: {{ .Values.vault.secretPath }}
        property: db-username
    - secretKey: SPRING_DATASOURCE_PASSWORD
      remoteRef:
        key: {{ .Values.vault.secretPath }}
        property: db-password
    - secretKey: SPRING_DATA_REDIS_PASSWORD
      remoteRef:
        key: {{ .Values.vault.secretPath }}
        property: redis-password
    - secretKey: SA_USERNAME
      remoteRef:
        key: {{ .Values.vault.secretPath }}
        property: sa-username
    - secretKey: SA_PASSWORD
      remoteRef:
        key: {{ .Values.vault.secretPath }}
        property: sa-password
    - secretKey: TOKEN_ENCRYPTION_KEY
      remoteRef:
        key: {{ .Values.vault.secretPath }}
        property: token-encryption-key
