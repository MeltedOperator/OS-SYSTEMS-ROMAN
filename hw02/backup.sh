#!/bin/bash
#Использование: ./backup.sh /название директории
set -euo pipefail
validate_args() {
	#проверяем количество аргументов больше ли нуля
	if [[ $# -eq 0 ]]; then
    		echo "Резервное копирование не удалось. Не была передана директория"
    		exit 1
	fi
}
validate_dir() {
	#проверяем существование директории
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

	#создаем архив backup-(текущая дата и время) с расширением .tar.gz
	archive="$where_to_copy/backup-$(date +%F_%H-%M-%S).tar.gz"

	#сохраняем этот архив в директории backups
	tar -czf "$archive" -C "$main_dir" "$directory_name"
	echo "$archive"
}

rotate_backups() {
	
	backups="$reserve_dir"
	#Выводим список файлов и выбираем те что с расширением .tar.gz,
	#перенаправляем ошибки в "черную дыру"(/dev/null) 
	#начиная с четвертого файла xargs берет этот список и удаляет файлы в нем
	#оставляя только три самых последних
	ls -t "$backups"/*.tar.gz 2>/dev/null | tail -n +4 | xargs -r rm -f
}

print_report() {
	#Директория которую нужно заархивировать, архив и куда все сохраняется
	local dir_to_report="$wanted_dir" 
	local archive="$archive"
	local where_saved="$reserve_dir"

	#считаем файлы в директории
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
	#директория которую мы хотим заархивировать. Передается по умолчанию
	local wanted_dir="${1:-}"
	
	#Проверяем существование переданной директории
	validate_args "$wanted_dir"
	validate_dir "$wanted_dir"

	#папка где будут храниться бэкапы. Если такой нет, то она создается
	mkdir -p ~/os-systems-work/os-hw02/backups
	reserve_dir="$HOME/os-systems-work/os-hw02/backups" 

	archive=$(create_backup "$wanted_dir" "$reserve_dir")
        
	
	rotate_backups "$reserve_dir"
	

	print_report "$wanted_dir" "$archive" "$reserve_dir"
	#здесь я выводил что находилось в backups, чтобы проверять что они правильно
	#сохранялись
	#ls -la "$reserve_dir"
}
main "$@"
