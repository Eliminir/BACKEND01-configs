#!/bin/bash

echo "Настройка MySQL Master сервера..."

# Останавливаем MySQL для настройки
sudo systemctl stop mysql

# Создаем конфигурационный файл для Master
sudo tee /etc/mysql/mysql.conf.d/replication.cnf > /dev/null <<EOF
[mysqld]
server-id = 1
log_bin = /var/log/mysql/mysql-bin.log
binlog_do_db = test_db
bind-address = 192.168.196.129
EOF

# Запускаем MySQL
sudo systemctl start mysql

# Подключаемся к MySQL и настраиваем репликацию
sudo mysql -e "
CREATE USER 'replica_user'@'192.168.196.130' IDENTIFIED BY 'replica_password';
GRANT REPLICATION SLAVE ON *.* TO 'replica_user'@'192.168.196.130';
FLUSH PRIVILEGES;

CREATE DATABASE IF NOT EXISTS test_db;
USE test_db;
CREATE TABLE IF NOT EXISTS example_table (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

FLUSH TABLES WITH READ LOCK;
SHOW MASTER STATUS;
"

echo "Master настройка завершена!"
echo "Запомните значения File и Position из команды SHOW MASTER STATUS"
