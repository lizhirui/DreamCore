/*
 * SPDX-License-Identifier: Apache-2.0
 * Copyright 2019 Western Digital Corporation or its affiliates.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
*/ 

/*
 Linker script
*/

OUTPUT_ARCH( "riscv" )
ENTRY(_start)

MEMORY
{
  ICCM  (wxa!ri) : ORIGIN = 0x80020000, LENGTH = 256K
}

/*----------------------------------------------------------------------*/
/* Sections                                                             */
/*----------------------------------------------------------------------*/

SECTIONS
{
  __stack_size = DEFINED(__stack_size) ? __stack_size : 32K;

  .text.init	:
  {
	*(.text.init)
	. = ALIGN(4);
  } > ICCM

  .text :
  {
    *(.text.unlikely .text.unlikely.*)
    *(.text.startup .text.startup.*)
    *(.text .text.*)
    *(.gnu.linkonce.t.*)
	. = ALIGN(4);
  } > ICCM

  .rodata	:
  {
    *(.rdata)
    *(.rodata .rodata.*)
    *(.gnu.linkonce.r.*)
	. = ALIGN(4);
  } > ICCM
  .data	:
  {
	*(.data .data.*)
    *(.gnu.linkonce.d.*)
	. = ALIGN(4);
  } > ICCM
  .sdata	:
  {
	. = ALIGN(4);
    __global_pointer$ = . + 0x800;
    *(.sdata .sdata.*)
    *(.gnu.linkonce.s.*)
    . = ALIGN(4);
    *(.srodata .srodata.*)
	. = ALIGN(4);
  } > ICCM
  
  __bss_start = .;

  .sbss : {
    *(.sbss .sbss.* .gnu.linkonce.sb.*)
    *(.scommon)
	. = ALIGN(4);
  } > ICCM
  .bss :
  {
	*(.bss)
	. = ALIGN(4);
  } > ICCM

  _end = .;

  .stack :
  {
	_heap_end = .;
	. = . + __stack_size;
	_sp = .;
  } > ICCM
  
  __bss_end = .;
}
