#!/bin/csh -f

if ($1 == "basic") then
    set module = $2
else if ($1 == "difftest") then
    setenv SIM_TRACE_NAME $2
    set module = $3
else
    echo "Usage: test_sim_run.sh <basic|difftest> [<trace_name>] <module>"
    exit 1
endif

cd ../tb/$1/$module/
verdi -f ./flist.f -2001 -top top -ssf top.fsdb &
cd ../sim