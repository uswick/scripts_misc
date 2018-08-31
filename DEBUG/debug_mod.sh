#!/bin/bash
GDBC_SLEEP=10
GDBS_PORT=2345
LAUNCH="srun"

echo "enter program to remote debug [ENTER]:"
read PRG

#echo "enter program PID to remote debug [ENTER]:"
#read PID

echo "enter (remote) host to debug [ENTER]:"
read HOST

echo "enter Number of nodes [ENTER]:"
read N

#echo "enter Number of total tasks [ENTER]:"
#read t
t=$N

if [ -z $N ]; then
 N=1
fi

if [ -z $t ]; then
 t=1
fi

PRG=$(readlink -f $PRG)

CMD_GDBC="gdb $PRG"
# -c is cpus per task; we need to add an addditional cpu to start debug server
CMD="${LAUNCH} -N${N} -n${t} -c2 --exclusive  --nodelist=$HOST ./debug_server.sh $PRG $HOST $GDBS_PORT" 
#CMD="${LAUNCH} -N${N} -n${t} -c2 --exclusive  --nodelist=$HOST ./debug_server_pid.sh $PID $HOST $GDBS_PORT" 

echo "Remote Debug configuration;  Program : [$PRG] PID : [$PID] Debug Host : [$HOST] Launch : [$LAUNCH] Nodes : [$N] Tasks : [$t]" 

#add gdb init configuration to auto connect at start
function gen_gdbinit {
cat <<EOF > .gdbinit
target remote $HOST:$GDBS_PORT
b main
continue
EOF

echo "gdb config file generated"
}

function start_parallel {
$CMD &
echo "parallel run executed"
}

function start_gdb {
echo  "You can connect to gdb server now!"
sleep $GDBC_SLEEP
echo "========================================"
echo "target remote $HOST:$GDBS_PORT"
$CMD_GDBC
}

#gen_gdbinit
#run commands
start_parallel
start_gdb

wait

