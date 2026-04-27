# Структура лабороторной работы lab03

# Симлинки VS Хардлинки
Что такое Симлинки и Хардлинки?
Хардлинк - это другое имя файла, для которого мы создаем хардлинк
Симлинк в свою очередь - это отдельный файл, которых хранит путь к файлу,
для которого мы делаем симлинк. С его помощью можно ссылаться на другие файлы
и даже директории, в том числе - на файловые системы.

В самой первой лабораторной работе мы уже создавали симлинк sample_access.log
в /logs. Теперь его можно смотреть из любой точки где лежит access.log

original.txt --> hard_link.txt - Одинаковый Inode
original.txt --> sym_link.txt - Разный Inode

Если удалить original.txt то в hard_link.txt сохранятся данные
sym_link в свою очередь будет сломана

# Занятые блоки памяти
$ sudo tune2fs -l /dev/sdc | grep -i reserved
Reserved block count:     13421772
Reserved GDT blocks:      1024
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)

# Память занимаемая Inodом
Filesystem     Inodes IUsed IFree IUse% Mounted on
/dev/sdd          64M   54K   64M    1% /

# Символические ссылки в /etc
/etc/ssl/certs/7f3d5d1d.0
/etc/ssl/certs/8312c4c1.0
/etc/ssl/certs/HiPKI_Root_CA_-_G1.pem
/etc/ssl/certs/CFCA_EV_ROOT.pem
/etc/ssl/certs/b433981b.0
/etc/ssl/certs/GTS_Root_R2.pem
/etc/ssl/certs/ce5e74ef.0
/etc/ssl/certs/GlobalSign_Root_CA.pem
/etc/ssl/certs/1d3472b9.0
/etc/ssl/certs/bf53fb88.0

# Топ файлов, измененных за последнее время
/home/melted/os-systems-work/lab03/hard_link.txt
/home/melted/os-systems-work/lab03/fs_quick_report.sh
/home/melted/os-systems-work/lab03/links_report.txt
/home/melted/os-systems-work/lab03/.README.md.swp
/home/melted/os-systems-work/lab03/report_du.txt
/home/melted/os-systems-work/lab03/README.md
/home/melted/os-systems-work/hw01/warmup.sh
/home/melted/os-systems-work/hw02/answers.md
/home/melted/os-systems-work/hw02/backups/backup-2026-04-26_22-11-11.tar.gz
/home/melted/os-systems-work/hw02/README.md

# Подсчет файлов по их типу
Files:     680
Dirs:      169
Symlinks:  537


NAME
    MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda   8:0    0 388.6M  1 disk
sdb   8:16   0   186M  1 disk
sdc   8:32   0     1G  0 disk [SWAP]
sdd   8:48   0     1T  0 disk /mnt/wslg/distro

# Тесты fs_quick_report.sh
1) c аргументом ./fs_quick_report.sh /etc
=== ФС отчёт ===

--- Смонтированные ФС ---
Filesystem     Type     Size  Used Avail Use% Mounted on
none           tmpfs    1.9G  4.0K  1.9G   1% /mnt/wsl
/dev/sdd       ext4    1007G  2.2G  954G   1% /
none           tmpfs    1.9G  168K  1.9G   1% /mnt/wslg
none           tmpfs    1.9G  504K  1.9G   1% /run
none           tmpfs    1.9G     0  1.9G   0% /run/lock
none           tmpfs    1.9G     0  1.9G   0% /run/shm
tmpfs          tmpfs    385M   20K  385M   1% /run/user/1000

--- Статистика: /etc ---
  Файлов:     680
  Директорий: 169
  Симлинков:   537

--- Топ-3 крупнейших файла ---
  Inode      Размер Путь
  1174       215Ki        /etc/ssl/certs/ca-certificates.crt
  769        74Ki         /etc/mime.types
  12716      32Ki         /etc/apparmor.d/usr.lib.snapd.snap-confine.real

2)Без аргумента ./fs_quick_report.sh (по умолчанию стоит /etc)
=== ФС отчёт ===

--- Смонтированные ФС ---
Filesystem     Type     Size  Used Avail Use% Mounted on
none           tmpfs    1.9G  4.0K  1.9G   1% /mnt/wsl
/dev/sdd       ext4    1007G  2.2G  954G   1% /
none           tmpfs    1.9G  168K  1.9G   1% /mnt/wslg
none           tmpfs    1.9G  504K  1.9G   1% /run
none           tmpfs    1.9G     0  1.9G   0% /run/lock
none           tmpfs    1.9G     0  1.9G   0% /run/shm
tmpfs          tmpfs    385M   20K  385M   1% /run/user/1000

--- Статистика: /etc ---
  Файлов:     680
  Директорий: 169
  Симлинков:   537

--- Топ-3 крупнейших файла ---
  Inode      Размер Путь
  1174       215Ki        /etc/ssl/certs/ca-certificates.crt
  769        74Ki         /etc/mime.types
  12716      32Ki         /etc/apparmor.d/usr.lib.snapd.snap-confine.real

3) Не существующая директория ./fs_quick_report.sh /tmp/no_such_dir
Ошибка: '/tmp/no_such_dir' не найдена



