apiVersion: external-secrets.io/v1beta1
kind: SecretStore
metadata:
  name: vault-backend
  namespace: {{ .Release.Namespace }}
spec:
  provider:
    vault:
      server: {{ .Values.vault.address | quote }}
      path: {{ .Values.vault.mountPath | quote }}
      version: "v2"
      auth:
        kubernetes:
          mountPath: {{ .Values.vault.kubernetesMountPath | quote }}
          role: {{ .Values.vault.role | quote }}
          serviceAccountRef:
            name: external-secrets
