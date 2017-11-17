#!/bin/bash

#sh micro_lco_pwc.sh > micro_N_256_I_1000_lco_pwc.res
#sh micro_proc_pwc.sh > micro_N_256_I_1000_proc_pwc.res
sh micro_proc_isir.sh > micro_N_256_I_1000_proc_isir.res
sh micro_lco_isir.sh > micro_N_256_I_1000_lco_isir.res
