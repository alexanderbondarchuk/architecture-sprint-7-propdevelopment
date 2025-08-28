# Инструкция

## Создаём namespace для изоляции

```bash
kubectl create namespace traffic-management
```

## Создаём сервисы с метками

```bash
kubectl run front-end-app --image=nginx --labels role=front-end --expose --port 80 -n traffic-management
kubectl run back-end-api-app --image=nginx --labels role=back-end-api --expose --port 80 -n traffic-management
kubectl run admin-front-end-app --image=nginx --labels role=admin-front-end --expose --port 80 -n traffic-management
kubectl run admin-back-end-api-app --image=nginx --labels role=admin-back-end-api --expose --port 80 -n traffic-management
```

## Проверяем создание

```bash
kubectl get pods,services -n traffic-management --show-labels
```

## Применяем политики

```bash
kubectl apply -f non-admin-api-allow.yaml
```

## Проверяем созданные политики

```bash
kubectl get networkpolicies -n traffic-management
```
