#!/bin/bash
CLANG_COMPL_FILE=.syntastic_cpp_config
SYNTASTIC_CPP_CONF_FILE=.clang_complete
C_STD=gnu++11

echo "enter include dir(s) and press [ENTER]:"
read dirs

echo "enter exclude dir(s) and press [ENTER]:"
read exdirs

#echo "==> $dirs"
cat <<EOF > syn.tmp
-I .
EOF

cat <<EOF > clang.tmp
-Wl,-rpath
-Wl,/foo
-Werror
-Wall
-std=gnu++11
-I .
EOF

all=()
excluded=()
for d in ${dirs[@]}; do
	#statements
	ABS_PATH=$d
	if [[ $d = /* ]]; then
		echo "absolute dir => $d" > /dev/null
		#statements
	else
		echo "relative dir => $d" > /dev/null
		ABS_PATH="$PWD/${d}"
	fi
	#echo "ABS_PATH => $ABS_PATH"

	for sub in $(find $ABS_PATH -maxdepth 100 -type d); do
		current_sub_normalized="`cd "${sub}";pwd`"
		cidx=0
		all+=("$current_sub_normalized")
	done

done


for ex in ${exdirs[@]}; do
	EX_ABS_PATH=$ex
	if [[ $ex = /* ]]; then
		echo "absolute dir => $ex" > /dev/null
	else
		EX_ABS_PATH="$PWD/${ex}"
	fi

	for sub in $(find $EX_ABS_PATH -maxdepth 100 -type d); do
		excl_sub_normalized="`cd "${sub}";pwd`"
		excluded+=("$excl_sub_normalized")
	done
done


for f in ${all[@]}; do
	cidx=0
	for g in ${excluded[@]}; do
		#check if excluded directory is among any directories considered
		#if so skip that dir
		if [[ $g -ef $f ]]; then
			cidx=$(($cidx+1))
			break
		fi
	done

	if [[ $cidx -eq 0 ]]; then
		echo "-I $f" >> syn.tmp
		echo "-I $f" >> clang.tmp
	fi
done

mv syn.tmp ${SYNTASTIC_CPP_CONF_FILE}
mv clang.tmp ${CLANG_COMPL_FILE}
