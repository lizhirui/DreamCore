//===- IntrinsicsWebAssembly.td - Defines wasm intrinsics --*- tablegen -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
///
/// \file
/// This file defines all of the WebAssembly-specific intrinsics.
///
//===----------------------------------------------------------------------===//

let TargetPrefix = "wasm" in {  // All intrinsics start with "llvm.wasm.".

// Query the current memory size, and increase the current memory size.
// Note that memory.size is not IntrNoMem because it must be sequenced with
// respect to memory.grow calls.
def int_wasm_memory_size : Intrinsic<[llvm_anyint_ty],
                                     [llvm_i32_ty],
                                     [IntrReadMem]>;
def int_wasm_memory_grow : Intrinsic<[llvm_anyint_ty],
                                     [llvm_i32_ty, LLVMMatchType<0>],
                                     []>;

// These are the old names.
def int_wasm_mem_size : Intrinsic<[llvm_anyint_ty],
                                  [llvm_i32_ty],
                                  [IntrReadMem]>;
def int_wasm_mem_grow : Intrinsic<[llvm_anyint_ty],
                                  [llvm_i32_ty, LLVMMatchType<0>],
                                  []>;

// These are the old old names. They also lack the immediate field.
def int_wasm_current_memory : Intrinsic<[llvm_anyint_ty], [], [IntrReadMem]>;
def int_wasm_grow_memory : Intrinsic<[llvm_anyint_ty], [LLVMMatchType<0>], []>;

//===----------------------------------------------------------------------===//
// Exception handling intrinsics
//===----------------------------------------------------------------------===//

// throw / rethrow
def int_wasm_throw : Intrinsic<[], [llvm_i32_ty, llvm_ptr_ty],
                               [Throws, IntrNoReturn]>;
def int_wasm_rethrow : Intrinsic<[], [], [Throws, IntrNoReturn]>;

// Since wasm does not use landingpad instructions, these instructions return
// exception pointer and selector values until we lower them in WasmEHPrepare.
def int_wasm_get_exception : Intrinsic<[llvm_ptr_ty], [llvm_token_ty],
                                       [IntrHasSideEffects]>;
def int_wasm_get_ehselector : Intrinsic<[llvm_i32_ty], [llvm_token_ty],
                                        [IntrHasSideEffects]>;

// wasm.catch returns the pointer to the exception object caught by wasm 'catch'
// instruction.
def int_wasm_catch : Intrinsic<[llvm_ptr_ty], [llvm_i32_ty],
                               [IntrHasSideEffects]>;

// WebAssembly EH must maintain the landingpads in the order assigned to them
// by WasmEHPrepare pass to generate landingpad table in EHStreamer. This is
// used in order to give them the indices in WasmEHPrepare.
def int_wasm_landingpad_index: Intrinsic<[], [llvm_i32_ty], [IntrNoMem]>;

// Returns LSDA address of the current function.
def int_wasm_lsda : Intrinsic<[llvm_ptr_ty], [], [IntrNoMem]>;
}
