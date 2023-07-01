/**
 * @file proj2.c
 * @author David Kvacek (xkvace00)
 * @brief Implementation of the second task in IOS 2022/23
 * @version 1.0
 * @date 2023-05-01
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <unistd.h>
#include <limits.h>
#include <fcntl.h>
#include <ctype.h>
#include <time.h>

#include <semaphore.h>
#include <sys/types.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <sys/sem.h>
#include <sys/shm.h>
#include <sys/ipc.h>

#define OK 0
#define FAIL 1

#define MS 1000

FILE *output = NULL;

sem_t *sem_output = NULL;
sem_t *sem_closed = NULL;
sem_t *sem_one = NULL;
sem_t *sem_two = NULL;
sem_t *sem_three = NULL;
sem_t *sem_first_service = NULL;
sem_t *sem_second_service = NULL;
sem_t *sem_third_service = NULL;
sem_t *sem_service = NULL;

int *A = NULL;
int *closed = NULL;
int *one = NULL;
int *two = NULL;
int *three = NULL;
int *service = NULL;

/**
 * @brief Initializes the resources and semaphores
 */
void init(void) {
    output = fopen("proj2.out", "w");
    if(output == NULL) {
        fprintf(stderr, "proj2: unable to open the output file 'proj2.out'\n");
        exit(FAIL);
    }

    setbuf(output, NULL);

    sem_close(sem_output);
    sem_close(sem_closed);
    sem_close(sem_one);
    sem_close(sem_two);
    sem_close(sem_three);
    sem_close(sem_first_service);
    sem_close(sem_second_service);
    sem_close(sem_third_service);
    sem_close(sem_service);

    sem_unlink("/xkvace00.output");
    sem_unlink("/xkvace00.closed");
    sem_unlink("/xkvace00.one");
    sem_unlink("/xkvace00.two");
    sem_unlink("/xkvace00.three");
    sem_unlink("/xkvace00.first_service");
    sem_unlink("/xkvace00.second_service");
    sem_unlink("/xkvace00.third_service");
    sem_unlink("/xkvace00.service");

    munmap(A, sizeof(int));
    munmap(closed, sizeof(int));
    munmap(one, sizeof(int));
    munmap(two, sizeof(int));
    munmap(three, sizeof(int));
    munmap(service, sizeof(int));

    sem_output = sem_open("/xkvace00.output", O_CREAT, 0666, 1);
    sem_closed = sem_open("/xkvace00.closed", O_CREAT, 0666, 1);
    sem_one = sem_open("/xkvace00.one", O_CREAT, 0666, 1);
    sem_two = sem_open("/xkvace00.two", O_CREAT, 0666, 1);
    sem_three = sem_open("/xkvace00.three", O_CREAT, 0666, 1);
    sem_first_service = sem_open("/xkvace00.first_service", O_CREAT, 0666, 1);
    sem_second_service = sem_open("/xkvace00.second_service", O_CREAT, 0666, 1);
    sem_third_service = sem_open("/xkvace00.third_service", O_CREAT, 0666, 1);
    sem_service = sem_open("/xkvace00.service", O_CREAT, 0666, 1);

    A = mmap(NULL, sizeof(int), PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, 0, 0);
    closed = mmap(NULL, sizeof(bool), PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, 0, 0);
    one = mmap(NULL, sizeof(int), PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, 0, 0);
    two = mmap(NULL, sizeof(int), PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, 0, 0);
    three = mmap(NULL, sizeof(int), PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, 0, 0);
    service = mmap(NULL, sizeof(int), PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, 0, 0);
}

/**
 * @brief Cleans up the resources and semaphores
 */
void clean(void) {
    sem_close(sem_output);
    sem_close(sem_closed);
    sem_close(sem_one);
    sem_close(sem_two);
    sem_close(sem_three);
    sem_close(sem_first_service);
    sem_close(sem_second_service);
    sem_close(sem_third_service);
    sem_close(sem_service);

    sem_unlink("/xkvace00.output");
    sem_unlink("/xkvace00.closed");
    sem_unlink("/xkvace00.one");
    sem_unlink("/xkvace00.two");
    sem_unlink("/xkvace00.three");
    sem_unlink("/xkvace00.first_service");
    sem_unlink("/xkvace00.second_service");
    sem_unlink("/xkvace00.third_service");
    sem_unlink("/xkvace00.service");

    munmap(A, sizeof(int));
    munmap(closed, sizeof(int));
    munmap(one, sizeof(int));
    munmap(two, sizeof(int));
    munmap(three, sizeof(int));
    munmap(service, sizeof(int));

    fclose(output);
}

/**
 * @brief The customer process
 * @param idZ id of the customer
 * @param TZ maximum time of waiting
 */
