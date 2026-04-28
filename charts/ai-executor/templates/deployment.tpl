apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "ai-executor.fullname" . }}
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "ai-executor.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      {{- include "ai-executor.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      labels:
        {{- include "ai-executor.selectorLabels" . | nindent 8 }}
      annotations:
        checksum/config: {{ include (print $.Template.BasePath "/configmap.tpl") . | sha256sum }}
    spec:
      serviceAccountName: {{ include "ai-executor.fullname" . }}
      {{- with .Values.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      initContainers:
        - name: wait-for-config-server
          image: busybox:1.36
          envFrom:
            - configMapRef:
                name: {{ include "ai-executor.fullname" . }}-config
          command:
            - sh
            - -c
            - |
              until wget -qO- http://${CONFIG_SERVER_HOST}/actuator/health 2>/dev/null | grep -q '"status":"UP"'; do
                echo "Waiting for config-server at ${CONFIG_SERVER_HOST}..."
                sleep 3
              done
              echo "Config-server is UP"
      containers:
        - name: ai-executor
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          ports:
            - name: http
              containerPort: {{ .Values.config.serverPort | int }}
              protocol: TCP
          envFrom:
            - configMapRef:
                name: {{ include "ai-executor.fullname" . }}-config
            - secretRef:
                name: {{ include "ai-executor.fullname" . }}-secrets
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
