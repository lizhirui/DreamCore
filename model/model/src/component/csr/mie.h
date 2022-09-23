#pragma once
#include "common.h"
#include "../csr_base.h"

namespace component
{
	namespace csr
	{
		class mie : public csr_base
		{
			public:
				mie() : csr_base("mie", 0x00000000)
				{
			
				}

				virtual uint32_t filter(uint32_t value)
				{
					return value & 0x888;
				}

				void set_msie(bool value)
				{
					this->setbit(3, value);
				}

				bool get_msie()
				{
					return this->getbit(3);
				}

				void set_mtie(bool value)
				{
					this->setbit(7, value);
				}

				bool get_mtie()
				{
					return this->getbit(7);
				}

				void set_meie(bool value)
				{
					this->setbit(11, value);
				}

				bool get_meie()
				{
					return this->getbit(11);
				}
		};
	}
}