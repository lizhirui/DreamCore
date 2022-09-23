#pragma once
#include "common.h"
#include "../csr_base.h"

namespace component
{
	namespace csr
	{
		class finish : public csr_base
		{
			public:
				finish() : csr_base("finish", 0xFFFFFFFF)
				{
					
				}
		};
	}
}