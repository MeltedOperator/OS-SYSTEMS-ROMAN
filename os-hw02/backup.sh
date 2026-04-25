#!/bin/bash
#Использование: ./backup.sh /название директории
set -euo pipefail

if [[ $# -eq 0 ]]; then
    echo "Ошибка: укажите файл"
    exit 1
fi

if [[ -d "$1" ]]; then
    echo "Директория найдена"
else
    echo "Директория '$1' существует"
    exit 1
fi
mkdir -p ~/os-systems-work/os-hw02/backups

