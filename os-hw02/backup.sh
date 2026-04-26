#!/bin/bash
#Использование: ./backup.sh /название директории
set -euo pipefail
validate_args() {
	if [[ $# -eq 0 ]]; then
    		echo "Резервное копирование не удалось. Не была передана директория"
    		exit 1
	fi
}
validate_dir() {
	if [[ ! -d "$1" ]]; then
    		echo "Резервное копирование не удалось. Директория '$1' не существует"
    		exit 1
	fi
}

create_backup() {
	local copy_what="$1"
	local where_to_copy="$2"
        
	main_dir="$(dirname "$copy_what")"
	directory_name="$(basename "$copy_what")"
	archive="$where_to_copy/backup-$(date +%F_%H-%M-%S).tar.gz"

	tar -czf "$archive" -C "$main_dir" "$directory_name"
	echo "$archive"
}

rotate_backups() {
	backups="$1"
	ls -t "$backups"/*.tar.gz 2>/dev/null | tail -n +4 | xargs -r rm -f
}

print_report() {
	local dir_to_report="$wanted_dir" 
	local archive="$archive"
	local where_saved="$reserve_dir"

	FILE_COUNT=$(ls -1 "$where_saved" | wc -l)

	echo "=== РЕЗЕРВНОЕ КОПИРОВАНИЕ ==="
	echo "Источник: $(dirname "$dir_to_report")"
	echo "Архив: $(basename "$archive")"
	echo "Размер: $(stat -c%s "$archive")"
	echo "Сохранено в "$where_saved" "
	echo "Архивов после ротации: "$FILE_COUNT" "	
	echo "=== Готово! ==="
}

main() {
	local wanted_dir="${1:-}"

	validate_args "$wanted_dir"
	validate_dir "$wanted_dir"

	reserve_dir="$HOME/os-systems-work/os-hw02/backups" 


	archive=$(create_backup "$wanted_dir" "$reserve_dir")
        
	
	rotate_backups "$reserve_dir"
	
	print_report "$wanted_dir" "$archive" "$reserve_dir"
	ls -la "$reserve_dir"
}
main "$@"
