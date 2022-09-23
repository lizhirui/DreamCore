#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdarg.h>
#include <stdio.h>
#include "crc.h"

#define PRG_LOAD_ADDR 0x80020000

#define PACK_BUF_SIZE 10240
#define PACK_HEAD 0x55
#define PACK_TAIL 0xAA
#define PACK_TRAN 0xCC
#define PACK_TRAN_55 0x05
#define PACK_TRAN_AA 0x0A
#define PACK_TRAN_CC 0x0C

void send_char(char ch);
uint32_t read_char();

void send_str(char *str)
{
    while(*str)
    {
        send_char(*(str++));
    }
}

void my_printf(char *fmt, ...)
{
    va_list args;
    static uint8_t buf[4096];

    va_start(args, fmt);
    vsprintf(buf, fmt, args);
    va_end(args);
    send_str(buf);
}

static void send_tran(uint8_t dat)
{
	switch(dat)
	{
		case 0x55:
			send_char(PACK_TRAN);
			send_char(PACK_TRAN_55);
			break;

		case 0xAA:
			send_char(PACK_TRAN);
			send_char(PACK_TRAN_AA);
			break;

		case 0xCC:
			send_char(PACK_TRAN);
			send_char(PACK_TRAN_CC);
			break;

		default:
			send_char(dat);
			break;
	}
}

static void send_pack(uint8_t *buf,uint32_t length)
{
	uint8_t crc_value = crc8_l(buf,length);

	send_char(PACK_HEAD);
	send_tran(crc_value);

	while(length--)
	{
		send_tran(*(buf++));
	}

	send_char(PACK_TAIL);
}

uint8_t get_byte()
{
    uint32_t dat;

    do
    {
        dat = read_char();    
    }while(!(dat & 0x40000000));

    return dat & 0xff;
}

uint8_t pack_buf[PACK_BUF_SIZE];

static uint32_t rev_pack(uint8_t *buf,uint32_t max_length)
{
	uint8_t dat = 0;
	bool tran_mode = false;
	bool rev_mode = false;
	bool wait_crc = false;
	uint32_t cur_length = 0;
	uint8_t crc_value = 0;

	while(1)
	{
		dat = get_byte();

		if(rev_mode || (dat == PACK_HEAD))
		{
			if(!tran_mode)
			{
				switch(dat)
				{
					case PACK_HEAD:
						//throw all pack
						wait_crc = true;
						tran_mode = false;
						cur_length = 0;
						rev_mode = true;
						break;

					case PACK_TAIL:
						rev_mode = false;

						if(crc8_l(buf,cur_length) == crc_value)
						{
							return cur_length;
						}

						//crc error
						break;

					case PACK_TRAN:
						//prepare to transform special char
						tran_mode = true;
						break;

					default:
						pack_data_deal:
							if(wait_crc)
							{
								crc_value = dat;
								wait_crc = false;
							}
							else if(cur_length < max_length)
							{
								buf[cur_length++] = dat;
							}
							else
							{
								//rev buffer full,throw this pack
								rev_mode = false;
							}

							break;
				}
			}
			else
			{
				tran_mode = false;

				switch(dat)
				{
					case PACK_TRAN_55:
						dat = 0x55;
						goto pack_data_deal;
						break;

					case PACK_TRAN_AA:
						dat = 0xAA;
						goto pack_data_deal;
						break;

					case PACK_TRAN_CC:
						dat = 0xCC;
						goto pack_data_deal;
						break;

					default:
						//unknown transform char
						rev_mode = false;
						break;
				}
			}
		}
	}
}

#define PACK_CMD_SETCUROFFSET 0x01
#define PACK_CMD_WRITEBUFFER 0x02
#define PACK_CMD_WRITEOK 0x03
#define PACK_ERR_OK 0x5A
#define PACK_ERR_UNKNOWNARG 0x7C
#define PACK_ERR_UNKNOWNPACK 0xFF

static uint32_t get_uint32(uint8_t *buf)
{
	return ((uint32_t)buf[0]) | (((uint32_t)buf[1]) << 8) | (((uint32_t)buf[2]) << 16) | (((uint32_t)buf[3]) << 24);
}

static uint32_t rev_bin_data()
{
	uint8_t dat = 0;
	uint32_t cur_offset = 0;
	uint8_t *buf = (uint8_t *)PRG_LOAD_ADDR;
	my_printf("\nStart to receive binary data\n");
	
	while(1)
	{
		uint32_t length = rev_pack(pack_buf,PACK_BUF_SIZE);

		if(length > 0)
		{
			switch(pack_buf[0])
			{
				case PACK_CMD_SETCUROFFSET:
					cur_offset = get_uint32(pack_buf + 1);
					dat = PACK_ERR_OK;
					send_pack(&dat,1);
					break;

				case PACK_CMD_WRITEBUFFER:
					if(((uint32_t)buf + cur_offset + length - 2) < (uint32_t)buf)
					{
						dat = PACK_ERR_UNKNOWNARG;
						send_pack(&dat,1);
					}

					memcpy(buf + cur_offset,pack_buf + 1,length - 1);
					cur_offset += length - 1;
					dat = PACK_ERR_OK;
					send_pack(&dat,1);
					break;

				case PACK_CMD_WRITEOK:
					dat = PACK_ERR_OK;
					send_pack(&dat,1);
					goto next;
					break;

				default:
					dat = PACK_ERR_UNKNOWNPACK;
					send_pack(&dat,1);
					break;
			}
		}
		else
		{
			dat = PACK_ERR_UNKNOWNPACK;
			send_pack(&dat,1);
		}
	}

	next:
		my_printf("\nReceive data ok\n");
		return cur_offset;
}

void main()
{
    my_printf("Bootloader, RISC-V Out-Of-Order Core by LiZhirui!\n");
    rev_bin_data();
    my_printf("Press enter to start to execute!\n");
    while(get_byte() != '\n');
    my_printf("Program is booting...(Entry Address is %08x)\n", PRG_LOAD_ADDR);
    ((void (*)(void))PRG_LOAD_ADDR)();
}