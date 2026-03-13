apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "journal-service.fullname" . }}
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "journal-service.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      {{- include "journal-service.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      labels:
        {{- include "journal-service.selectorLabels" . | nindent 8 }}
      annotations:
        checksum/config: {{ include (print $.Template.BasePath "/configmap.tpl") . | sha256sum }}
    spec:
      serviceAccountName: {{ include "journal-service.fullname" . }}
      {{- with .Values.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      containers:
        - name: journal-service
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          ports:
            - name: http
              containerPort: {{ .Values.config.serverPort | int }}
              protocol: TCP
          envFrom:
            - configMapRef:
                name: {{ include "journal-service.fullname" . }}-config
            - secretRef:
                name: {{ include "journal-service.fullname" . }}-secrets
          livenessProbe:
            httpGet:
              path: /actuator/health/liveness
              port: http
            initialDelaySeconds: 60
            periodSeconds: 15
            failureThreshold: 3
          readinessProbe:
            httpGet:
              path: /actuator/health/readiness
              port: http
            initialDelaySeconds: 30
            periodSeconds: 10
            failureThreshold: 3
          resources:
            {{- toYaml .Values.resources | nindent 12 }}
