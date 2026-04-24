#!/bin/bash
# Запуск: ./analyze_v2 sample_access.log
set -euo pipefail

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

#echo "=== Самый популярный URL ==="
# TODO 3: Извлечь самый популярный URL
#cat "$LOG" | awk '{print $7}' | sort | uniq -c | sort -rn | head -1
#echo ""

top_url() {

}

#echo "=== СЕКЦИЯ 4 ==="
#echo "=== Общее количество строк ==="
# TODO 4: Вывести общее количество строк sample_access.log
#wc -l "$LOG" | awk '{print $1}'

main() {
	local log_dir="${1:-$HOME/os-systems-work/os-lab01/logs/sample_access.log}"
	validate_args "$log_dir"

	echo "=== СЕКЦИЯ 1: ТОП-5 IP по числу запросов ==="
	top_ips "$log_dir"
	echo ""

	echo "=== СЕКЦИЯ 2: Количество запросов с 404 ==="
	count_404 "$log_dir"
}
main "$@"


