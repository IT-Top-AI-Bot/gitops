apiVersion: v1
kind: Service
metadata:
  name: {{ include "mock-journal-api.fullname" . }}
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "mock-journal-api.labels" . | nindent 4 }}
spec:
  type: {{ .Values.service.type }}
  ports:
    - port: {{ .Values.service.port }}
      targetPort: http
      protocol: TCP
      name: http
  selector:
    {{- include "mock-journal-api.selectorLabels" . | nindent 4 }}
