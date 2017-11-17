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
luleshmpi="$HOME/hpx/hpx-libnbc/sw_coll/hpx-apps/lulesh/mpi/lullesh-mpi"
luleshpar_isir_mpicoll="$HOME/hpx/hpx-libnbc/sw_coll/hpx-apps/lulesh/parcels/luleshparcels_mpicoll"

luleshpar_isir_parcelcoll="/u/uswickra/hpx/hpx-libnbc/sw_coll/hpx-apps/lulesh/parcels/luleshparcels_isirparcoll"
luleshpar_pwc_parcelcoll="$HOME/hpx/hpx-libnbc/sw_coll/hpx-apps/lulesh/parcels/luleshparcels_pwccoll"
tst="mpi"
#tst="isir_mpi"

#tst="pwc"
#tst="isir_parcel"

#for tst in "pwc"; do
for i in {2..6}; do
	n=$(($i**3))
	#x=48
	x=32
	i=100

	m=$(($n%$cpn))
	if [ "$m" -gt "0" ]; then
		np=$(($n/$cpn+1))
	else
		np=$(($n/$cpn))
	fi

	m=$(($n%$np))
	if [ "$m" -gt "0" ]; then
		t=$(($n/$np+1))
	else
		t=$(($n/$np))
	fi

	if [ 0 = 1 ]; then
		if [ "$n" -eq "8" ]; then
			n=216
			x=16
		elif [ "$n" -eq "27" ]; then
			n=216
			x=24
		elif [ "$n" -eq "64" ]; then
			n=512
			x=24
		elif [ "$n" -eq "125" ]; then
			n=512
			x=30
		elif [ "$n" -eq "216" ]; then
			n=729
			x=32
		fi
	fi

	case "$tst" in
		mpi)
			cmd="mpirun -np ${n} -mca mtl ^psm ${luleshmpi} ${x} ${i}"
			;;
		pwc)
			cmd="mpirun -np ${np} -mca mtl ^psm -map-by node:PE=16 ${luleshpar_pwc_parcelcoll} -n ${n} -x ${x} -i ${i} --hpx-threads=${t} --hpx-network=${tst} --hpx-photon-ibdev=qib0"
			;;
		isir_mpi)
			cmd="mpirun -np ${np} -mca mtl ^psm -map-by node:PE=16 ${luleshpar_isir_mpicoll} -n ${n} -x ${x} -i ${i} --hpx-threads=${t} --hpx-network=isir "
			;;
		isir_parcel)
			cmd="mpirun -np ${np} -mca mtl ^psm -map-by node:PE=16 ${luleshpar_isir_parcelcoll} -n ${n} -x ${x} -i ${i} --hpx-threads=${t} --hpx-network=isir "
			;;
	esac

	for j in {1..5}; do
		echo "Running \"${cmd}\"..."
		#$cmd
		sleep 1
	done
done
#done
