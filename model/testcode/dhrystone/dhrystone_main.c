// See LICENSE for license details.

//**************************************************************************
// Dhrystone bencmark
//--------------------------------------------------------------------------
//
// This is the classic Dhrystone synthetic integer benchmark.
//

#pragma GCC optimize ("no-inline")

#include "dhrystone.h"

void debug_printf(const char* str, ...);

#include "encoding.h"

#include "printf.h"
#define debug_printf printf

#include <alloca.h>
#include <string.h>

/* Global Variables: */

Rec_Pointer     Ptr_Glob,
                Next_Ptr_Glob;
int             Int_Glob;
Boolean         Bool_Glob;
char            Ch_1_Glob,
                Ch_2_Glob;
int             Arr_1_Glob [50];
int             Arr_2_Glob [50] [50];

Enumeration     Func_1 ();
  /* forward declaration necessary since Enumeration may not simply be int */

#ifndef REG
        Boolean Reg = false;
#define REG
        /* REG becomes defined as empty */
        /* i.e. no register variables   */
#else
        Boolean Reg = true;
#undef REG
#define REG register
#endif

#define ee_u32 unsigned int
#define ee_u64 unsigned long long

#define CORETIMETYPE ee_u64
#define CORE_TICKS ee_u64

Boolean		Done;

ee_u64            Begin_Time,
                End_Time,
                User_Time;
ee_u64            Microseconds,
                Dhrystones_Per_Second;

/* end of variables for time measurement */

static CORETIMETYPE start_instret_val, stop_instret_val;
static CORETIMETYPE start_branch_total_val, stop_branch_total_val;
static CORETIMETYPE start_branch_hit_val, stop_branch_hit_val;

void start_instret() {
        ee_u32 minstretl;
        ee_u32 minstreth0 = 0, minstreth1 = 1;
        ee_u64 instret;

        while(minstreth0 != minstreth1) {
                asm volatile ("csrr %0,minstreth"  : "=r" (minstreth0) );
                asm volatile ("csrr %0,minstret"   : "=r" (minstretl)  );
                asm volatile ("csrr %0,minstreth"  : "=r" (minstreth1) );
        }

        instret = minstreth1;
        start_instret_val = (instret << 32) | minstretl;
}

void stop_instret() {
        ee_u32 minstretl;
        ee_u32 minstreth0 = 0, minstreth1=1;
        ee_u64 instret;

        while(minstreth0 != minstreth1) {
                asm volatile ("csrr %0,minstreth"  : "=r" (minstreth0) );
                asm volatile ("csrr %0,minstret"   : "=r" (minstretl)  );
                asm volatile ("csrr %0,minstreth"  : "=r" (minstreth1) );
        }
        instret = minstreth1;
        stop_instret_val = (instret << 32) | minstretl;
}

CORE_TICKS get_instret(void) {
        ee_u64 elapsed=stop_instret_val - start_instret_val;
        return elapsed;
}

void start_branch() {
        ee_u32 hitl, totall;
        ee_u32 hith0 = 0, hith1 = 1, totalh0 = 0, totalh1 = 1;
        ee_u64 hit, total;

        while((hith0 != hith1) || (totalh0 != totalh1)) {
                asm volatile ("csrr %0,0xB85"  : "=r" (hith0) );
                asm volatile ("csrr %0,0xB05"   : "=r" (hitl)  );
                asm volatile ("csrr %0,0xB85"  : "=r" (hith1) );
                asm volatile ("csrr %0,0xB84"  : "=r" (totalh0) );
                asm volatile ("csrr %0,0xB04"   : "=r" (totall)  );
                asm volatile ("csrr %0,0xB84"  : "=r" (totalh1) );
        }

        hit = hith1;
        start_branch_hit_val = (hit << 32) | hitl;
        total = totalh1;
        start_branch_total_val = (total << 32) | totall;
}

void stop_branch() {
        ee_u32 hitl, totall;
        ee_u32 hith0 = 0, hith1 = 1, totalh0 = 0, totalh1 = 1;
        ee_u64 hit, total;

        while((hith0 != hith1) || (totalh0 != totalh1)) {
                asm volatile ("csrr %0,0xB85"  : "=r" (hith0) );
                asm volatile ("csrr %0,0xB05"   : "=r" (hitl)  );
                asm volatile ("csrr %0,0xB85"  : "=r" (hith1) );
                asm volatile ("csrr %0,0xB84"  : "=r" (totalh0) );
                asm volatile ("csrr %0,0xB04"   : "=r" (totall)  );
                asm volatile ("csrr %0,0xB84"  : "=r" (totalh1) );
        }

        hit = hith1;
        stop_branch_hit_val = (hit << 32) | hitl;
        total = totalh1;
        stop_branch_total_val = (total << 32) | totall;
}


