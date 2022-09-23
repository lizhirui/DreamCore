#!/bin/csh -f

setenv SIM_ROOT_DIR `pwd`/..

setenv SIM_SCRIPT_DIR `pwd` 

if ($1 == "basic" || $1 == "test") then
    set module = $2
    mkdir -p ../tb_output/$1/$module
    cp -r ../tb/$1/$module/* ../tb_output/$1/$module/
    cd ../tb_output/$1/$module/
else if ($1 == "difftest") then
    setenv SIM_TRACE_NAME $2
    set module = $3
    mkdir -p ../tb_output/$1/$2/$module
    cp -r ../tb/$1/$module/* ../tb_output/$1/$2/$module/
    cd ../tb_output/$1/$2/$module/
else
    echo "Usage: test_xrun.sh <basic|test|difftest> [<trace_name>] <module>"
    exit 1
endif

set nc_def = 'SIM_IMAGE_NAME="$SIM_ROOT_DIR/image/'$2'.hex"'
#set plusargs = "-noupdate"
#set plusargs = "-profile"
set plusargs = ""
#set multicore = "-mce"
set multicore = ""
set flist = "./flist.f" ;
set fsdb_opts = '';
set notiming = "-notimingcheck";
set coverage_opts = ""; 
set assert_opts = "";
set ida_dump = "-input $SIM_SCRIPT_DIR/xcelium_ida_dump.tcl -access +rwc -accessreg +rwc -debug -linedebug -uvmlinedebug -classlinedebug -plidebug -fsmdebug"
#set ida_dump = "-input $SIM_SCRIPT_DIR/xcelium_ida_dump.tcl -access +rwc -accessreg +rwc -debug -plidebug"
set ida_dump = ""
set xprop = "-xprop C -XPELSA -xfile $SIM_ROOT_DIR/sim/xfile.txt"
#set xprop = ""

set OS=`uname -s`

switch ($OS)
   case SunOS:
           setenv OS_NAME SOL2
   breaksw
   case Linux:
           setenv OS_NAME LINUX
   breaksw
endsw

xrun -clean

xrun -64bit \
    -sv \
    $notiming \
    $multicore \
    $plusargs \
    $ida_dump \
    +define+$nc_def \
    +define+SIMULATOR \
    -uvmaccess \
    -date \
    -dumpstack \
    -negdelay \
    $xprop \
    -nowarn CUVWSP \
    -nowarn DSEMEL \
    -nowarn RNDXCELON \
    -nowarn DSEM2009 \
    -nowarn RNQUIE \
    -timescale 1ns/100ps \
    -l xrun.log \
    -sv_lib $SIM_ROOT_DIR/tools/tdb_reader/tdb_reader.so \
    -f $flist

cd $SIM_SCRIPT_DIR