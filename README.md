# DanIT Homework - Step Final

Цей проект містить повну інфраструктуру для деплою Python додатку на AWS EKS з використанням ArgoCD для GitOps.

## Структура проекту

### 1. Backend сервер (`app.py`)
- Flask додаток, який слухає на порту 8080
- Повертає IP адресу пода та клієнта
- Відповідає вимогам завдання

### 2. Dockerfile
- Використовує Python 3.11-slim
- Встановлює Flask з requirements.txt
- Копіює та запускає app.py

### 3. GitHub Actions (`.github/workflows/docker-build.yml`)
- Автоматичний білд Docker образу при push до main гілки
- Пуш образу до Docker Hub
- Використовує GitHub Secrets для автентифікації

### 4. Terraform код для EKS (`EKS/`)
- Створення EKS кластера з одним node group
- Nginx Ingress Controller
- External DNS для автоматичного управління DNS
- ACM сертифікати для HTTPS
- ArgoCD встановлення та конфігурація

### 5. Kubernetes маніфести (`k8s/`)
- `deployment.yaml` - Deployment для додатку
- `service.yaml` - Service для доступу до додатку
- `ingress.yaml` - Ingress для зовнішнього доступу

### 6. ArgoCD Application (`argocd-app.yaml`)
- Автоматичний деплой додатку з Git репозиторію
- GitOps підхід з автоматичним оновленням

## Налаштування

### GitHub Secrets
Необхідно налаштувати наступні secrets в GitHub репозиторії:
- `DOCKERHUB_USERNAME` - ім'я користувача Docker Hub
- `DOCKERHUB_TOKEN` - токен доступу Docker Hub

### Terraform змінні
В `EKS/terraform.tfvars`:
```hcl
region = "eu-central-1"
name = "agrynov"  # замініть на своє ім'я
zone_name = "devops7.test-danit.com"  # замініть на свою групу
```

### DNS домени
- ArgoCD: `argocd.agrynov.devops7.test-danit.com`
- Додаток: `app.agrynov.devops7.test-danit.com`

## Деплой

1. **Створення EKS кластера:**
```bash
cd EKS
terraform init
terraform plan
terraform apply
```

2. **Налаштування kubectl:**
```bash
aws eks update-kubeconfig --region eu-central-1 --name agrynov
```

3. **Перевірка статусу:**
```bash
kubectl get pods -n argocd
kubectl get applications -n argocd
```

## Перевірка роботи

1. **ArgoCD UI:** https://argocd.agrynov.devops7.test-danit.com
2. **Додаток:** https://app.agrynov.devops7.test-danit.com

## Автоматизація

- При кожному push до main гілки GitHub Actions автоматично:
  - Білдить новий Docker образ
  - Пушить його до Docker Hub
- ArgoCD автоматично:
  - Відстежує зміни в Git репозиторії
  - Деплоїть нову версію додатку на EKS

## Формат здачі

1. ✅ Код backend сервера (передає IP адресу пода)
2. ✅ Код Dockerfile
3. ✅ Код GitHub Actions пайплайну
4. ✅ Код створення кластера, nginx controller, etc.
5. ✅ Код підняття ArgoCD
6. ✅ Код маніфестів
7. 📸 Скріни роботи кластера, неймспейсів, роботи ArgoCD, конфігурації ArgoCD, зміни імеджів в Docker Hub
8. 📸 Скріни виконання завдання по пунктах (для захисту проекту)
