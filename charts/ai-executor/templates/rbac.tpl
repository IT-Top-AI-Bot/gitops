apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: {{ include "ai-executor.fullname" . }}-discovery
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "ai-executor.labels" . | nindent 4 }}
rules:
  - apiGroups: [""]
    resources: ["services", "endpoints", "pods"]
    verbs: ["get", "list", "watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: {{ include "ai-executor.fullname" . }}-discovery
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "ai-executor.labels" . | nindent 4 }}
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: {{ include "ai-executor.fullname" . }}-discovery
subjects:
  - kind: ServiceAccount
    name: {{ include "ai-executor.fullname" . }}
    namespace: {{ .Release.Namespace }}
