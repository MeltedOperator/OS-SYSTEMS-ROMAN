# Структура лабораторной работы lab05
/lab05/hello.c(УДАЛЕН) - Возвращает hello from C! Нужен, чтобы 
ознакомить с основами С, после чего удаляется
/lab05/README.md - Вы здесь. Как обычно я буду приводить результаты выполненных команд.
/lab05/fork_lab.c - Выводит PID текущего процесса, затем создает копию этого процесса, после чего
у нас есть родительский и дочерний процесс. Дочерний процесс выводит свой PID и PID родителя, 
родитель свой PID и PID дочерний. Работают они параллельно
/lab05/launcher_lab.c - это микроскопический терминал, который выводит действия команд в консоль


# Что происходит при запуске программы несколько раз?
PID меняется по возврастанию. Это происходит потому что любой созданный процесс держит за собой PID
и занимает какую то ячейку памяти. После завершения процесса ячейка еще занята некоторое время,
поэтому следующий PID будет идти по нарастанию, пока не упрется в потолок, счетчик не обнулится
и Линукс не найдет ему новую свободную ячейку

clone(child_stack=NULL, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x74adbce77a10) = 10426
Этот клон - это и есть процесс, созданный fork() 

# После pstree -p | grep fork_lab:
|-init-systemd(Ub(2)-+-SessionLeader(7575)---Relay(7582)(7577)---bash(7582)---fork_lab_sleep(10504)---fork_lab_sleep(105+


drwxrwxrwt  9 root root 4096 Apr 28 02:17 .
drwxr-xr-x 37 root root 4096 Apr 27 16:18 ..
drwxrwxrwx  2 root root   60 Apr 25 10:39 .X11-unix
drwx------  2 root root 4096 Apr 25 10:39 snap-private-tmp
drwx------  3 root root 4096 Apr 26 19:13 systemd-private-be4105d0ed2c4780a29ee6d0314936b8-polkit.service-KeWqjo
drwx------  3 root root 4096 Apr 25 10:39 systemd-private-be4105d0ed2c4780a29ee6d0314936b8-systemd-logind.service-ulC0JJ
drwx------  3 root root 4096 Apr 25 10:39 systemd-private-be4105d0ed2c4780a29ee6d0314936b8-systemd-resolved.service-MOQ8tN
drwx------  3 root root 4096 Apr 25 10:39 systemd-private-be4105d0ed2c4780a29ee6d0314936b8-systemd-timesyncd.service-W3mOyt
drwx------  3 root root 4096 Apr 25 10:39 systemd-private-be4105d0ed2c4780a29ee6d0314936b8-wsl-pro.service-uDHiQm
Child exited with code: 0

# если заменить ls на date то произойдет следующее
Tue Apr 28 02:24:44 +05 2026
Child exited with code: 0

# если сунуть fake_cmd то выйдет следующее сообщение об ошибке
ls: cannot access 'fake_cmd': No such file or directory

# если запустить вместе с strace
strace -e trace=process ./launcher_lab 2>&1
execve("./launcher_lab", ["./launcher_lab"], 0x7ffce3859170 /* 27 vars */) = 0
clone(child_stack=NULL, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x76ccf36b0a10) = 10757
wait4(10757, total 32
drwxrwxrwt  9 root root 4096 Apr 28 02:39 .
drwxr-xr-x 37 root root 4096 Apr 27 16:18 ..
drwxrwxrwx  2 root root   60 Apr 25 10:39 .X11-unix
drwx------  2 root root 4096 Apr 25 10:39 snap-private-tmp
drwx------  3 root root 4096 Apr 26 19:13 systemd-private-be4105d0ed2c4780a29ee6d0314936b8-polkit.service-KeWqjo
drwx------  3 root root 4096 Apr 25 10:39 systemd-private-be4105d0ed2c4780a29ee6d0314936b8-systemd-logind.service-ulC0JJ
drwx------  3 root root 4096 Apr 25 10:39 systemd-private-be4105d0ed2c4780a29ee6d0314936b8-systemd-resolved.service-MOQ8tN
drwx------  3 root root 4096 Apr 25 10:39 systemd-private-be4105d0ed2c4780a29ee6d0314936b8-systemd-timesyncd.service-W3mOyt
drwx------  3 root root 4096 Apr 25 10:39 systemd-private-be4105d0ed2c4780a29ee6d0314936b8-wsl-pro.service-uDHiQm
[{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 10757
--- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_EXITED, si_pid=10757, si_uid=1000, si_status=0, si_utime=0, si_stime=0} ---
Child exited with code: 0
exit_group(0)                           = ?
+++ exited with 0 +++

# среди них нужно выделить:
execve("./launcher_lab", ["./launcher_lab"], 0x7ffce3859170 /* 27 vars */) = 0
clone(child_stack=NULL, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x76ccf36b0a10) = 10757
wait4(10757, total 32
Эти три строчки - это жизненный цикл программы в линукс. Ее рождение(clone) - под программу выделяют память, дают ей PID,
трансформация(execve) - удали мою текущую память, пройди по пути, прочитай бинарник и запусти мой код с первой строки
и смерть(wait4) ядро находит зомби процесс, передает его код завершения нам и стирает зомби из памяти навсегда


# SIGTERM - Мягкое завершение
[1] 10797
alive
dead
[1]+  Terminated              sleep 300

# SIGSTOP - замораживает процесс
[1] 10808
    PID STAT COMMAND
  10808 T    bash

[1]+  Stopped                 sleep 300
    PID STAT COMMAND
  10808 S    sleep

# SIGCONT - Вопроизвести

# Зомби процесс!
Зомби - это мертвый процесс, который не был уничтожен ядром ОS так как родительский процесс не прочитал
его код возврата
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
melted     10830  0.0  0.0      0     0 pts/3    Z    02:54   0:00 [zombie_demo] <defunct>
melted     10836  0.0  0.0   4088  1920 pts/4    S+   02:54   0:00 grep --color=auto Z
# Удаляем зомби
[1]+  Done                    gcc -Wall -o zombie_demo zombie_demo.c && ./zombie_demo


