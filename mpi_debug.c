#include <stdio.h>

int main(int argc, char *argv[])
{
	//DEBUG Parallal ie:- MPI //todo remove
	{
	  int i= 0;
 	  char hostname[256];
	  gethostname(hostname, sizeof(hostname));
	  printf("PID %d on %s ready for attach\n", getpid(), hostname);
	  fflush(stdout);
	  while (0 == i)
	   sleep(5);
	}	

	//DEBUG MPI //todo remove
	{
	  int rank;	
	  int i= 0;
 	  char hostname[256];
	  gethostname(hostname, sizeof(hostname));
	  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	  printf("PID %d on %s rank :%d ready for attach\n", getpid(), hostname, rank);
	  fflush(stdout);
	  //special MPI debug mode where we debug just one rank
	  //others will be running parallal after barrier 
	  if(rank == 0){
	    while (0 == i)
	     sleep(5);
	  }

	  MPI_Barrier(MPI_COMM_WORLD);
	}	
	return 0;
}
