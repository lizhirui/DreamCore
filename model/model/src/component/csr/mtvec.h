#pragma once
#include "common.h"
#include "../csr_base.h"

namespace component
{
	namespace csr
	{
		class mtvec : public csr_base
		{
			public:
				mtvec() : csr_base("mtvec", 0x00000000)
				{
			
				}

				virtual uint32_t filter(uint32_t value)
				{
					return value & (~0x03);
				}
		};
	}
}