apiVersion: v1
kind: Service
metadata:
  name: {{ include "ai-executor.fullname" . }}
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "ai-executor.labels" . | nindent 4 }}
spec:
  type: {{ .Values.service.type }}
  ports:
    - port: {{ .Values.service.port }}
      targetPort: http
      protocol: TCP
      name: http
  selector:
    {{- include "ai-executor.selectorLabels" . | nindent 4 }}
