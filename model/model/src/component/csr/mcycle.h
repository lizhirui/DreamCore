#pragma once
#include "common.h"
#include "../csr_base.h"

namespace component
{
	namespace csr
	{
		class mcycle : public csr_base
		{
			public:
				mcycle() : csr_base("mcycle", 0x00000000)
				{
			
				}
		};
	}
}