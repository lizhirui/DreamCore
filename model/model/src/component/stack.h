#pragma once
#include "common.h"

namespace component
{
    template<typename T>
    class stack : public if_print_t, public if_reset_t
    {
        protected:
            T *buffer;
            uint32_t size;
            uint32_t top_ptr;

        public:
            stack(uint32_t size);
            ~stack();
            virtual void reset();
            void flush();
            bool push(T element);
            bool pop(T *element);
            bool get_top(T *element);
            uint32_t get_size();
            bool is_empty();
            bool is_full();
    };

    template<typename T>
    stack<T>::stack(uint32_t size)
    {
        this->size = size;
        buffer = new T[size];
        top_ptr = 0;
    }

    template<typename T>
    stack<T>::~stack()
    {
        delete[] buffer;
    }

    template<typename T>
    void stack<T>::reset()
    {
        top_ptr = 0;
    }

    template<typename T>
    void stack<T>::flush()
    {
        top_ptr = 0;
    }

    template<typename T>
    bool stack<T>::push(T element)
    {
        if(is_full())
        {
            return false;
        }

        buffer[top_ptr++] = element;
        return true;
    }

    template<typename T>
    bool stack<T>::pop(T *element)
    {
        if(is_empty())
        {
            return false;
        }

        *element = buffer[--top_ptr];
        return true;
    }

    template<typename T>
    bool stack<T>::get_top(T *element)
    {
        if(this->is_empty())
        {
            return false;
        }

        *element = this->buffer[top_ptr - 1];
        return true;
    }

    template<typename T>
    uint32_t stack<T>::get_size()
    {
        return this->is_full() ? this->size : ((this->wptr + this->size - this->rptr) % this->size);
    }

    template<typename T>
    bool stack<T>::is_empty()
    {
        return top_ptr == 0;
    }

    template<typename T>
    bool stack<T>::is_full()
    {
        return top_ptr == size;
    }
}