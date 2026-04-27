# Структура лабораторной работы lab04

/lab04/README.md - Так как это мидтерм неделя, я все равно подготовил файл к прочтению, 
где были описана вся пройденная работа и результаты вызовов

man 1 printf | head -5
PRINTF(1)               User Commands                 PRINTF(1)

NAME
       printf - format and print data
Это - утилита. Printf выводит данные в консоль

man 3 printf | head -5
printf(3)               Library Functions Manual      printf(3)

NAME
       printf, fprintf, dprintf, sprintf, snprintf, vprintf, vfprintf, vdprintf, vsprintf, vsnprintf - formatted out‐
       put conversion
Это в свою очередь библиотека. Здесь есть набор утилит которые можно использовать. Я не проверял их вывод


man -k "access" - Среди всех совпадений с access можно выделить следующую утилиту
access (2)           - check user's permissions for a file
она проверяет права доступа пользователя


stat --help 2>&1 | head -10
  -c  --format=FORMAT   use the specified FORMAT instead of the default;
                          output a newline after each use of FORMAT


strace -e trace=file ls /etc 2>&1 | head -10
execve("/usr/bin/ls", ["ls", "/etc"], 0x7ffd7c2ddc28 /* 26 vars */) = 0
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libselinux.so.1", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libpcre2-8.so.0", O_RDONLY|O_CLOEXEC) = 3
statfs("/sys/fs/selinux", {f_type=SYSFS_MAGIC, f_bsize=4096, f_blocks=0, f_bfree=0, f_bavail=0, f_files=0, f_ffree=0, f_fsid={val=[0x31a2fb27, 0xa6c83cc6]}, f_namelen=255, f_frsize=4096, f_flags=ST_VALID|ST_NOSUID|ST_NODEV|ST_NOEXEC|ST_NOATIME}) = 0
statfs("/selinux", 0x7ffe809bef60)      = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/proc/filesystems", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/proc/mounts", O_RDONLY|O_CLOEXEC) = 3


strace -e trace=write echo "hello" 2>&1
write(1, "hello\n", 6hello
)                  = 6
+++ exited with 0 +++

strace -c ls /tmp 2>&1
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
 33.22    0.002452          70        35        13 openat
Самым частым из всех процессов будет openat с 35 запросами

====== =========== =========== ========= ========= ================
cat /etc/hostname' > /tmp/strace_demo.sh
chmod +x /tmp/strace_demo.sh
strace -e trace=file /tmp/strace_demo.sh 2>&1 | head -15

