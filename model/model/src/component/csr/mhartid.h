#pragma once
#include "common.h"
#include "../csr_base.h"

namespace component
{
	namespace csr
	{
		class mhartid : public csr_base
		{
			public:
				mhartid() : csr_base("mhartid", 0x00000000)
				{
			
				}
		};
	}
}