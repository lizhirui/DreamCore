#pragma once
#include "common.h"
#include "../csr_base.h"

namespace component
{
	namespace csr
	{
		class mconfigptr : public csr_base
		{
			public:
				mconfigptr() : csr_base("mconfigptr", 0x00000000)
				{
			
				}
		};
	}
}