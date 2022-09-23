#pragma once
#include "common.h"
#include "../csr_base.h"

namespace component
{
	namespace csr
	{
		class mvendorid : public csr_base
		{
			public:
				mvendorid() : csr_base("mvendorid", 0x00000000)
				{
			
				}
		};
	}
}