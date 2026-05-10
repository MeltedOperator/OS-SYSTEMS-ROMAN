#!/bin/bash
set -euo pipefail

# Функция поиска процессов (возвращает список строк)
find_processes() {
  local process_name="$1"
  ps -eo pid,user,%cpu,%mem,comm | grep "$process_name" | grep -v grep
}

# Заголовок + заголовок ps
show_header() {
  local process_name="$1"
  echo "=== СЕКЦИЯ 1: НАЙДЕННЫЕ ПРОЦЕССЫ ДЛЯ $process_name ==="
  ps -eo pid,user,%cpu,%mem,comm | head -1
}

# Сводка: количество + CPU/MEM
show_summary() {
  local procs="$1"
  local count
  count=$(echo "$procs" | wc -l)
  echo "=== СЕКЦИЯ 2: ОБЩЕЕ КОЛ-ВО ПРОЦЕССОВ И СВОДКА ==="
  echo "Количество процессов: $count"
  local cpu_sum
  cpu_sum=$(echo "$procs" | awk '{sum += $3} END {printf "%.2f", sum}')
  local mem_sum
  mem_sum=$(echo "$procs" | awk '{sum += $4} END {printf "%.2f", sum}')
  echo "Общий %CPU: ${cpu_sum}%"
  echo "Общий %MEM: ${mem_sum}%"
  echo " "
}

# FD для первого PID
show_fd() {
  local first_pid="$1"
  local fd_dir="/proc/$first_pid/fd"
  echo "=== СЕКЦИЯ 3: ПЕРВЫЙ PID, /proc И FD ==="
  echo "Первый PID: $first_pid"
  echo "Путь /proc: /proc/$first_pid"
  
  if [ -d "$fd_dir" ]; then
    local fd_count
    fd_count=$(ls -1 "$fd_dir" 2>/dev/null | wc -l)
    echo "Количество FD: $fd_count"
    cd "$fd_dir" 2>/dev/null && \
      for fdfile in *; do
        local target
        target=$(readlink "$fdfile" 2>/dev/null || echo '[deleted]')
        printf "  %s -> %s\n" "$fdfile" "$target"
      done || echo "  Не удалось прочитать FD"
  else
    echo "  Директория FD недоступна"
  fi
  echo " "
}

# Информация из /proc
show_proc_info() {
  local first_pid="$1"
  echo "=== СЕКЦИЯ 4: ИНФОРМАЦИЯ ИЗ /proc/$first_pid ==="
  if [ -d "/proc/$first_pid" ]; then
    local name
    name=$(cat "/proc/$first_pid/comm" 2>/dev/null || echo "N/A")
    local state
    state=$(cat "/proc/$first_pid/status" 2>/dev/null | grep '^State:' | awk '{print $2 " (" $3 ")"}' || echo "N/A")
    local vmrss
    vmrss=$(cat "/proc/$first_pid/status" 2>/dev/null | grep '^VmRSS:' | awk '{print $2 " " $3}' || echo "N/A")
    
    printf "  Имя:       %s\n" "$name"
    printf "  Состояние: %s\n" "$state"
    printf "  VmRSS:     %s\n" "$vmrss"
  else
    echo "  Процесс завершён"
  fi
}

# Главная функция
main() {
  local process_name="${1:-}"
  if [[ -z "$process_name" ]]; then
    echo "Usage: $0 <process_name>" >&2
    exit 1
  fi

  local procs
  show_header "$process_name"
  procs=$(find_processes "$process_name")
  echo "$procs"
  
  show_summary "$procs"
  
  if [[ $(echo "$procs" | wc -l) -gt 0 ]]; then
    local first_pid
    first_pid=$(echo "$procs" | awk '{print $1}' | sort -n | head -n 1)
    show_fd "$first_pid"
    show_proc_info "$first_pid"
  else
    echo "Процессы не найдены"
  fi
}

# Запуск
main "$@"

