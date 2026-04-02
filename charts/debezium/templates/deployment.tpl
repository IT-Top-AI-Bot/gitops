apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "debezium.fullname" . }}
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "debezium.labels" . | nindent 4 }}
spec:
  # CDC must run as a single instance — do not scale
  replicas: 1
  selector:
    matchLabels:
      {{- include "debezium.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      labels:
        {{- include "debezium.selectorLabels" . | nindent 8 }}
      annotations:
        checksum/config: {{ include (print $.Template.BasePath "/configmap.tpl") . | sha256sum }}
    spec:
      volumes:
        - name: config
          configMap:
            name: {{ include "debezium.fullname" . }}-config
      containers:
        - name: debezium
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          ports:
            - name: http
              containerPort: 8080
              protocol: TCP
          # Sensitive values injected as env vars; referenced in application.properties via ${VAR}
          envFrom:
            - secretRef:
                name: {{ include "debezium.fullname" . }}-secrets
          volumeMounts:
            - name: config
              mountPath: /debezium/conf/application.properties
              subPath: application.properties
          livenessProbe:
            httpGet:
              path: /q/health/live
              port: http
            initialDelaySeconds: 30
            periodSeconds: 15
            failureThreshold: 3
          readinessProbe:
            httpGet:
              path: /q/health/ready
              port: http
            initialDelaySeconds: 20
            periodSeconds: 10
            failureThreshold: 3
          resources:
            {{- toYaml .Values.resources | nindent 12 }}
