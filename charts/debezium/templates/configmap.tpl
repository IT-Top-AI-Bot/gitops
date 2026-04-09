apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "debezium.fullname" . }}-config
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "debezium.labels" . | nindent 4 }}
data:
  # Debezium Server reads application.properties from /debezium/config/
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

    # --- Offset storage: file-based on PVC (/debezium/data/) ---
    debezium.source.offset.storage=org.apache.kafka.connect.storage.FileOffsetBackingStore
    debezium.source.offset.storage.file.filename=/debezium/data/offsets.dat

    # --- Outbox EventRouter transform ---
    debezium.transforms=outbox
    debezium.transforms.outbox.type=io.debezium.transforms.outbox.EventRouter
    debezium.transforms.outbox.route.by.field=topic
    debezium.transforms.outbox.route.topic.replacement={{ .Values.connector.outboxTopicReplacement }}
    debezium.transforms.outbox.table.field.event.id=id
    debezium.transforms.outbox.table.field.event.key=key
    debezium.transforms.outbox.table.field.event.payload=payload
    debezium.transforms.outbox.table.fields.additional.placement=event_type:header:eventType,aggregate_type:header:aggregateType,aggregate_id:header:aggregateId,trace_context:header:traceparent
    debezium.transforms.outbox.route.tombstone.on.empty.payload=false
    debezium.transforms.outbox.table.expand.json.payload=true

    # --- Sink: Kafka ---
    debezium.sink.type=kafka
    debezium.sink.kafka.producer.bootstrap.servers={{ .Values.kafkaBootstrapServers }}
    debezium.sink.kafka.producer.key.serializer=org.apache.kafka.common.serialization.StringSerializer
    debezium.sink.kafka.producer.value.serializer=org.apache.kafka.common.serialization.StringSerializer
    debezium.format.value=json
    debezium.format.value.schemas.enable=false
    debezium.format.key=simplestring
    debezium.format.header=json
    debezium.format.header.schemas.enable=false

    # --- Quarkus HTTP (health/metrics) ---
    quarkus.http.port=8080
