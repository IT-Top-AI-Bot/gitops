apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "debezium.fullname" . }}-config
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "debezium.labels" . | nindent 4 }}
data:
  # Connector config POSTed to Kafka Connect REST API by the connector-register Job.
  # Sensitive values (DATABASE_HOST, DATABASE_PASSWORD, etc.) use ${env:VAR} syntax —
  # resolved at runtime by Kafka Connect EnvVarConfigProvider from the pod's env vars.
  connector.json: |
    {
      "name": "journal-outbox-connector",
      "config": {
        "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
        "plugin.name": "{{ .Values.connector.pluginName }}",
        "database.hostname": "${env:DATABASE_HOST}",
        "database.port": "${env:DATABASE_PORT}",
        "database.user": "${env:DATABASE_USER}",
        "database.password": "${env:DATABASE_PASSWORD}",
        "database.dbname": "${env:DATABASE_NAME}",
        "topic.prefix": "{{ .Values.connector.topicPrefix }}",
        "table.include.list": "{{ .Values.connector.tableIncludeList }}",
        "slot.name": "{{ .Values.connector.slotName }}",
        "publication.name": "{{ .Values.connector.publicationName }}",
        "snapshot.mode": "{{ .Values.connector.snapshotMode }}",
        "heartbeat.interval.ms": "{{ .Values.connector.heartbeatIntervalMs }}",
        "transforms": "outbox",
        "transforms.outbox.type": "io.debezium.transforms.outbox.EventRouter",
        "transforms.outbox.route.by.field": "topic",
        "transforms.outbox.route.topic.replacement": "{{ .Values.connector.outboxTopicReplacement }}",
        "transforms.outbox.table.field.event.id": "id",
        "transforms.outbox.table.field.event.key": "key",
        "transforms.outbox.table.field.event.payload": "payload",
        "transforms.outbox.table.fields.additional.placement": "event_type:header:eventType,aggregate_type:header:aggregateType,aggregate_id:header:aggregateId,trace_context:header:traceparent",
        "transforms.outbox.route.tombstone.on.empty.payload": "false",
        "transforms.outbox.table.expand.json.payload": "true",
        "value.converter": "org.apache.kafka.connect.storage.StringConverter",
        "header.converter": "org.apache.kafka.connect.storage.StringConverter"
      }
    }
