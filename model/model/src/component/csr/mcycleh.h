#pragma once
#include "common.h"
#include "../csr_base.h"

namespace component
{
	namespace csr
	{
		class mcycleh : public csr_base
		{
			public:
				mcycleh() : csr_base("mcycleh", 0x00000000)
				{
			
				}
		};
	}
}