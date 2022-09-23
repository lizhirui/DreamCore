#!/bin/csh -f

set nc_def = ""
set plusargs = +NULL
set flist = "./flist.f" ;
set fsdb_opts = '';
set notiming = "+notimingcheck";
set coverage_opts = ''; 
set assert_opts = '';
set optconfig='-debug_all -j16'

set OS=`uname -s`

switch ($OS)
   case SunOS:
           setenv OS_NAME SOL2
   breaksw
   case Linux:
           setenv OS_NAME LINUX
   breaksw
endsw

vcs -full64 -fsdb  \
    -line   \
    +vcsd   \
    +vpi    \
    $fsdb_opts \
    +plusarg_save    \
    -Mupdate \
    +cli+3 \
    +error+10    \
    +v2k    \
    +ntb_exit_on_error=10 \
    -negdelay \
    +neg_tchk    \
    +memcbk    \
    +sdfverbose    \
    +define+$nc_def     \
    -timescale=1ns/100ps    \
    $plusargs    \
    +warn=all    \
    +warn=noTFIPC \
    $coverage_opts \
    $assert_opts \
    $optconfig \
    $notiming \
    +warn=noWSUM \
    -sverilog \
    -l vcs.log \
    -f $flist

if ($status != 0) then
  /bin/echo -e "\t@@@ RTL Compile FAILED"
  /bin/echo -e ""
  exit 0
endif

./simv +vcs+lic+wait -l ./simv.log

cd ../sim