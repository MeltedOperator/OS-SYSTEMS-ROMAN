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

main() {
	local reserve_dir="$HOME/os-systems-work/os-hw02/backups"
	local wanted_dir="$1"
	validate_args "$1"
	validate_dir "$1"
	tar -czf "$reserve_dir"/backup-$(date +%F).tar.gz "$1"


}
main "$@"
