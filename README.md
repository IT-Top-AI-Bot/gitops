# GitOps Repository

ArgoCD + Helm + HashiCorp Vault + External Secrets Operator

## Структура

```
apps/
  root.yaml                  # App of Apps — точка входа ArgoCD
  dev/
    infra.yaml               # SecretStore, ServiceAccount для dev namespace
    journal-service.yaml     # journal-service приложение
charts/
  dev-infra/                 # Namespace-level инфраструктура
  journal-service/           # Helm chart
envs/
  dev/
    infra-values.yaml        # Vault адрес и auth конфигурация
    journal-service-values.yaml
```

## Плейсхолдеры для замены

Перед использованием замени в файлах:

| Плейсхолдер            | Что подставить                              |
|------------------------|---------------------------------------------|
| `YOUR_ORG`             | GitHub organization name                    |
| `YOUR_VAULT_ADDRESS`   | Адрес Vault (например: `vault.example.com`) |
| `YOUR_DOMAIN`          | Домен для ingress (например: `dev.local`)   |
| `YOUR_JOURNAL_API_URL` | URL внешнего журнала                        |

## Bootstrap: первоначальная настройка

### 1. Добавить gitops репозиторий в ArgoCD

```bash
argocd repo add https://github.com/YOUR_ORG/gitops \
  --username YOUR_GITHUB_USERNAME \
  --password YOUR_GITHUB_PAT
```

### 2. Создать imagePullSecret для GHCR

```bash
kubectl create namespace dev

kubectl create secret docker-registry ghcr-credentials \
  --namespace dev \
  --docker-server=ghcr.io \
  --docker-username=YOUR_GITHUB_USERNAME \
  --docker-password=YOUR_GITHUB_PAT
```

### 3. Развернуть Root App

```bash
kubectl apply -f apps/root.yaml
```

После этого ArgoCD сам задеплоит `dev-infra` и `journal-service`.

## Vault: структура секретов

Все секреты journal-service хранятся по пути `secret/dev/journal-service` (KV v2).

Требуемые поля:

```bash
vault kv put secret/dev/journal-service \
  db-url="jdbc:postgresql://HOST:5432/journal" \
  db-username="journal_user" \
  db-password="..." \
  redis-password="..." \
  sa-username="..." \
  sa-password="..." \
  token-encryption-key="..."    # Base64-encoded AES-256 ключ
```

## Vault: Kubernetes auth

Vault должен быть настроен на Kubernetes auth:

```bash
# Привязать роль dev-role к ServiceAccount external-secrets в namespace dev
vault write auth/kubernetes/role/dev-role \
  bound_service_account_names=external-secrets \
  bound_service_account_namespaces=dev \
  policies=dev-policy \
  ttl=1h
```

Политика `dev-policy` должна разрешать чтение `secret/data/dev/*`.

## CI: обновление image tag

При деплое новой версии CI обновляет `envs/dev/journal-service-values.yaml`:

```bash
sed -i "s/tag: .*/tag: \"$IMAGE_TAG\"/" envs/dev/journal-service-values.yaml
git commit -am "chore: deploy journal-service $IMAGE_TAG to dev"
git push
```

ArgoCD подхватит изменение автоматически (auto-sync включён).
