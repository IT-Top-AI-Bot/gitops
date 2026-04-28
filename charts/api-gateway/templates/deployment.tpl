apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "api-gateway.fullname" . }}
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "api-gateway.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      {{- include "api-gateway.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      labels:
        {{- include "api-gateway.selectorLabels" . | nindent 8 }}
      annotations:
        checksum/config: {{ include (print $.Template.BasePath "/configmap.tpl") . | sha256sum }}
    spec:
      serviceAccountName: {{ include "api-gateway.fullname" . }}
      {{- with .Values.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      initContainers:
        - name: wait-for-config-server
          image: busybox:1.36
          envFrom:
            - configMapRef:
                name: {{ include "api-gateway.fullname" . }}-config
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
        - name: api-gateway
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          ports:
            - name: http
              containerPort: {{ .Values.config.serverPort | int }}
              protocol: TCP
          envFrom:
            - configMapRef:
                name: {{ include "api-gateway.fullname" . }}-config
            - secretRef:
                name: {{ include "api-gateway.fullname" . }}-secrets
          startupProbe:
            httpGet:
              path: {{ .Values.probes.startup.path }}
              port: http
            periodSeconds: {{ .Values.probes.startup.periodSeconds }}
            failureThreshold: {{ .Values.probes.startup.failureThreshold }}
          livenessProbe:
            httpGet:
              path: {{ .Values.probes.liveness.path }}
              port: http
            initialDelaySeconds: {{ .Values.probes.liveness.initialDelaySeconds }}
            periodSeconds: {{ .Values.probes.liveness.periodSeconds }}
            failureThreshold: {{ .Values.probes.liveness.failureThreshold }}
          readinessProbe:
            httpGet:
              path: {{ .Values.probes.readiness.path }}
              port: http
            initialDelaySeconds: {{ .Values.probes.readiness.initialDelaySeconds }}
            periodSeconds: {{ .Values.probes.readiness.periodSeconds }}
            failureThreshold: {{ .Values.probes.readiness.failureThreshold }}
          resources:
            {{- toYaml .Values.resources | nindent 12 }}
