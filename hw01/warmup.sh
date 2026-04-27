#!/bin/bash
# warmup.sh — знакомство с пайп-цепочками
# Запуск: ./warmup.sh sample_access.log

LOG="$1"

echo "=== КОЛИЧЕСТВО СТРОК ==="
wc -l "$LOG" | awk '{print $1}'

echo ""
echo "=== ПЕРВЫЕ 5 СТРОК ==="
cat "$LOG" | head -5


echo ""
echo "=== ВСЕ УНИКАЛЬНЫЕ IP (КОЛИЧЕСТВО) ==="
cat "$LOG" | awk '{print $1}' | sort | uniq -c | wc -l


