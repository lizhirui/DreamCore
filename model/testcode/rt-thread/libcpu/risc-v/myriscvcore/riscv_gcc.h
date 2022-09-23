#ifndef __RISCV_GCC_H__
#define __RISCV_GCC_H__

    #ifndef __GNUC__
        #define __attribute__(x)
        #define aligned(x)
        #define packed
        #define vector_size(x)
        #define always_inline
        #define used
        #define weak
        #define __restrict
        #error "this program must be compiled by GCC!"
    #endif

#ifdef __cplusplus
    extern "C"
    {
#endif

    #define __ASM                               __asm
    #define __INLINE                            inline
    #define __STATIC_INLINE                     static inline
    #define __STATIC_FORCEINLINE                __attribute__((always_inline)) static inline
    #define __USED                              __attribute__((used))
    #define __WEAK                              __attribute__((weak))
    #define __VECTOR_SIZE(x)                    __attribute__((vector_size(x)))
    #define __PACKED                            __attribute__((packed, aligned(1)))
    #define __PACKED_STRUCT                     struct __attribute__((packed, aligned(1)))
    #define __PACKED_UNION                      struct __attribute__((packed, aligned(1)))
    #define __ALIGNED(x)                        __attribute__((aligned(x)))
    #define __ALIGN4B                           __ALIGNED(4)
    #define __ALIGN4K                           __ALIGNED(4096)
    #define __RESTRICT                          __restrict
    #define __COMPILER_BARRIER()                __ASM volatile("":::"memory")
    /** \brief provide the compiler with branch prediction information, the branch is usually true */
    #define __USUALLY(exp)                      __builtin_expect((exp), 1)
    /** \brief provide the compiler with branch prediction information, the branch is rarely true */
    #define __RARELY(exp)                       __builtin_expect((exp), 0)
    /** \brief Use this attribute to indicate that the specified function is an interrupt handler. */
    #define __INTERRUPT                         __attribute__((interrupt))

    /** \brief Defines 'read only' permissions */
    #ifdef __cplusplus
        #define __I     volatile
    #else
        #define __I     volatile const
    #endif
    /** \brief Defines 'write only' permissions */
    #define     __O     volatile
    /** \brief Defines 'read / write' permissions */
    #define     __IO    volatile

    /* following defines should be used for structure members */
    /** \brief Defines 'read only' structure member permissions */
    #define     __IM    volatile const
    /** \brief Defines 'write only' structure member permissions */
    #define     __OM    volatile
    /** \brief Defines 'read/write' structure member permissions */
    #define     __IOM   volatile

#ifdef __cplusplus
    }
#endif

#endif