CORE_TICKS get_branch_hit(void) {
        ee_u64 elapsed=stop_branch_hit_val - start_branch_hit_val;
        return elapsed;
}

CORE_TICKS get_branch_total(void) {
        ee_u64 elapsed=stop_branch_total_val - start_branch_total_val;
        return elapsed;
}

/** Define Host specific (POSIX), or target specific global time variables. */
static CORETIMETYPE start_time_val, stop_time_val;

/* Function : start_time
        This function will be called right before starting the timed portion of the benchmark.

        Implementation may be capturing a system timer (as implemented in the example code)
        or zeroing some system parameters - e.g. setting the cpu clocks cycles to 0.
*/
void start_time() {
        ee_u32 mcyclel;
        ee_u32 mcycleh0 = 0, mcycleh1=1;
        ee_u64 cycles;

        while(mcycleh0 != mcycleh1) {
                asm volatile ("csrr %0,mcycleh"  : "=r" (mcycleh0) );
                asm volatile ("csrr %0,mcycle"   : "=r" (mcyclel)  );
                asm volatile ("csrr %0,mcycleh"  : "=r" (mcycleh1) );
        }
        cycles = mcycleh1;
        start_time_val = (cycles << 32) | mcyclel;
}
/* Function : stop_time
        This function will be called right after ending the timed portion of the benchmark.

        Implementation may be capturing a system timer (as implemented in the example code)
        or other system parameters - e.g. reading the current value of cpu cycles counter.
*/
void stop_time() {
        ee_u32 mcyclel;
        ee_u32 mcycleh0 = 0, mcycleh1=1;
        ee_u64 cycles;

        while(mcycleh0 != mcycleh1) {
                asm volatile ("csrr %0,mcycleh"  : "=r" (mcycleh0) );
                asm volatile ("csrr %0,mcycle"   : "=r" (mcyclel)  );
                asm volatile ("csrr %0,mcycleh"  : "=r" (mcycleh1) );
        }
        cycles = mcycleh1;
        stop_time_val = (cycles << 32) | mcyclel;
}
/* Function : get_time
        Return an abstract "ticks" number that signifies time on the system.

        Actual value returned may be cpu cycles, milliseconds or any other value,
        as long as it can be converted to seconds by <time_in_secs>.
        This methodology is taken to accomodate any hardware or simulated platform.
        The sample implementation returns millisecs by default,
        and the resolution is controlled by <TIMER_RES_DIVIDER>
*/
CORE_TICKS get_time(void) {
        CORE_TICKS elapsed=(CORE_TICKS)(stop_time_val - start_time_val);
        return elapsed;
}


