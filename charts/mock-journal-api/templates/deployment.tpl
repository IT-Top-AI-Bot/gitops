apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "mock-journal-api.fullname" . }}
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "mock-journal-api.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      {{- include "mock-journal-api.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      labels:
        {{- include "mock-journal-api.selectorLabels" . | nindent 8 }}
      annotations:
        checksum/mappings: {{ include (print $.Template.BasePath "/configmap-mappings.tpl") . | sha256sum }}
        checksum/files: {{ include (print $.Template.BasePath "/configmap-files.tpl") . | sha256sum }}
    spec:
      containers:
        - name: wiremock
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          args:
            - --verbose
          ports:
            - name: http
              containerPort: 8080
              protocol: TCP
          volumeMounts:
            - name: mappings
              mountPath: /home/wiremock/mappings
            - name: files
              mountPath: /home/wiremock/__files
          livenessProbe:
            httpGet:
              path: /__admin/health
              port: http
            initialDelaySeconds: 10
            periodSeconds: 15
          readinessProbe:
            httpGet:
              path: /__admin/health
              port: http
            initialDelaySeconds: 5
            periodSeconds: 10
          resources:
            {{- toYaml .Values.resources | nindent 12 }}
      volumes:
        - name: mappings
          configMap:
            name: {{ include "mock-journal-api.fullname" . }}-mappings
        - name: files
          configMap:
            name: {{ include "mock-journal-api.fullname" . }}-files
