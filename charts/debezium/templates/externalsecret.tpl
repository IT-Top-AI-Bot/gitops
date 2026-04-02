apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: {{ include "debezium.fullname" . }}-secrets
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "debezium.labels" . | nindent 4 }}
spec:
  refreshInterval: 5m
  secretStoreRef:
    name: {{ .Values.secretStore.name }}
    kind: {{ .Values.secretStore.kind }}
  target:
    name: {{ include "debezium.fullname" . }}-secrets
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
    - secretKey: DATABASE_USER
      remoteRef:
        key: {{ .Values.vault.secretPath }}
        property: DATABASE_USER
    - secretKey: DATABASE_PASSWORD
      remoteRef:
        key: {{ .Values.vault.secretPath }}
        property: DATABASE_PASSWORD
    - secretKey: KAFKA_BOOTSTRAP_SERVERS
      remoteRef:
        key: {{ .Values.vault.secretPath }}
        property: KAFKA_BOOTSTRAP_SERVERS
