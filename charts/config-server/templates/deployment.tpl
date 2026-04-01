apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "config-server.fullname" . }}
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "config-server.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      {{- include "config-server.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      labels:
        {{- include "config-server.selectorLabels" . | nindent 8 }}
      annotations:
        checksum/config: {{ include (print $.Template.BasePath "/configmap.tpl") . | sha256sum }}
    spec:
      serviceAccountName: {{ include "config-server.fullname" . }}
      {{- with .Values.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      containers:
        - name: config-server
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          ports:
            - name: http
              containerPort: {{ .Values.config.serverPort | int }}
              protocol: TCP
          envFrom:
            - configMapRef:
                name: {{ include "config-server.fullname" . }}-config
            - secretRef:
                name: {{ include "config-server.fullname" . }}-secrets
          livenessProbe:
            httpGet:
              path: /actuator/health/liveness
              port: http
            initialDelaySeconds: 30
            periodSeconds: 15
            failureThreshold: 3
          readinessProbe:
            httpGet:
              path: /actuator/health/readiness
              port: http
            initialDelaySeconds: 15
            periodSeconds: 10
            failureThreshold: 3
          resources:
            {{- toYaml .Values.resources | nindent 12 }}