void customer(int idZ, int TZ) {
    sem_wait(sem_output);
    fprintf(output, "%d: Z %d: started\n", ++(*A), idZ);
    sem_post(sem_output);

    srand(time(NULL) * getpid());
    usleep((rand() % (TZ + 1)) * MS);

    sem_wait(sem_service);
    sem_wait(sem_closed);
    if(*closed == 0) {
        (*service) = (rand() % 3) + 1;
        sem_wait(sem_output);
        fprintf(output, "%d: Z %d: entering office for a service %d\n", ++(*A), idZ, (*service));
        sem_post(sem_output);

        switch(*service) {
            case 1:
                sem_wait(sem_one);
                (*one)++;
                sem_post(sem_one);

                sem_post(sem_closed);
                sem_wait(sem_first_service);
                break;
            case 2:
                sem_wait(sem_two);
                (*two)++;
                sem_post(sem_two);

                sem_post(sem_closed);
                sem_wait(sem_second_service);
                break;
            case 3:
                sem_wait(sem_three);
                (*three)++;
                sem_post(sem_three);

                sem_post(sem_closed);
                sem_wait(sem_third_service);
                break;
        }

        sem_wait(sem_output);
        fprintf(output, "%d: Z %d: called by office worker\n", ++(*A), idZ);
        sem_post(sem_output);

        usleep((rand() % (10 + 1)) * MS);
    }
    else {
        sem_post(sem_closed);
    }

    sem_wait(sem_output);
    fprintf(output, "%d: Z %d: going home\n", ++(*A), idZ);
    sem_post(sem_output);
}

/**
 * @brief The officer process
 * @param idU id of the officer
 * @param TU maximum time for a break
 */
void officer(int idU, int TU) {
    sem_wait(sem_output);
    fprintf(output, "%d: U %d: started\n", ++(*A), idU);
    sem_post(sem_output);

    srand(time(NULL) * getpid());

    while(true) {
        if(((*one) > 0) || ((*two) > 0) || ((*three) > 0)) {
            (*service) = (rand() % 3) + 1;
            switch(*service) {
                case 1:
                    if((*one) < 1) {
                        continue;
                    }
                    break;
                case 2:
                    if((*two) < 1) {
                        continue;
                    }
                    break;
                case 3:
                    if((*three) < 1) {
                        continue;
                    }
                    break;
            }

            sem_wait(sem_output);
            fprintf(output, "%d: U %d: serving a service of type %d\n", ++(*A), idU, (*service));
            sem_post(sem_output);

            sem_post(sem_service);
            switch(*service) {
                case 1:
                    sem_wait(sem_one);
                    (*one)--;
                    sem_post(sem_one);

                    sem_post(sem_first_service);
                    break;
                case 2:
                    sem_wait(sem_two);
                    (*two)--;
                    sem_post(sem_two);

                    sem_post(sem_second_service);
                    break;
                case 3:
                    sem_wait(sem_three);
                    (*three)--;
                    sem_post(sem_three);

                    sem_post(sem_third_service);
                    break;
            }

            usleep((rand() % (10 + 1)) * MS);

            sem_wait(sem_output);
            fprintf(output, "%d: U %d: service finished\n", ++(*A), idU);
            sem_post(sem_output);
            continue;
        }
        else {
            if((*closed) == 1) {
                break;
            }
            else {
                sem_wait(sem_output);
                fprintf(output, "%d: U %d: taking break\n", ++(*A), idU);
                sem_post(sem_output);

                usleep((rand() % (TU + 1)) * MS);

                sem_wait(sem_output);
                fprintf(output, "%d: U %d: break finished\n", ++(*A), idU);
                sem_post(sem_output);
                sem_post(sem_service);
                continue;
            }
        }
    }

    sem_wait(sem_output);
    fprintf(output, "%d: U %d: going home\n", ++(*A), idU);
    sem_post(sem_output);
}

/**
 * @brief Main function (process) of the program
 * @param argc number of command line arguments
 * @param argv array of command line arguments
 * @return int OK if program ends successfully, int FAIL otherwise
 */
int main(int argc, char *argv[]) {
    if(argc != 6) {
        fprintf(stderr, "proj2: incorrect number of arguments\n");
        exit(FAIL);
    }

    for(int i = 1; i < argc; i++) {
        for(int j = 0; argv[i][j] != '\0'; j++) {
            if(!isdigit(argv[i][j])) {
                fprintf(stderr, "proj2: invalid format of argument(s)\n");
                exit(FAIL);
            }
        }
    }

    int NZ = atoi(argv[1]);
    int NU = atoi(argv[2]);
    int TZ = atoi(argv[3]);
    int TU = atoi(argv[4]);
    int F = atoi(argv[5]);

    if(NZ < 0 || NU < 1 || TZ < 0 || TZ > 10000 || TU < 0 || TU > 100 || F < 0 || F > 10000) {
        fprintf(stderr, "proj2: incorrect value of argument(s)\n");
        exit(FAIL);
    }

    init();

    for(int idZ = 1; idZ <= NZ; idZ++) {
        pid_t pid = fork();
        if(pid == 0) {
            customer(idZ, TZ);
            exit(OK);
        }
    }

    for(int idU = 1; idU <= NU; idU++) {
        pid_t pid = fork();
        if(pid == 0) {
            officer(idU, TU);
            exit(OK);
        }
    }

    srand(time(NULL));
    usleep(((rand() % ((F / 2) + 1)) + (F / 2)) * MS);

    sem_wait(sem_output);
    fprintf(output, "%d: closing\n", ++(*A));
    sem_post(sem_output);

    sem_wait(sem_closed);
    (*closed) = 1;
    sem_post(sem_closed);

    while(wait(NULL) > 0);
    clean();
    exit(OK);
}
