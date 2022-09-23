#pragma once
#include "common.h"
#include "../csr_base.h"

namespace component
{
	namespace csr
	{
		class minstret : public csr_base
		{
			public:
				minstret() : csr_base("minstret", 0x00000000)
				{
			
				}
		};
	}
}