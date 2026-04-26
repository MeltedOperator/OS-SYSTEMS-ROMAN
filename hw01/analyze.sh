#!/bin/bash
# warmup.sh — знакомство с пайп-цепочками
# Запуск: ./warmup.sh sample_access.log

LOG="$1"
echo "=== СЕКЦИЯ 1 ==="
echo "=== Топ-5 IP по числу запросов ==="
# TODO 1: Вывести ТОП-5 IP по числу запросов
cat "$LOG" | awk '{print $1}' | sort | uniq -c | head -5
echo ""

echo "=== СЕКЦИЯ 2 ==="
echo "=== Количество 404 ==="
# TODO 2: Вывести все запросы с кодом 404
grep " 404 " "$LOG" | wc -l
echo ""

echo "=== СЕКЦИЯ 3 ==="
echo "=== Самый популярный URL ==="
# TODO 3: Извлечь самый популярный URL
cat "$LOG" | awk '{print $7}' | sort | uniq -c | sort -rn | head -1
echo ""

echo "=== СЕКЦИЯ 4 ==="
echo "=== Общее количество строк ==="
# TODO 4: Вывести общее количество строк sample_access.log
wc -l "$LOG" | awk '{print $1}'
