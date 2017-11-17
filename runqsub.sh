#!/bin/bash

qsub -I  -l walltime=24:00:00 -l nodes=2:ppn=8
salloc -N 2  --ntasks-per-node=1  -t 5 --exclusive /bin/bash
srun --jobid=46681 --pty bash
srun --pty bash
find . -name Makefile | xargs sed -i 's/-DMIC/-mmic/g'
LD_PRELOAD=/u/uswickra/privatemodules/valgrind/3.11.0/lib/valgrind/libmpiwrap-amd64-linux.so mpirun -np 1 valgrind --leak-check=full --track-origins=yes  ./hello --hpx-opt-smp=0 --hpx-threads=1 > my2.log 2>&1
 salloc -N 12  --ntasks-per-node=1  -t 06:10:00 --exclusive /bin/bash
LD_PRELOAD=/u/uswickra/privatemodules/valgrind/3.11.0/lib/valgrind/libmpiwrap-amd64-linux.so mpirun -np 2 valgrind --tool=callgrind --dump-instr=yes --collect-jumps=yes    ./photon_test_nbc_coll 

=====
LD_PRELOAD=/u/uswickra/privatemodules/valgrind/3.11.0/lib/valgrind/libmpiwrap-amd64-linux.so  mpirun  -np 3 --mca mtl ^psm /u/uswickra/privatemodules/valgrind//3.11.0/bin/valgrind --log-file=Valgrind.%p  --leak-check=full --vgdb=yes --vgdb-error=0  ./photon_test_nbc_coll 

=== disable mtl  (cm - Mellanox MXM, Infinipath-PSM, Myrinet MX, Portals)
=== enable btl (ob1 - OpenFabrics, uGINI[Aries/Gemini], Loopback, SHMem, TCP)

mpirun  -np 4 --mca pml ob1 /u/uswickra/privatemodules/valgrind//3.11.0/bin/valgrind --log-file=Valgrind.%p  --leak-check=full --track-origins=yes ./photon_test_nbc_coll


=======
=== set hpx and comeback ===
mode="pwc" ;curr=`pwd`; cd $HPX_HOME ; sethpx -i $mode;  cd $curr



=== find hosts in an address range
nmap -sP 192.168.1.1/24



Lulesh : x==58 , n = 27 , 8 nodes
==================================

mpi ==> 
mpirun --map-by node -np 2 /u/uswickra/hpx/hpx-libnbc/collbench_overlap/parcels/collective-benchmarks-lullesh/apps/hpx-apps/lulesh/parcels/luleshparcels -n 27 -x 58 -i 100 --hpx-threads=16 --hpx-network=pwc  --hpx-photon-ibdev=qib0 


mpi+omp ==>
omp threads = ceil(cpn / procs per node) = ceil( 16/(27/8) )
OMP_NUM_THREADS=5 mpirun --map-by node -np 27 /u/uswickra/hpx/hpx-libnbc/collbench_overlap/parcels/collective-benchmarks-lullesh/collective-benchmarks/scripts/profile/../../lulesh_mpiomp 58 100


hpx-5 (regular) ==>
mpirun --map-by node -np 2 /u/uswickra/hpx/hpx-libnbc/collbench_overlap/parcels/collective-benchmarks-lullesh/apps/hpx-apps/lulesh/parcels/luleshparcels -n 27 -x 58 -i 100 --hpx-threads=16 --hpx-network=pwc  --hpx-photon-ibdev=qib0


hpx-5 (oversub) ==> nx^3 = n1x1^3
x1 = cubic_root(27*58^3/64)
np = 64/cpn = 16

mpirun --map-by node -np 4 /u/uswickra/hpx/hpx-libnbc/collbench_overlap/parcels/collective-benchmarks-lullesh/apps/hpx-apps/lulesh/parcels/luleshparcels -n 64 -x 43 -i 100 --hpx-threads=16 --hpx-network=pwc  --hpx-photon-ibdev=qib0 


hpx-5 (regular) + network colls  ==> 
mpirun --map-by node -np 2 /u/uswickra/hpx/hpx-libnbc/collbench_overlap/parcels/collective-benchmarks-lullesh/apps/hpx-apps/lulesh/parcels/luleshparcels -n 27 -x 58 -i 100 --hpx-threads=16 --hpx-network=pwc  --hpx-photon-ibdev=qib0 --hpx-coll-network  --hpx-photon-coll=nbc



hpx-5 (oversub) + network colls  ==> 
mpirun --map-by node -np 4 /u/uswickra/hpx/hpx-libnbc/collbench_overlap/parcels/collective-benchmarks-lullesh/apps/hpx-apps/lulesh/parcels/luleshparcels -n 64 -x 43 -i 100 --hpx-threads=16 --hpx-network=pwc  --hpx-photon-ibdev=qib0 --hpx-coll-network  --hpx-photon-coll=nbc


