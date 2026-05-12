# Структура домашней работы hw05

hw05/README.md
hw05/launcher.c - 

# Описание fork.c
fork.c - это программа, которая выводит PID текущего процесса, после чего вызывает fork().
В child: выводит «I am child, PID=..., PPID=...».
В parent: выводит «I am parent, PID=..., child PID=...», вызывает wait() и выводит exit code.

# Пример вывода fork.c 
```
Before fork: PID=1746
i am parent PID=1746, child PID=1747
i am child  PID=1747, PPID=1746
Child exited with code: 0
```
# Запуск и код fork.c/task1_fork.c
Основной код --> task1_fork.c
gcc -Wall -o fork.c task1_fork.c && ./fork.c



# Описание launcher.c 
launcher.c - это программа, которая принимает в качестве аргумента имя другой исполняемой программы
либо же директории, после чего запускает ее. Делается fork, после чего дочерний процесс получает свой PID,
родитель вызывает wait() и программа завершается с exit 0 при успешном выполнении либо же с exit 1 при ошибке

# Тесты launcher.c
Основной код --> task2_launcher.c
gcc -Wall -o launcher.c task2_launcher.c
# Пример 1: $ ./launcher.c ./fork.c  с аргументом
```
Before fork: PID=1814
i am parent PID=1814, child PID=1815
i am child  PID=1815, PPID=1814
Child exited with code: 0
Child exited with code: 0
```

# Пример 2: $ ./launcher.c ls вывод директории текущец
```
README.md  fork.c  launcher.c  task1_fork.c  task2_launcher.c  task3_signals.md
Child exited with code: 0
```

# Пример 3: $ ./launcher.c fakedir несуществующая директория
```
exec failed: No such file or directory
Child exited with code: 1
```

# Пример 4: $ ./launcher.c
```
Usage: ./launcher.c program_name
``` 
