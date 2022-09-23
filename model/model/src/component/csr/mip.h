#pragma once
#include "common.h"
#include "../csr_base.h"

namespace component
{
	namespace csr
	{
		class mip : public csr_base
		{
			public:
				mip() : csr_base("mip", 0x00000000)
				{
			
				}

				virtual uint32_t filter(uint32_t value)
				{
					return value & 0x888;
				}

				void set_msip(bool value)
				{
					this->setbit(3, value);
				}

				bool get_msip()
				{
					return this->getbit(3);
				}

				void set_mtip(bool value)
				{
					this->setbit(7, value);
				}

				bool get_mtip()
				{
					return this->getbit(7);
				}

				void set_meip(bool value)
				{
					this->setbit(11, value);
				}

				bool get_meip()
				{
					return this->getbit(11);
				}
		};
	}
}