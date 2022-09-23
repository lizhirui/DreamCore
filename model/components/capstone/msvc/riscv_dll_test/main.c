#include <stdio.h>
#include <windows.h>
#include <capstone/platform.h>
#include <capstone/capstone.h>

typedef uint32_t (*riscv32_disasm_func)(char *buffer, uint32_t size, uint32_t address, cs_insn **insn);
typedef void (*result_free_func)(void *buffer);

#define RISCV_CODE32 "\x37\x34\x00\x00\x97\x82\x00\x00\xef\x00\x80\x00\xef\xf0\x1f\xff\xe7\x00\x45\x00\xe7\x00\xc0\xff\x63\x05\x41\x00\xe3\x9d\x61\xfe\x63\xca\x93\x00\x63\x53\xb5\x00\x63\x65\xd6\x00\x63\x76\xf7\x00\x03\x88\x18\x00\x03\x99\x49\x00\x03\xaa\x6a\x00\x03\xcb\x2b\x01\x03\xdc\x8c\x01\x23\x86\xad\x03\x23\x9a\xce\x03\x23\x8f\xef\x01\x93\x00\xe0\x00\x13\xa1\x01\x01\x13\xb2\x02\x7d\x13\xc3\x03\xdd\x13\xe4\xc4\x12\x13\xf5\x85\x0c\x13\x96\xe6\x01\x13\xd7\x97\x01\x13\xd8\xf8\x40\x33\x89\x49\x01\xb3\x0a\x7b\x41\x33\xac\xac\x01\xb3\x3d\xde\x01\x33\xd2\x62\x40\xb3\x43\x94\x00\x33\xe5\xc5\x00\xb3\x76\xf7\x00\xb3\x54\x39\x01\xb3\x50\x31\x00\x33\x9f\x0f\x00"

typedef struct disasm_item
{
    uint32_t address;
    uint32_t size;
    uint8_t bytes[24];
    char mnemonic[32];
    char op_str[160];
}disasm_item;

int main()
{
    uint64_t address = 0x1000;
    disasm_item *result;
    int i;
    size_t count;
    riscv32_disasm_func riscv32_disasm;
    result_free_func result_free;

    HINSTANCE hdll = LoadLibrary("riscv_dll.dll");
    riscv32_disasm = (riscv32_disasm_func)GetProcAddress(hdll, "riscv32_disasm");
    result_free = (result_free_func)GetProcAddress(hdll, "result_free");

    count = riscv32_disasm(RISCV_CODE32, sizeof(RISCV_CODE32) - 1, (uint32_t)address, &result);
    printf("count = %d\n", count);
	

    for(auto i = 0;i < count;i++)
    {
		printf("0x%08x %s %s\n", result[i].address, result[i].mnemonic, result[i].op_str);
    }

    result_free(result);
    return 0;
}
