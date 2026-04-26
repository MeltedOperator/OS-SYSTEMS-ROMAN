#!/bin/bash
# warmup.sh — знакомство с пайп-цепочками
# Запуск: ./warmup.sh sample_access.log

LOG="$1"

echo "=== КОЛИЧЕСТВО СТРОК ==="
# TODO 1: Посчитайте количество строк в файле $LOG
wc -l "$LOG" | awk '{print $1}'

echo ""
echo "=== ПЕРВЫЕ 5 СТРОК ==="
# TODO 2: Выведите первые 5 строк файла $LOG
cat "$LOG" | head -5


echo ""
echo "=== ВСЕ УНИКАЛЬНЫЕ IP (КОЛИЧЕСТВО) ==="
# TODO 3: Пайп-цепочка: извлечь IP
cat "$LOG" | awk '{print $1}' | sort | uniq -c | wc -l


