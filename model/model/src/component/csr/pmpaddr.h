#pragma once
#include "common.h"
#include "../csr_base.h"

namespace component
{
	namespace csr
	{
		class pmpaddr : public csr_base
		{
			public:
				pmpaddr(uint32_t id) : csr_base(std::string("pmpaddr") + std::to_string(id), 0x00000000)
				{
			
				}

				virtual uint32_t filter(uint32_t value)
				{
					return 0;
				}
		};
	}
}