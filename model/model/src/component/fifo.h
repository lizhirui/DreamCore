#pragma once
#include "common.h"

namespace component
{
    template<typename T>
    class fifo : public if_print_t, public if_reset_t
    {
        protected:
            T *buffer;
            uint32_t size;
            uint32_t wptr;
            bool wstage;
            uint32_t rptr;
            bool rstage;
            bool pop_status_save;
            uint32_t rptr_saved;
            bool rstage_saved;

        public:
            fifo(uint32_t size);
            ~fifo();
            virtual void reset();
            void flush();
            bool push(T element);
            bool pop(T *element);
            bool get_front(T *element);
            bool get_tail(T *element);
            uint32_t get_size();
            uint32_t get_remain_space();
            bool is_empty();
            bool is_full();
            void set_pop_status_save(bool value);
            void reset_pop_status();
            virtual void print(std::string indent);
            virtual json get_json();
    };

    template<typename T>
    fifo<T>::fifo(uint32_t size)
    {
        this->size = size;
        buffer = new T[size];
        wptr = 0;
        wstage = false;
        rptr = 0;
        rstage = false;
        pop_status_save = false;
    }

    template<typename T>
    fifo<T>::~fifo()
    {
        delete[] buffer;
    }

    template<typename T>
    void fifo<T>::reset()
    {
        wptr = 0;
        wstage = false;
        rptr = 0;
        rstage = false;
    }

    template<typename T>
    void fifo<T>::flush()
    {
        wptr = 0;
        wstage = false;
        rptr = 0;
        rstage = false;
    }

    template<typename T>
    bool fifo<T>::push(T element)
    {
        if(is_full())
        {
            return false;
        }

        buffer[wptr++] = element;

        if(wptr >= size)
        {
            wptr = 0;
            wstage = !wstage;
        }

        return true;
    }

    template<typename T>
    bool fifo<T>::pop(T *element)
    {
        if(is_empty())
        {
            return false;
        }

        *element = buffer[rptr++];

        if(rptr >= size)
        {
            rptr = 0;
            rstage = !rstage;
        }

        return true;
    }

    template<typename T>
    bool fifo<T>::get_front(T *element)
    {
        if(this->is_empty())
        {
            return false;
        }

        *element = this->buffer[rptr];
        return true;
    }

    template<typename T>
    bool fifo<T>::get_tail(T *element)
    {
        if(this->is_empty())
        {
            return false;
        }

        *element = this->buffer[(wptr + this->size - 1) % this->size];
        return true;
    }

    template<typename T>
    uint32_t fifo<T>::get_size()
    {
        return this->is_full() ? this->size : pop_status_save ? ((this->wptr + this->size - this->rptr_saved) % this->size) : ((this->wptr + this->size - this->rptr) % this->size);
    }

    template<typename T>
    uint32_t fifo<T>::get_remain_space()
    {
        return this->size - get_size();
    }

    template<typename T>
    bool fifo<T>::is_empty()
    {
        return (rptr == wptr) && (rstage == wstage);
    }

    template<typename T>
    bool fifo<T>::is_full()
    {
        if(pop_status_save)
        {
            return (rptr_saved == wptr) && (rstage_saved != wstage);
        }

        return (rptr == wptr) && (rstage != wstage);
    }

    template<typename T>
    void fifo<T>::set_pop_status_save(bool value)
    {
        pop_status_save = value;
        reset_pop_status();
    }

    template<typename T>
    void fifo<T>::reset_pop_status()
    {
        rptr_saved = rptr;
        rstage_saved = rstage;
    }

    template<typename T>
    void fifo<T>::print(std::string indent)
    {
        std::cout << indent << "Item Count = " << this->get_size() << "/" << this->size << std::endl;
        std::cout << indent << "Input:" << std::endl;
        T item;
        if_print_t *if_print;

        if(!this->get_tail(&item))
        {
            std::cout << indent << "\t<Empty>" << std::endl;
        }
        else
        {
            if_print = dynamic_cast<if_print_t *>(&item);
            if_print->print(indent + "\t");
        }

        std::cout << indent << "Output:" << std::endl;

        if(!this->get_front(&item))
        {
            std::cout << indent << "\t<Empty>" << std::endl;
        }
        else
        {
            if_print = dynamic_cast<if_print_t *>(&item);
            if_print->print(indent + "\t");
        }
    }

    template<typename T>
    json fifo<T>::get_json()
    {
        json ret = json::array();
        if_print_t *if_print;

        if(!is_empty())
        {
            auto cur = rptr;
            auto cur_stage = rstage;

            while(1)
            {
                if_print = dynamic_cast<if_print_t *>(&buffer[cur]);
                ret.push_back(if_print->get_json());
                
                cur++;

                if(cur >= size)
                {
                    cur = 0;
                    cur_stage = !cur_stage;
                }

                if((cur == wptr) && (cur_stage == wstage))
                {
                    break;
                }
            }
        }

        return ret;
    }
}