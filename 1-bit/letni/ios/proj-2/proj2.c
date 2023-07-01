/**
 * Operating Systems
 * =================
 * 
 * 2nd Project
 * Author: David Kvacek
 * Login: xkvace00; FIT
 * Date: 2022-05-02
 * 
 * Solution inspired
 * by The Little Book
 * of Semaphores written
 * by Allen B. Downey
 */

/**
 * Program includes
 */
#include <ctype.h>
#include <fcntl.h>
#include <limits.h>
#include <semaphore.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <sys/ipc.h>
#include <sys/mman.h>
#include <sys/shm.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>

/**
 * Program defines
 */
#define OK 0
#define FAIL 1

/**
 * Function prototypes
 */
int argv_check(char *arr);
int init();
void clean();
void oxygen(int idO, int TI, int TB);
void hydrogen(int idH, int TI, int TB);

/**
 * Global variables
 */
FILE *fileptr;

sem_t *sem_mutex_one = NULL;
sem_t *sem_mutex_two = NULL;
sem_t *sem_oxyQueue = NULL;
sem_t *sem_hydroQueue = NULL;
sem_t *sem_turnstile_one = NULL;
sem_t *sem_turnstile_two = NULL;

int *A = NULL;
int *O = NULL;
int *H = NULL;
int *noM = NULL;
int *count = NULL;

int main(int argc, char *argv[]) {
    if(argc != 5) {
        fprintf(stderr, "FAIL: proj2: Invalid number of arguments [%d]\n", argc - 1);
        return FAIL;
    }

    for(int i = 1; i < argc; i++) {
        if((argv_check(argv[i])) == FAIL) {
            fprintf(stderr, "FAIL: proj2: Argument '%s' is not a number\n", argv[i]);
            return FAIL;
        }

        if((atoi(argv[i])) < 0) {
            fprintf(stderr, "FAIL: proj2: Argument '%s' must be a positive integer\n", argv[i]);
            return FAIL;
        }

        if(i == 3 || i == 4) {
            if((atoi(argv[i])) > 1000) {
                fprintf(stderr, "FAIL: proj2: Argument '%s' must be between 0 and 1000\n", argv[i]);
                return FAIL;
            }
        }
    }

    int NO = atoi(argv[1]);
    int NH = atoi(argv[2]);
    int TI = atoi(argv[3]);
    int TB = atoi(argv[4]);

    if((NO < 1) && (NH < 1)) {
        fprintf(stderr, "FAIL: proj2: No O and H atoms\n");
        return FAIL;
    }

    if(init() == FAIL) {
        return FAIL;
    }

    for(int i = 0; i < NO; i++) {
        pid_t pid = fork();
        if(pid == 0) {
            oxygen(i + 1, TI, TB);
            exit(OK);
        }
    }

    for(int j = 0; j < NH; j++) {
        pid_t pid = fork();
        if(pid == 0) {
            hydrogen(j + 1, TI, TB);
            exit(OK);
        }
    }

    while(wait(NULL) > 0);
    clean();

    return OK;
}

/**
 * Function checks whether argument is a valid number
 */
int argv_check(char *arr) {
    int start = 0;
    int len = strlen(arr);

    if(arr[0] == ' ') {
        return FAIL;
    }

    if(arr[0] == '-') {
        start = 1;
    }

    for(int i = start; i < len; i++) {
        if(arr[i] < '0' || arr[i] > '9') {
            return FAIL;
        }
    }

    return OK;
}

/**
 * Function opens a file, initializes semaphores and creates resources
 */
int init() {
    fileptr = fopen("proj2.out", "w");
    if(fileptr == NULL) {
        fprintf(stderr, "FAIL: proj2: Unable to open file 'proj2.out'\n");
        return FAIL;
    }

    setbuf(fileptr, NULL);

    sem_mutex_one = mmap(NULL, sizeof(sem_t), PROT_READ | PROT_WRITE, MAP_ANONYMOUS | MAP_SHARED, 0, 0);
    sem_mutex_two = mmap(NULL, sizeof(sem_t), PROT_READ | PROT_WRITE, MAP_ANONYMOUS | MAP_SHARED, 0, 0);
    sem_oxyQueue = mmap(NULL, sizeof(sem_t), PROT_READ | PROT_WRITE, MAP_ANONYMOUS | MAP_SHARED, 0, 0);
    sem_hydroQueue = mmap(NULL, sizeof(sem_t), PROT_READ | PROT_WRITE, MAP_ANONYMOUS | MAP_SHARED, 0, 0);
    sem_turnstile_one = mmap(NULL, sizeof(sem_t), PROT_READ | PROT_WRITE, MAP_ANONYMOUS | MAP_SHARED, 0, 0);
    sem_turnstile_two = mmap(NULL, sizeof(sem_t), PROT_READ | PROT_WRITE, MAP_ANONYMOUS | MAP_SHARED, 0, 0);

    A = mmap(NULL, sizeof(int), PROT_READ | PROT_WRITE, MAP_ANONYMOUS | MAP_SHARED, 0, 0);
    O = mmap(NULL, sizeof(int), PROT_READ | PROT_WRITE, MAP_ANONYMOUS | MAP_SHARED, 0, 0);
    H = mmap(NULL, sizeof(int), PROT_READ | PROT_WRITE, MAP_ANONYMOUS | MAP_SHARED, 0, 0);
    noM = mmap(NULL, sizeof(int), PROT_READ | PROT_WRITE, MAP_ANONYMOUS | MAP_SHARED, 0, 0);
    count = mmap(NULL, sizeof(int), PROT_READ | PROT_WRITE, MAP_ANONYMOUS | MAP_SHARED, 0, 0);

    sem_init(sem_mutex_one, 1, 1);
    sem_init(sem_mutex_two, 1, 1);
    sem_init(sem_oxyQueue, 1, 0);
    sem_init(sem_hydroQueue, 1, 0);
    sem_init(sem_turnstile_one, 1, 0);
    sem_init(sem_turnstile_two, 1, 1);

    return OK;
}

