apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: {{ include "config-server.fullname" . }}-secrets
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "config-server.labels" . | nindent 4 }}
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: {{ .Values.secretStore.name }}
    kind: {{ .Values.secretStore.kind }}
  target:
    name: {{ include "config-server.fullname" . }}-secrets
    creationPolicy: Owner
  data:
    - secretKey: CONFIG_SERVER_USERNAME
      remoteRef:
        key: {{ .Values.vault.secretPath }}
        property: CONFIG_SERVER_USERNAME
    - secretKey: CONFIG_SERVER_PASSWORD
      remoteRef:
        key: {{ .Values.vault.secretPath }}
        property: CONFIG_SERVER_PASSWORD
