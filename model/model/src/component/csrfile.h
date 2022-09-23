#pragma once
#include "common.h"
#include "config.h"
#include "csr_base.h"
#include "csr_all.h"

namespace component
{
	class csrfile : public if_print_t, public if_reset_t
	{
		private:
			typedef struct csr_item_t
			{
				bool readonly;
				std::shared_ptr<csr_base> csr;
			}csr_item_t;

			enum class sync_request_type_t
            {
				write,
                write_sys
            };

            typedef struct sync_request_t
            {
                sync_request_type_t req;
                uint32_t arg1;
                uint32_t arg2;
            }sync_request_t;

            std::queue<sync_request_t> sync_request_q;

			std::unordered_map<uint32_t, csr_item_t> csr_map_table;

			trace::trace_database tdb;

			static bool csr_out_list_cmp(const std::pair<std::string, std::string> &a, const std::pair<std::string, std::string> &b)
			{
				if(std::isdigit(a.first[a.first.length() - 1]) && std::isdigit(b.first[b.first.length() - 1]))
				{
					size_t a_index = 0;
					size_t b_index = 0;

					for(auto i = a.first.length() - 1;i >= 0;i--)
					{
						if(!std::isdigit(a.first[i]))
						{
							break;
						}
						else
						{
							a_index = i;
						}

						if(i == 0)
						{
							break;
						}
					}

					for(auto i = b.first.length() - 1;i >= 0;i--)
					{
						if(!std::isdigit(b.first[i]))
						{
							break;
						}
						else
						{
							b_index = i;
						}

						if(i == 0)
						{
							break;
						}
					}

					auto a_left = a.first.substr(0, a_index);
					auto a_right = a.first.substr(a_index);
					auto b_left = b.first.substr(0, b_index);
					auto b_right = b.first.substr(b_index);
					auto a_int = 0;
					auto b_int = 0;
					std::istringstream a_stream(a_right);
					std::istringstream b_stream(b_right);
					a_stream >> a_int;
					b_stream >> b_int;
					return (a_left < b_left) || ((a_left == b_left) && (a_int < b_int));
				}
				else
				{
					return a.first < b.first;
				}
			}

		public:
			csrfile() : tdb(TRACE_CSRFILE)
			{
			
			}

			virtual void reset()
			{
				for(auto iter = csr_map_table.begin();iter != csr_map_table.end();iter++)
				{
					iter->second.csr->reset();
				}

				clear_queue(sync_request_q);

				this->tdb.create(TRACE_DIR + "csrfile.tdb");

				this->tdb.mark_signal(trace::domain_t::input, "excsr_csrf_addr", sizeof(uint16_t), 1);
				this->tdb.mark_signal(trace::domain_t::output, "csrf_excsr_data", sizeof(uint32_t), 1);

				this->tdb.mark_signal(trace::domain_t::input, "commit_csrf_read_addr", sizeof(uint16_t), 4);
				this->tdb.mark_signal(trace::domain_t::output, "csrf_commit_read_data", sizeof(uint32_t), 4);
				this->tdb.mark_signal(trace::domain_t::input, "commit_csrf_write_addr", sizeof(uint16_t), 4);
				this->tdb.mark_signal(trace::domain_t::input, "commit_csrf_write_data", sizeof(uint32_t), 4);
				this->tdb.mark_signal(trace::domain_t::input, "commit_csrf_we", sizeof(uint8_t), 4);

				this->tdb.mark_signal(trace::domain_t::input, "intif_csrf_mip_data", sizeof(uint32_t), 1);

				this->tdb.mark_signal(trace::domain_t::output, "csrf_all_mie_data", sizeof(uint32_t), 1);
				this->tdb.mark_signal(trace::domain_t::output, "csrf_all_mstatus_data", sizeof(uint32_t), 1);
				this->tdb.mark_signal(trace::domain_t::output, "csrf_all_mip_data", sizeof(uint32_t), 1);
				this->tdb.mark_signal(trace::domain_t::output, "csrf_all_mepc_data", sizeof(uint32_t), 1);

				this->tdb.mark_signal(trace::domain_t::input, "fetch_csrf_checkpoint_buffer_full_add", sizeof(uint8_t), 1);
				this->tdb.mark_signal(trace::domain_t::input, "fetch_csrf_fetch_not_full_add", sizeof(uint8_t), 1);
				this->tdb.mark_signal(trace::domain_t::input, "fetch_csrf_fetch_decode_fifo_full_add", sizeof(uint8_t), 1);
				this->tdb.mark_signal(trace::domain_t::input, "decode_csrf_decode_rename_fifo_full_add", sizeof(uint8_t), 1);
				this->tdb.mark_signal(trace::domain_t::input, "rename_csrf_phy_regfile_full_add", sizeof(uint8_t), 1);
				this->tdb.mark_signal(trace::domain_t::input, "rename_csrf_rob_full_add", sizeof(uint8_t), 1);
				this->tdb.mark_signal(trace::domain_t::input, "issue_csrf_issue_execute_fifo_full_add", sizeof(uint8_t), 1);
				this->tdb.mark_signal(trace::domain_t::input, "issue_csrf_issue_queue_full_add", sizeof(uint8_t), 1);
				this->tdb.mark_signal(trace::domain_t::input, "commit_csrf_branch_num_add", sizeof(uint8_t), 1);
				this->tdb.mark_signal(trace::domain_t::input, "commit_csrf_branch_predicted_add", sizeof(uint8_t), 1);
				this->tdb.mark_signal(trace::domain_t::input, "commit_csrf_branch_hit_add", sizeof(uint8_t), 1);
				this->tdb.mark_signal(trace::domain_t::input, "commit_csrf_branch_miss_add", sizeof(uint8_t), 1);
				this->tdb.mark_signal(trace::domain_t::input, "commit_csrf_commit_num_add", sizeof(uint8_t), 1);
				this->tdb.mark_signal(trace::domain_t::input, "ras_csrf_ras_full_add", sizeof(uint8_t), 1);

				this->tdb.write_metainfo();
                this->tdb.trace_on();
                this->tdb.capture_status();
                this->tdb.write_row();
			}

