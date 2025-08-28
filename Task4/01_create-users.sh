#!/bin/bash

echo "Создание пользователей..."

# Создаем пользователей и их сертификаты
create_user() {
    local username=$1
    local group=$2
    
    echo "Создаем пользователя: $username (группа: $group)"
    
    # Генерация приватного ключа
    openssl genrsa -out $username.key 2048
    
    # Создание CSR
    openssl req -new -key $username.key -out $username.csr -subj "/CN=$username/O=$group"
    
    # Подписание сертификата (используем minikube CA)
    openssl x509 -req -in $username.csr \
        -CA ~/.minikube/ca.crt \
        -CAkey ~/.minikube/ca.key \
        -CAcreateserial \
        -out $username.crt \
        -days 365
    
    # Добавляем пользователя в kubeconfig
    kubectl config set-credentials $username \
        --client-certificate=$(pwd)/$username.crt \
        --client-key=$(pwd)/$username.key \
        --embed-certs=true
    
    echo "Пользователь $username создан"
}

# Создаем трех пользователей для разных групп
create_user "viewer-user" "platform-viewers"
create_user "admin-user" "platform-admins" 
create_user "dev-user" "developers"

echo "Все пользователи созданы успешно!"