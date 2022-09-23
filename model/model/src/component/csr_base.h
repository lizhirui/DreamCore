#pragma once
#include "common.h"

namespace component
{
	class csr_base : public if_reset_t
	{
		protected:
			const std::string name;
			const uint32_t init_value;
			uint32_t value;

			void setbit(uint32_t bit, bool value)
			{
				this->write((this->read() & (~(1 << bit))) | ((value ? 1 : 0) << bit));
			}

			bool getbit(uint32_t bit)
			{
				return this->read() & (1 << bit);
			}
			
		public:
			csr_base(std::string name, uint32_t init_value) : name(name), init_value(init_value)
			{
				this->value = init_value;
			}

			virtual void reset()
			{
				this->value = init_value;
			}

			void load(uint32_t value)
			{
				this->value = value;
			}

			uint32_t get_value()
			{
				return this->value;
			}

			std::string get_name()
			{
				return this->name;
			}

			virtual uint32_t filter(uint32_t value)
			{
				return value;
			}

			void write(uint32_t value)
			{
				this->value = filter(value);
			}

			virtual uint32_t read()
			{
				return this->value;
			}
	};
}