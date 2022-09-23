#pragma once
#include "common.h"
#include "../csr_base.h"

namespace component
{
	namespace csr
	{
		class mhpmcounter : public csr_base
		{
			public:
				mhpmcounter(std::string name) : csr_base(name, 0x00000000)
				{
			
				}
		};
	}
}