int main (int argc, char** argv)
/*****/
  /* main program, corresponds to procedures        */
  /* Main and Proc_0 in the Ada version             */
{
        One_Fifty       Int_1_Loc;
  REG   One_Fifty       Int_2_Loc;
        One_Fifty       Int_3_Loc;
  REG   char            Ch_Index;
        Enumeration     Enum_Loc;
        Str_30          Str_1_Loc;
        Str_30          Str_2_Loc;
  REG   int             Run_Index;
  REG   int             Number_Of_Runs;

  /* Arguments */
  Number_Of_Runs = NUMBER_OF_RUNS;

  /* Initializations */

  Next_Ptr_Glob = (Rec_Pointer) alloca (sizeof (Rec_Type));
  Ptr_Glob = (Rec_Pointer) alloca (sizeof (Rec_Type));

  Ptr_Glob->Ptr_Comp                    = Next_Ptr_Glob;
  Ptr_Glob->Discr                       = Ident_1;
  Ptr_Glob->variant.var_1.Enum_Comp     = Ident_3;
  Ptr_Glob->variant.var_1.Int_Comp      = 40;
  strcpy (Ptr_Glob->variant.var_1.Str_Comp, 
          "DHRYSTONE PROGRAM, SOME STRING");
  strcpy (Str_1_Loc, "DHRYSTONE PROGRAM, 1'ST STRING");

  Arr_2_Glob [8][7] = 10;
        /* Was missing in published program. Without this statement,    */
        /* Arr_2_Glob [8][7] would have an undefined value.             */
        /* Warning: With 16-Bit processors and Number_Of_Runs > 32000,  */
        /* overflow may occur for this array element.                   */

  debug_printf("\n");
  debug_printf("Dhrystone Benchmark, Version %s\n", Version);
  if (Reg)
  {
    debug_printf("Program compiled with 'register' attribute\n");
  }
  else
  {
    debug_printf("Program compiled without 'register' attribute\n");
  }
  debug_printf("Using %s, HZ=%d\n", CLOCK_TYPE, HZ);
  debug_printf("\n");

  Done = false;
  while (!Done) {
    debug_printf("Trying %d runs through Dhrystone:\n", Number_Of_Runs);

    /***************/
    /* Start timer */
    /***************/

    //setStats(1);
    //Start_Timer();
    start_time();
    start_instret();
    start_branch();

    for (Run_Index = 1; Run_Index <= Number_Of_Runs; ++Run_Index)
    {

      Proc_5();
      Proc_4();
	/* Ch_1_Glob == 'A', Ch_2_Glob == 'B', Bool_Glob == true */
      Int_1_Loc = 2;
      Int_2_Loc = 3;
      strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 2'ND STRING");
      Enum_Loc = Ident_2;
      Bool_Glob = ! Func_2 (Str_1_Loc, Str_2_Loc);
	/* Bool_Glob == 1 */
      while (Int_1_Loc < Int_2_Loc)  /* loop body executed once */
      {
	Int_3_Loc = 5 * Int_1_Loc - Int_2_Loc;
	  /* Int_3_Loc == 7 */
	Proc_7 (Int_1_Loc, Int_2_Loc, &Int_3_Loc);
	  /* Int_3_Loc == 7 */
	Int_1_Loc += 1;
      } /* while */
	/* Int_1_Loc == 3, Int_2_Loc == 3, Int_3_Loc == 7 */
      Proc_8 (Arr_1_Glob, Arr_2_Glob, Int_1_Loc, Int_3_Loc);
	/* Int_Glob == 5 */
      Proc_1 (Ptr_Glob);
      for (Ch_Index = 'A'; Ch_Index <= Ch_2_Glob; ++Ch_Index)
			       /* loop body executed twice */
      {
	if (Enum_Loc == Func_1 (Ch_Index, 'C'))
	    /* then, not executed */
	  {
	  Proc_6 (Ident_1, &Enum_Loc);
	  strcpy (Str_2_Loc, "DHRYSTONE PROGRAM, 3'RD STRING");
	  Int_2_Loc = Run_Index;
	  Int_Glob = Run_Index;
	  }
      }
	/* Int_1_Loc == 3, Int_2_Loc == 3, Int_3_Loc == 7 */
      Int_2_Loc = Int_2_Loc * Int_1_Loc;
      Int_1_Loc = Int_2_Loc / Int_3_Loc;
      Int_2_Loc = 7 * (Int_2_Loc - Int_3_Loc) - Int_1_Loc;
	/* Int_1_Loc == 1, Int_2_Loc == 13, Int_3_Loc == 7 */
      Proc_2 (&Int_1_Loc);
	/* Int_1_Loc == 5 */

    } /* loop "for Run_Index" */

    /**************/
    /* Stop timer */
    /**************/
    stop_branch();
    stop_instret();
    stop_time();
    //Stop_Timer();
    //setStats(0);

    //User_Time = End_Time - Begin_Time;
    User_Time = get_time();

    if (User_Time < Too_Small_Time)
    {
      printf("Measured time too small to obtain meaningful results\n");
      Number_Of_Runs = Number_Of_Runs * 10;
      printf("\n");
    } else Done = true;
  }

  debug_printf("Final values of the variables used in the benchmark:\n");
  debug_printf("\n");
  debug_printf("Int_Glob:            %d\n", Int_Glob);
  debug_printf("        should be:   %d\n", 5);
  debug_printf("Bool_Glob:           %d\n", Bool_Glob);
  debug_printf("        should be:   %d\n", 1);
  debug_printf("Ch_1_Glob:           %c\n", Ch_1_Glob);
  debug_printf("        should be:   %c\n", 'A');
  debug_printf("Ch_2_Glob:           %c\n", Ch_2_Glob);
  debug_printf("        should be:   %c\n", 'B');
  debug_printf("Arr_1_Glob[8]:       %d\n", Arr_1_Glob[8]);
  debug_printf("        should be:   %d\n", 7);
  debug_printf("Arr_2_Glob[8][7]:    %d\n", Arr_2_Glob[8][7]);
  debug_printf("        should be:   Number_Of_Runs + 10\n");
  debug_printf("Ptr_Glob->\n");
  debug_printf("  Ptr_Comp:          %d\n", (long) Ptr_Glob->Ptr_Comp);
  debug_printf("        should be:   (implementation-dependent)\n");
  debug_printf("  Discr:             %d\n", Ptr_Glob->Discr);
  debug_printf("        should be:   %d\n", 0);
  debug_printf("  Enum_Comp:         %d\n", Ptr_Glob->variant.var_1.Enum_Comp);
  debug_printf("        should be:   %d\n", 2);
  debug_printf("  Int_Comp:          %d\n", Ptr_Glob->variant.var_1.Int_Comp);
  debug_printf("        should be:   %d\n", 17);
  debug_printf("  Str_Comp:          %s\n", Ptr_Glob->variant.var_1.Str_Comp);
  debug_printf("        should be:   DHRYSTONE PROGRAM, SOME STRING\n");
  debug_printf("Next_Ptr_Glob->\n");
  debug_printf("  Ptr_Comp:          %d\n", (long) Next_Ptr_Glob->Ptr_Comp);
  debug_printf("        should be:   (implementation-dependent), same as above\n");
  debug_printf("  Discr:             %d\n", Next_Ptr_Glob->Discr);
  debug_printf("        should be:   %d\n", 0);
  debug_printf("  Enum_Comp:         %d\n", Next_Ptr_Glob->variant.var_1.Enum_Comp);
  debug_printf("        should be:   %d\n", 1);
  debug_printf("  Int_Comp:          %d\n", Next_Ptr_Glob->variant.var_1.Int_Comp);
  debug_printf("        should be:   %d\n", 18);
  debug_printf("  Str_Comp:          %s\n",
                                Next_Ptr_Glob->variant.var_1.Str_Comp);
  debug_printf("        should be:   DHRYSTONE PROGRAM, SOME STRING\n");
  debug_printf("Int_1_Loc:           %d\n", Int_1_Loc);
  debug_printf("        should be:   %d\n", 5);
  debug_printf("Int_2_Loc:           %d\n", Int_2_Loc);
  debug_printf("        should be:   %d\n", 13);
  debug_printf("Int_3_Loc:           %d\n", Int_3_Loc);
  debug_printf("        should be:   %d\n", 7);
  debug_printf("Enum_Loc:            %d\n", Enum_Loc);
  debug_printf("        should be:   %d\n", 1);
  debug_printf("Str_1_Loc:           %s\n", Str_1_Loc);
  debug_printf("        should be:   DHRYSTONE PROGRAM, 1'ST STRING\n");
  debug_printf("Str_2_Loc:           %s\n", Str_2_Loc);
  debug_printf("        should be:   DHRYSTONE PROGRAM, 2'ND STRING\n");
  debug_printf("\n");


  Microseconds = ((User_Time / Number_Of_Runs) * Mic_secs_Per_Second) / HZ;
  Dhrystones_Per_Second = (HZ * Number_Of_Runs) / User_Time;

  printf("Microseconds for one run through Dhrystone: %llu\n", Microseconds);
  printf("Dhrystones per Second:                      %llu\n", Dhrystones_Per_Second);

  printf("DMIPS/MHz: %llu,%06llu\n", Dhrystones_Per_Second / 1757 / (HZ / 1000000ULL), (ee_u64)((1000000ull * Dhrystones_Per_Second / 1757 / (HZ / 1000000ULL)) % 1000000));

  ee_u64 total_time = get_time();
  ee_u64 total_instret = get_instret();
  ee_u64 total_branch = get_branch_total();
  ee_u64 total_branch_hit = get_branch_hit();
  printf("Total ticks      : %llu\n",total_time);
  printf("Total ticks (hex) : %08x%08x\n", (ee_u32)(total_time >> 32), (ee_u32)(total_time & 0xffffffffu));
  printf("Total instrets (hex) : %08x%08x\n", (ee_u32)(total_instret >> 32), (ee_u32)(total_instret & 0xffffffffu));
  printf("Total branchs (hex) : %08x%08x\n", (ee_u32)(total_branch >> 32), (ee_u32)(total_branch & 0xffffffffu));
  printf("Total branch hits (hex) : %08x%08x\n", (ee_u32)(total_branch_hit >> 32), (ee_u32)(total_branch_hit & 0xffffffffu));
  printf("IPC : %u.%06u\n", (ee_u32)(total_instret / total_time), (ee_u32)(((1000000 * total_instret) / total_time) % 1000000));
  printf("Branch Hit Rate : %u.%06u%%\n", (ee_u32)((total_branch_hit * 100ull) / total_branch), (ee_u32)(((1000000000ull * total_branch_hit) / total_branch) % 1000000));
  return 0;
}


