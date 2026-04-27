# Структура домашнего задания hw03
/hw03/README.md - вы здесь
/hw03/fs_audit.sh -
/hw03/answers.md - содержит ответы на вопросы

# 1)Что хранит inode? Что не хранит? Где хранится имя файла?
# 2)ln file.txt link.txt, затем rm file.txt. Данные потеряны? Почему?
# 3)df показывает 15 ГБ, du — 12 ГБ. Назовите 2 причины расхождения.
# 4)Чем ordered отличается от writeback? Какой default?

# Пример вывода fs_audit.sh
Секция 1: Смонтированные ФС
=== Смонтированные файловые системы ===
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/sdc       ext4  1007G  15G  941G   2% /
tmpfs          tmpfs  7.8G  ...
Используйте: df -Th | grep -E 'ext4|tmpfs|Filesystem'

Секция 2: Статистика директории
=== Статистика: /etc ===
  Файлов:      1847
  Директорий:  412
  Симлинков:    127
Используйте: find "$1" -type f|d|l | wc -l

Секция 3: Топ-5 крупнейших файлов
=== Топ-5 крупнейших файлов в /etc ===
  Inode      Размер       Путь
  393523     1.2Mi        /etc/services
  393287     612Ki        /etc/ssh/moduli
  ...
Секция 4: df vs du
=== df vs du (/) ===
  df used:   15728640 KB
  du used:   12582912 KB
  Разница:   3145728 KB (20%)
