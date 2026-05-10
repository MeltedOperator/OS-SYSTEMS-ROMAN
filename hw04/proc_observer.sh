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

echo "=== СЕКЦИЯ 3: ПЕРВЫЙ PID, /proc И FD ==="
if [ "$count" -gt 0 ]; then
  first_pid=$(echo "$procs" | awk '{print $1}' | sort -n | head -n 1)
  echo "Первый PID: $first_pid"
  echo "Путь /proc: /proc/$first_pid"
  
  fd_dir="/proc/$first_pid/fd"
  if [ -d "$fd_dir" ]; then
    fd_count=$(ls -1 "$fd_dir" 2>/dev/null | wc -l)
    echo "Количество FD: $fd_count"
    cd "$fd_dir" 2>/dev/null && \
      for fdfile in *; do
        target=$(readlink "$fdfile" 2>/dev/null || echo '[deleted]')
        printf "  %s -> %s\n" "$fdfile" "$target"
      done || echo "Не удалось прочитать FD"
  else
    echo "Директория FD недоступна"
  fi
else
  echo "Процессы не найдены"
fi
