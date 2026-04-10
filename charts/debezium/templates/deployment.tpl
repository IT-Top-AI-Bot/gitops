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
      containers:
        - name: debezium
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          ports:
            - name: rest
              containerPort: 8083
              protocol: TCP
          # DB credentials injected from ExternalSecret; referenced in connector.json via ${env:VAR}
          envFrom:
            - secretRef:
                name: {{ include "debezium.fullname" . }}-secrets
          env:
            # Kafka Connect worker config
            - name: BOOTSTRAP_SERVERS
              value: {{ .Values.kafkaBootstrapServers | quote }}
            - name: GROUP_ID
              value: {{ .Values.kafka.groupId | quote }}
            - name: CONFIG_STORAGE_TOPIC
              value: {{ .Values.kafka.configStorageTopic | quote }}
            - name: OFFSET_STORAGE_TOPIC
              value: {{ .Values.kafka.offsetStorageTopic | quote }}
            - name: STATUS_STORAGE_TOPIC
              value: {{ .Values.kafka.statusStorageTopic | quote }}
            - name: CONFIG_STORAGE_REPLICATION_FACTOR
              value: "1"
            - name: OFFSET_STORAGE_REPLICATION_FACTOR
              value: "1"
            - name: STATUS_STORAGE_REPLICATION_FACTOR
              value: "1"
            - name: KEY_CONVERTER
              value: org.apache.kafka.connect.storage.StringConverter
            - name: VALUE_CONVERTER
              value: org.apache.kafka.connect.json.JsonConverter
            - name: VALUE_CONVERTER_SCHEMAS_ENABLE
              value: "false"
            # EnvVarConfigProvider — allows ${env:VAR} substitution in connector config
            - name: CONNECT_CONFIG_PROVIDERS
              value: env
            - name: CONNECT_CONFIG_PROVIDERS_ENV_CLASS
              value: org.apache.kafka.common.config.provider.EnvVarConfigProvider
          livenessProbe:
            httpGet:
              path: /
              port: rest
            initialDelaySeconds: 60
            periodSeconds: 15
            failureThreshold: 3
          readinessProbe:
            httpGet:
              path: /connectors
              port: rest
            initialDelaySeconds: 30
            periodSeconds: 10
            failureThreshold: 3
          resources:
            {{- toYaml .Values.resources | nindent 12 }}
