#pragma once
#include "common.h"
#include "../csr_base.h"

namespace component
{
	namespace csr
	{
		class mcause : public csr_base
		{
			public:
				mcause() : csr_base("mcause", 0x00000000)
				{
			
				}
		};
	}
}