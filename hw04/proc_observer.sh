#!/bin/bash
set -euo pipefail
process_name="${1:-}"

echo "=== СЕКЦИЯ 1: НАЙДЕННЫЕ ПРОЦЕССЫ ДЛЯ $process_name ==="
ps -eo pid,user,%cpu,%mem,comm | head -1
procs=$(ps -eo pid,user,%cpu,%mem,comm | grep "$process_name" | grep -v grep)
echo "$procs"
echo " "

echo "=== СЕКЦИЯ 2: ОБЩЕЕ КОЛ-ВО ПРОЦЕССОВ И СВОДКА ==="
count=$(echo "$procs" | wc -l)
echo "Количество процессов: $count"
cpu_sum=$(echo "$procs" | awk '{sum += $3} END {printf "%.2f", sum}')
mem_sum=$(echo "$procs" | awk '{sum += $4} END {printf "%.2f", sum}')
echo "Общий %CPU: ${cpu_sum}%"
echo "Общий %MEM: ${mem_sum}%"
echo " "

echo "=== СЕКЦИЯ 3: File descriptors первого процесса ==="
if [ "$count" -gt 0 ]; then
  first_pid=$(echo "$procs" | awk '{print $1}' | sort -n | head -n 1)
  echo "Первый (минимальный) PID: $first_pid"
  echo "Путь /proc: /proc/$first_pid"
  echo "Пример: статус процесса:"
  cat /proc/"$first_pid"/status | grep 'Name:' || echo "Не удалось прочитать"
else
  echo "Процессы не найдены"
fi

