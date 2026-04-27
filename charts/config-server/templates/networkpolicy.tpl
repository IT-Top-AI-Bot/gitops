{{- if .Values.networkPolicy.enabled }}
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: {{ include "config-server.fullname" . }}
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "config-server.labels" . | nindent 4 }}
spec:
  podSelector:
    matchLabels:
      {{- include "config-server.selectorLabels" . | nindent 6 }}
  policyTypes:
    - Ingress
  ingress:
    - from:
        {{- range .Values.networkPolicy.allowedNamespaces }}
        - namespaceSelector:
            matchLabels:
              kubernetes.io/metadata.name: {{ . | quote }}
        {{- end }}
      ports:
        - protocol: TCP
          port: {{ .Values.service.port }}
{{- end }}
