#pragma once
#include "common.h"
#include "fifo.h"

namespace component
{
    template<typename T>
    class issue_queue : public fifo<T>
    {
        private:
            enum class sync_request_type_t
            {
                pop,
                set_item,
                compress
            };
            
            typedef struct sync_request_t
            {
                sync_request_type_t req;
                uint32_t arg1;
                T arg2;
                std::vector<uint32_t> item_id_list;
            }sync_request_t;
            
            std::queue<sync_request_t> sync_request_q;
            
            bool check_id_valid(uint32_t id)
            {
                if(this->is_empty())
                {
                    return false;
                }
                else if(this->wstage == this->rstage)
                {
                    return (id >= this->rptr) && (id < this->wptr);
                }
                else
                {
                    return ((id >= this->rptr) && (id < this->size)) || (id < this->wptr);
                }
            }

            bool get_next_id_stage(uint32_t id, bool stage, uint32_t *next_id, bool *next_stage)
            {
                assert(check_id_valid(id));
                *next_id = (id + 1) % this->size;
                *next_stage = ((id + 1) >= this->size) != stage;
                return check_id_valid(*next_id);
            }
        
        public:
            issue_queue(uint32_t size) : fifo<T>(size)
            {
                            
            }

            virtual void reset()
            {
                fifo<T>::reset();
                clear_queue(sync_request_q);
            }
            
            uint32_t get_size()
            {
                return this->is_full() ? this->size : ((this->wptr + this->size - this->rptr) % this->size);
            }
            
            T get_item(uint32_t id)
            {
                assert(check_id_valid(id));
                return this->buffer[id];
            }
            
            void set_item(uint32_t id, T value)
            {
                assert(check_id_valid(id));
                this->buffer[id] = value;
            }
            
            void set_item_sync(uint32_t id, T value)
            {
                sync_request_t item;
                
                item.req = sync_request_type_t::set_item;
                item.arg1 = id;
                item.arg2 = value;
                sync_request_q.push(item);
            }
            
            bool get_front_id(uint32_t *front_id)
            {
                if(this->is_empty())
                {
                    return false;
                }
                
                *front_id = this->rptr;
                return true;
            }
            
            bool get_tail_id(uint32_t *tail_id)
            {
                if(this->is_empty())
                {
                    return false;
                }
                
                *tail_id = (wptr + this->size - 1) % this->size;
                return true;
            }
            
            bool get_next_id(uint32_t id, uint32_t *next_id)
            {
                assert(check_id_valid(id));
                *next_id = (id + 1) % this->size;
                return check_id_valid(*next_id);
            }
            
            bool get_front(T *value)
            {
                *value = this->buffer[this->rptr];
                return !this->is_empty();
            }

            void compress(std::vector<uint32_t> &item_id_list)
            {
                uint32_t first_id = 0;

                if((item_id_list.size() > 0) && get_front_id(&first_id))
                {
                    auto cur_id = first_id;
                    auto cur_stage = rstage;
                    auto new_wptr = first_id;
                    auto new_wstage = rstage;
                    auto next_id = first_id;
                    auto invalid_item_found = false;
                    auto i = 0;
                        
                    do
                    {
                        if(!invalid_item_found)
                        {
                            if((i < item_id_list.size()) && (cur_id == item_id_list[i]))
                            {
                                invalid_item_found = true;
                                i++;
                                next_id = cur_id;
                                new_wptr = cur_id;
                                new_wstage = cur_stage;
                            }
                        }
                        else
                        {
                            if((i < item_id_list.size()) && (cur_id == item_id_list[i]))
                            {
                                i++;
                            }
                            else
                            {
                                set_item(next_id, get_item(cur_id));
                                get_next_id_stage(next_id, new_wstage, &new_wptr, &new_wstage);
                                next_id = new_wptr;
                            }
                        }
                    }while(get_next_id_stage(cur_id, cur_stage, &cur_id, &cur_stage) && (cur_id != first_id));

                    wptr = new_wptr;
                    wstage = new_wstage;
                }
            }

            void compress_sync(std::vector<uint32_t> &item_id_list)
            {
                sync_request_t item;

                item.req = sync_request_type_t::compress;
                item.item_id_list = item_id_list;
                sync_request_q.push(item);
            }
            
            void pop_sync()
            {
                sync_request_t item;
                    
                item.req = sync_request_type_t::pop;
                sync_request_q.push(item);
            }
            
            void sync()
            {
                while(!sync_request_q.empty())
                {
                    auto item = sync_request_q.front();
                    sync_request_q.pop();
                    T v;
                    
                    switch(item.req)
                    {
                        case sync_request_type_t::set_item:
                            set_item(item.arg1, item.arg2);
                            break;
                            
                        case sync_request_type_t::pop:
                            this->pop(&v);
                            break;

                        case sync_request_type_t::compress:
                            this->compress(item.item_id_list);
                            break;
                    }
                }
            }
    };
}
