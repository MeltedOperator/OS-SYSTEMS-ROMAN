#!/bin/bash
#использование: ./fs_audit.sh <имя директории>
#TODO list: что делает fs_audit.sh 
#берет директорию и выводит 4 секции:
#TODO 1: Смонтированные ФС
#TODO 2: Статистика Директории
#TODO 3: Топ-5 Крупнейших файлов
#TODO 4: df vs du
#Критерии: 
#bin/bash + set -euo pipefail
#Функции show_mounted_f(), show_dir_stats()
#show_top_files(), show_df_vs_du()
#main()
#Валидация $#, -d "$1"
#shellcheck fs_audit.sh