			void trace_pre()
            {
                this->tdb.capture_input();
				
				this->tdb.update_signal<uint16_t>(trace::domain_t::input, "excsr_csrf_addr", 65535, 0);
				this->tdb.update_signal<uint32_t>(trace::domain_t::output, "csrf_excsr_data", 0, 0);


				for(auto i = 0;i < 4;i++)
				{
					this->tdb.update_signal<uint16_t>(trace::domain_t::input, "commit_csrf_read_addr", 65535, i);
					this->tdb.update_signal<uint32_t>(trace::domain_t::output, "csrf_commit_read_data", 0, i);
					this->tdb.update_signal<uint16_t>(trace::domain_t::input, "commit_csrf_write_addr", 0, i);
					this->tdb.update_signal<uint32_t>(trace::domain_t::input, "commit_csrf_write_data", 0, i);
					this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_csrf_we", 0, i);
				}

				this->tdb.update_signal<uint32_t>(trace::domain_t::input, "intif_csrf_mip_data", 0, 0);

				this->tdb.update_signal<uint32_t>(trace::domain_t::output, "csrf_all_mie_data", 0, 0);
				this->tdb.update_signal<uint32_t>(trace::domain_t::output, "csrf_all_mstatus_data", 0, 0);
				this->tdb.update_signal<uint32_t>(trace::domain_t::output, "csrf_all_mip_data", 0, 0);
				this->tdb.update_signal<uint32_t>(trace::domain_t::output, "csrf_all_mepc_data", 0, 0);

				this->tdb.update_signal<uint8_t>(trace::domain_t::input, "fetch_csrf_checkpoint_buffer_full_add", 0, 0);
				this->tdb.update_signal<uint8_t>(trace::domain_t::input, "fetch_csrf_fetch_not_full_add", 0, 0);
				this->tdb.update_signal<uint8_t>(trace::domain_t::input, "fetch_csrf_fetch_decode_fifo_full_add", 0, 0);
				this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_csrf_decode_rename_fifo_full_add", 0, 0);
				this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_csrf_phy_regfile_full_add", 0, 0);
				this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_csrf_rob_full_add", 0, 0);
				this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_csrf_issue_execute_fifo_full_add", 0, 0);
				this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_csrf_issue_queue_full_add", 0, 0);
				this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_csrf_branch_num_add", 0, 0);
				this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_csrf_branch_predicted_add", 0, 0);
				this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_csrf_branch_hit_add", 0, 0);
				this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_csrf_branch_miss_add", 0, 0);
				this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_csrf_commit_num_add", 0, 0);
				this->tdb.update_signal<uint8_t>(trace::domain_t::input, "ras_csrf_ras_full_add", 0, 0);

				this->tdb.update_signal<uint32_t>(trace::domain_t::output, "csrf_all_mie_data", read_sys(CSR_MIE), 0);
				this->tdb.update_signal<uint32_t>(trace::domain_t::output, "csrf_all_mstatus_data", read_sys(CSR_MSTATUS), 0);
				this->tdb.update_signal<uint32_t>(trace::domain_t::output, "csrf_all_mip_data", read_sys(CSR_MIP), 0);
				this->tdb.update_signal<uint32_t>(trace::domain_t::output, "csrf_all_mepc_data", read_sys(CSR_MEPC), 0);
            }

