# Production GitOps

Этот каталог содержит production values для namespace `prod`.

## Перед первым sync

- Замените `sha-REPLACE_ME` на реальные immutable image tags.
- Замените `api.example.com` и `bot.example.com` на реальные production hostnames.
- Проверьте `kafkaBootstrapServers` в [debezium-values.yaml](./debezium-values.yaml).
- При другом storage hostname обновите `config.homeworkDownloadAllowedHosts`
  в [ai-executor-values.yaml](./ai-executor-values.yaml).
- Убедитесь, что Vault Kubernetes role `prod-role` существует и имеет доступ к путям `secret/data/prod/*`.
- Создайте в namespace `prod` image pull secret `ghcr-credentials`, если его ещё нет.

## ArgoCD

- Для production app-of-apps используйте [root-prod.yaml](../../apps/root-prod.yaml).
- `argocd-config` здесь не дублируется намеренно: это cluster-wide ресурс, и его не нужно создавать вторым env-root в
  том же кластере.

## Vault secrets

### `secret/data/prod/config-server`

- `CONFIG_SERVER_USERNAME`
- `CONFIG_SERVER_PASSWORD`

### `secret/data/prod/api-gateway`

- `CONFIG_SERVER_USERNAME`
- `CONFIG_SERVER_PASSWORD`

### `secret/data/prod/journal-service`

- `DATABASE_HOST`
- `DATABASE_PORT`
- `DATABASE_NAME`
- `DATABASE_USERNAME`
- `DATABASE_PASSWORD`
- `REDIS_HOST`
- `REDIS_PORT`
- `REDIS_PASSWORD`
- `S3_ENDPOINT`
- `S3_REGION`
- `S3_ACCESS_KEY`
- `S3_SECRET_KEY`
- `KAFKA_BOOTSTRAP_SERVERS`
- `ENCRYPTION_KEY`
- `SA_USERNAME`
- `SA_PASSWORD`
- `APPLICATION_KEY`
- `CONFIG_SERVER_USERNAME`
- `CONFIG_SERVER_PASSWORD`

### `secret/data/prod/ai-executor`

- `DATABASE_HOST`
- `DATABASE_PORT`
- `DATABASE_NAME`
- `DATABASE_USERNAME`
- `DATABASE_PASSWORD`
- `KAFKA_BOOTSTRAP_SERVERS`
- `S3_ENDPOINT`
- `S3_REGION`
- `S3_ACCESS_KEY`
- `S3_SECRET_KEY`
- `MISTRALAI_API_KEY`
- `GEMINI_API_KEY`
- `CONFIG_SERVER_USERNAME`
- `CONFIG_SERVER_PASSWORD`

### `secret/data/prod/tg-bot`

- `TELEGRAM_BOT_TOKEN`
- `TELEGRAM_BOT_USERNAME`
- `TELEGRAM_WEBHOOK_SECRET_TOKEN`
- `CONFIG_SERVER_USERNAME`
- `CONFIG_SERVER_PASSWORD`
- `ADMIN_TELEGRAM_IDS`

### `secret/data/prod/debezium`

- `DATABASE_HOST`
- `DATABASE_PORT`
- `DATABASE_NAME`
- `DATABASE_USER`
- `DATABASE_PASSWORD`

## Kubernetes secrets вне Vault

### Namespace `prod`

- `ghcr-credentials`
  Тип: `kubernetes.io/dockerconfigjson`
  Назначение: pull images из `ghcr.io/it-top-ai-bot/*`