Proc_1 (Ptr_Val_Par)
/******************/

REG Rec_Pointer Ptr_Val_Par;
    /* executed once */
{
  REG Rec_Pointer Next_Record = Ptr_Val_Par->Ptr_Comp;  
                                        /* == Ptr_Glob_Next */
  /* Local variable, initialized with Ptr_Val_Par->Ptr_Comp,    */
  /* corresponds to "rename" in Ada, "with" in Pascal           */
  
  structassign (*Ptr_Val_Par->Ptr_Comp, *Ptr_Glob); 
  Ptr_Val_Par->variant.var_1.Int_Comp = 5;
  Next_Record->variant.var_1.Int_Comp 
        = Ptr_Val_Par->variant.var_1.Int_Comp;
  Next_Record->Ptr_Comp = Ptr_Val_Par->Ptr_Comp;
  Proc_3 (&Next_Record->Ptr_Comp);
    /* Ptr_Val_Par->Ptr_Comp->Ptr_Comp 
                        == Ptr_Glob->Ptr_Comp */
  if (Next_Record->Discr == Ident_1)
    /* then, executed */
  {
    Next_Record->variant.var_1.Int_Comp = 6;
    Proc_6 (Ptr_Val_Par->variant.var_1.Enum_Comp, 
           &Next_Record->variant.var_1.Enum_Comp);
    Next_Record->Ptr_Comp = Ptr_Glob->Ptr_Comp;
    Proc_7 (Next_Record->variant.var_1.Int_Comp, 10, 
           &Next_Record->variant.var_1.Int_Comp);
  }
  else /* not executed */
    structassign (*Ptr_Val_Par, *Ptr_Val_Par->Ptr_Comp);
} /* Proc_1 */


