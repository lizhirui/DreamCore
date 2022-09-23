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
    echo "Usage: run_vcs.sh <basic|difftest> [<trace_name>] <module>"
    exit 1
endif

#set nc_def = "FSDB_DUMP"
set nc_def = 'SIM_IMAGE_NAME="$SIM_ROOT_DIR/image/'$2'.hex"'
set plusargs = "-noIncrComp"
set plusargs = +NULL
set flist = "./flist.f" ;
set fsdb_opts = '';
set notiming = "+notimingcheck";
set coverage_opts = ''; 
set assert_opts = '';
#set optconfig='-debug_all -j'
#set optconfig='-simprofile'
set optconfig=''

set OS=`uname -s`

switch ($OS)
   case SunOS:
           setenv OS_NAME SOL2
   breaksw
   case Linux:
           setenv OS_NAME LINUX
   breaksw
endsw

#    -fsdb   \
#    -line   \
#    +vcsd   \

#-negdelay \
#+neg_tchk    \
#+memcbk    \
#+sdfverbose    \

vcs -full64  \
    +vpi    \
    $fsdb_opts \
    +plusarg_save    \
    -Mupdate \
    +cli+3 \
    +error+10    \
    +v2k    \
    +ntb_exit_on_error=10 \
    +define+$nc_def     \
    +define+SIMULATOR \
    +define+SIMULATOR_NOT_SUPPORT_SFORMATF_AS_CONSTANT_EXPRESSION \
    -timescale=1ns/100ps    \
    $plusargs    \
    +warn=all    \
    +warn=noTFIPC \
    $coverage_opts \
    $assert_opts \
    $optconfig \
    $notiming \
    +warn=noWSUM \
    -rad -debug_acc+pp \
    -sverilog \
    -l vcs.log \
    -f $flist  

if ($status != 0) then
  /bin/echo -e "\t@@@ RTL Compile FAILED"
  /bin/echo -e ""
  exit 0
endif

./simv +vcs+lic+wait -l ./simv.log

cd $SIM_SCRIPT_DIR