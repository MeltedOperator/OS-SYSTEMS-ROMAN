#!/bin/bash
# Запуск: ./analyze_v2 sample_access.log
set -euo pipefail

#проверка директории на существование
validate_args() {
       local file="$1"
       if [[ ! -f "$file" ]]; then
               echo "Файл '$1' не существует"
               exit 1
       fi
}

# TODO 1: Вывести ТОП-5 IP по числу запросов

top_ips() {
       local file="$1"
       cat "$file" | awk '{print $1}' | sort | uniq -c | head -5
}


# TODO 2: Вывести все запросы с кодом 404

count_404() {
       local file="$1"
       grep " 404 " "$file" | wc -l
}

# TODO 3: Извлечь самый популярный URL

top_url() {
      #берем седьмой столбец, сортируем, отбираем только уникальные URL
      #сортируем в обратном порядке и берем самую первую строчку
      local LOG="$1"
      cat "$LOG" | awk '{print $7}' | sort | uniq -c | sort -rn | head -1
}


main() {
       #берем за файл по умолчанию sample_access.log
       local log_dir="${1:-$HOME/os-systems-work/os-lab01/logs/sample_access.log}"
       
       #валидируем файл который мы передали в аргумент, если он проходит проверку продолжаем
       validate_args "$log_dir"

       #выводим поочередно секции
       echo "=== СЕКЦИЯ 1: ТОП-5 IP по числу запросов ==="
       top_ips "$log_dir"
       echo ""

       echo "=== СЕКЦИЯ 2: Количество запросов с 404 ==="
       count_404 "$log_dir"

       echo "=== СЕКЦИЯ 3: Самый популярный URL ==="
       top_url "$log_dir"
       echo ""
}
main "$@"
