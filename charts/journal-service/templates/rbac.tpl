apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: {{ include "journal-service.fullname" . }}-discovery
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "journal-service.labels" . | nindent 4 }}
rules:
  - apiGroups: [""]
    resources: ["services", "endpoints", "pods"]
    verbs: ["get", "list", "watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: {{ include "journal-service.fullname" . }}-discovery
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "journal-service.labels" . | nindent 4 }}
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: {{ include "journal-service.fullname" . }}-discovery
subjects:
  - kind: ServiceAccount
    name: {{ include "journal-service.fullname" . }}
    namespace: {{ .Release.Namespace }}
