#pragma once
#include "common.h"
#include "../csr_base.h"

namespace component
{
	namespace csr
	{
		class mstatush : public csr_base
		{
			public:
				mstatush() : csr_base("mstatush", 0x00000000)
				{
			
				}

				virtual uint32_t filter(uint32_t value)
				{
					return 0;
				}
		};
	}
}