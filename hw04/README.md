# proc_observer.sh - находит процессы по имени и выводит информацию о них.
Использование: ./proc_observer.sh <имя процесса>

# Примерный вывод proc_observer.sh:
```
=== Процессы, содержащие "bash" ===
  PID    USER       %CPU   %MEM   COMMAND
  1234   student    0.0    0.1    /bin/bash
  5678   student    0.0    0.1    /bin/bash --login

=== Сводка ===
  Найдено процессов: 2
  Суммарный %CPU:    0.0
  Суммарный %MEM:    0.2

=== File descriptors процесса 1234 ===
  Количество FD: 5
  0 -> /dev/pts/0
  1 -> /dev/pts/0
  2 -> /dev/pts/0
  3 -> /tmp/some_file.log
  255 -> /dev/pts/0

=== Информация из /proc/1234 ===
  Имя:       bash
  Состояние: S (sleeping)
  VmRSS:     5432 kB
```


