#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s program_name\n", argv[0]);
        return 1;
    }

    pid_t pid = fork();

    if (pid == 0) {
        execlp(argv[1], argv[1], NULL);
        perror("exec failed");
        _exit(1);
    } else if (pid > 0) {
        int status;
        waitpid(pid, &status, 0);

        if (WIFEXITED(status)) {
            printf("Child exited with code: %d\n", WEXITSTATUS(status));
        }
    } else {
        perror("fork failed");
        return 1;
    }

    return 0;
}

