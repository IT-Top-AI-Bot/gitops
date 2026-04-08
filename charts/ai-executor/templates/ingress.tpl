{{- if .Values.ingress.enabled -}}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ include "ai-executor.fullname" . }}
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "ai-executor.labels" . | nindent 4 }}
spec:
  ingressClassName: {{ .Values.ingress.className }}
  rules:
    - host: {{ .Values.ingress.host }}
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: {{ include "ai-executor.fullname" . }}
                port:
                  name: http
{{- end }}
