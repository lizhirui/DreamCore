#pragma once
#include "common.h"
#include "../csr_base.h"

namespace component
{
	namespace csr
	{
		class mimpid : public csr_base
		{
			public:
				mimpid() : csr_base("mimpid", 0x20220201)
				{
			
				}
		};
	}
}