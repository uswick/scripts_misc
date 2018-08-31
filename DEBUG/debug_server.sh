#!/bin/bash

#PRG=/N/u/uswickra/BR2Plus/ugini/ugni_net/uGNI_Net/a.out
PRG=$1
#sleep 10 && echo "done" > /N/u/uswickra/BR2Plus/ugini/ugni_net/uGNI_Net/my.out &

$PRG &

#sleep number of seconds to avoid connecting too early
sleep 5

HOST=$(hostname)
echo "$HOST"

if [ "$HOST" == "$2" ]; then
 gdbserver --attach ":$3" `pidof ${PRG}`
 echo "GDB server started on ${HOST} port 2345" 
fi

wait
