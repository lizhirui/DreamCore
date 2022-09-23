import socket
import os
import time
import getopt
import sys
import traceback
from tqdm import tqdm

soc = None

crc_array = [
            0x00, 0x07, 0x0E, 0x09, 0x1C, 0x1B, 0x12, 0x15, 0x38, 0x3F, 
            0x36, 0x31, 0x24, 0x23, 0x2A, 0x2D, 0x70, 0x77, 0x7E, 0x79, 
            0x6C, 0x6B, 0x62, 0x65, 0x48, 0x4F, 0x46, 0x41, 0x54, 0x53, 
            0x5A, 0x5D, 0xE0, 0xE7, 0xEE, 0xE9, 0xFC, 0xFB, 0xF2, 0xF5, 
            0xD8, 0xDF, 0xD6, 0xD1, 0xC4, 0xC3, 0xCA, 0xCD, 0x90, 0x97, 
            0x9E, 0x99, 0x8C, 0x8B, 0x82, 0x85, 0xA8, 0xAF, 0xA6, 0xA1, 
            0xB4, 0xB3, 0xBA, 0xBD, 0xC7, 0xC0, 0xC9, 0xCE, 0xDB, 0xDC, 
            0xD5, 0xD2, 0xFF, 0xF8, 0xF1, 0xF6, 0xE3, 0xE4, 0xED, 0xEA, 
            0xB7, 0xB0, 0xB9, 0xBE, 0xAB, 0xAC, 0xA5, 0xA2, 0x8F, 0x88, 
            0x81, 0x86, 0x93, 0x94, 0x9D, 0x9A, 0x27, 0x20, 0x29, 0x2E, 
            0x3B, 0x3C, 0x35, 0x32, 0x1F, 0x18, 0x11, 0x16, 0x03, 0x04, 
            0x0D, 0x0A, 0x57, 0x50, 0x59, 0x5E, 0x4B, 0x4C, 0x45, 0x42, 
            0x6F, 0x68, 0x61, 0x66, 0x73, 0x74, 0x7D, 0x7A, 0x89, 0x8E, 
            0x87, 0x80, 0x95, 0x92, 0x9B, 0x9C, 0xB1, 0xB6, 0xBF, 0xB8, 
            0xAD, 0xAA, 0xA3, 0xA4, 0xF9, 0xFE, 0xF7, 0xF0, 0xE5, 0xE2, 
            0xEB, 0xEC, 0xC1, 0xC6, 0xCF, 0xC8, 0xDD, 0xDA, 0xD3, 0xD4, 
            0x69, 0x6E, 0x67, 0x60, 0x75, 0x72, 0x7B, 0x7C, 0x51, 0x56, 
            0x5F, 0x58, 0x4D, 0x4A, 0x43, 0x44, 0x19, 0x1E, 0x17, 0x10, 
            0x05, 0x02, 0x0B, 0x0C, 0x21, 0x26, 0x2F, 0x28, 0x3D, 0x3A, 
            0x33, 0x34, 0x4E, 0x49, 0x40, 0x47, 0x52, 0x55, 0x5C, 0x5B, 
            0x76, 0x71, 0x78, 0x7F, 0x6A, 0x6D, 0x64, 0x63, 0x3E, 0x39, 
            0x30, 0x37, 0x22, 0x25, 0x2C, 0x2B, 0x06, 0x01, 0x08, 0x0F, 
            0x1A, 0x1D, 0x14, 0x13, 0xAE, 0xA9, 0xA0, 0xA7, 0xB2, 0xB5, 
            0xBC, 0xBB, 0x96, 0x91, 0x98, 0x9F, 0x8A, 0x8D, 0x84, 0x83, 
            0xDE, 0xD9, 0xD0, 0xD7, 0xC2, 0xC5, 0xCC, 0xCB, 0xE6, 0xE1, 
            0xE8, 0xEF, 0xFA, 0xFD, 0xF4, 0xF3]

def crc8_l(buf, length):
    crc8 = length & 0xFF
    i = 0

    while length > 0:
        length = length - 1
        crc8 = crc_array[crc8 ^ buf[i]]
        i = i + 1

    return crc8 & 0xFF

PACK_HEAD = 0x55
PACK_TAIL = 0xAA
PACK_TRAN = 0xCC
PACK_TRAN_55 = 0x05
PACK_TRAN_AA = 0x0A
PACK_TRAN_CC = 0x0C

def send_char(dat):
    soc.send(bytes([dat]))

def send_tran(dat, send_func = send_char):
    if dat == 0x55:
        send_func(PACK_TRAN)
        send_func(PACK_TRAN_55)
    elif dat == 0xAA:
        send_func(PACK_TRAN)
        send_func(PACK_TRAN_AA)
    elif dat == 0xCC:
        send_func(PACK_TRAN)
        send_func(PACK_TRAN_CC)
    else:
        send_func(dat)

def send_pack(buf, length, send_func = send_char):
    crc_value = crc8_l(buf, length)
    send_func(PACK_HEAD)
    send_tran(crc_value, send_func)
    i = 0

    while length > 0:
        length = length - 1
        send_tran(buf[i], send_func)
        i = i + 1

    send_func(PACK_TAIL)

