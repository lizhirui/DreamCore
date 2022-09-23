#!/bin/python3
#****************************************************************************************
# Copyright lizhirui
#
# SPDX-License-Identifier: Apache-2.0
#
# Change Logs:
# Date           Author       Notes
# 2022-07-20     lizhirui     the first version
# 2022-07-21     lizhirui     add time show support
# 2022-08-24     lizhirui     fixed exit bug and add xcelium support and warning check
#****************************************************************************************
from concurrent.futures import thread
from pathlib import Path as path
import sys
import os
import subprocess
import threading
import math
import argparse
from multiprocessing import cpu_count
import time

def shell(cmd):
    p = subprocess.Popen(cmd, shell = False, stdout = subprocess.PIPE, stderr = subprocess.STDOUT)
    return p.stdout.read().decode()

def file_key(elem):
    return elem[0] + "_" + elem[1]

def error(text):
    print("\033[0;31mError: " + text + "\033[0m")
    exit(1)

def warning(text):
    print("\033[0;34mWarning: " + text + "\033[0m")

def warning_or_error(is_warning, text):
    if is_warning:
        warning(text)
    else:
        error(text)

def red_text(text):
    print("\033[0;31m" + text + "\033[0m")

def green_text(text, end="\n"):
    print("\033[0;32m" + text + "\033[0m", end=end)

def yellow_text(text):
    print("\033[0;33m" + text + "\033[0m")

