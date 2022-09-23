#pragma once
#include "common.h"
#include "../csr_base.h"

namespace component
{
	namespace csr
	{
		class mscratch : public csr_base
		{
			public:
				mscratch() : csr_base("mscratch", 0x00000000)
				{
			
				}
		};
	}
}