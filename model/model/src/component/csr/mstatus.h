#pragma once
#include "common.h"
#include "../csr_base.h"

namespace component
{
	namespace csr
	{
		class mstatus : public csr_base
		{
			public:
				mstatus() : csr_base("mstatus", 0x00000000)
				{
			
				}

				virtual uint32_t filter(uint32_t value)
				{
					return value & 0x88;
				}

				void set_mie(bool value)
				{
					this->setbit(3, value);
				}

				bool get_mie()
				{
					return this->getbit(3);
				}

				void set_mpie(bool value)
				{
					this->setbit(7, value);
				}

				bool get_mpie()
				{
					return this->getbit(7);
				}
		};
	}
}