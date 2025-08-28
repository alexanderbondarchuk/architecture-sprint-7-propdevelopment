#!/bin/bash

echo "Создание ролей..."

# Создаем namespaces если их нет
kubectl create namespace client --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace tenant --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace security --dry-run=client -o yaml | kubectl apply -f -

# ClusterRole для просмотра (первая группа)
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: cluster-viewer
rules:
- apiGroups: [""]
  resources: ["pods", "services", "nodes", "namespaces"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["apps"]
  resources: ["deployments", "replicasets"]
  verbs: ["get", "list", "watch"]
EOF

# ClusterRole для администрирования (вторая группа)
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: cluster-admin
rules:
- apiGroups: ["*"]
  resources: ["*"]
  verbs: ["*"]
EOF

# Role для работы с секретами в security namespace (привилегированная группа)
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: security
  name: security-manager
rules:
- apiGroups: [""]
  resources: ["secrets"]
  verbs: ["get", "list", "create", "update", "delete"]
EOF

# Role для разработчиков в client namespace
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: client
  name: developer
rules:
- apiGroups: ["", "apps"]
  resources: ["pods", "services", "deployments", "configmaps"]
  verbs: ["get", "list", "create", "update", "delete", "patch"]
- apiGroups: [""]
  resources: ["pods/log", "events"]
  verbs: ["get", "list"]
EOF

echo "Все роли созданы успешно!"