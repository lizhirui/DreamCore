using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace MyRISC_VCore_Model_GUI
{
    public static class RISC_V_Disassembler
    {
        [DllImport("riscv_dll.dll", EntryPoint = "riscv32_disasm", CallingConvention = CallingConvention.Cdecl)]
        private static extern int riscv32_disasm(IntPtr buffer, int size, uint address, out IntPtr result);

        [DllImport("riscv_dll.dll", EntryPoint = "result_free", CallingConvention = CallingConvention.Cdecl)]
        private static extern void result_free(IntPtr buffer);

        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi)]
        private struct disasm_item
        {
            public uint address;
            public int size;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 24)]
            public byte[] bytes;
            [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)]
            public string mnemonic;
            [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 160)]
            public string op_str;
        }

        public struct Result_Item
        {
            public uint address;
            public int size;
            public byte[] bytes;
            public string mnemonic;
            public string op_str;
        };

        private static Result_Item[] SingleDisassemble(byte[] data, uint address, uint start_pos)
        {
            var data_buffer = Marshal.AllocHGlobal((int)(((uint)data.Length) - start_pos));
            Marshal.Copy(data, (int)start_pos, data_buffer, (int)(((uint)data.Length) - start_pos));
            var result_ptr = IntPtr.Zero;
            var count = riscv32_disasm(data_buffer, data.Length, address, out result_ptr);
            var result = new Result_Item[count];

            for(var i = 0;i < count;i++)
            {
                var item = Marshal.PtrToStructure<disasm_item>(result_ptr + i * Marshal.SizeOf(typeof(disasm_item)));

                result[i].address = item.address;
                result[i].size = item.size;
                result[i].bytes = item.bytes;
                result[i].mnemonic = item.mnemonic;
                result[i].op_str = item.op_str;
            }

            result_free(result_ptr);
            Marshal.FreeHGlobal(data_buffer);
            return result;
        }

        public static Result_Item[] Disassemble(byte[] data, uint address)
        {
            var cur_pos = 0U;
            var result_list = new List<Result_Item>();

            while(true)
            {
                var result = SingleDisassemble(data, address + cur_pos, cur_pos);

                if(result.Length == 0)
                {
                    cur_pos += 4;
                }
                else
                {
                    result_list.AddRange(result);
                    cur_pos = result_list[result_list.Count - 1].address - address + ((uint)result_list[result_list.Count - 1].size);
                }

                if(cur_pos >= data.Length)
                {
                    break;
                }
            }

            return result_list.ToArray();
        }
    }
}
