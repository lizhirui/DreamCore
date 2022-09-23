#!/bin/bash

CYAN='\033[0;36m'
NC='\033[0m' # No Color

main() {
    # difftest return code
    dt_ret_code=0
    
    make -j

    for FILE in cases/riscv-tests/*; do
        elf=${FILE:6}

        echo -e "Start testing on ${CYAN}${elf}${NC} !!!"

        make prepare ELF=/$elf
        pushd build
        ./emulator
        
        ret_code=$?
        if [ $ret_code != 0 ]; then
            dt_ret_code=1
        fi    
        
        popd
    done 
    return $dt_ret_code
}

main
