#pragma once
#include "common.h"
#include "../csr_base.h"

namespace component
{
	namespace csr
	{
		class marchid : public csr_base
		{
			public:
				marchid() : csr_base("marchid", 0x19981001)
				{
			
				}
		};
	}
}