def to_human_friendly_time(t):
    t = int(t)

    if t < 60:
        return str(t) + "s"
    elif t < 3600:
        return str(t // 60) + "m" + str(t % 60) + "s"
    else:
        return str(t // 3600) + "h" + str(t % 3600 // 60) + "m" + str(t % 60) + "s"

print_lock = threading.Lock()
passed_cnt = 0
failed_cnt = 0
unknown_error_cnt = 0

class dynamic_check_thread(threading.Thread):
    def __init__(self, thread_id, local_task_list):
        threading.Thread.__init__(self)
        self.thread_id = thread_id
        self.local_task_list = local_task_list

    def run(self):
        global passed_cnt, failed_cnt, unknown_error_cnt
        cnt = 0

        for item in self.local_task_list:
            cnt = cnt + 1
            retry_cnt = 0
            
            while True:
                start_time = time.time()

                if len(item) == 4:
                    ret = shell(["./run_" + item[3] + ".sh"] + [item[0], item[2], item[1]])
                else:
                    ret = shell(["./run_" + item[2] + ".sh"] + [item[0], item[1]])

                end_time = time.time()
                elapsed_time = to_human_friendly_time(end_time - start_time)
                    
                case_name = ""

                for x in item:
                    case_name += x + ", "

                case_name = case_name.rstrip(", ")

                if "was either corrupt or the file system cache consistency check failed" in ret:
                    print_lock.acquire()

                    if retry_cnt == 0:
                        retry_cnt += 1
                        
                        if len(item) == 3:
                            ret = shell(["./clean_xrun.sh"] + [item[0], item[2], item[1]])
                        else:
                            ret = shell(["./clean_xrun.sh"] + item)
                        
                        yellow_text("[" + str(self.thread_id + 1) + "-" + str(cnt) + "/" + str(len(self.local_task_list)) + ", " + case_name + "]: Database Corrupted, Retry " + elapsed_time)
                    else:
                        yellow_text("[" + str(self.thread_id + 1) + "-" + str(cnt) + "/" + str(len(self.local_task_list)) + ", " + case_name + "]: Database Corrupted, Retry Failed " + elapsed_time)
                        print(ret)
                        os._exit(0)

                    print_lock.release()
                else:
                    break

            if "TEST PASSED" in ret:
                print_lock.acquire()
                green_text("[" + str(self.thread_id + 1) + "-" + str(cnt) + "/" + str(len(self.local_task_list)) + ", " + case_name + "]: Test Passed " + elapsed_time)
                passed_cnt += 1
                print_lock.release()
            elif "Offending" in ret or "assert" in ret:
                print_lock.acquire()
                red_text("[" + str(self.thread_id + 1) + "-" + str(cnt) + "/" + str(len(self.local_task_list)) + ", " + case_name + "]: Test Failed " + elapsed_time)
                #print(ret)
                #os._exit(0)
                failed_cnt += 1
                print_lock.release()
            else:
                print_lock.acquire()
                yellow_text("[" + str(self.thread_id + 1) + "-" + str(cnt) + "/" + str(len(self.local_task_list)) + ", " + case_name + "]: Unknown Error " + elapsed_time)
                print(ret)
                #os._exit(0)
                unknown_error_cnt += 1
                print_lock.release()

            if "*W" in ret.replace("*W,BADPRF", "").replace("*W,PRLDYN", "").replace("*W,WKWTLK", "").replace("*N,SPUNSP", "").replace("*W,XPWDIS", "").replace("*W,DEAPF", "").replace("*W,XPOPT", "") or \
                "Warning-" in ret.replace("Warning-[DEBUG_DEP] Option will be deprecated", "").replace("Warning-[LINX_KRNL] Unsupported Linux kernel", "").replace("Warning-[UNGB] Unnamed generate block", ""):
                print_lock.acquire()
                yellow_text("Warnings had been found: ")
                print(ret)

                if len(item) == 3:
                    ret = shell(["./clean_xrun.sh"] + [item[0], item[2], item[1]])
                else:
                    ret = shell(["./clean_xrun.sh"] + item)

                #os._exit(0)
                print_lock.release()

total_start_time = time.time()

tb_dir = "../tb"
trace_dir = "../trace"
parallel_count = 1

parser = argparse.ArgumentParser()
parser.add_argument("-g", "--group", help="test group", choices=["basic", "difftest", "all"], required=True)
parser.add_argument("-s", "--trace", help="trace name", type=str, dest="trace_name")
parser.add_argument("-i", "--simulator", help="simulator name", choices=["vcs", "xrun", "all"], required=True)
parser.add_argument("-j", help="parallel count limit, default is 1", nargs="?", type=int, const=0, choices=range(0, cpu_count() + 1), dest="parallel_count")
parser.add_argument("-t", help="testcase name, default is all testcases", type=str, dest="testcase_name")
args = parser.parse_args()

if not args.parallel_count is None:
    if args.parallel_count == 0:
        parallel_count = cpu_count()
    else:
        parallel_count = args.parallel_count

tb_groups = []
use_vcs = False
use_xrun = False

if args.group == "all":
    tb_groups.append("basic")
    tb_groups.append("difftest")
else:
    tb_groups.append(args.group)

if args.simulator == "all":
    use_vcs = True
    use_xrun = True
elif args.simulator == "vcs":
    use_vcs = True
elif args.simulator == "xrun":
    use_xrun = True

print("Start Time: " + time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()))

print("Start to scan testcases...")

original_testcase_list = []
group_testcase_list = {}
trace_list = []
testcase_list = []

vcs_ignore_list = ["difftest-core_top"]
xrun_ignore_list = ["difftest-core_top"]

if "difftest" in tb_groups:
    if not args.trace_name is None:
        if not os.path.exists(os.path.join(trace_dir, args.trace_name)):
            error("trace " + args.trace_name + "isn't exist!")
            
        trace_list.append(args.trace_name)
    else:
        trace_root = path(trace_dir)

        for dir_item in trace_root.iterdir():
            if dir_item.is_dir():
                trace_list.append(dir_item.name)

for group in tb_groups:
    group_root = path(os.path.join(tb_dir, group))
    group_testcase_list[group] = []
    
    for dir_item in group_root.iterdir():
        if dir_item.is_dir():
            if dir_item.name == args.testcase_name or args.testcase_name is None:
                original_testcase_list.append([group, dir_item.name])
                group_testcase_list[group].append(dir_item.name)

original_testcase_list.sort(key = file_key)

for item in original_testcase_list:
    if item[0] == "difftest":
        for trace in trace_list:
            if use_vcs and not (item[0] + "-" + item[1]) in vcs_ignore_list:
                testcase_list.append([item[0], item[1], trace, "vcs"])

            if use_xrun and not (item[0] + "-" + item[1]) in xrun_ignore_list:
                testcase_list.append([item[0], item[1], trace, "xrun"])
    else:
        if use_vcs and not (item[0] + "-" + item[1]) in vcs_ignore_list:
            testcase_list.append([item[0], item[1], "vcs"])

        if use_xrun and not (item[0] + "-" + item[1]) in xrun_ignore_list:
            testcase_list.append([item[0], item[1], "xrun"])

if len(trace_list) > 0:
    print(str(len(trace_list)) + " traces are found: ")

    for trace in trace_list:
        green_text(trace + " ", end="")

    print()

print(str(len(original_testcase_list)) + " testcases are found: ")

for group in tb_groups:
    green_text(group + ":", end="")

    for testcase in group_testcase_list[group]:
        print(" " + testcase, end="")

    print()

print(str(len(testcase_list)) + " extended testcases are found!")

if len(testcase_list) == 0:
    error("No any testcase needs to test!")

print("Start to assign tasks...")
actual_parallel_count = min(parallel_count, len(testcase_list))

if actual_parallel_count < parallel_count:
    warning("You request " + str(parallel_count) + " threads, but only " + str(len(testcase_list)) + " testcases need to be tested!")

total_task_num = len(testcase_list)

'''
average_task_num_floor = math.floor(len(testcase_list) / actual_parallel_count)
average_task_num_ceil = math.ceil(len(testcase_list) / actual_parallel_count)
average_task_num = average_task_num_floor if (average_task_num_floor * (actual_parallel_count - 1)) > (average_task_num_ceil * (actual_parallel_count)) else average_task_num_ceil

if average_task_num * (actual_parallel_count - 1) >= total_task_num:
    actual_parallel_count -= 1
    warning("You request " + str(parallel_count) + " threads, but only " + str(actual_parallel_count) + " threads need to be tested!")

assigned_task_num = 0


thread_task_list = []
thread_list = []

for i in range(0, actual_parallel_count):
    task_num = average_task_num if i < (actual_parallel_count - 1) else (total_task_num - assigned_task_num)
    thread_task_list.append(testcase_list[assigned_task_num : (assigned_task_num + task_num)])
    assigned_task_num += task_num
    #green_text("Thread " + str(i) + " is assigned " + str(task_num) + " tasks")
'''

thread_task_list = [[] for i in range(0, parallel_count)]
thread_list = []

assigned_task_num = 0
cur_thread_id = 0

for i in range(0, total_task_num):
    if testcase_list[i][0] != "difftest":
        thread_task_list[cur_thread_id].append(testcase_list[i])
        assigned_task_num += 1
        cur_thread_id = (cur_thread_id + 1) % parallel_count

for i in range(0, total_task_num):
    if testcase_list[i][0] == "difftest":
        thread_task_list[cur_thread_id].append(testcase_list[i])
        assigned_task_num += 1
        cur_thread_id = (cur_thread_id + 1) % parallel_count

print("The count of total assigned tasks is " + str(total_task_num) + " , the count of actual assigned tasks is " + str(assigned_task_num))

print("Starting threads...")
print_lock.acquire()

for i in range(0, actual_parallel_count):
    task_thread = dynamic_check_thread(i, thread_task_list[i])
    thread_list.append(task_thread)
    task_thread.start()

print("Waiting threads finish...")
print_lock.release()

for task_thread in thread_list:
    task_thread.join()

print("All thread are finished, " + str(passed_cnt) + " passed, " + str(failed_cnt) + " failed, " + str(unknown_error_cnt) + " unknown error, " + str(total_task_num - passed_cnt - failed_cnt - unknown_error_cnt) + " don't have any results!")

if passed_cnt < total_task_num:
    error("Some testcases are failed")
else:
    green_text("All testcases are passed!")

total_end_time = time.time()
total_elapsed = to_human_friendly_time(total_end_time - total_start_time)
print(total_elapsed)