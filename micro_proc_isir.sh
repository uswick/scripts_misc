#!/bin/bash

##SBATCH -N 14
##SBATCH -n 224
#SBATCH -N 16
#SBATCH -n 256
#SBATCH -t 01:00:00
#SBATCH --exclusive
#SBATCH --output run_lulesh_cutter.%J.out

#module load openmpi/1.8.8

cpn=16   # CPUs per node
allreduce_mpi="/u/uswickra/hpx/hpx-libnbc/sw_coll/test-hpx/allreduce/osu-micro-benchmarks-5.1/mpi/collective/micro_allreduce"

lco_allreduce_pwc_coll="/u/uswickra/hpx/hpx-libnbc/sw_coll/hpx2/hpx2/hpx/tests/unit/lco_allreduce"
lco_allreduce_isir_coll="/u/uswickra/hpx/hpx-libnbc/sw_coll/test-hpx/hpx_micro/tests/unit/lco_allreduce"

process_allreduce_pwc_coll="/u/uswickra/hpx/hpx-libnbc/sw_coll/hpx2/hpx2/hpx/tests/unit/allreduce"
process_allreduce_isir_mpicoll="/u/uswickra/hpx/hpx-libnbc/sw_coll/test-hpx/hpx_micro/tests/unit/allreduce"

#tst="mpi"
#tst="lco_pwc"
#tst="lco_isir"
#tst="process_pwc"
tst="process_isir"

#no elements to reduce
N=256
#for tst in "pwc"; do
for i in {1..16}; do
	mpi_n=$(($i*$cpn))
	hpx_n=$i
	t=$cpn
	case "$tst" in
		mpi)
			cmd="mpirun -np ${mpi_n} -mca mtl ^psm ${allreduce_mpi}"
			;;
		process_pwc)
			cmd="mpirun -np ${hpx_n} -mca mtl ^psm -map-by node:PE=16 ${process_allreduce_pwc_coll} --hpx-threads=${t} --hpx-network=pwc --hpx-photon-ibdev=qib0"
			;;
		process_isir)
			cmd="mpirun -np ${hpx_n} -mca mtl ^psm -map-by node:PE=16 ${process_allreduce_isir_mpicoll} --hpx-threads=${t} --hpx-network=isir "
			;;
		lco_pwc)
			cmd="mpirun -np ${hpx_n} -mca mtl ^psm -map-by node:PE=16 ${lco_allreduce_pwc_coll} --hpx-threads=${t} --hpx-network=pwc  --hpx-photon-ibdev=qib0"
			;;
		lco_isir)
			cmd="mpirun -np ${hpx_n} -mca mtl ^psm -map-by node:PE=16 ${lco_allreduce_isir_coll} --hpx-threads=${t} --hpx-network=isir"
			;;
	esac

	for j in {1..5}; do
		echo "Running \"${cmd}\"..."
		$cmd
		sleep 1
	done
done
#done
