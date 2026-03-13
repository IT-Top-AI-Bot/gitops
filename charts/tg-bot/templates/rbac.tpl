apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: {{ include "tg-bot.fullname" . }}-discovery
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "tg-bot.labels" . | nindent 4 }}
rules:
  - apiGroups: [""]
    resources: ["services", "endpoints", "pods"]
    verbs: ["get", "list", "watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: {{ include "tg-bot.fullname" . }}-discovery
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "tg-bot.labels" . | nindent 4 }}
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: {{ include "tg-bot.fullname" . }}-discovery
subjects:
  - kind: ServiceAccount
    name: {{ include "tg-bot.fullname" . }}
    namespace: {{ .Release.Namespace }}
