apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: {{ include "debezium.fullname" . }}-data
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "debezium.labels" . | nindent 4 }}
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: {{ .Values.persistence.size }}
  {{- if .Values.persistence.storageClass }}
  storageClassName: {{ .Values.persistence.storageClass }}
  {{- end }}
