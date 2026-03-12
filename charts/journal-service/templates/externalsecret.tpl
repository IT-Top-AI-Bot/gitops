apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: {{ include "journal-service.fullname" . }}-secrets
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "journal-service.labels" . | nindent 4 }}
spec:
  refreshInterval: 5m
  secretStoreRef:
    name: {{ .Values.secretStore.name }}
    kind: {{ .Values.secretStore.kind }}
  target:
    name: {{ include "journal-service.fullname" . }}-secrets
    creationPolicy: Owner
    template:
      engineVersion: v2
      data:
        # ── Database ──
        DATABASE_HOST:     "{{ .db_host }}"
        DATABASE_PORT:     "{{ .db_port }}"
        DATABASE_NAME:     "{{ .db_name }}"
        DATABASE_USERNAME: "{{ .db_username }}"
        DATABASE_PASSWORD: "{{ .db_password }}"

        # ── S3 / RustFS ──
        S3_ENDPOINT:   "{{ .s3_endpoint }}"
        S3_REGION:     "{{ .s3_region }}"
        S3_ACCESS_KEY: "{{ .s3_access_key }}"
        S3_SECRET_KEY: "{{ .s3_secret_key }}"

        # ── Kafka ──
        KAFKA_BOOTSTRAP_SERVERS: "{{ .kafka_bootstrap_servers }}"

        # ── Redis ──
        REDIS_HOST:     "{{ .redis_host }}"
        REDIS_PORT:     "{{ .redis_port }}"
        REDIS_PASSWORD: "{{ .redis_password }}"

        # ── Eureka ──
        EUREKA_SERVER_URL: "{{ .eureka_server_url }}"

        # ── Crypto ──
        ENCRYPTION_KEY: "{{ .encryption_key }}"

  data:
    - secretKey: db_host
      remoteRef:
        key: secret/journal-service/dev
        property: DATABASE_HOST
    - secretKey: db_port
      remoteRef:
        key: secret/journal-service/dev
        property: DATABASE_PORT
    - secretKey: db_name
      remoteRef:
        key: secret/journal-service/dev
        property: DATABASE_NAME
    - secretKey: db_username
      remoteRef:
        key: secret/journal-service/dev
        property: DATABASE_USERNAME
    - secretKey: db_password
      remoteRef:
        key: secret/journal-service/dev
        property: DATABASE_PASSWORD
    - secretKey: s3_endpoint
      remoteRef:
        key: secret/journal-service/dev
        property: S3_ENDPOINT
    - secretKey: s3_region
      remoteRef:
        key: secret/journal-service/dev
        property: S3_REGION
    - secretKey: s3_access_key
      remoteRef:
        key: secret/journal-service/dev
        property: S3_ACCESS_KEY
    - secretKey: s3_secret_key
      remoteRef:
        key: secret/journal-service/dev
        property: S3_SECRET_KEY
    - secretKey: kafka_bootstrap_servers
      remoteRef:
        key: secret/journal-service/dev
        property: KAFKA_BOOTSTRAP_SERVERS
    - secretKey: redis_host
      remoteRef:
        key: secret/journal-service/dev
        property: REDIS_HOST
    - secretKey: redis_port
      remoteRef:
        key: secret/journal-service/dev
        property: REDIS_PORT
    - secretKey: redis_password
      remoteRef:
        key: secret/journal-service/dev
        property: REDIS_PASSWORD
    - secretKey: eureka_server_url
      remoteRef:
        key: secret/journal-service/dev
        property: EUREKA_SERVER_URL
    - secretKey: encryption_key
      remoteRef:
        key: secret/journal-service/dev
        property: ENCRYPTION_KEY