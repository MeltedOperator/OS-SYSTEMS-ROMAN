#!/bin/bash
#Использование: ./backup.sh /название директории
set -euo pipefail
validate_args() {
	if [[ $# -eq 0 ]]; then
    		echo "Ошибка: укажите файл"
    		exit 1
	fi
}
validate_dir() {
	if [[ ! -d "$1" ]]; then
    		echo "Директория '$1' не существует"
    		exit 1
	fi
}

create_backup() {
	local copy_what="$1"
	local where_to_copy="$2"
        
	tar -czf "$where_to_copy"/backup-$(date +%F_%H-%M-%S).tar.gz "$copy_what"
}

rotate_backups() {
	backups="$1"
	ls -t "$backups"/*.tar.gz 2>/dev/null | tail -n +3 | xargs -r rm -f
}

main() {
	local wanted_dir="${1:-}"

	validate_args "$wanted_dir"
	validate_dir "$wanted_dir"

	local reserve_dir="$HOME/os-systems-work/os-hw02/backups"
	
	create_backup "$wanted_dir" "$reserve_dir"
	ls -la "$reserve_dir"
	rotate_backups "$reserve_dir"


}
main "$@"
