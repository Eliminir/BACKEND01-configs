#!/bin/bash
set -e

echo "Установка сервисов и конфигов..."

CONFIG_DIR="/opt/server-configs"
REPO_URL="https://github.com/Eliminir/BACKEND01-configs.git"

# Обновление системы
sudo apt update
sudo apt install -y git wget

# Очистка и клонирование репозитория
echo "Очистка старой директории конфигов..."
sudo rm -rf "$CONFIG_DIR"
sudo git clone $REPO_URL $CONFIG_DIR

# Apache2
echo "Установка Apache2..."
sudo apt install -y apache2
if [ -d "$CONFIG_DIR/apache2" ]; then
    sudo cp -r $CONFIG_DIR/apache2/* /etc/apache2/
fi
sudo systemctl restart apache2
sudo systemctl enable apache2

# MySQL
echo "Установка MySQL..."
sudo apt install -y mysql-server
if [ -f "$CONFIG_DIR/mysql/my.cnf" ]; then
    sudo cp $CONFIG_DIR/mysql/my.cnf /etc/mysql/
fi
sudo systemctl restart mysql
sudo systemctl enable mysql

#  Завершено


