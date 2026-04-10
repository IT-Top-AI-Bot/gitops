apiVersion: v1
kind: Service
metadata:
  name: {{ include "debezium.fullname" . }}
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "debezium.labels" . | nindent 4 }}
spec:
  type: ClusterIP
  selector:
    {{- include "debezium.selectorLabels" . | nindent 4 }}
  ports:
    - name: rest
      port: 8083
      targetPort: rest
      protocol: TCP
