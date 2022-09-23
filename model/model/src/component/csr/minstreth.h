#pragma once
#include "common.h"
#include "../csr_base.h"

namespace component
{
	namespace csr
	{
		class minstreth : public csr_base
		{
			public:
				minstreth() : csr_base("minstreth", 0x00000000)
				{
			
				}
		};
	}
}