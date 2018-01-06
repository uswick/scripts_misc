#include <assert.h>
#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/utsname.h>


struct utsname   uts_info;

#define NUM 4
void addem(int *, int *, int *, MPI_Datatype *);

void addem(int *invec, int *inoutvec, int *len, MPI_Datatype *dtype) {
  int i, rank;
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  for (i = 0; i < *len; i++) inoutvec[i] += invec[i];
  printf("rank : %d length : %d \n", rank, *len );
}

volatile int i = 0;

int main(int argc, char **argv) {
  int    size, rank;
  int    root = 0;
  MPI_Op op;
  MPI_Init(&argc, &argv);
  MPI_Comm_size(MPI_COMM_WORLD, &size);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);

  uname(&uts_info);
  printf("******* START rank : %d %d %s \n", rank, getpid(), uts_info.nodename);
  fflush(stdout);
  while(!rank && !i){
    sleep(1);
  }
  MPI_Barrier(MPI_COMM_WORLD);

  int *localsum  = malloc(sizeof(int) * NUM);
  int *globalsum = calloc(NUM, sizeof(int));

  for (i = 0; i < NUM; ++i) {
    localsum[i] = 5 * i;
  }
  MPI_Op_create((MPI_User_function *)addem, 1, &op);

  MPI_Reduce(localsum, globalsum, NUM, MPI_INT, op, root, MPI_COMM_WORLD);

  if (rank == root) {
    for (i = 0; i < NUM; ++i) {
      printf("globalsum1[%d] = %d \n", i, globalsum[i]);
      assert(globalsum[i] == 5 * i * size);
    }
  }

  MPI_Finalize();

  return (EXIT_SUCCESS);
}