            void trace_post()
            {
                this->tdb.capture_output_status();
                this->tdb.write_row();
            }

			trace::trace_database *get_tdb()
            {
                return &tdb;
            }

			void map(uint32_t addr, bool readonly, std::shared_ptr<csr_base> csr)
			{
				assert(csr_map_table.find(addr) == csr_map_table.end());
				csr_item_t t_item;
				t_item.readonly = readonly;
				t_item.csr = csr;
				csr_map_table[addr] = t_item;
			}

			void write_sys(uint32_t addr, uint32_t value)
			{
				assert(!(csr_map_table.find(addr) == csr_map_table.end()));
				csr_map_table[addr].csr->write(value);
			}

			void write_sys_sync(uint32_t addr, uint32_t value)
			{
				sync_request_t t_req;

				t_req.req = sync_request_type_t::write_sys;
				t_req.arg1 = addr;
				t_req.arg2 = value;
				this->sync_request_q.push(t_req);
			}

			uint32_t read_sys(uint32_t addr)
			{
				assert(!(csr_map_table.find(addr) == csr_map_table.end()));
				return csr_map_table[addr].csr->read();
			}

			bool write_check(uint32_t addr, uint32_t value)
			{
				if(csr_map_table.find(addr) == csr_map_table.end())
				{
					return false;
				}

				if(csr_map_table[addr].readonly)
				{
					return false;
				}

				return true;
			}

			bool write(uint32_t addr, uint32_t value)
			{
				if(!write_check(addr, value))
				{
					return false;
				}

				csr_map_table[addr].csr->write(value);
				return true;
			}	

			void write_sync(uint32_t addr, uint32_t value)
			{
				sync_request_t t_req;

				t_req.req = sync_request_type_t::write;
				t_req.arg1 = addr;
				t_req.arg2 = value;
				this->sync_request_q.push(t_req);
			}

			bool read(uint32_t addr, uint32_t *value)
			{
				if(csr_map_table.find(addr) == csr_map_table.end())
				{
					return false;
				}

				*value = csr_map_table[addr].csr->read();
				return true;
			}

			void sync()
            {
                sync_request_t t_req;

                while(!sync_request_q.empty())
                {
                    t_req = sync_request_q.front();
                    sync_request_q.pop();

                    switch(t_req.req)
                    {
						case sync_request_type_t::write:
							assert(write(t_req.arg1, t_req.arg2));
							break;

                        case sync_request_type_t::write_sys:
                            write_sys(t_req.arg1, t_req.arg2);
                            break;
                    }
                }
            }

			virtual void print(std::string indent)
			{
				std::cout << indent << "CSR List:" << std::endl;
				std::vector<std::pair<std::string, std::string>> out_list;

				for(auto iter = csr_map_table.begin();iter != csr_map_table.end();iter++)
				{
					std::ostringstream stream;
					stream << indent << std::setw(15) << iter->second.csr->get_name() << "\t[0x" << fillzero(3) << outhex(iter->first) << ", " << (iter->second.readonly ? "RO" : "RW") << "] = 0x" << fillzero(8) << outhex(iter->second.csr->read()) << std::endl;
					out_list.push_back(std::pair<std::string, std::string>(iter->second.csr->get_name(), stream.str()));
				}

				std::sort(out_list.begin(), out_list.end(), csr_out_list_cmp);

				for(auto iter = out_list.begin();iter != out_list.end();iter++)
				{
					std::cout << iter->second;
				}
			}

			std::string get_info_packet()
			{
				std::stringstream result;

				std::vector<std::pair<std::string, std::string>> out_list;

				for(auto iter = csr_map_table.begin();iter != csr_map_table.end();iter++)
				{
					std::ostringstream stream;
					stream << outhex(iter->second.csr->read());
					out_list.push_back(std::pair<std::string, std::string>(iter->second.csr->get_name(), stream.str()));
				}

				std::sort(out_list.begin(), out_list.end(), csr_out_list_cmp);

				for(auto iter = out_list.begin();iter != out_list.end();iter++)
				{
					result << iter->first << ":" << iter->second;

					if(iter != out_list.end())
					{
						result << ",";
					}
				}

				return result.str();
			}
	};
}