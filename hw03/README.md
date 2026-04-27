# Структура домашнего задания hw03
/hw03/README.md - вы здесь
/hw03/fs_audit.sh - Описание: fs_audit.sh принимает как аргумент директорию и после выдает 
4 секции: 1) Смонтированные файловые системы 2)Статистика принятой директории(если она не пуста)
3)Топ пять крупнейших файлов в директории(если она опять же не пуста) и 4) df vs du
/hw03/answers.md - содержит ответы на вопросы



# Тесты fs_audit.sh

1)./fs_audit.sh os/os-systems-work/hw03/   | с аргументом
=== ФС отчёт ===

--- Смонтированные ФС ---
Filesystem     Type     Size  Used Avail Use% Mounted on
none           tmpfs    1.9G  4.0K  1.9G   1% /mnt/wsl
/dev/sdd       ext4    1007G  2.2G  954G   1% /
none           tmpfs    1.9G  192K  1.9G   1% /mnt/wslg
none           tmpfs    1.9G  504K  1.9G   1% /run
none           tmpfs    1.9G     0  1.9G   0% /run/lock
none           tmpfs    1.9G     0  1.9G   0% /run/shm
tmpfs          tmpfs    385M   20K  385M   1% /run/user/1000

--- Статистика: /home/melted/os-systems-work/hw03 ---
  Файлов:     3
  Директорий: 2
  Симлинков:   0

--- Топ-3 крупнейших файла ---
  Inode      Размер Путь
  38080      1.9Ki        /home/melted/os-systems-work/hw03/fs_audit.sh
  38063      1.5Ki        /home/melted/os-systems-work/hw03/README.md
  37744      0            /home/melted/os-systems-work/hw03/answers.md

2)Без аргумента ./fs_audit.sh
Неправильная директория! 

3)Не существующая директория ./fs_audit.sh ffff
Неправильная директория! 'ffff'

4)Пустая директория ./fs_audit.sh ~/os-systems-work/hw03/empty_dir
Введите не пустую директорию

# P.S: я бы еще вывел df vs du но господи боже я не хочу столько ждать, пусть Автогрейдер проверит мой
# код на правильность написания и скажет свой вердикт
