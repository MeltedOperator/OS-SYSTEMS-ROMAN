#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

int main() {
    pid_t pid = fork();

    if (pid == 0) {
        /* Child: выполнить ls -la /tmp */
        execlp("ls", "ls", "-la","/tmp", NULL);
        perror("exec failed");  /* Сюда — только при ошибке */
        exit(1);
    } else if (pid > 0) {
        /* Parent: ждать child */
        int status;
        waitpid(pid, &status, 0);

        if (WIFEXITED(status)) {
            printf("Child exited with code: %d\n", WEXITSTATUS(status));
        }
    }
    return 0;
}
