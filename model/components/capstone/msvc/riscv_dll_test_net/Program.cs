﻿// See https://aka.ms/new-console-template for more information
using System.Runtime.InteropServices;



var inst = new byte[]{0x37,0x34,0x00,0x00,0x97,0x82,0x00,0x00,0xef,0x00,0x80,0x00,0xef,0xf0,0x1f,0xff,0xe7,0x00,0x45,0x00,0xe7,0x00,0xc0,0xff,0x63,0x05,0x41,0x00,0xe3,0x9d,0x61,0xfe,0x63,0xca,0x93,0x00,0x63,0x53,0xb5,0x00,0x63,0x65,0xd6,0x00,0x63,0x76,0xf7,0x00,0x03,0x88,0x18,0x00,0x03,0x99,0x49,0x00,0x03,0xaa,0x6a,0x00,0x03,0xcb,0x2b,0x01,0x03,0xdc,0x8c,0x01,0x23,0x86,0xad,0x03,0x23,0x9a,0xce,0x03,0x23,0x8f,0xef,0x01,0x93,0x00,0xe0,0x00,0x13,0xa1,0x01,0x01,0x13,0xb2,0x02,0x7d,0x13,0xc3,0x03,0xdd,0x13,0xe4,0xc4,0x12,0x13,0xf5,0x85,0x0c,0x13,0x96,0xe6,0x01,0x13,0xd7,0x97,0x01,0x13,0xd8,0xf8,0x40,0x33,0x89,0x49,0x01,0xb3,0x0a,0x7b,0x41,0x33,0xac,0xac,0x01,0xb3,0x3d,0xde,0x01,0x33,0xd2,0x62,0x40,0xb3,0x43,0x94,0x00,0x33,0xe5,0xc5,0x00,0xb3,0x76,0xf7,0x00,0xb3,0x54,0x39,0x01,0xb3,0x50,0x31,0x00,0x33,0x9f,0x0f,0x00};

var inst_buffer = Marshal.AllocHGlobal(inst.Length);
Marshal.Copy(inst, 0, inst_buffer, inst.Length);
IntPtr result_ptr = IntPtr.Zero;
var count = riscv32_disasm(inst_buffer, inst.Length, 0x1000, out result_ptr);

var result = new disasm_item[count];

for(var i = 0;i < count;i++)
{
    result[i] = (disasm_item)Marshal.PtrToStructure<disasm_item>(result_ptr + i * Marshal.SizeOf(typeof(disasm_item)));
}

result_free(result_ptr);

for(var i = 0;i < count;i++)
{
    Console.WriteLine(result[i].address + " " + result[i].mnemonic + " " + result[i].op_str);
}

Console.WriteLine("Hello, World!");

[DllImport("riscv_dll.dll", EntryPoint = "riscv32_disasm", CallingConvention = CallingConvention.Cdecl)]
static extern int riscv32_disasm(IntPtr buffer, int size, int address, out IntPtr result);

[DllImport("riscv_dll.dll", EntryPoint = "result_free", CallingConvention = CallingConvention.Cdecl)]
static extern void result_free(IntPtr buffer);

[StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi)]
struct disasm_item
{
    public int address;
    public int size;
    [MarshalAs(UnmanagedType.ByValArray, SizeConst = 24)]
    public byte[] bytes;
    [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)]
    public string mnemonic;
    [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 160)]
    public string op_str;
}
