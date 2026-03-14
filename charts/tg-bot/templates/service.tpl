apiVersion: v1
kind: Service
metadata:
  name: {{ include "tg-bot.fullname" . }}
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "tg-bot.labels" . | nindent 4 }}
spec:
  type: ClusterIP
  ports:
    - port: 8080
      targetPort: http
      protocol: TCP
      name: http
  selector:
    {{- include "tg-bot.selectorLabels" . | nindent 4 }}
