# Структура лабораторной работы lab06

# Текущие процессы
$ ps -eo pid,ni,pri,cls,comm --sort=-pcpu | head -15

    PID  NI PRI CLS COMMAND
      1   0  19  TS systemd
     64  -1  20  TS systemd-journal
    123   0  19  TS systemd-resolve
    364   0  19  TS systemd
    124   0  19  TS systemd-timesyn
    240   0  19  TS unattended-upgr
    270   0  19  TS systemd-timedat
    197   0  19  TS systemd-logind
    120   0  19  TS systemd-udevd
    201   0  19  TS wsl-pro-service
    209   0  19  TS rsyslogd
    178   0  19  TS dbus-daemon
    395   0  19  TS bash
    281   0  19  TS bash

Нас интересуют столбцы:
 NI PRI CLS
 0 19 TS
 0 19 TS
 -1 20 TS
 0 19 TS
 0 19 TS
 0 19 TS
 0 19 TS
 0 19 TS
 0 19 TS
 0 19 TS
 0 19 TS
 0 19 TS
 0 19 TS
 0 19 TS

# /proc/$$/stat
$ cat /proc/$$/stat | awk '{print "PID=" $1, "PRI=" $18, "NI=" $19}'
PID=281 PRI=20 NI=0

# Текущая политика
$ chrt -p $$
pid 281's current scheduling policy: SCHED_OTHER
pid 281's current scheduling priority: 0


# Два CPU-Стресс процесса
$ nice -n 0  dd if=/dev/urandom of=/dev/null bs=1M count=200 2>/dev/null &
$ PID_HIGH=$!
$ nice -n 19 dd if=/dev/urandom of=/dev/null bs=1M count=200 2>/dev/null &
$ PID_LOW=$!

$ ps -o pid,ni,pri,%cpu,comm -p $PID_HIGH,$PID_LOW
$ cat /proc/$PID_HIGH/stat | awk '{print "HIGH: PRI=" $18, "NI=" $19}'
$ cat /proc/$PID_LOW/stat  | awk '{print "LOW:  PRI=" $18, "NI=" $19}'

$ wait

[1] 715
[2] 716
    PID  NI PRI %CPU COMMAND
    715   0  19  0.0 dd
    716  19   0  0.0 dd
HIGH: PRI=20 NI=0
LOW:  PRI=39 NI=19
[1]-  Done                    nice -n 0 dd if=/dev/urandom of=/dev/null bs=1M count=200 2> /dev/null
[2]+  Done                    nice -n 19 dd if=/dev/urandom of=/dev/null bs=1M count=200 2> /dev/null

# Выводы
[1] NI 0  %CPU 0.0
[2] NI 19 %CPU 0.0

# Если с nice -n 10 && nice -n 19
[1] NI 10 %CPU 0.0
[2] NI 19 %CPU 0.0

# Изменение на лету
$ dd if=/dev/urandom of=/dev/null bs=1M &
$ PID=$!
$ ps -o pid,ni,pri,%cpu -p $PID
[1] 737
    PID  NI PRI %CPU
    737   0  19  0.0

# Изменения nice
$ renice -n 15 -p $PID
$ ps -o pid,ni,pri,%cpu -p $PID
737 (process ID) old priority 0, new priority 15
    PID  NI PRI %CPU
    737  15   4  108

# Попытка понизить nice
$ renice -n 5 -p $PID

renice: failed to set priority for 737 (process ID): Permission denied


# С sudo
$ sudo renice -n 0 -p $PID
$ ps -o pid,ni,pri,%cpu -p $PID
$ kill $PID
737 (process ID) old priority 15, new priority 0
    PID  NI PRI %CPU
    737   0  19  105


# Результаты Эксперимента
[1]+  Terminated              dd if=/dev/urandom of=/dev/null bs=1M
[1] 807
[2] 808
[3] 809
[4] 810
[5] 811
^C
[4]-  Done                    { time nice -n 0 dd if=/dev/urandom of=/dev/null bs=1M count=200 2> /dev/null; } 2> /tmp/time_high.txt
[5]+  Done                    { time nice -n 19 dd if=/dev/urandom of=/dev/null bs=1M count=200 2> /dev/null; } 2> /tmp/time_low.txt
=== nice 0 ===

real    0m1.387s
user    0m0.000s
sys     0m1.461s
=== nice 19 ===

real    0m2.514s
user    0m0.001s
sys     0m1.372s

# Кто завершился первым?
Первым завершился процесс с nice 0, что совпадает с гипотезой

# Выводы Эксперимента:
CFS даёт больше CPU-времени процессу с меньшим nice, из за чего он быстрее заканчивает задачу
