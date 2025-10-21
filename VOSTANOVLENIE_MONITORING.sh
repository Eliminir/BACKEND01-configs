#!/bin/bash

# Восстановление Prometheus из бэкапа
echo "Восстановление Prometheus..."

# Останавливаю сервис (опционально)
sudo systemctl stop prometheus

# Распаковываю архив
sudo tar xzf prometheus_backup.tar.gz -C /

# Накручиваю права
sudo chown -R prometheus:prometheus /etc/prometheus/

# Восстановление Grafana из бэкапа
echo "Восстановление Grafana..."

# Останавливаю сервис
sudo systemctl stop grafana-server

# Распаковываю конфиги
sudo tar xzf grafana_backup.tar.gz -C /

# Восстанавливаю права
sudo chown -R grafana:grafana /etc/grafana/
sudo chown -R grafana:grafana /var/lib/grafana/

# Восстановление Node Exporter из бэкапа
echo "Восстановление Node Exporter..."

# Распаковываем бэкап node_exporter
sudo tar xzf node_exporter_backup.tar.gz -C /

# Проверяем что конфиги восстановились
ls -la /etc/systemd/system/node_exporter.service
ls -la /etc/default/prometheus-node-exporter 2>/dev/null || echo "No default config"

# Запуск сервисов
echo "Запуск сервисов..."
sudo systemctl start grafana-server
sudo systemctl start prometheus
sudo systemctl start node_exporter

sudo systemctl status grafana-server --no-pager
sudo systemctl status prometheus --no-pager
sudo systemctl status node_exporter --no-pager
echo "Восстановление завершено!"
