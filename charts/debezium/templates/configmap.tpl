apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "debezium.fullname" . }}-config
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "debezium.labels" . | nindent 4 }}
data:
  # Debezium Server reads application.properties from /debezium/conf/
  # Sensitive values (DATABASE_HOST, DATABASE_PASSWORD, etc.) are injected
  # as env vars from the ExternalSecret and referenced here via ${VAR} syntax
  # (Quarkus MicroProfile Config supports env var substitution)
  application.properties: |
    # --- Source: PostgreSQL ---
    debezium.source.connector.class=io.debezium.connector.postgresql.PostgresConnector
    debezium.source.database.hostname=${DATABASE_HOST}
    debezium.source.database.port=${DATABASE_PORT}
    debezium.source.database.user=${DATABASE_USER}
    debezium.source.database.password=${DATABASE_PASSWORD}
    debezium.source.database.dbname=${DATABASE_NAME}
    debezium.source.plugin.name={{ .Values.connector.pluginName }}
    debezium.source.slot.name={{ .Values.connector.slotName }}
    debezium.source.publication.name={{ .Values.connector.publicationName }}
    debezium.source.topic.prefix={{ .Values.connector.topicPrefix }}
    debezium.source.table.include.list={{ .Values.connector.tableIncludeList }}
    debezium.source.snapshot.mode={{ .Values.connector.snapshotMode }}
    debezium.source.heartbeat.interval.ms={{ .Values.connector.heartbeatIntervalMs }}

    # --- Offset storage in Kafka (survives pod restarts) ---
    debezium.source.offset.storage=org.apache.kafka.connect.storage.KafkaOffsetBackingStore
    debezium.source.offset.storage.topic={{ .Values.connector.offsetStorageTopic }}
    debezium.source.offset.storage.bootstrap.servers=${KAFKA_BOOTSTRAP_SERVERS}
    debezium.source.offset.storage.partitions=1
    debezium.source.offset.storage.replication.factor=1

    # --- Sink: Kafka ---
    debezium.sink.type=kafka
    debezium.sink.kafka.producer.bootstrap.servers=${KAFKA_BOOTSTRAP_SERVERS}
    debezium.sink.kafka.producer.key.serializer=org.apache.kafka.common.serialization.StringSerializer
    debezium.sink.kafka.producer.value.serializer=org.apache.kafka.common.serialization.StringSerializer

    # --- Quarkus HTTP (health/metrics) ---
    quarkus.http.port=8080
