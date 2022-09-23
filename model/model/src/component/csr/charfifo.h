#pragma once
#include "common.h"
#include "../csr_base.h"

namespace component
{
	namespace csr
	{
		class charfifo : public csr_base
		{
			private:
				boost::lockfree::spsc_queue<char, boost::lockfree::capacity<1024>> *send_fifo;
				boost::lockfree::spsc_queue<char, boost::lockfree::capacity<1024>> *rev_fifo;

			public:
				charfifo(boost::lockfree::spsc_queue<char, boost::lockfree::capacity<1024>> *send_fifo, boost::lockfree::spsc_queue<char, boost::lockfree::capacity<1024>> *rev_fifo) : csr_base("charfifo", 0x00000000)
				{
					this->send_fifo = send_fifo;
					this->rev_fifo = rev_fifo;
				}

				virtual uint32_t filter(uint32_t value)
				{
					if(value & 0x80000000)
					{
						while(!rev_fifo->pop());
					}
					else
					{
						while(!send_fifo->push((char)(value & 0xff)));
					}

					return 0;
				}

				virtual uint32_t read()
				{
					if(rev_fifo->empty())
					{
						return 0;
					}
					else
					{
						auto ch = rev_fifo->front();
						return 0x80000000 | ch;
					}
				}
		};
	}
}