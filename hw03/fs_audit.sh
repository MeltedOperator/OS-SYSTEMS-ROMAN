#!/bin/bash
#использование: ./fs_audit.sh /имя директории
set -euo pipefail

validate_dir() {

        if [[ $# -eq 0 ]]; then
                echo "Резервное копирование не удалось. Не была передана директория"
                exit 1
        fi
        #проверяем существование директории
        if [[ ! -d "$1" ]]; then
                echo "Неправильная директория! '$1'"
                exit 1
        fi

	if [ ! -n "$( ls -A "$1" 2>/dev/null)" ]; then
		echo "Введите не пустую директорию"
		exit 1
	fi
}

show_mounted_f() {
	echo "=== ФС отчёт ==="
	echo ""

	echo "--- Смонтированные ФС ---"
	df -Th 2>/dev/null | head -1
	df -Th 2>/dev/null | grep -E 'ext4|tmpfs'
	echo ""
}

show_dir_stats() {
	local TARGET_DIR="$1"
	echo "--- Статистика: $TARGET_DIR ---"
	echo "  Файлов:     $(find "$TARGET_DIR" -type f 2>/dev/null | wc -l)"
	echo "  Директорий: $(find "$TARGET_DIR" -type d 2>/dev/null | wc -l)"
	echo "  Симлинков:   $(find "$TARGET_DIR" -type l 2>/dev/null | wc -l)"
	echo ""

}

show_top_files() {
	local TARGET_DIR="$1"
	echo "--- Топ-3 крупнейших файла ---"
	printf "  %-10s %-12s %s\n" "Inode" "Размер" "Путь"
	find "$TARGET_DIR" -type f -printf '%i\t%s\t%p\n' 2>/dev/null \
   	  | sort -t$'\t' -k2 -rn \
   	  | head -3 \
   	  | while IFS=$'\t' read -r inode size path; do
       		 hr_size=$(numfmt --to=iec-i "$size" 2>/dev/null || echo "${size}B")
       		 printf "  %-10s %-12s %s\n" "$inode" "$hr_size" "$path"
   	  done
}

main() {
        local wanted_dir="${1:-}"
	validate_dir "$wanted_dir"
	show_mounted_f 
	show_dir_stats "$wanted_dir"
	show_top_files "$wanted_dir"
}
main "$@"
