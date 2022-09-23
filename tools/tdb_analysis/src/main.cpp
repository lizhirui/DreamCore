#include <tdb_reader.h>
#include <cstdio>
#include <iostream>
#include <cassert>
#include <chrono>

using namespace std;
using namespace trace;

int main()
{
    trace_reader tdb_fetch;
    trace_reader tdb_exbru;
    trace_reader tdb_commit;
    size_t cur_cycle;
    auto start = chrono::steady_clock::now();

    tdb_fetch.open("../../trace_remote/coremark_10/fetch.tdb");
    tdb_exbru.open("../../trace_remote/coremark_10/execute_bru_0.tdb");
    tdb_commit.open("../../trace_remote/coremark_10/commit.tdb");

    assert(tdb_fetch.read_cur_row());
    assert(tdb_exbru.read_cur_row());
    assert(tdb_commit.read_cur_row());
    cur_cycle = tdb_fetch.get_cur_row();

    while(1)
    {
        tdb_fetch.move_to_next_row();
        tdb_exbru.move_to_next_row();
        tdb_commit.move_to_next_row();
        cur_cycle = tdb_fetch.get_cur_row();

        if(!tdb_fetch.read_cur_row() || !tdb_exbru.read_cur_row() || !tdb_commit.read_cur_row())
        {
            break;
        }

        if(cur_cycle % 100000 == 0)
        {
            auto end = chrono::steady_clock::now();
            chrono::duration<double> diff = end - start;
            printf("cur_cycle = %lu - %.4lfs\n", cur_cycle, diff.count());
            start = chrono::steady_clock::now();
        }

        if(cur_cycle >= 860000)
        {
            for(auto i = 0;i < 4;i++)
            {
                auto commit_bp_pc = *(uint32_t *)tdb_commit.read_field(domain_t::output, "commit_bp_pc", i);
                auto commit_bp_valid = ((*(uint32_t *)tdb_commit.read_field(domain_t::output, "commit_bp_valid", 0)) >> i) & 0x01;
                auto commit_bp_hit = ((*(uint32_t *)tdb_commit.read_field(domain_t::output, "commit_bp_hit", 0)) >> i) & 0x01;
                auto commit_bp_jump = ((*(uint32_t *)tdb_commit.read_field(domain_t::output, "commit_bp_jump", 0)) >> i) & 0x01;
                
                if(commit_bp_valid && (commit_bp_pc == 0x80001544))
                {
                    printf("cycle = %ld, jump = %d, hit = %d\n", cur_cycle, commit_bp_jump, commit_bp_hit);
                }
            }
            
        }

        if(cur_cycle >= 866240)
        {
            break;
        }
    }

    printf("ok!\n");
    return 0;
}