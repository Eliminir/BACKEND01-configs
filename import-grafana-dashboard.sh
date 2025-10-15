#!/bin/bash
set -e

echo "Импорт дашборда Grafana..."

GRAFANA_URL="http://localhost:3000"
USER="admin"
PASSWORD="admin"
DASHBOARD_FILE="/opt/server-configs/grafana/dashboards/node_exporter_dashboard.json"

# Ждем запуск Grafana
echo "Ожидание запуска Grafana..."
until curl -s $GRAFANA_URL > /dev/null; do
    sleep 2
done

sleep 5

# Добавляем источник данных Prometheus
echo "Настройка источника данных..."
curl -X POST \
  "$GRAFANA_URL/api/datasources" \
  -u "$USER:$PASSWORD" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Prometheus",
    "type": "prometheus",
    "url": "http://localhost:9090",
    "access": "proxy",
    "isDefault": true
  }' 2>/dev/null || echo "Источник данных уже существует"

# Импортируем дашборд
echo "Импорт дашборда..."
if [ -f "$DASHBOARD_FILE" ]; then
    DASHBOARD_JSON=$(cat "$DASHBOARD_FILE")
    curl -X POST \
      "$GRAFANA_URL/api/dashboards/db" \
      -u "$USER:$PASSWORD" \
      -H "Content-Type: application/json" \
      -d "{
        \"dashboard\": $DASHBOARD_JSON,
        \"overwrite\": true
      }" && echo " - Дашборд импортирован" || echo " - Ошибка импорта дашборда"
else
    echo "Файл дашборда не найден: $DASHBOARD_FILE"
fi

echo ""
echo "Готово! Grafana настроена."
echo "URL: http://$(hostname -I | awk '{print $1}'):3000"