Proc_2 (Int_Par_Ref)
/******************/
    /* executed once */
    /* *Int_Par_Ref == 1, becomes 4 */

One_Fifty   *Int_Par_Ref;
{
  One_Fifty  Int_Loc;  
  Enumeration   Enum_Loc;

  Int_Loc = *Int_Par_Ref + 10;
  do /* executed once */
    if (Ch_1_Glob == 'A')
      /* then, executed */
    {
      Int_Loc -= 1;
      *Int_Par_Ref = Int_Loc - Int_Glob;
      Enum_Loc = Ident_1;
    } /* if */
  while (Enum_Loc != Ident_1); /* true */
} /* Proc_2 */


Proc_3 (Ptr_Ref_Par)
/******************/
    /* executed once */
    /* Ptr_Ref_Par becomes Ptr_Glob */

Rec_Pointer *Ptr_Ref_Par;

{
  if (Ptr_Glob != Null)
    /* then, executed */
    *Ptr_Ref_Par = Ptr_Glob->Ptr_Comp;
  Proc_7 (10, Int_Glob, &Ptr_Glob->variant.var_1.Int_Comp);
} /* Proc_3 */


Proc_4 () /* without parameters */
/*******/
    /* executed once */
{
  Boolean Bool_Loc;

  Bool_Loc = Ch_1_Glob == 'A';
  Bool_Glob = Bool_Loc | Bool_Glob;
  Ch_2_Glob = 'B';
} /* Proc_4 */


Proc_5 () /* without parameters */
/*******/
    /* executed once */
{
  Ch_1_Glob = 'A';
  Bool_Glob = false;
} /* Proc_5 */
