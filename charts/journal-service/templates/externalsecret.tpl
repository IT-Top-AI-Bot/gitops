apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: {{ include "journal-service.fullname" . }}-secrets
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "journal-service.labels" . | nindent 4 }}
spec:
  refreshInterval: 5m
  secretStoreRef:
    name: {{ .Values.secretStore.name }}
    kind: {{ .Values.secretStore.kind }}
  target:
    name: {{ include "journal-service.fullname" . }}-secrets
    creationPolicy: Owner
  data:
    - secretKey: DATABASE_HOST
      remoteRef:
        key: {{ .Values.vault.secretPath }}
        property: DATABASE_HOST
    - secretKey: DATABASE_PORT
      remoteRef:
        key: {{ .Values.vault.secretPath }}
        property: DATABASE_PORT
    - secretKey: DATABASE_NAME
      remoteRef:
        key: {{ .Values.vault.secretPath }}
        property: DATABASE_NAME
    - secretKey: DATABASE_USERNAME
      remoteRef:
        key: {{ .Values.vault.secretPath }}
        property: DATABASE_USERNAME
    - secretKey: DATABASE_PASSWORD
      remoteRef:
        key: {{ .Values.vault.secretPath }}
        property: DATABASE_PASSWORD
    - secretKey: REDIS_HOST
      remoteRef:
        key: {{ .Values.vault.secretPath }}
        property: REDIS_HOST
    - secretKey: REDIS_PORT
      remoteRef:
        key: {{ .Values.vault.secretPath }}
        property: REDIS_PORT
    - secretKey: REDIS_PASSWORD
      remoteRef:
        key: {{ .Values.vault.secretPath }}
        property: REDIS_PASSWORD
    - secretKey: S3_ENDPOINT
      remoteRef:
        key: {{ .Values.vault.secretPath }}
        property: S3_ENDPOINT
    - secretKey: S3_REGION
      remoteRef:
        key: {{ .Values.vault.secretPath }}
        property: S3_REGION
    - secretKey: S3_ACCESS_KEY
      remoteRef:
        key: {{ .Values.vault.secretPath }}
        property: S3_ACCESS_KEY
    - secretKey: S3_SECRET_KEY
      remoteRef:
        key: {{ .Values.vault.secretPath }}
        property: S3_SECRET_KEY
    - secretKey: KAFKA_BOOTSTRAP_SERVERS
      remoteRef:
        key: {{ .Values.vault.secretPath }}
        property: KAFKA_BOOTSTRAP_SERVERS
    - secretKey: ENCRYPTION_KEY
      remoteRef:
        key: {{ .Values.vault.secretPath }}
        property: ENCRYPTION_KEY
    - secretKey: SA_USERNAME
      remoteRef:
        key: {{ .Values.vault.secretPath }}
        property: SA_USERNAME
    - secretKey: SA_PASSWORD
      remoteRef:
        key: {{ .Values.vault.secretPath }}
        property: SA_PASSWORD
    - secretKey: APPLICATION_KEY
      remoteRef:
        key: {{ .Values.vault.secretPath }}
        property: APPLICATION_KEY
    - secretKey: CONFIG_SERVER_USERNAME
      remoteRef:
        key: {{ .Values.vault.secretPath }}
        property: CONFIG_SERVER_USERNAME
    - secretKey: CONFIG_SERVER_PASSWORD
      remoteRef:
        key: {{ .Values.vault.secretPath }}
        property: CONFIG_SERVER_PASSWORD
