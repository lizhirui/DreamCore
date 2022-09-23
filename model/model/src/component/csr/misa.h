#pragma once
#include "common.h"
#include "../csr_base.h"

namespace component
{
	namespace csr
	{
		class misa : public csr_base
		{
			public:
				misa() : csr_base("misa", 0x40001100)
				{
			
				}
		};
	}
}