execve("/tmp/strace_demo.sh", ["/tmp/strace_demo.sh"], 0x7ffd20410690 /* 26 vars */) = 0
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libtinfo.so.6", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/dev/tty", O_RDWR|O_NONBLOCK) = 3
openat(AT_FDCWD, "/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/share/locale/locale.alias", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/locale/C.UTF-8/LC_IDENTIFICATION", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/lib/locale/C.utf8/LC_IDENTIFICATION", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/gconv/gconv-modules.cache", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/locale/C.UTF-8/LC_MEASUREMENT", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/lib/locale/C.utf8/LC_MEASUREMENT", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/locale/C.UTF-8/LC_TELEPHONE", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/lib/locale/C.utf8/LC_TELEPHONE", O_RDONLY|O_CLOEXEC) = 3

# Открытые файлы текущего shell
lsof -p $$ 2>/dev/null | head -10
COMMAND  PID   USER   FD   TYPE DEVICE SIZE/OFF  NODE NAME
bash    8898 melted  cwd    DIR   8,48     4096 20504 /home/melted/os-systems-work/hw02
bash    8898 melted  rtd    DIR   8,48     4096     2 /
bash    8898 melted  txt    REG   8,48  1446024  1464 /usr/bin/bash
bash    8898 melted  mem    REG   8,48  2125328 38965 /usr/lib/x86_64-linux-gnu/libc.so.6
bash    8898 melted  mem    REG   8,48   360460 12170 /usr/lib/locale/C.utf8/LC_CTYPE
bash    8898 melted  mem    REG   8,48       50 12176 /usr/lib/locale/C.utf8/LC_NUMERIC
bash    8898 melted  mem    REG   8,48     3360 12179 /usr/lib/locale/C.utf8/LC_TIME
bash    8898 melted  mem    REG   8,48     1406 12169 /usr/lib/locale/C.utf8/LC_COLLATE
bash    8898 melted  mem    REG   8,48      270 12174 /usr/lib/locale/C.utf8/LC_MONETARY


[1] 9959
PID: 9959
total 0
dr-x------ 2 melted melted  3 Apr 27 23:27 .
dr-xr-xr-x 9 melted melted  0 Apr 27 23:27 ..
lrwx------ 1 melted melted 64 Apr 27 23:27 0 -> /dev/pts/4
lrwx------ 1 melted melted 64 Apr 27 23:27 1 -> /dev/pts/4
lrwx------ 1 melted melted 64 Apr 27 23:27 2 -> /dev/pts/4
Как вот эти вот 0 1 2 связаны с 2>/dev/null?
0,1,2 это дескрипторы файлов, 0 это stdin, 1 stdout, 2 stderr
все три потока подключены к терминалу /dev/pts/4.

2>/dev/null перенаправляет stderr (поток ошибок) в черную дыру /dev/null
все ошибки игнорируются. 
Так и тут выводы перенаправляются
command > out.txt только stdout в файл
command 2> err.txt только ошибки
command > all.txt 2>&1 все вместе


cat /proc/cpuinfo | head -5
cat /proc/meminfo | head -5
cat /proc/loadavg

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 142
model name      : Intel(R) Core(TM) i3-10110U CPU @ 2.10GHz
[1]+  Terminated              sleep 300
MemTotal:        3935472 kB
MemFree:         3361536 kB
MemAvailable:    3412504 kB
Buffers:            1072 kB
Cached:           130696 kB
0.00 0.06 0.05 1/184 10017

CPU core: Intel(R) Core(TM) i3-10110U CPU @ 2.10GHz
MemTotal      3935472 kB
load average    0.04 0.07 0.05 1/184 10027

# tee - дублирование потока
ls -la /etc | head -10 | tee /tmp/etc_listing.txt
cat /tmp/etc_listing.txt
rm /tmp/etc_listing.txt
total 804
drwxr-xr-x 87 root root       4096 Apr 27 23:12 .
drwxr-xr-x 37 root root       4096 Apr 27 16:18 ..
-rw-------  1 root root          0 Jan  7  2025 .pwd.lock
-rw-r--r--  1 root root        837 Jan  7  2025 .resolv.conf.systemd-resolved.bak
-rw-r--r--  1 root root        208 Jan  7  2025 .updated
drwxr-xr-x  2 root root       4096 Apr 24 08:31 PackageKit
drwxr-xr-x  7 root root       4096 Jan  7  2025 X11
-rw-r--r--  1 root root       3444 Jul  5  2023 adduser.conf
drwxr-xr-x  2 root root       4096 Apr 21 09:32 alternatives
total 804
drwxr-xr-x 87 root root       4096 Apr 27 23:12 .
drwxr-xr-x 37 root root       4096 Apr 27 16:18 ..
-rw-------  1 root root          0 Jan  7  2025 .pwd.lock
-rw-r--r--  1 root root        837 Jan  7  2025 .resolv.conf.systemd-resolved.bak
-rw-r--r--  1 root root        208 Jan  7  2025 .updated
drwxr-xr-x  2 root root       4096 Apr 24 08:31 PackageKit
drwxr-xr-x  7 root root       4096 Jan  7  2025 X11
-rw-r--r--  1 root root       3444 Jul  5  2023 adduser.conf
drwxr-xr-x  2 root root       4096 Apr 21 09:32 alternatives

