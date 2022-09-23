#pragma once
#include "common.h"
#include "../csr_base.h"

namespace component
{
	namespace csr
	{
		class mtval : public csr_base
		{
			public:
				mtval() : csr_base("mtval", 0x00000000)
				{
			
				}
		};
	}
}