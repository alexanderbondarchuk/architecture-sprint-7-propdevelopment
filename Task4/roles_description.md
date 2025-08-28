# Таблица ролей и полномочий

| Роль | Права роли | Группы пользователей |
|------|------------|---------------------|
| **cluster-viewer** | Просмотр: pods, services, nodes, namespaces, deployments, replicasets. Действия: get, list, watch | platform-viewers (только просмотр) |
| **cluster-admin** | Полный доступ ко всем ресурсам во всех namespaces. Действия: * (все действия) | platform-admins (администраторы) |
| **security-manager** | Управление secrets в namespace security. Действия: get, list, create, update, delete | security-admins (администраторы безопасности) |
| **developer** | Управление приложениями в namespace client. Ресурсы: pods, services, deployments, configmaps, pods/log, events. Действия: get, list, create, update, delete, patch | developers (разработчики) |
