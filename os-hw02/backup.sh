#!/bin/bash
#Использование: ./backup.sh /название директории
set -euo pipefail

#if [[ $# -eq 0 ]]; then
#    echo "Ошибка: укажите файл"
#    exit 1
#fi
#
#if [[ -f "$1" ]]; then
#    echo "Файл найден: $(wc -l < "$1") строк"
#else
#    echo "Файл '$1' не существует"
#    exit 1
#fi
mkdir -p ~/os-systems-work/os-hw02/backups

