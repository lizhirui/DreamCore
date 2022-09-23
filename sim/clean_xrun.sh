#!/bin/csh -f

setenv SIM_ROOT_DIR `pwd`/..

setenv SIM_SCRIPT_DIR `pwd` 

if ($1 == "basic") then
    set module = $2
else if ($1 == "difftest") then
    setenv SIM_TRACE_NAME $2
    set module = $3
else
    echo "Usage: clean_xrun.sh <basic|difftest> [<trace_name>] <module>"
    exit 1
endif

cd ../tb/$1/$module/

set OS=`uname -s`

switch ($OS)
   case SunOS:
           setenv OS_NAME SOL2
   breaksw
   case Linux:
           setenv OS_NAME LINUX
   breaksw
endsw

xrun -64bit -clean

cd $SIM_SCRIPT_DIR