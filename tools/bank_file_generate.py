import os

#input_file = "..\\image\\coremark_10.bin"
#output_file = "..\\image\\coremark_10.hex"

#input_file = "..\\image\\dhrystone.bin"
#output_file = "..\\image\\dhrystone.hex"

#input_file = "..\\image\\rtthread.bin"
#output_file = "..\\image\\rtthread.hex"

#input_file = "..\\software\\hello_world\\main\\hello_world.bin"
#output_file = "..\\image\\hello_world.hex"

input_file = "..\\software\\bootloader\\main\\bootloader.bin"
output_file = "..\\image\\bootloader.hex"

bank_num = 16
tcm_size = 1048576

with open(input_file, "rb") as f:
    data = f.read()

f_list = []

for i in range(bank_num):
    f_list.append([])

i = 0

for item in data:
    f_list[i % bank_num].append(hex(item).replace("0x", "").zfill(2) + "\n")
    i += 1


for i in range(bank_num):
    with open(output_file + "." + str(i), "w") as f:
        j = 0

        for item in f_list[i]:
            f.write(item)
            j += 1

        if j > (tcm_size / bank_num):
            print("data is too large")
            exit(1)

        while j < (tcm_size / bank_num):
            f.write("00\n")
            j += 1