def rev_pack(max_length):
    dat = 0
    tran_mode = False
    rev_mode = False
    wait_crc = False
    cur_length = 0
    crc_value = 0
    buf = []

    while True:
        dat = ord(soc.recv(1))
        need_deal_char = False

        if(rev_mode or (dat == PACK_HEAD)):
            if not tran_mode:
                if dat == PACK_HEAD:
                    #throw all pack
                    wait_crc = True
                    tran_mode = False
                    cur_length = 0
                    del buf[:]
                    rev_mode = True
                elif dat == PACK_TAIL:
                    rev_mode = False

                    if crc8_l(buf, cur_length) == crc_value:
                        return buf, cur_length

                    #crc error
                elif dat == PACK_TRAN:
                    #prepare to transform special char
                    tran_mode = True
                else:
                    need_deal_char = True

            else:
                tran_mode = False

                if dat == PACK_TRAN_55:
                    dat = 0x55
                    need_deal_char = True
                elif dat == PACK_TRAN_AA:
                    dat = 0xAA
                    need_deal_char = True
                elif dat == PACK_TRAN_CC:
                    dat = 0xCC
                    need_deal_char = True
                else:
                    #unknown transform char
                    rev_mode = False

            if need_deal_char:
                if wait_crc:
                    crc_value = dat
                    wait_crc = False
                elif cur_length < max_length:
                    buf.append(dat)
                    cur_length = cur_length + 1
                else:
                    #rev buffer full, throw this pack
                    rev_mode = False

PACK_CMD_SETCUROFFSET = 0x01
PACK_CMD_WRITEBUFFER = 0x02
PACK_CMD_WRITEOK = 0x03
PACK_ERR_OK = 0x5A
PACK_ERR_UNKNOWNARG = 0x7C
PACK_ERR_UNKNOWNPACK = 0xFF

def send_cmd(cmd, arg):
    buf = []
    buf.append(cmd)
    buf.append(arg & 0xff)
    buf.append((arg >> 8) & 0xff)
    buf.append((arg >> 16) & 0xff)
    buf.append((arg >> 24) & 0xff)
    send_pack(buf, len(buf))
    
    while True:
        pack, length = rev_pack(1024)
        break

    return pack[0]

temp_buf = []

def send_to_buf(dat):
    global temp_buf
    temp_buf.append(dat)

def send_data(databuf):
    global temp_buf
    buf = []
    buf.append(PACK_CMD_WRITEBUFFER)
    buf.extend(databuf)
    temp_buf = []
    send_pack(buf, len(buf), send_to_buf)
    soc.send(bytes(temp_buf))

    while True:
        pack, length = rev_pack(1024)
        break

    return pack[0]

def wait_line(content, err_list = []):
    while True:
        line = ""

        while True:
            ch = str(soc.recv(1), encoding="ascii")

            if ch != "\r" and ch != "\n":
                line += ch
            
            if ch == "\n":
                break

        print(line)
        
        if content in line:
            return line, True

        for err in err_list:
            if err in line:
                return line, False

def usage():
    print(sys.argv[0] + " [--help|-h] --ip|-i --port|-p port --file|-f file [--offset|-o] [--block|-b block]")
    print("default of offset is 0x00000000")
    print("default of block is 128")

if __name__ == "__main__":
    try:
        error = False

        try:
            opts, args = getopt.getopt(sys.argv[1:], "i:p:f:o:b:sh", ["ip=", "port=", "file=", "offset=", "block=", "help"])
        except:
            error = True

        if error:
            usage()
            sys.exit()

        offset = 0x00000000
        block_size = 128

        for o, a in opts:
            if o in ('-h', '--help'):
                usage()
                sys.exit()

            if o in ('-i', '--ip'):
                ip = a

            if o in ('-p', '--port'):
                port = int(a)

            if o in ('-f', '--file'):
                download_file = a

            if o in ('-o', '--offset'):
                offset = int(a)

            if o in ('-b', '--block'):
                block_size = int(a)
        
        if (not 'port' in dir()) or (not 'download_file' in dir()):
            usage()
            sys.exit()

        binfile = open(download_file, "rb")
        size = os.path.getsize(download_file)
        soc = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        soc.connect((ip, port))
        print("Waiting isp......")
        wait_line("Start to receive binary data")
        print("Start to download file " + download_file)

        print("Set Cur Offset = " + str(offset))
        err = send_cmd(PACK_CMD_SETCUROFFSET, offset)

        if err != PACK_ERR_OK:
            print("---Cmd Error---:", err)
            quit()

        print("Start to transfer data")
        
        with tqdm(total=size, unit="Byte") as pdar:
            for i in range(0, size, block_size):
                data = binfile.read(block_size)
                err = send_data(data)

                if err != PACK_ERR_OK:
                    print("\n---Cmd Error---:", err)
                    quit()

                pdar.update(block_size)

        print("\nSend OK")
        err = send_cmd(PACK_CMD_WRITEOK, 0)

        if err != PACK_ERR_OK:
            print("---Cmd Error---:", err)
            quit()

        wait_line("Receive data ok")
        print("Download OK")
        print("Please press enter to start to execute")
        soc.close()
    except Exception as e:
        print("---Exception---:", e)
        traceback.print_exc()