/**
 * Function closes a file, destroys semaphores and cleans up resources
 */
void clean() {
    sem_destroy(sem_mutex_one);
    sem_destroy(sem_mutex_two);
    sem_destroy(sem_oxyQueue);
    sem_destroy(sem_hydroQueue);
    sem_destroy(sem_turnstile_one);
    sem_destroy(sem_turnstile_two);

    munmap(sem_mutex_one, sizeof(sem_t));
    munmap(sem_mutex_two, sizeof(sem_t));
    munmap(sem_oxyQueue, sizeof(sem_t));
    munmap(sem_hydroQueue, sizeof(sem_t));
    munmap(sem_turnstile_one, sizeof(sem_t));
    munmap(sem_turnstile_two, sizeof(sem_t));

    munmap(A, sizeof(int));
    munmap(O, sizeof(int));
    munmap(H, sizeof(int));
    munmap(noM, sizeof(int));
    munmap(count, sizeof(int));

    fclose(fileptr);
}

/**
 * Oxygen function
 */
void oxygen(int idO, int TI, int TB) {
    srand(time(NULL) * getpid());
    fprintf(fileptr, "%d: O %d: started\n", ++(*A), idO);
    usleep(1000 * (rand() % (TI + 1)));
    fprintf(fileptr, "%d: O %d: going to queue\n", ++(*A), idO);

    sem_wait(sem_mutex_one);
    (*O)++;

    if((*H) >= 2) {
        ++(*noM);
        sem_post(sem_hydroQueue);
        sem_post(sem_hydroQueue);
        (*H) -= 2;
        sem_post(sem_oxyQueue);
        (*O)--;
    }

    else {
        sem_post(sem_mutex_one);
    }

    sem_wait(sem_oxyQueue);
    fprintf(fileptr, "%d: O %d: creating molecule %d\n", ++(*A), idO, (*noM));
    usleep(1000 * (rand() % (TB + 1)));

    sem_wait(sem_mutex_two);
    (*count)++;
    if((*count) == 3) {
        sem_wait(sem_turnstile_two);
        sem_post(sem_turnstile_one);
    }

    sem_post(sem_mutex_two);
    sem_wait(sem_turnstile_one);
    sem_post(sem_turnstile_one);

    fprintf(fileptr, "%d: O %d: molecule %d created\n", ++(*A), idO, (*noM));

    sem_wait(sem_mutex_two);
    (*count)--;
    if((*count) == 0) {
        sem_wait(sem_turnstile_one);
        sem_post(sem_turnstile_two);
    }

    sem_post(sem_mutex_two);
    sem_wait(sem_turnstile_two);
    sem_post(sem_turnstile_two);

    sem_post(sem_mutex_one);
}

/**
 * Hydrogen function
 */
void hydrogen(int idH, int TI, int TB) {
    srand(time(NULL) * getpid());
    fprintf(fileptr, "%d: H %d: started\n", ++(*A), idH);
    usleep(1000 * (rand() % (TI + 1)));
    fprintf(fileptr, "%d: H %d: going to queue\n", ++(*A), idH);

    sem_wait(sem_mutex_one);
    (*H)++;

    if((*H) >= 2 && (*O) >= 1) {
        ++(*noM);
        sem_post(sem_hydroQueue);
        sem_post(sem_hydroQueue);
        (*H) -= 2;
        sem_post(sem_oxyQueue);
        (*O)--;
    }

    else {
        sem_post(sem_mutex_one);
    }

    sem_wait(sem_hydroQueue);
    fprintf(fileptr, "%d: H %d: creating molecule %d\n", ++(*A), idH, (*noM));
    usleep(1000 * (rand() % (TB + 1)));

    sem_wait(sem_mutex_two);
    (*count)++;
    if((*count) == 3) {
        sem_wait(sem_turnstile_two);
        sem_post(sem_turnstile_one);
    }

    sem_post(sem_mutex_two);
    sem_wait(sem_turnstile_one);
    sem_post(sem_turnstile_one);

    fprintf(fileptr, "%d: H %d: molecule %d created\n", ++(*A), idH, (*noM));

    sem_wait(sem_mutex_two);
    (*count)--;
    if((*count) == 0) {
        sem_wait(sem_turnstile_one);
        sem_post(sem_turnstile_two);
    }

    sem_post(sem_mutex_two);
    sem_wait(sem_turnstile_two);
    sem_post(sem_turnstile_two);
}
