apiVersion: batch/v1
kind: Job
metadata:
  name: {{ include "debezium.fullname" . }}-connector-register
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "debezium.labels" . | nindent 4 }}
  annotations:
    "helm.sh/hook": post-install,post-upgrade
    "helm.sh/hook-weight": "1"
    "helm.sh/hook-delete-policy": before-hook-creation
spec:
  backoffLimit: 10
  template:
    metadata:
      labels:
        {{- include "debezium.selectorLabels" . | nindent 8 }}
    spec:
      restartPolicy: OnFailure
      containers:
        - name: register
          image: curlimages/curl:latest
          command:
            - sh
            - -c
            - |
              set -e
              CONNECT_URL="http://{{ include "debezium.fullname" . }}:8083"
              echo "Waiting for Kafka Connect at $CONNECT_URL ..."
              until curl -sf "$CONNECT_URL/connectors" > /dev/null; do
                echo "Not ready, retrying in 5s..."
                sleep 5
              done
              echo "Kafka Connect is ready."
              curl -s -X DELETE "$CONNECT_URL/connectors/journal-outbox-connector" || true
              echo "Registering connector..."
              curl -sf -X POST "$CONNECT_URL/connectors" \
                -H "Content-Type: application/json" \
                -d @/config/connector.json
              echo "Connector registered successfully."
          volumeMounts:
            - name: connector-config
              mountPath: /config
      volumes:
        - name: connector-config
          configMap:
            name: {{ include "debezium.fullname" . }}-config
