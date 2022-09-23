
rtthread.elf:     file format elf32-littleriscv


Disassembly of section .init:

80000000 <_start>:
80000000:	00000093          	li	ra,0
80000004:	00000113          	li	sp,0
80000008:	00000193          	li	gp,0
8000000c:	00000213          	li	tp,0
80000010:	00000293          	li	t0,0
80000014:	00000313          	li	t1,0
80000018:	00000393          	li	t2,0
8000001c:	00000413          	li	s0,0
80000020:	00000493          	li	s1,0
80000024:	00000513          	li	a0,0
80000028:	00000593          	li	a1,0
8000002c:	00000613          	li	a2,0
80000030:	00000693          	li	a3,0
80000034:	00000713          	li	a4,0
80000038:	00000793          	li	a5,0
8000003c:	00000813          	li	a6,0
80000040:	00000893          	li	a7,0
80000044:	00000913          	li	s2,0
80000048:	00000993          	li	s3,0
8000004c:	00000a13          	li	s4,0
80000050:	00000a93          	li	s5,0
80000054:	00000b13          	li	s6,0
80000058:	00000b93          	li	s7,0
8000005c:	00000c13          	li	s8,0
80000060:	00000c93          	li	s9,0
80000064:	00000d13          	li	s10,0
80000068:	00000d93          	li	s11,0
8000006c:	00000e13          	li	t3,0
80000070:	00000e93          	li	t4,0
80000074:	00000f13          	li	t5,0
80000078:	00000f93          	li	t6,0
8000007c:	00040117          	auipc	sp,0x40
80000080:	f8410113          	addi	sp,sp,-124 # 80040000 <_sp>
80000084:	30047073          	csrci	mstatus,8
80000088:	00021197          	auipc	gp,0x21
8000008c:	9d818193          	addi	gp,gp,-1576 # 80020a60 <__global_pointer$>
80000090:	00000297          	auipc	t0,0x0
80000094:	2f028293          	addi	t0,t0,752 # 80000380 <exc_entry>
80000098:	30529073          	csrw	mtvec,t0
8000009c:	3062f073          	csrci	mcounteren,5
800000a0:	0000f517          	auipc	a0,0xf
800000a4:	a4050513          	addi	a0,a0,-1472 # 8000eae0 <__fini_array_end>
800000a8:	00020597          	auipc	a1,0x20
800000ac:	f5858593          	addi	a1,a1,-168 # 80020000 <__RAM_BASE>
800000b0:	00020617          	auipc	a2,0x20
800000b4:	1cc60613          	addi	a2,a2,460 # 8002027c <__bss_start>
800000b8:	00c5fc63          	bgeu	a1,a2,800000d0 <_start+0xd0>
800000bc:	00052283          	lw	t0,0(a0)
800000c0:	0055a023          	sw	t0,0(a1)
800000c4:	00450513          	addi	a0,a0,4
800000c8:	00458593          	addi	a1,a1,4
800000cc:	fec5e8e3          	bltu	a1,a2,800000bc <_start+0xbc>
800000d0:	00020517          	auipc	a0,0x20
800000d4:	1ac50513          	addi	a0,a0,428 # 8002027c <__bss_start>
800000d8:	5b818593          	addi	a1,gp,1464 # 80021018 <_end>
800000dc:	00b57863          	bgeu	a0,a1,800000ec <_start+0xec>
800000e0:	00052023          	sw	zero,0(a0)
800000e4:	00450513          	addi	a0,a0,4
800000e8:	feb56ce3          	bltu	a0,a1,800000e0 <_start+0xe0>
800000ec:	0000c517          	auipc	a0,0xc
800000f0:	b1050513          	addi	a0,a0,-1264 # 8000bbfc <__libc_fini_array>
800000f4:	2e90b0ef          	jal	ra,8000bbdc <atexit>
800000f8:	2e10b0ef          	jal	ra,8000bbd8 <__libc_init_array>
800000fc:	00000513          	li	a0,0
80000100:	00000593          	li	a1,0
80000104:	00000613          	li	a2,0
80000108:	171000ef          	jal	ra,80000a78 <entry>
8000010c:	0000006f          	j	8000010c <_start+0x10c>

Disassembly of section .text:

80000140 <main>:
80000140:	ff010113          	addi	sp,sp,-16
80000144:	00112623          	sw	ra,12(sp)
80000148:	570000ef          	jal	ra,800006b8 <rt_hw_uart_start_rx_thread>
8000014c:	114000ef          	jal	ra,80000260 <testapp>
80000150:	00c12083          	lw	ra,12(sp)
80000154:	00000513          	li	a0,0
80000158:	01010113          	addi	sp,sp,16
8000015c:	00008067          	ret

80000160 <thread_a_entry>:
80000160:	ff010113          	addi	sp,sp,-16
80000164:	00812423          	sw	s0,8(sp)
80000168:	00912223          	sw	s1,4(sp)
8000016c:	01212023          	sw	s2,0(sp)
80000170:	00112623          	sw	ra,12(sp)
80000174:	00000413          	li	s0,0
80000178:	0000c917          	auipc	s2,0xc
8000017c:	27090913          	addi	s2,s2,624 # 8000c3e8 <__ascii_wctomb+0x30>
80000180:	00a00493          	li	s1,10
80000184:	00040593          	mv	a1,s0
80000188:	00090513          	mv	a0,s2
8000018c:	6e1010ef          	jal	ra,8000206c <rt_kprintf>
80000190:	00100513          	li	a0,1
80000194:	00140413          	addi	s0,s0,1
80000198:	510030ef          	jal	ra,800036a8 <rt_thread_mdelay>
8000019c:	fe9414e3          	bne	s0,s1,80000184 <thread_a_entry+0x24>
800001a0:	00c12083          	lw	ra,12(sp)
800001a4:	00812403          	lw	s0,8(sp)
800001a8:	00412483          	lw	s1,4(sp)
800001ac:	00012903          	lw	s2,0(sp)
800001b0:	01010113          	addi	sp,sp,16
800001b4:	00008067          	ret

800001b8 <thread_b_entry>:
800001b8:	ff010113          	addi	sp,sp,-16
800001bc:	00812423          	sw	s0,8(sp)
800001c0:	00912223          	sw	s1,4(sp)
800001c4:	00112623          	sw	ra,12(sp)
800001c8:	00000413          	li	s0,0
800001cc:	0000c497          	auipc	s1,0xc
800001d0:	23448493          	addi	s1,s1,564 # 8000c400 <__ascii_wctomb+0x48>
800001d4:	00040593          	mv	a1,s0
800001d8:	00048513          	mv	a0,s1
800001dc:	691010ef          	jal	ra,8000206c <rt_kprintf>
800001e0:	00a00513          	li	a0,10
800001e4:	4c4030ef          	jal	ra,800036a8 <rt_thread_mdelay>
800001e8:	00140413          	addi	s0,s0,1
800001ec:	00a00793          	li	a5,10
800001f0:	fef412e3          	bne	s0,a5,800001d4 <thread_b_entry+0x1c>
800001f4:	00c12083          	lw	ra,12(sp)
800001f8:	00812403          	lw	s0,8(sp)
800001fc:	00412483          	lw	s1,4(sp)
80000200:	01010113          	addi	sp,sp,16
80000204:	00008067          	ret

80000208 <thread_c_entry>:
80000208:	ff010113          	addi	sp,sp,-16
8000020c:	00812423          	sw	s0,8(sp)
80000210:	00912223          	sw	s1,4(sp)
80000214:	01212023          	sw	s2,0(sp)
80000218:	00112623          	sw	ra,12(sp)
8000021c:	00000413          	li	s0,0
80000220:	0000c917          	auipc	s2,0xc
80000224:	1f890913          	addi	s2,s2,504 # 8000c418 <__ascii_wctomb+0x60>
80000228:	00a00493          	li	s1,10
8000022c:	00040593          	mv	a1,s0
80000230:	00090513          	mv	a0,s2
80000234:	639010ef          	jal	ra,8000206c <rt_kprintf>
80000238:	00500513          	li	a0,5
8000023c:	00140413          	addi	s0,s0,1
80000240:	468030ef          	jal	ra,800036a8 <rt_thread_mdelay>
80000244:	fe9414e3          	bne	s0,s1,8000022c <thread_c_entry+0x24>
80000248:	00c12083          	lw	ra,12(sp)
8000024c:	00812403          	lw	s0,8(sp)
80000250:	00412483          	lw	s1,4(sp)
80000254:	00012903          	lw	s2,0(sp)
80000258:	01010113          	addi	sp,sp,16
8000025c:	00008067          	ret

80000260 <testapp>:
80000260:	ff010113          	addi	sp,sp,-16
80000264:	00a00793          	li	a5,10
80000268:	00a00713          	li	a4,10
8000026c:	000016b7          	lui	a3,0x1
80000270:	00000613          	li	a2,0
80000274:	00000597          	auipc	a1,0x0
80000278:	eec58593          	addi	a1,a1,-276 # 80000160 <thread_a_entry>
8000027c:	0000c517          	auipc	a0,0xc
80000280:	1b450513          	addi	a0,a0,436 # 8000c430 <__ascii_wctomb+0x78>
80000284:	00112623          	sw	ra,12(sp)
80000288:	00812423          	sw	s0,8(sp)
8000028c:	00912223          	sw	s1,4(sp)
80000290:	01212023          	sw	s2,0(sp)
80000294:	1a4030ef          	jal	ra,80003438 <rt_thread_create>
80000298:	00020917          	auipc	s2,0x20
8000029c:	fe490913          	addi	s2,s2,-28 # 8002027c <__bss_start>
800002a0:	00a92023          	sw	a0,0(s2)
800002a4:	00a00793          	li	a5,10
800002a8:	00a00713          	li	a4,10
800002ac:	000016b7          	lui	a3,0x1
800002b0:	00000613          	li	a2,0
800002b4:	00000597          	auipc	a1,0x0
800002b8:	f0458593          	addi	a1,a1,-252 # 800001b8 <thread_b_entry>
800002bc:	0000c517          	auipc	a0,0xc
800002c0:	18050513          	addi	a0,a0,384 # 8000c43c <__ascii_wctomb+0x84>
800002c4:	174030ef          	jal	ra,80003438 <rt_thread_create>
800002c8:	00020497          	auipc	s1,0x20
800002cc:	fb848493          	addi	s1,s1,-72 # 80020280 <thread_b>
800002d0:	00a00793          	li	a5,10
800002d4:	00a00713          	li	a4,10
800002d8:	000016b7          	lui	a3,0x1
800002dc:	00000613          	li	a2,0
800002e0:	00000597          	auipc	a1,0x0
800002e4:	f2858593          	addi	a1,a1,-216 # 80000208 <thread_c_entry>
800002e8:	00a4a023          	sw	a0,0(s1)
800002ec:	0000c517          	auipc	a0,0xc
800002f0:	15c50513          	addi	a0,a0,348 # 8000c448 <__ascii_wctomb+0x90>
800002f4:	144030ef          	jal	ra,80003438 <rt_thread_create>
800002f8:	00020417          	auipc	s0,0x20
800002fc:	f8c40413          	addi	s0,s0,-116 # 80020284 <thread_c>
80000300:	00a42023          	sw	a0,0(s0)
80000304:	00092503          	lw	a0,0(s2)
80000308:	48c030ef          	jal	ra,80003794 <rt_thread_startup>
8000030c:	0004a503          	lw	a0,0(s1)
80000310:	484030ef          	jal	ra,80003794 <rt_thread_startup>
80000314:	00042503          	lw	a0,0(s0)
80000318:	47c030ef          	jal	ra,80003794 <rt_thread_startup>
8000031c:	00c12083          	lw	ra,12(sp)
80000320:	00812403          	lw	s0,8(sp)
80000324:	00412483          	lw	s1,4(sp)
80000328:	00012903          	lw	s2,0(sp)
8000032c:	00000513          	li	a0,0
80000330:	01010113          	addi	sp,sp,16
80000334:	00008067          	ret

80000338 <_fini>:
80000338:	00008067          	ret

8000033c <rt_hw_board_init>:
8000033c:	ff010113          	addi	sp,sp,-16
80000340:	00112623          	sw	ra,12(sp)
80000344:	30047073          	csrci	mstatus,8
80000348:	759030ef          	jal	ra,800042a0 <riscv_trap_vector_init>
8000034c:	639030ef          	jal	ra,80004184 <rt_hw_ticksetup>
80000350:	0003e597          	auipc	a1,0x3e
80000354:	cb058593          	addi	a1,a1,-848 # 8003e000 <_heap_end>
80000358:	5b818513          	addi	a0,gp,1464 # 80021018 <_end>
8000035c:	040020ef          	jal	ra,8000239c <rt_system_heap_init>
80000360:	3e8000ef          	jal	ra,80000748 <rt_hw_uart_init>
80000364:	0000c517          	auipc	a0,0xc
80000368:	10850513          	addi	a0,a0,264 # 8000c46c <__fsym___cmd_testapp_name+0x10>
8000036c:	499010ef          	jal	ra,80002004 <rt_console_set_device>
80000370:	544000ef          	jal	ra,800008b4 <rt_components_board_init>
80000374:	00c12083          	lw	ra,12(sp)
80000378:	01010113          	addi	sp,sp,16
8000037c:	6810306f          	j	800041fc <disable_external_irq>

80000380 <exc_entry>:
80000380:	fb010113          	addi	sp,sp,-80
80000384:	00112023          	sw	ra,0(sp)
80000388:	00412223          	sw	tp,4(sp)
8000038c:	00512423          	sw	t0,8(sp)
80000390:	00612623          	sw	t1,12(sp)
80000394:	00712823          	sw	t2,16(sp)
80000398:	00a12a23          	sw	a0,20(sp)
8000039c:	00b12c23          	sw	a1,24(sp)
800003a0:	00c12e23          	sw	a2,28(sp)
800003a4:	02d12023          	sw	a3,32(sp)
800003a8:	02e12223          	sw	a4,36(sp)
800003ac:	02f12423          	sw	a5,40(sp)
800003b0:	03012c23          	sw	a6,56(sp)
800003b4:	03112e23          	sw	a7,60(sp)
800003b8:	05c12023          	sw	t3,64(sp)
800003bc:	05d12223          	sw	t4,68(sp)
800003c0:	05e12423          	sw	t5,72(sp)
800003c4:	05f12623          	sw	t6,76(sp)
800003c8:	34202573          	csrr	a0,mcause
800003cc:	00010593          	mv	a1,sp
800003d0:	63d030ef          	jal	ra,8000420c <core_exception_handler>
800003d4:	03012283          	lw	t0,48(sp)
800003d8:	34129073          	csrw	mepc,t0
800003dc:	02c12283          	lw	t0,44(sp)
800003e0:	34229073          	csrw	mcause,t0
800003e4:	00012083          	lw	ra,0(sp)
800003e8:	00412203          	lw	tp,4(sp)
800003ec:	00812283          	lw	t0,8(sp)
800003f0:	00c12303          	lw	t1,12(sp)
800003f4:	01012383          	lw	t2,16(sp)
800003f8:	01412503          	lw	a0,20(sp)
800003fc:	01812583          	lw	a1,24(sp)
80000400:	01c12603          	lw	a2,28(sp)
80000404:	02012683          	lw	a3,32(sp)
80000408:	02412703          	lw	a4,36(sp)
8000040c:	02812783          	lw	a5,40(sp)
80000410:	03812803          	lw	a6,56(sp)
80000414:	03c12883          	lw	a7,60(sp)
80000418:	04012e03          	lw	t3,64(sp)
8000041c:	04412e83          	lw	t4,68(sp)
80000420:	04812f03          	lw	t5,72(sp)
80000424:	04c12f83          	lw	t6,76(sp)
80000428:	05010113          	addi	sp,sp,80
8000042c:	30200073          	mret
	...

80000440 <clint_yield_swi>:
80000440:	20000737          	lui	a4,0x20000
80000444:	00072783          	lw	a5,0(a4) # 20000000 <__RAM_SIZE+0x1ffe0000>
80000448:	0017e793          	ori	a5,a5,1
8000044c:	00f72023          	sw	a5,0(a4)
80000450:	00008067          	ret

80000454 <clint_clear_swi_flag>:
80000454:	20000737          	lui	a4,0x20000
80000458:	00072783          	lw	a5,0(a4) # 20000000 <__RAM_SIZE+0x1ffe0000>
8000045c:	ffe7f793          	andi	a5,a5,-2
80000460:	00f72023          	sw	a5,0(a4)
80000464:	00008067          	ret

80000468 <systimer_start>:
80000468:	00008067          	ret

8000046c <systick_config>:
8000046c:	2000c6b7          	lui	a3,0x2000c
80000470:	00050713          	mv	a4,a0
80000474:	00000513          	li	a0,0
80000478:	fea6ac23          	sw	a0,-8(a3) # 2000bff8 <__RAM_SIZE+0x1ffebff8>
8000047c:	00058793          	mv	a5,a1
80000480:	00000593          	li	a1,0
80000484:	feb6ae23          	sw	a1,-4(a3)
80000488:	200046b7          	lui	a3,0x20004
8000048c:	00e6a023          	sw	a4,0(a3) # 20004000 <__RAM_SIZE+0x1ffe4000>
80000490:	00f6a223          	sw	a5,4(a3)
80000494:	5550306f          	j	800041e8 <enable_systimer_irq>

80000498 <systick_reload>:
80000498:	2000c6b7          	lui	a3,0x2000c
8000049c:	ff86a603          	lw	a2,-8(a3) # 2000bff8 <__RAM_SIZE+0x1ffebff8>
800004a0:	ffc6a683          	lw	a3,-4(a3)
800004a4:	00058793          	mv	a5,a1
800004a8:	00050713          	mv	a4,a0
800004ac:	00a60533          	add	a0,a2,a0
800004b0:	00f68833          	add	a6,a3,a5
800004b4:	00c535b3          	sltu	a1,a0,a2
800004b8:	010585b3          	add	a1,a1,a6
800004bc:	00058893          	mv	a7,a1
800004c0:	00050813          	mv	a6,a0
800004c4:	00b6e663          	bltu	a3,a1,800004d0 <systick_reload+0x38>
800004c8:	00d59c63          	bne	a1,a3,800004e0 <systick_reload+0x48>
800004cc:	01067a63          	bgeu	a2,a6,800004e0 <systick_reload+0x48>
800004d0:	200047b7          	lui	a5,0x20004
800004d4:	0107a023          	sw	a6,0(a5) # 20004000 <__RAM_SIZE+0x1ffe4000>
800004d8:	0117a223          	sw	a7,4(a5)
800004dc:	00008067          	ret
800004e0:	2000c6b7          	lui	a3,0x2000c
800004e4:	00000513          	li	a0,0
800004e8:	fea6ac23          	sw	a0,-8(a3) # 2000bff8 <__RAM_SIZE+0x1ffebff8>
800004ec:	00000593          	li	a1,0
800004f0:	feb6ae23          	sw	a1,-4(a3)
800004f4:	200046b7          	lui	a3,0x20004
800004f8:	00e6a023          	sw	a4,0(a3) # 20004000 <__RAM_SIZE+0x1ffe4000>
800004fc:	00f6a223          	sw	a5,4(a3)
80000500:	00008067          	ret

80000504 <myriscvcore_control>:
80000504:	ff010113          	addi	sp,sp,-16
80000508:	00812423          	sw	s0,8(sp)
8000050c:	00912223          	sw	s1,4(sp)
80000510:	01212023          	sw	s2,0(sp)
80000514:	00112623          	sw	ra,12(sp)
80000518:	00050413          	mv	s0,a0
8000051c:	00058913          	mv	s2,a1
80000520:	00060493          	mv	s1,a2
80000524:	00051e63          	bnez	a0,80000540 <myriscvcore_control+0x3c>
80000528:	02a00613          	li	a2,42
8000052c:	0000c597          	auipc	a1,0xc
80000530:	02058593          	addi	a1,a1,32 # 8000c54c <__FUNCTION__.3582>
80000534:	0000c517          	auipc	a0,0xc
80000538:	f3c50513          	addi	a0,a0,-196 # 8000c470 <__fsym___cmd_testapp_name+0x14>
8000053c:	4b1010ef          	jal	ra,800021ec <rt_assert_handler>
80000540:	01000793          	li	a5,16
80000544:	02f90463          	beq	s2,a5,8000056c <myriscvcore_control+0x68>
80000548:	01100793          	li	a5,17
8000054c:	02f90a63          	beq	s2,a5,80000580 <myriscvcore_control+0x7c>
80000550:	00c12083          	lw	ra,12(sp)
80000554:	00812403          	lw	s0,8(sp)
80000558:	00412483          	lw	s1,4(sp)
8000055c:	00012903          	lw	s2,0(sp)
80000560:	00000513          	li	a0,0
80000564:	01010113          	addi	sp,sp,16
80000568:	00008067          	ret
8000056c:	10000793          	li	a5,256
80000570:	fef490e3          	bne	s1,a5,80000550 <myriscvcore_control+0x4c>
80000574:	00100793          	li	a5,1
80000578:	06f42223          	sw	a5,100(s0)
8000057c:	fd5ff06f          	j	80000550 <myriscvcore_control+0x4c>
80000580:	10000793          	li	a5,256
80000584:	fcf496e3          	bne	s1,a5,80000550 <myriscvcore_control+0x4c>
80000588:	06042223          	sw	zero,100(s0)
8000058c:	fc5ff06f          	j	80000550 <myriscvcore_control+0x4c>

80000590 <myriscvcore_configure>:
80000590:	ff010113          	addi	sp,sp,-16
80000594:	00812423          	sw	s0,8(sp)
80000598:	00912223          	sw	s1,4(sp)
8000059c:	00112623          	sw	ra,12(sp)
800005a0:	00050413          	mv	s0,a0
800005a4:	00058493          	mv	s1,a1
800005a8:	00051e63          	bnez	a0,800005c4 <myriscvcore_configure+0x34>
800005ac:	02200613          	li	a2,34
800005b0:	0000c597          	auipc	a1,0xc
800005b4:	f8458593          	addi	a1,a1,-124 # 8000c534 <__FUNCTION__.3576>
800005b8:	0000c517          	auipc	a0,0xc
800005bc:	eb850513          	addi	a0,a0,-328 # 8000c470 <__fsym___cmd_testapp_name+0x14>
800005c0:	42d010ef          	jal	ra,800021ec <rt_assert_handler>
800005c4:	00049e63          	bnez	s1,800005e0 <myriscvcore_configure+0x50>
800005c8:	02300613          	li	a2,35
800005cc:	0000c597          	auipc	a1,0xc
800005d0:	f6858593          	addi	a1,a1,-152 # 8000c534 <__FUNCTION__.3576>
800005d4:	0000c517          	auipc	a0,0xc
800005d8:	eb050513          	addi	a0,a0,-336 # 8000c484 <__fsym___cmd_testapp_name+0x28>
800005dc:	411010ef          	jal	ra,800021ec <rt_assert_handler>
800005e0:	0004a783          	lw	a5,0(s1)
800005e4:	00c12083          	lw	ra,12(sp)
800005e8:	00412483          	lw	s1,4(sp)
800005ec:	04f42a23          	sw	a5,84(s0)
800005f0:	00812403          	lw	s0,8(sp)
800005f4:	00000513          	li	a0,0
800005f8:	01010113          	addi	sp,sp,16
800005fc:	00008067          	ret

80000600 <uart_rx>:
80000600:	ff010113          	addi	sp,sp,-16
80000604:	00812423          	sw	s0,8(sp)
80000608:	00112623          	sw	ra,12(sp)
8000060c:	00050413          	mv	s0,a0
80000610:	06442783          	lw	a5,100(s0)
80000614:	00078c63          	beqz	a5,8000062c <uart_rx+0x2c>
80000618:	1e0000ef          	jal	ra,800007f8 <rev_char>
8000061c:	00055863          	bgez	a0,8000062c <uart_rx+0x2c>
80000620:	00100593          	li	a1,1
80000624:	00040513          	mv	a0,s0
80000628:	225040ef          	jal	ra,8000504c <rt_hw_serial_isr>
8000062c:	00a00513          	li	a0,10
80000630:	078030ef          	jal	ra,800036a8 <rt_thread_mdelay>
80000634:	fddff06f          	j	80000610 <uart_rx+0x10>

80000638 <myriscvcore_getc>:
80000638:	ff010113          	addi	sp,sp,-16
8000063c:	00812423          	sw	s0,8(sp)
80000640:	00112623          	sw	ra,12(sp)
80000644:	1b4000ef          	jal	ra,800007f8 <rev_char>
80000648:	00050413          	mv	s0,a0
8000064c:	fff00513          	li	a0,-1
80000650:	00045863          	bgez	s0,80000660 <myriscvcore_getc+0x28>
80000654:	80000537          	lui	a0,0x80000
80000658:	198000ef          	jal	ra,800007f0 <send_char>
8000065c:	0ff47513          	andi	a0,s0,255
80000660:	00c12083          	lw	ra,12(sp)
80000664:	00812403          	lw	s0,8(sp)
80000668:	01010113          	addi	sp,sp,16
8000066c:	00008067          	ret

80000670 <myriscvcore_putc>:
80000670:	ff010113          	addi	sp,sp,-16
80000674:	00812423          	sw	s0,8(sp)
80000678:	00112623          	sw	ra,12(sp)
8000067c:	00058413          	mv	s0,a1
80000680:	00051e63          	bnez	a0,8000069c <myriscvcore_putc+0x2c>
80000684:	04400613          	li	a2,68
80000688:	0000c597          	auipc	a1,0xc
8000068c:	ed858593          	addi	a1,a1,-296 # 8000c560 <__FUNCTION__.3590>
80000690:	0000c517          	auipc	a0,0xc
80000694:	de050513          	addi	a0,a0,-544 # 8000c470 <__fsym___cmd_testapp_name+0x14>
80000698:	355010ef          	jal	ra,800021ec <rt_assert_handler>
8000069c:	00040513          	mv	a0,s0
800006a0:	150000ef          	jal	ra,800007f0 <send_char>
800006a4:	00c12083          	lw	ra,12(sp)
800006a8:	00812403          	lw	s0,8(sp)
800006ac:	00100513          	li	a0,1
800006b0:	01010113          	addi	sp,sp,16
800006b4:	00008067          	ret

800006b8 <rt_hw_uart_start_rx_thread>:
800006b8:	ff010113          	addi	sp,sp,-16
800006bc:	01400793          	li	a5,20
800006c0:	00800713          	li	a4,8
800006c4:	000026b7          	lui	a3,0x2
800006c8:	91418613          	addi	a2,gp,-1772 # 80020374 <uart_device>
800006cc:	00000597          	auipc	a1,0x0
800006d0:	f3458593          	addi	a1,a1,-204 # 80000600 <uart_rx>
800006d4:	0000c517          	auipc	a0,0xc
800006d8:	dc050513          	addi	a0,a0,-576 # 8000c494 <__fsym___cmd_testapp_name+0x38>
800006dc:	00812423          	sw	s0,8(sp)
800006e0:	00112623          	sw	ra,12(sp)
800006e4:	555020ef          	jal	ra,80003438 <rt_thread_create>
800006e8:	00050413          	mv	s0,a0
800006ec:	00051e63          	bnez	a0,80000708 <rt_hw_uart_start_rx_thread+0x50>
800006f0:	07600613          	li	a2,118
800006f4:	0000c597          	auipc	a1,0xc
800006f8:	e8058593          	addi	a1,a1,-384 # 8000c574 <__FUNCTION__.3606>
800006fc:	0000c517          	auipc	a0,0xc
80000700:	da450513          	addi	a0,a0,-604 # 8000c4a0 <__fsym___cmd_testapp_name+0x44>
80000704:	2e9010ef          	jal	ra,800021ec <rt_assert_handler>
80000708:	00040513          	mv	a0,s0
8000070c:	088030ef          	jal	ra,80003794 <rt_thread_startup>
80000710:	02050463          	beqz	a0,80000738 <rt_hw_uart_start_rx_thread+0x80>
80000714:	00812403          	lw	s0,8(sp)
80000718:	00c12083          	lw	ra,12(sp)
8000071c:	07700613          	li	a2,119
80000720:	0000c597          	auipc	a1,0xc
80000724:	e5458593          	addi	a1,a1,-428 # 8000c574 <__FUNCTION__.3606>
80000728:	0000c517          	auipc	a0,0xc
8000072c:	dd850513          	addi	a0,a0,-552 # 8000c500 <__fsym___cmd_testapp_name+0xa4>
80000730:	01010113          	addi	sp,sp,16
80000734:	2b90106f          	j	800021ec <rt_assert_handler>
80000738:	00c12083          	lw	ra,12(sp)
8000073c:	00812403          	lw	s0,8(sp)
80000740:	01010113          	addi	sp,sp,16
80000744:	00008067          	ret

80000748 <rt_hw_uart_init>:
80000748:	ff010113          	addi	sp,sp,-16
8000074c:	0001c7b7          	lui	a5,0x1c
80000750:	00112623          	sw	ra,12(sp)
80000754:	91418513          	addi	a0,gp,-1772 # 80020374 <uart_device>
80000758:	20078793          	addi	a5,a5,512 # 1c200 <__HEAP_SIZE+0x1a200>
8000075c:	04f52a23          	sw	a5,84(a0)
80000760:	05852783          	lw	a5,88(a0)
80000764:	fc000737          	lui	a4,0xfc000
80000768:	3ff70713          	addi	a4,a4,1023 # fc0003ff <_sp+0x7bfc03ff>
8000076c:	ff07f793          	andi	a5,a5,-16
80000770:	0087e793          	ori	a5,a5,8
80000774:	04f52c23          	sw	a5,88(a0)
80000778:	05852783          	lw	a5,88(a0)
8000077c:	00000693          	li	a3,0
80000780:	10300613          	li	a2,259
80000784:	fcf7f793          	andi	a5,a5,-49
80000788:	0107e793          	ori	a5,a5,16
8000078c:	04f52c23          	sw	a5,88(a0)
80000790:	05852783          	lw	a5,88(a0)
80000794:	0000c597          	auipc	a1,0xc
80000798:	cd858593          	addi	a1,a1,-808 # 8000c46c <__fsym___cmd_testapp_name+0x10>
8000079c:	00e7f7b3          	and	a5,a5,a4
800007a0:	00200737          	lui	a4,0x200
800007a4:	00e7e7b3          	or	a5,a5,a4
800007a8:	04f52c23          	sw	a5,88(a0)
800007ac:	0000c797          	auipc	a5,0xc
800007b0:	df478793          	addi	a5,a5,-524 # 8000c5a0 <uart_ops>
800007b4:	04f52823          	sw	a5,80(a0)
800007b8:	9601ac23          	sw	zero,-1672(gp) # 800203d8 <uart_device+0x64>
800007bc:	7c8040ef          	jal	ra,80004f84 <rt_hw_serial_register>
800007c0:	02050263          	beqz	a0,800007e4 <rt_hw_uart_init+0x9c>
800007c4:	00c12083          	lw	ra,12(sp)
800007c8:	08900613          	li	a2,137
800007cc:	0000c597          	auipc	a1,0xc
800007d0:	dc458593          	addi	a1,a1,-572 # 8000c590 <__FUNCTION__.3615>
800007d4:	0000c517          	auipc	a0,0xc
800007d8:	d4c50513          	addi	a0,a0,-692 # 8000c520 <__fsym___cmd_testapp_name+0xc4>
800007dc:	01010113          	addi	sp,sp,16
800007e0:	20d0106f          	j	800021ec <rt_assert_handler>
800007e4:	00c12083          	lw	ra,12(sp)
800007e8:	01010113          	addi	sp,sp,16
800007ec:	00008067          	ret

800007f0 <send_char>:
800007f0:	80051073          	csrw	0x800,a0
800007f4:	00008067          	ret

800007f8 <rev_char>:
800007f8:	80002573          	csrr	a0,0x800
800007fc:	00008067          	ret

80000800 <rt_tick_get>:
80000800:	00020517          	auipc	a0,0x20
80000804:	a8852503          	lw	a0,-1400(a0) # 80020288 <rt_tick>
80000808:	00008067          	ret

8000080c <rt_tick_increase>:
8000080c:	00020717          	auipc	a4,0x20
80000810:	a7c70713          	addi	a4,a4,-1412 # 80020288 <rt_tick>
80000814:	00072783          	lw	a5,0(a4)
80000818:	ff010113          	addi	sp,sp,-16
8000081c:	00112623          	sw	ra,12(sp)
80000820:	00178793          	addi	a5,a5,1
80000824:	00f72023          	sw	a5,0(a4)
80000828:	409020ef          	jal	ra,80003430 <rt_thread_self>
8000082c:	05452783          	lw	a5,84(a0)
80000830:	fff78793          	addi	a5,a5,-1
80000834:	04f52a23          	sw	a5,84(a0)
80000838:	00079e63          	bnez	a5,80000854 <rt_tick_increase+0x48>
8000083c:	05052783          	lw	a5,80(a0)
80000840:	04f52a23          	sw	a5,84(a0)
80000844:	04054783          	lbu	a5,64(a0)
80000848:	0087e793          	ori	a5,a5,8
8000084c:	04f50023          	sb	a5,64(a0)
80000850:	698020ef          	jal	ra,80002ee8 <rt_schedule>
80000854:	00c12083          	lw	ra,12(sp)
80000858:	01010113          	addi	sp,sp,16
8000085c:	4b80306f          	j	80003d14 <rt_timer_check>

80000860 <rt_tick_from_millisecond>:
80000860:	02054663          	bltz	a0,8000088c <rt_tick_from_millisecond+0x2c>
80000864:	3e800713          	li	a4,1000
80000868:	02e547b3          	div	a5,a0,a4
8000086c:	06400693          	li	a3,100
80000870:	02e56533          	rem	a0,a0,a4
80000874:	02d50533          	mul	a0,a0,a3
80000878:	3e750513          	addi	a0,a0,999
8000087c:	02e54533          	div	a0,a0,a4
80000880:	02d787b3          	mul	a5,a5,a3
80000884:	00f50533          	add	a0,a0,a5
80000888:	00008067          	ret
8000088c:	fff00513          	li	a0,-1
80000890:	00008067          	ret

80000894 <rti_start>:
80000894:	00000513          	li	a0,0
80000898:	00008067          	ret

8000089c <rti_end>:
8000089c:	00000513          	li	a0,0
800008a0:	00008067          	ret

800008a4 <rti_board_start>:
800008a4:	00000513          	li	a0,0
800008a8:	00008067          	ret

800008ac <rti_board_end>:
800008ac:	00000513          	li	a0,0
800008b0:	00008067          	ret

800008b4 <rt_components_board_init>:
800008b4:	fe010113          	addi	sp,sp,-32
800008b8:	00812c23          	sw	s0,24(sp)
800008bc:	00912a23          	sw	s1,20(sp)
800008c0:	01212823          	sw	s2,16(sp)
800008c4:	01312623          	sw	s3,12(sp)
800008c8:	00112e23          	sw	ra,28(sp)
800008cc:	0000e417          	auipc	s0,0xe
800008d0:	02c40413          	addi	s0,s0,44 # 8000e8f8 <__rt_init_desc_rti_board_start>
800008d4:	0000e497          	auipc	s1,0xe
800008d8:	02c48493          	addi	s1,s1,44 # 8000e900 <__rt_init_desc_rti_board_end>
800008dc:	0000c917          	auipc	s2,0xc
800008e0:	cd890913          	addi	s2,s2,-808 # 8000c5b4 <uart_ops+0x14>
800008e4:	0000c997          	auipc	s3,0xc
800008e8:	ce098993          	addi	s3,s3,-800 # 8000c5c4 <uart_ops+0x24>
800008ec:	02946063          	bltu	s0,s1,8000090c <rt_components_board_init+0x58>
800008f0:	01c12083          	lw	ra,28(sp)
800008f4:	01812403          	lw	s0,24(sp)
800008f8:	01412483          	lw	s1,20(sp)
800008fc:	01012903          	lw	s2,16(sp)
80000900:	00c12983          	lw	s3,12(sp)
80000904:	02010113          	addi	sp,sp,32
80000908:	00008067          	ret
8000090c:	00042583          	lw	a1,0(s0)
80000910:	00090513          	mv	a0,s2
80000914:	00840413          	addi	s0,s0,8
80000918:	754010ef          	jal	ra,8000206c <rt_kprintf>
8000091c:	ffc42783          	lw	a5,-4(s0)
80000920:	000780e7          	jalr	a5
80000924:	00050593          	mv	a1,a0
80000928:	00098513          	mv	a0,s3
8000092c:	740010ef          	jal	ra,8000206c <rt_kprintf>
80000930:	fbdff06f          	j	800008ec <rt_components_board_init+0x38>

80000934 <rt_components_init>:
80000934:	fe010113          	addi	sp,sp,-32
80000938:	0000c517          	auipc	a0,0xc
8000093c:	c9850513          	addi	a0,a0,-872 # 8000c5d0 <uart_ops+0x30>
80000940:	00812c23          	sw	s0,24(sp)
80000944:	00912a23          	sw	s1,20(sp)
80000948:	01212823          	sw	s2,16(sp)
8000094c:	01312623          	sw	s3,12(sp)
80000950:	00112e23          	sw	ra,28(sp)
80000954:	0000e417          	auipc	s0,0xe
80000958:	fac40413          	addi	s0,s0,-84 # 8000e900 <__rt_init_desc_rti_board_end>
8000095c:	710010ef          	jal	ra,8000206c <rt_kprintf>
80000960:	0000e497          	auipc	s1,0xe
80000964:	fc048493          	addi	s1,s1,-64 # 8000e920 <__rt_init_desc_rti_end>
80000968:	0000c917          	auipc	s2,0xc
8000096c:	c4c90913          	addi	s2,s2,-948 # 8000c5b4 <uart_ops+0x14>
80000970:	0000c997          	auipc	s3,0xc
80000974:	c5498993          	addi	s3,s3,-940 # 8000c5c4 <uart_ops+0x24>
80000978:	02946063          	bltu	s0,s1,80000998 <rt_components_init+0x64>
8000097c:	01c12083          	lw	ra,28(sp)
80000980:	01812403          	lw	s0,24(sp)
80000984:	01412483          	lw	s1,20(sp)
80000988:	01012903          	lw	s2,16(sp)
8000098c:	00c12983          	lw	s3,12(sp)
80000990:	02010113          	addi	sp,sp,32
80000994:	00008067          	ret
80000998:	00042583          	lw	a1,0(s0)
8000099c:	00090513          	mv	a0,s2
800009a0:	00840413          	addi	s0,s0,8
800009a4:	6c8010ef          	jal	ra,8000206c <rt_kprintf>
800009a8:	ffc42783          	lw	a5,-4(s0)
800009ac:	000780e7          	jalr	a5
800009b0:	00050593          	mv	a1,a0
800009b4:	00098513          	mv	a0,s3
800009b8:	6b4010ef          	jal	ra,8000206c <rt_kprintf>
800009bc:	fbdff06f          	j	80000978 <rt_components_init+0x44>

800009c0 <main_thread_entry>:
800009c0:	ff010113          	addi	sp,sp,-16
800009c4:	00112623          	sw	ra,12(sp)
800009c8:	f6dff0ef          	jal	ra,80000934 <rt_components_init>
800009cc:	00c12083          	lw	ra,12(sp)
800009d0:	01010113          	addi	sp,sp,16
800009d4:	f6cff06f          	j	80000140 <main>

800009d8 <rt_application_init>:
800009d8:	ff010113          	addi	sp,sp,-16
800009dc:	01400793          	li	a5,20
800009e0:	00a00713          	li	a4,10
800009e4:	40000693          	li	a3,1024
800009e8:	00000613          	li	a2,0
800009ec:	00000597          	auipc	a1,0x0
800009f0:	fd458593          	addi	a1,a1,-44 # 800009c0 <main_thread_entry>
800009f4:	0000c517          	auipc	a0,0xc
800009f8:	bfc50513          	addi	a0,a0,-1028 # 8000c5f0 <uart_ops+0x50>
800009fc:	00812423          	sw	s0,8(sp)
80000a00:	00112623          	sw	ra,12(sp)
80000a04:	235020ef          	jal	ra,80003438 <rt_thread_create>
80000a08:	00050413          	mv	s0,a0
80000a0c:	00051e63          	bnez	a0,80000a28 <rt_application_init+0x50>
80000a10:	0c800613          	li	a2,200
80000a14:	0000c597          	auipc	a1,0xc
80000a18:	bf458593          	addi	a1,a1,-1036 # 8000c608 <__FUNCTION__.3078>
80000a1c:	0000c517          	auipc	a0,0xc
80000a20:	bdc50513          	addi	a0,a0,-1060 # 8000c5f8 <uart_ops+0x58>
80000a24:	7c8010ef          	jal	ra,800021ec <rt_assert_handler>
80000a28:	00040513          	mv	a0,s0
80000a2c:	00812403          	lw	s0,8(sp)
80000a30:	00c12083          	lw	ra,12(sp)
80000a34:	01010113          	addi	sp,sp,16
80000a38:	55d0206f          	j	80003794 <rt_thread_startup>

80000a3c <rtthread_startup>:
80000a3c:	ff010113          	addi	sp,sp,-16
80000a40:	00112623          	sw	ra,12(sp)
80000a44:	77c030ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
80000a48:	8f5ff0ef          	jal	ra,8000033c <rt_hw_board_init>
80000a4c:	6c8010ef          	jal	ra,80002114 <rt_show_version>
80000a50:	5d4030ef          	jal	ra,80004024 <rt_system_timer_init>
80000a54:	2e8020ef          	jal	ra,80002d3c <rt_system_scheduler_init>
80000a58:	f81ff0ef          	jal	ra,800009d8 <rt_application_init>
80000a5c:	5d8030ef          	jal	ra,80004034 <rt_system_timer_thread_init>
80000a60:	730000ef          	jal	ra,80001190 <rt_thread_idle_init>
80000a64:	434020ef          	jal	ra,80002e98 <rt_system_scheduler_start>
80000a68:	00c12083          	lw	ra,12(sp)
80000a6c:	00000513          	li	a0,0
80000a70:	01010113          	addi	sp,sp,16
80000a74:	00008067          	ret

80000a78 <entry>:
80000a78:	ff010113          	addi	sp,sp,-16
80000a7c:	00112623          	sw	ra,12(sp)
80000a80:	fbdff0ef          	jal	ra,80000a3c <rtthread_startup>
80000a84:	00c12083          	lw	ra,12(sp)
80000a88:	00000513          	li	a0,0
80000a8c:	01010113          	addi	sp,sp,16
80000a90:	00008067          	ret

80000a94 <rt_device_find>:
80000a94:	fe010113          	addi	sp,sp,-32
80000a98:	01312623          	sw	s3,12(sp)
80000a9c:	00112e23          	sw	ra,28(sp)
80000aa0:	00812c23          	sw	s0,24(sp)
80000aa4:	00912a23          	sw	s1,20(sp)
80000aa8:	01212823          	sw	s2,16(sp)
80000aac:	00050993          	mv	s3,a0
80000ab0:	181020ef          	jal	ra,80003430 <rt_thread_self>
80000ab4:	00050463          	beqz	a0,80000abc <rt_device_find+0x28>
80000ab8:	5d0020ef          	jal	ra,80003088 <rt_enter_critical>
80000abc:	00900513          	li	a0,9
80000ac0:	68d010ef          	jal	ra,8000294c <rt_object_get_information>
80000ac4:	00050493          	mv	s1,a0
80000ac8:	00051e63          	bnez	a0,80000ae4 <rt_device_find+0x50>
80000acc:	07c00613          	li	a2,124
80000ad0:	0000c597          	auipc	a1,0xc
80000ad4:	c5058593          	addi	a1,a1,-944 # 8000c720 <__FUNCTION__.2964>
80000ad8:	0000c517          	auipc	a0,0xc
80000adc:	be450513          	addi	a0,a0,-1052 # 8000c6bc <__rti_rti_start_name+0x80>
80000ae0:	70c010ef          	jal	ra,800021ec <rt_assert_handler>
80000ae4:	0044a903          	lw	s2,4(s1)
80000ae8:	00448493          	addi	s1,s1,4
80000aec:	00991e63          	bne	s2,s1,80000b08 <rt_device_find+0x74>
80000af0:	141020ef          	jal	ra,80003430 <rt_thread_self>
80000af4:	00050413          	mv	s0,a0
80000af8:	02050a63          	beqz	a0,80000b2c <rt_device_find+0x98>
80000afc:	5b4020ef          	jal	ra,800030b0 <rt_exit_critical>
80000b00:	00000413          	li	s0,0
80000b04:	0280006f          	j	80000b2c <rt_device_find+0x98>
80000b08:	fe890413          	addi	s0,s2,-24
80000b0c:	01400613          	li	a2,20
80000b10:	00098593          	mv	a1,s3
80000b14:	00040513          	mv	a0,s0
80000b18:	755000ef          	jal	ra,80001a6c <rt_strncmp>
80000b1c:	02051863          	bnez	a0,80000b4c <rt_device_find+0xb8>
80000b20:	111020ef          	jal	ra,80003430 <rt_thread_self>
80000b24:	00050463          	beqz	a0,80000b2c <rt_device_find+0x98>
80000b28:	588020ef          	jal	ra,800030b0 <rt_exit_critical>
80000b2c:	01c12083          	lw	ra,28(sp)
80000b30:	00040513          	mv	a0,s0
80000b34:	01812403          	lw	s0,24(sp)
80000b38:	01412483          	lw	s1,20(sp)
80000b3c:	01012903          	lw	s2,16(sp)
80000b40:	00c12983          	lw	s3,12(sp)
80000b44:	02010113          	addi	sp,sp,32
80000b48:	00008067          	ret
80000b4c:	00092903          	lw	s2,0(s2)
80000b50:	f9dff06f          	j	80000aec <rt_device_find+0x58>

80000b54 <rt_device_register>:
80000b54:	02051463          	bnez	a0,80000b7c <rt_device_register+0x28>
80000b58:	fff00513          	li	a0,-1
80000b5c:	00008067          	ret
80000b60:	fff00513          	li	a0,-1
80000b64:	00c12083          	lw	ra,12(sp)
80000b68:	00812403          	lw	s0,8(sp)
80000b6c:	00412483          	lw	s1,4(sp)
80000b70:	00012903          	lw	s2,0(sp)
80000b74:	01010113          	addi	sp,sp,16
80000b78:	00008067          	ret
80000b7c:	ff010113          	addi	sp,sp,-16
80000b80:	00812423          	sw	s0,8(sp)
80000b84:	00050413          	mv	s0,a0
80000b88:	00058513          	mv	a0,a1
80000b8c:	00912223          	sw	s1,4(sp)
80000b90:	01212023          	sw	s2,0(sp)
80000b94:	00112623          	sw	ra,12(sp)
80000b98:	00058493          	mv	s1,a1
80000b9c:	00060913          	mv	s2,a2
80000ba0:	ef5ff0ef          	jal	ra,80000a94 <rt_device_find>
80000ba4:	fa051ee3          	bnez	a0,80000b60 <rt_device_register+0xc>
80000ba8:	00040513          	mv	a0,s0
80000bac:	00048613          	mv	a2,s1
80000bb0:	00900593          	li	a1,9
80000bb4:	5d5010ef          	jal	ra,80002988 <rt_object_init>
80000bb8:	00000513          	li	a0,0
80000bbc:	03241223          	sh	s2,36(s0)
80000bc0:	02040423          	sb	zero,40(s0)
80000bc4:	02041323          	sh	zero,38(s0)
80000bc8:	f9dff06f          	j	80000b64 <rt_device_register+0x10>

80000bcc <rt_device_open>:
80000bcc:	ff010113          	addi	sp,sp,-16
80000bd0:	00812423          	sw	s0,8(sp)
80000bd4:	01212023          	sw	s2,0(sp)
80000bd8:	00112623          	sw	ra,12(sp)
80000bdc:	00912223          	sw	s1,4(sp)
80000be0:	00050413          	mv	s0,a0
80000be4:	00058913          	mv	s2,a1
80000be8:	00051e63          	bnez	a0,80000c04 <rt_device_open+0x38>
80000bec:	0f400613          	li	a2,244
80000bf0:	0000c597          	auipc	a1,0xc
80000bf4:	b4058593          	addi	a1,a1,-1216 # 8000c730 <__FUNCTION__.2988>
80000bf8:	0000c517          	auipc	a0,0xc
80000bfc:	a5050513          	addi	a0,a0,-1456 # 8000c648 <__rti_rti_start_name+0xc>
80000c00:	5ec010ef          	jal	ra,800021ec <rt_assert_handler>
80000c04:	00040513          	mv	a0,s0
80000c08:	0f0020ef          	jal	ra,80002cf8 <rt_object_get_type>
80000c0c:	00900793          	li	a5,9
80000c10:	00f50e63          	beq	a0,a5,80000c2c <rt_device_open+0x60>
80000c14:	0f500613          	li	a2,245
80000c18:	0000c597          	auipc	a1,0xc
80000c1c:	b1858593          	addi	a1,a1,-1256 # 8000c730 <__FUNCTION__.2988>
80000c20:	0000c517          	auipc	a0,0xc
80000c24:	a3850513          	addi	a0,a0,-1480 # 8000c658 <__rti_rti_start_name+0x1c>
80000c28:	5c4010ef          	jal	ra,800021ec <rt_assert_handler>
80000c2c:	02445783          	lhu	a5,36(s0)
80000c30:	0107f793          	andi	a5,a5,16
80000c34:	04079c63          	bnez	a5,80000c8c <rt_device_open+0xc0>
80000c38:	03442783          	lw	a5,52(s0)
80000c3c:	04078263          	beqz	a5,80000c80 <rt_device_open+0xb4>
80000c40:	00040513          	mv	a0,s0
80000c44:	000780e7          	jalr	a5
80000c48:	00050493          	mv	s1,a0
80000c4c:	02050a63          	beqz	a0,80000c80 <rt_device_open+0xb4>
80000c50:	00050613          	mv	a2,a0
80000c54:	00040593          	mv	a1,s0
80000c58:	0000c517          	auipc	a0,0xc
80000c5c:	a7c50513          	addi	a0,a0,-1412 # 8000c6d4 <__rti_rti_start_name+0x98>
80000c60:	40c010ef          	jal	ra,8000206c <rt_kprintf>
80000c64:	00c12083          	lw	ra,12(sp)
80000c68:	00812403          	lw	s0,8(sp)
80000c6c:	00012903          	lw	s2,0(sp)
80000c70:	00048513          	mv	a0,s1
80000c74:	00412483          	lw	s1,4(sp)
80000c78:	01010113          	addi	sp,sp,16
80000c7c:	00008067          	ret
80000c80:	02445783          	lhu	a5,36(s0)
80000c84:	0107e793          	ori	a5,a5,16
80000c88:	02f41223          	sh	a5,36(s0)
80000c8c:	02445783          	lhu	a5,36(s0)
80000c90:	0087f793          	andi	a5,a5,8
80000c94:	00078a63          	beqz	a5,80000ca8 <rt_device_open+0xdc>
80000c98:	02645783          	lhu	a5,38(s0)
80000c9c:	ff900493          	li	s1,-7
80000ca0:	0087f793          	andi	a5,a5,8
80000ca4:	fc0790e3          	bnez	a5,80000c64 <rt_device_open+0x98>
80000ca8:	03842783          	lw	a5,56(s0)
80000cac:	04078a63          	beqz	a5,80000d00 <rt_device_open+0x134>
80000cb0:	00090593          	mv	a1,s2
80000cb4:	00040513          	mv	a0,s0
80000cb8:	000780e7          	jalr	a5
80000cbc:	00050493          	mv	s1,a0
80000cc0:	04051c63          	bnez	a0,80000d18 <rt_device_open+0x14c>
80000cc4:	02645783          	lhu	a5,38(s0)
80000cc8:	0087e793          	ori	a5,a5,8
80000ccc:	02f41323          	sh	a5,38(s0)
80000cd0:	02844783          	lbu	a5,40(s0)
80000cd4:	00178793          	addi	a5,a5,1
80000cd8:	0ff7f793          	andi	a5,a5,255
80000cdc:	02f40423          	sb	a5,40(s0)
80000ce0:	f80792e3          	bnez	a5,80000c64 <rt_device_open+0x98>
80000ce4:	12300613          	li	a2,291
80000ce8:	0000c597          	auipc	a1,0xc
80000cec:	a4858593          	addi	a1,a1,-1464 # 8000c730 <__FUNCTION__.2988>
80000cf0:	0000c517          	auipc	a0,0xc
80000cf4:	a1c50513          	addi	a0,a0,-1508 # 8000c70c <__rti_rti_start_name+0xd0>
80000cf8:	4f4010ef          	jal	ra,800021ec <rt_assert_handler>
80000cfc:	f69ff06f          	j	80000c64 <rt_device_open+0x98>
80000d00:	000015b7          	lui	a1,0x1
80000d04:	f0f58593          	addi	a1,a1,-241 # f0f <__HEAP_SIZE-0x10f1>
80000d08:	00b97933          	and	s2,s2,a1
80000d0c:	03241323          	sh	s2,38(s0)
80000d10:	00000493          	li	s1,0
80000d14:	fb1ff06f          	j	80000cc4 <rt_device_open+0xf8>
80000d18:	ffa00793          	li	a5,-6
80000d1c:	f4f514e3          	bne	a0,a5,80000c64 <rt_device_open+0x98>
80000d20:	fa5ff06f          	j	80000cc4 <rt_device_open+0xf8>

80000d24 <rt_device_close>:
80000d24:	ff010113          	addi	sp,sp,-16
80000d28:	00812423          	sw	s0,8(sp)
80000d2c:	00112623          	sw	ra,12(sp)
80000d30:	00050413          	mv	s0,a0
80000d34:	00051e63          	bnez	a0,80000d50 <rt_device_close+0x2c>
80000d38:	13500613          	li	a2,309
80000d3c:	0000c597          	auipc	a1,0xc
80000d40:	a0458593          	addi	a1,a1,-1532 # 8000c740 <__FUNCTION__.2993>
80000d44:	0000c517          	auipc	a0,0xc
80000d48:	90450513          	addi	a0,a0,-1788 # 8000c648 <__rti_rti_start_name+0xc>
80000d4c:	4a0010ef          	jal	ra,800021ec <rt_assert_handler>
80000d50:	00040513          	mv	a0,s0
80000d54:	7a5010ef          	jal	ra,80002cf8 <rt_object_get_type>
80000d58:	00900793          	li	a5,9
80000d5c:	00f50e63          	beq	a0,a5,80000d78 <rt_device_close+0x54>
80000d60:	13600613          	li	a2,310
80000d64:	0000c597          	auipc	a1,0xc
80000d68:	9dc58593          	addi	a1,a1,-1572 # 8000c740 <__FUNCTION__.2993>
80000d6c:	0000c517          	auipc	a0,0xc
80000d70:	8ec50513          	addi	a0,a0,-1812 # 8000c658 <__rti_rti_start_name+0x1c>
80000d74:	478010ef          	jal	ra,800021ec <rt_assert_handler>
80000d78:	02844783          	lbu	a5,40(s0)
80000d7c:	fff00513          	li	a0,-1
80000d80:	04078063          	beqz	a5,80000dc0 <rt_device_close+0x9c>
80000d84:	fff78793          	addi	a5,a5,-1
80000d88:	0ff7f793          	andi	a5,a5,255
80000d8c:	02f40423          	sb	a5,40(s0)
80000d90:	00000513          	li	a0,0
80000d94:	02079663          	bnez	a5,80000dc0 <rt_device_close+0x9c>
80000d98:	03c42783          	lw	a5,60(s0)
80000d9c:	00079863          	bnez	a5,80000dac <rt_device_close+0x88>
80000da0:	00000513          	li	a0,0
80000da4:	02041323          	sh	zero,38(s0)
80000da8:	0180006f          	j	80000dc0 <rt_device_close+0x9c>
80000dac:	00040513          	mv	a0,s0
80000db0:	000780e7          	jalr	a5
80000db4:	fe0506e3          	beqz	a0,80000da0 <rt_device_close+0x7c>
80000db8:	ffa00793          	li	a5,-6
80000dbc:	fef504e3          	beq	a0,a5,80000da4 <rt_device_close+0x80>
80000dc0:	00c12083          	lw	ra,12(sp)
80000dc4:	00812403          	lw	s0,8(sp)
80000dc8:	01010113          	addi	sp,sp,16
80000dcc:	00008067          	ret

80000dd0 <rt_device_read>:
80000dd0:	fe010113          	addi	sp,sp,-32
80000dd4:	00812c23          	sw	s0,24(sp)
80000dd8:	00912a23          	sw	s1,20(sp)
80000ddc:	01212823          	sw	s2,16(sp)
80000de0:	01312623          	sw	s3,12(sp)
80000de4:	00112e23          	sw	ra,28(sp)
80000de8:	00050413          	mv	s0,a0
80000dec:	00058493          	mv	s1,a1
80000df0:	00060913          	mv	s2,a2
80000df4:	00068993          	mv	s3,a3
80000df8:	00051e63          	bnez	a0,80000e14 <rt_device_read+0x44>
80000dfc:	15f00613          	li	a2,351
80000e00:	0000c597          	auipc	a1,0xc
80000e04:	95058593          	addi	a1,a1,-1712 # 8000c750 <__FUNCTION__.3000>
80000e08:	0000c517          	auipc	a0,0xc
80000e0c:	84050513          	addi	a0,a0,-1984 # 8000c648 <__rti_rti_start_name+0xc>
80000e10:	3dc010ef          	jal	ra,800021ec <rt_assert_handler>
80000e14:	00040513          	mv	a0,s0
80000e18:	6e1010ef          	jal	ra,80002cf8 <rt_object_get_type>
80000e1c:	00900793          	li	a5,9
80000e20:	00f50e63          	beq	a0,a5,80000e3c <rt_device_read+0x6c>
80000e24:	16000613          	li	a2,352
80000e28:	0000c597          	auipc	a1,0xc
80000e2c:	92858593          	addi	a1,a1,-1752 # 8000c750 <__FUNCTION__.3000>
80000e30:	0000c517          	auipc	a0,0xc
80000e34:	82850513          	addi	a0,a0,-2008 # 8000c658 <__rti_rti_start_name+0x1c>
80000e38:	3b4010ef          	jal	ra,800021ec <rt_assert_handler>
80000e3c:	02844783          	lbu	a5,40(s0)
80000e40:	fff00513          	li	a0,-1
80000e44:	02078e63          	beqz	a5,80000e80 <rt_device_read+0xb0>
80000e48:	04042303          	lw	t1,64(s0)
80000e4c:	02030863          	beqz	t1,80000e7c <rt_device_read+0xac>
80000e50:	00040513          	mv	a0,s0
80000e54:	01812403          	lw	s0,24(sp)
80000e58:	01c12083          	lw	ra,28(sp)
80000e5c:	00098693          	mv	a3,s3
80000e60:	00090613          	mv	a2,s2
80000e64:	00c12983          	lw	s3,12(sp)
80000e68:	01012903          	lw	s2,16(sp)
80000e6c:	00048593          	mv	a1,s1
80000e70:	01412483          	lw	s1,20(sp)
80000e74:	02010113          	addi	sp,sp,32
80000e78:	00030067          	jr	t1
80000e7c:	ffa00513          	li	a0,-6
80000e80:	249000ef          	jal	ra,800018c8 <rt_set_errno>
80000e84:	01c12083          	lw	ra,28(sp)
80000e88:	01812403          	lw	s0,24(sp)
80000e8c:	01412483          	lw	s1,20(sp)
80000e90:	01012903          	lw	s2,16(sp)
80000e94:	00c12983          	lw	s3,12(sp)
80000e98:	00000513          	li	a0,0
80000e9c:	02010113          	addi	sp,sp,32
80000ea0:	00008067          	ret

80000ea4 <rt_device_write>:
80000ea4:	fe010113          	addi	sp,sp,-32
80000ea8:	00812c23          	sw	s0,24(sp)
80000eac:	00912a23          	sw	s1,20(sp)
80000eb0:	01212823          	sw	s2,16(sp)
80000eb4:	01312623          	sw	s3,12(sp)
80000eb8:	00112e23          	sw	ra,28(sp)
80000ebc:	00050413          	mv	s0,a0
80000ec0:	00058493          	mv	s1,a1
80000ec4:	00060913          	mv	s2,a2
80000ec8:	00068993          	mv	s3,a3
80000ecc:	00051e63          	bnez	a0,80000ee8 <rt_device_write+0x44>
80000ed0:	18600613          	li	a2,390
80000ed4:	0000c597          	auipc	a1,0xc
80000ed8:	88c58593          	addi	a1,a1,-1908 # 8000c760 <__FUNCTION__.3007>
80000edc:	0000b517          	auipc	a0,0xb
80000ee0:	76c50513          	addi	a0,a0,1900 # 8000c648 <__rti_rti_start_name+0xc>
80000ee4:	308010ef          	jal	ra,800021ec <rt_assert_handler>
80000ee8:	00040513          	mv	a0,s0
80000eec:	60d010ef          	jal	ra,80002cf8 <rt_object_get_type>
80000ef0:	00900793          	li	a5,9
80000ef4:	00f50e63          	beq	a0,a5,80000f10 <rt_device_write+0x6c>
80000ef8:	18700613          	li	a2,391
80000efc:	0000c597          	auipc	a1,0xc
80000f00:	86458593          	addi	a1,a1,-1948 # 8000c760 <__FUNCTION__.3007>
80000f04:	0000b517          	auipc	a0,0xb
80000f08:	75450513          	addi	a0,a0,1876 # 8000c658 <__rti_rti_start_name+0x1c>
80000f0c:	2e0010ef          	jal	ra,800021ec <rt_assert_handler>
80000f10:	02844783          	lbu	a5,40(s0)
80000f14:	fff00513          	li	a0,-1
80000f18:	02078e63          	beqz	a5,80000f54 <rt_device_write+0xb0>
80000f1c:	04442303          	lw	t1,68(s0)
80000f20:	02030863          	beqz	t1,80000f50 <rt_device_write+0xac>
80000f24:	00040513          	mv	a0,s0
80000f28:	01812403          	lw	s0,24(sp)
80000f2c:	01c12083          	lw	ra,28(sp)
80000f30:	00098693          	mv	a3,s3
80000f34:	00090613          	mv	a2,s2
80000f38:	00c12983          	lw	s3,12(sp)
80000f3c:	01012903          	lw	s2,16(sp)
80000f40:	00048593          	mv	a1,s1
80000f44:	01412483          	lw	s1,20(sp)
80000f48:	02010113          	addi	sp,sp,32
80000f4c:	00030067          	jr	t1
80000f50:	ffa00513          	li	a0,-6
80000f54:	175000ef          	jal	ra,800018c8 <rt_set_errno>
80000f58:	01c12083          	lw	ra,28(sp)
80000f5c:	01812403          	lw	s0,24(sp)
80000f60:	01412483          	lw	s1,20(sp)
80000f64:	01012903          	lw	s2,16(sp)
80000f68:	00c12983          	lw	s3,12(sp)
80000f6c:	00000513          	li	a0,0
80000f70:	02010113          	addi	sp,sp,32
80000f74:	00008067          	ret

80000f78 <rt_device_set_rx_indicate>:
80000f78:	ff010113          	addi	sp,sp,-16
80000f7c:	00812423          	sw	s0,8(sp)
80000f80:	00912223          	sw	s1,4(sp)
80000f84:	00112623          	sw	ra,12(sp)
80000f88:	00050413          	mv	s0,a0
80000f8c:	00058493          	mv	s1,a1
80000f90:	00051e63          	bnez	a0,80000fac <rt_device_set_rx_indicate+0x34>
80000f94:	1c100613          	li	a2,449
80000f98:	0000b597          	auipc	a1,0xb
80000f9c:	7d858593          	addi	a1,a1,2008 # 8000c770 <__FUNCTION__.3020>
80000fa0:	0000b517          	auipc	a0,0xb
80000fa4:	6a850513          	addi	a0,a0,1704 # 8000c648 <__rti_rti_start_name+0xc>
80000fa8:	244010ef          	jal	ra,800021ec <rt_assert_handler>
80000fac:	00040513          	mv	a0,s0
80000fb0:	549010ef          	jal	ra,80002cf8 <rt_object_get_type>
80000fb4:	00900793          	li	a5,9
80000fb8:	00f50e63          	beq	a0,a5,80000fd4 <rt_device_set_rx_indicate+0x5c>
80000fbc:	1c200613          	li	a2,450
80000fc0:	0000b597          	auipc	a1,0xb
80000fc4:	7b058593          	addi	a1,a1,1968 # 8000c770 <__FUNCTION__.3020>
80000fc8:	0000b517          	auipc	a0,0xb
80000fcc:	69050513          	addi	a0,a0,1680 # 8000c658 <__rti_rti_start_name+0x1c>
80000fd0:	21c010ef          	jal	ra,800021ec <rt_assert_handler>
80000fd4:	02942623          	sw	s1,44(s0)
80000fd8:	00c12083          	lw	ra,12(sp)
80000fdc:	00812403          	lw	s0,8(sp)
80000fe0:	00412483          	lw	s1,4(sp)
80000fe4:	00000513          	li	a0,0
80000fe8:	01010113          	addi	sp,sp,16
80000fec:	00008067          	ret

80000ff0 <rt_thread_idle_excute>:
80000ff0:	fd010113          	addi	sp,sp,-48
80000ff4:	01412c23          	sw	s4,24(sp)
80000ff8:	88818a13          	addi	s4,gp,-1912 # 800202e8 <rt_thread_defunct>
80000ffc:	02912223          	sw	s1,36(sp)
80001000:	01512a23          	sw	s5,20(sp)
80001004:	01612823          	sw	s6,16(sp)
80001008:	01712623          	sw	s7,12(sp)
8000100c:	01812423          	sw	s8,8(sp)
80001010:	02112623          	sw	ra,44(sp)
80001014:	02812423          	sw	s0,40(sp)
80001018:	03212023          	sw	s2,32(sp)
8000101c:	01312e23          	sw	s3,28(sp)
80001020:	000a0493          	mv	s1,s4
80001024:	0000ba97          	auipc	s5,0xb
80001028:	79ca8a93          	addi	s5,s5,1948 # 8000c7c0 <__FUNCTION__.3055>
8000102c:	0000bb17          	auipc	s6,0xb
80001030:	760b0b13          	addi	s6,s6,1888 # 8000c78c <__FUNCTION__.3020+0x1c>
80001034:	0000bb97          	auipc	s7,0xb
80001038:	780b8b93          	addi	s7,s7,1920 # 8000c7b4 <__FUNCTION__.3020+0x44>
8000103c:	00100c13          	li	s8,1
80001040:	000a2783          	lw	a5,0(s4)
80001044:	02979a63          	bne	a5,s1,80001078 <rt_thread_idle_excute+0x88>
80001048:	02c12083          	lw	ra,44(sp)
8000104c:	02812403          	lw	s0,40(sp)
80001050:	02412483          	lw	s1,36(sp)
80001054:	02012903          	lw	s2,32(sp)
80001058:	01c12983          	lw	s3,28(sp)
8000105c:	01812a03          	lw	s4,24(sp)
80001060:	01412a83          	lw	s5,20(sp)
80001064:	01012b03          	lw	s6,16(sp)
80001068:	00c12b83          	lw	s7,12(sp)
8000106c:	00812c03          	lw	s8,8(sp)
80001070:	03010113          	addi	sp,sp,48
80001074:	00008067          	ret
80001078:	148030ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
8000107c:	00050413          	mv	s0,a0
80001080:	60c000ef          	jal	ra,8000168c <rt_interrupt_get_nest>
80001084:	02050063          	beqz	a0,800010a4 <rt_thread_idle_excute+0xb4>
80001088:	000a8593          	mv	a1,s5
8000108c:	000b0513          	mv	a0,s6
80001090:	7dd000ef          	jal	ra,8000206c <rt_kprintf>
80001094:	0a000613          	li	a2,160
80001098:	000a8593          	mv	a1,s5
8000109c:	000b8513          	mv	a0,s7
800010a0:	14c010ef          	jal	ra,800021ec <rt_assert_handler>
800010a4:	00040513          	mv	a0,s0
800010a8:	120030ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
800010ac:	114030ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
800010b0:	0004a783          	lw	a5,0(s1)
800010b4:	00050993          	mv	s3,a0
800010b8:	04978a63          	beq	a5,s1,8000110c <rt_thread_idle_excute+0x11c>
800010bc:	0004a403          	lw	s0,0(s1)
800010c0:	00442783          	lw	a5,4(s0)
800010c4:	00042703          	lw	a4,0(s0)
800010c8:	fe040913          	addi	s2,s0,-32
800010cc:	00f72223          	sw	a5,4(a4)
800010d0:	00e7a023          	sw	a4,0(a5)
800010d4:	00842223          	sw	s0,4(s0)
800010d8:	00842023          	sw	s0,0(s0)
800010dc:	7ad010ef          	jal	ra,80003088 <rt_enter_critical>
800010e0:	07042783          	lw	a5,112(s0)
800010e4:	00078663          	beqz	a5,800010f0 <rt_thread_idle_excute+0x100>
800010e8:	00090513          	mv	a0,s2
800010ec:	000780e7          	jalr	a5
800010f0:	00090513          	mv	a0,s2
800010f4:	3c1010ef          	jal	ra,80002cb4 <rt_object_is_systemobject>
800010f8:	05851263          	bne	a0,s8,8000113c <rt_thread_idle_excute+0x14c>
800010fc:	00090513          	mv	a0,s2
80001100:	199010ef          	jal	ra,80002a98 <rt_object_detach>
80001104:	7ad010ef          	jal	ra,800030b0 <rt_exit_critical>
80001108:	00098513          	mv	a0,s3
8000110c:	02812403          	lw	s0,40(sp)
80001110:	02c12083          	lw	ra,44(sp)
80001114:	02412483          	lw	s1,36(sp)
80001118:	02012903          	lw	s2,32(sp)
8000111c:	01c12983          	lw	s3,28(sp)
80001120:	01812a03          	lw	s4,24(sp)
80001124:	01412a83          	lw	s5,20(sp)
80001128:	01012b03          	lw	s6,16(sp)
8000112c:	00c12b83          	lw	s7,12(sp)
80001130:	00812c03          	lw	s8,8(sp)
80001134:	03010113          	addi	sp,sp,48
80001138:	0900306f          	j	800041c8 <rt_hw_interrupt_enable>
8000113c:	775010ef          	jal	ra,800030b0 <rt_exit_critical>
80001140:	00098513          	mv	a0,s3
80001144:	084030ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
80001148:	01442503          	lw	a0,20(s0)
8000114c:	638010ef          	jal	ra,80002784 <rt_free>
80001150:	00090513          	mv	a0,s2
80001154:	2c9010ef          	jal	ra,80002c1c <rt_object_delete>
80001158:	ee9ff06f          	j	80001040 <rt_thread_idle_excute+0x50>

8000115c <rt_thread_idle_entry>:
8000115c:	ff010113          	addi	sp,sp,-16
80001160:	00912223          	sw	s1,4(sp)
80001164:	00112623          	sw	ra,12(sp)
80001168:	00812423          	sw	s0,8(sp)
8000116c:	a2418493          	addi	s1,gp,-1500 # 80020484 <rt_thread_stack>
80001170:	a1418413          	addi	s0,gp,-1516 # 80020474 <idle_hook_list>
80001174:	00042783          	lw	a5,0(s0)
80001178:	00078463          	beqz	a5,80001180 <rt_thread_idle_entry+0x24>
8000117c:	000780e7          	jalr	a5
80001180:	00440413          	addi	s0,s0,4
80001184:	fe9418e3          	bne	s0,s1,80001174 <rt_thread_idle_entry+0x18>
80001188:	e69ff0ef          	jal	ra,80000ff0 <rt_thread_idle_excute>
8000118c:	fe5ff06f          	j	80001170 <rt_thread_idle_entry+0x14>

80001190 <rt_thread_idle_init>:
80001190:	fd010113          	addi	sp,sp,-48
80001194:	00000613          	li	a2,0
80001198:	0000b597          	auipc	a1,0xb
8000119c:	62058593          	addi	a1,a1,1568 # 8000c7b8 <__FUNCTION__.3020+0x48>
800011a0:	00c10513          	addi	a0,sp,12
800011a4:	02112623          	sw	ra,44(sp)
800011a8:	02812423          	sw	s0,40(sp)
800011ac:	615000ef          	jal	ra,80001fc0 <rt_sprintf>
800011b0:	97c18413          	addi	s0,gp,-1668 # 800203dc <idle>
800011b4:	00c10593          	addi	a1,sp,12
800011b8:	02000893          	li	a7,32
800011bc:	01f00813          	li	a6,31
800011c0:	18c00793          	li	a5,396
800011c4:	a2418713          	addi	a4,gp,-1500 # 80020484 <rt_thread_stack>
800011c8:	00000693          	li	a3,0
800011cc:	00000617          	auipc	a2,0x0
800011d0:	f9060613          	addi	a2,a2,-112 # 8000115c <rt_thread_idle_entry>
800011d4:	00040513          	mv	a0,s0
800011d8:	180020ef          	jal	ra,80003358 <rt_thread_init>
800011dc:	00040513          	mv	a0,s0
800011e0:	5b4020ef          	jal	ra,80003794 <rt_thread_startup>
800011e4:	02c12083          	lw	ra,44(sp)
800011e8:	02812403          	lw	s0,40(sp)
800011ec:	03010113          	addi	sp,sp,48
800011f0:	00008067          	ret

800011f4 <rt_ipc_list_resume.isra.0>:
800011f4:	ff010113          	addi	sp,sp,-16
800011f8:	fe050513          	addi	a0,a0,-32
800011fc:	00112623          	sw	ra,12(sp)
80001200:	4c0020ef          	jal	ra,800036c0 <rt_thread_resume>
80001204:	00c12083          	lw	ra,12(sp)
80001208:	00000513          	li	a0,0
8000120c:	01010113          	addi	sp,sp,16
80001210:	00008067          	ret

80001214 <rt_ipc_list_suspend>:
80001214:	ff010113          	addi	sp,sp,-16
80001218:	00912223          	sw	s1,4(sp)
8000121c:	01212023          	sw	s2,0(sp)
80001220:	00050493          	mv	s1,a0
80001224:	00060913          	mv	s2,a2
80001228:	00058513          	mv	a0,a1
8000122c:	00812423          	sw	s0,8(sp)
80001230:	00112623          	sw	ra,12(sp)
80001234:	00058413          	mv	s0,a1
80001238:	2ac020ef          	jal	ra,800034e4 <rt_thread_suspend>
8000123c:	02090463          	beqz	s2,80001264 <rt_ipc_list_suspend+0x50>
80001240:	00100793          	li	a5,1
80001244:	02f90e63          	beq	s2,a5,80001280 <rt_ipc_list_suspend+0x6c>
80001248:	00c12083          	lw	ra,12(sp)
8000124c:	00812403          	lw	s0,8(sp)
80001250:	00412483          	lw	s1,4(sp)
80001254:	00012903          	lw	s2,0(sp)
80001258:	00000513          	li	a0,0
8000125c:	01010113          	addi	sp,sp,16
80001260:	00008067          	ret
80001264:	0044a703          	lw	a4,4(s1)
80001268:	02040793          	addi	a5,s0,32
8000126c:	00f72023          	sw	a5,0(a4)
80001270:	02e42223          	sw	a4,36(s0)
80001274:	00f4a223          	sw	a5,4(s1)
80001278:	02942023          	sw	s1,32(s0)
8000127c:	fcdff06f          	j	80001248 <rt_ipc_list_suspend+0x34>
80001280:	0004a783          	lw	a5,0(s1)
80001284:	00978863          	beq	a5,s1,80001294 <rt_ipc_list_suspend+0x80>
80001288:	04144683          	lbu	a3,65(s0)
8000128c:	0217c703          	lbu	a4,33(a5)
80001290:	02e6f063          	bgeu	a3,a4,800012b0 <rt_ipc_list_suspend+0x9c>
80001294:	0047a683          	lw	a3,4(a5)
80001298:	02040713          	addi	a4,s0,32
8000129c:	00e6a023          	sw	a4,0(a3) # 2000 <__HEAP_SIZE>
800012a0:	02d42223          	sw	a3,36(s0)
800012a4:	00e7a223          	sw	a4,4(a5)
800012a8:	02f42023          	sw	a5,32(s0)
800012ac:	f9dff06f          	j	80001248 <rt_ipc_list_suspend+0x34>
800012b0:	0007a783          	lw	a5,0(a5)
800012b4:	fd1ff06f          	j	80001284 <rt_ipc_list_suspend+0x70>

800012b8 <rt_sem_init>:
800012b8:	fe010113          	addi	sp,sp,-32
800012bc:	00812c23          	sw	s0,24(sp)
800012c0:	00912a23          	sw	s1,20(sp)
800012c4:	01212823          	sw	s2,16(sp)
800012c8:	01312623          	sw	s3,12(sp)
800012cc:	00112e23          	sw	ra,28(sp)
800012d0:	00050413          	mv	s0,a0
800012d4:	00058993          	mv	s3,a1
800012d8:	00060493          	mv	s1,a2
800012dc:	00068913          	mv	s2,a3
800012e0:	00051e63          	bnez	a0,800012fc <rt_sem_init+0x44>
800012e4:	0d200613          	li	a2,210
800012e8:	0000b597          	auipc	a1,0xb
800012ec:	5c458593          	addi	a1,a1,1476 # 8000c8ac <__FUNCTION__.3061>
800012f0:	0000b517          	auipc	a0,0xb
800012f4:	4e850513          	addi	a0,a0,1256 # 8000c7d8 <__FUNCTION__.3055+0x18>
800012f8:	6f5000ef          	jal	ra,800021ec <rt_assert_handler>
800012fc:	000107b7          	lui	a5,0x10
80001300:	00f4ee63          	bltu	s1,a5,8000131c <rt_sem_init+0x64>
80001304:	0d300613          	li	a2,211
80001308:	0000b597          	auipc	a1,0xb
8000130c:	5a458593          	addi	a1,a1,1444 # 8000c8ac <__FUNCTION__.3061>
80001310:	0000b517          	auipc	a0,0xb
80001314:	4d850513          	addi	a0,a0,1240 # 8000c7e8 <__FUNCTION__.3055+0x28>
80001318:	6d5000ef          	jal	ra,800021ec <rt_assert_handler>
8000131c:	00040513          	mv	a0,s0
80001320:	00098613          	mv	a2,s3
80001324:	00200593          	li	a1,2
80001328:	660010ef          	jal	ra,80002988 <rt_object_init>
8000132c:	02040793          	addi	a5,s0,32
80001330:	02941423          	sh	s1,40(s0)
80001334:	01240aa3          	sb	s2,21(s0)
80001338:	01c12083          	lw	ra,28(sp)
8000133c:	02f42223          	sw	a5,36(s0)
80001340:	02f42023          	sw	a5,32(s0)
80001344:	01812403          	lw	s0,24(sp)
80001348:	01412483          	lw	s1,20(sp)
8000134c:	01012903          	lw	s2,16(sp)
80001350:	00c12983          	lw	s3,12(sp)
80001354:	00000513          	li	a0,0
80001358:	02010113          	addi	sp,sp,32
8000135c:	00008067          	ret

80001360 <rt_sem_take>:
80001360:	fd010113          	addi	sp,sp,-48
80001364:	02812423          	sw	s0,40(sp)
80001368:	02112623          	sw	ra,44(sp)
8000136c:	02912223          	sw	s1,36(sp)
80001370:	03212023          	sw	s2,32(sp)
80001374:	01312e23          	sw	s3,28(sp)
80001378:	00b12623          	sw	a1,12(sp)
8000137c:	00050413          	mv	s0,a0
80001380:	00051e63          	bnez	a0,8000139c <rt_sem_take+0x3c>
80001384:	15000613          	li	a2,336
80001388:	0000b597          	auipc	a1,0xb
8000138c:	53058593          	addi	a1,a1,1328 # 8000c8b8 <__FUNCTION__.3085>
80001390:	0000b517          	auipc	a0,0xb
80001394:	44850513          	addi	a0,a0,1096 # 8000c7d8 <__FUNCTION__.3055+0x18>
80001398:	655000ef          	jal	ra,800021ec <rt_assert_handler>
8000139c:	00040513          	mv	a0,s0
800013a0:	159010ef          	jal	ra,80002cf8 <rt_object_get_type>
800013a4:	00200793          	li	a5,2
800013a8:	00f50e63          	beq	a0,a5,800013c4 <rt_sem_take+0x64>
800013ac:	15100613          	li	a2,337
800013b0:	0000b597          	auipc	a1,0xb
800013b4:	50858593          	addi	a1,a1,1288 # 8000c8b8 <__FUNCTION__.3085>
800013b8:	0000b517          	auipc	a0,0xb
800013bc:	44450513          	addi	a0,a0,1092 # 8000c7fc <__FUNCTION__.3055+0x3c>
800013c0:	62d000ef          	jal	ra,800021ec <rt_assert_handler>
800013c4:	8741a783          	lw	a5,-1932(gp) # 800202d4 <rt_object_trytake_hook>
800013c8:	00078663          	beqz	a5,800013d4 <rt_sem_take+0x74>
800013cc:	00040513          	mv	a0,s0
800013d0:	000780e7          	jalr	a5 # 10000 <__HEAP_SIZE+0xe000>
800013d4:	5ed020ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
800013d8:	02845783          	lhu	a5,40(s0)
800013dc:	00050993          	mv	s3,a0
800013e0:	02078663          	beqz	a5,8000140c <rt_sem_take+0xac>
800013e4:	fff78793          	addi	a5,a5,-1
800013e8:	02f41423          	sh	a5,40(s0)
800013ec:	5dd020ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
800013f0:	8701a783          	lw	a5,-1936(gp) # 800202d0 <rt_object_take_hook>
800013f4:	00000513          	li	a0,0
800013f8:	02078263          	beqz	a5,8000141c <rt_sem_take+0xbc>
800013fc:	00040513          	mv	a0,s0
80001400:	000780e7          	jalr	a5
80001404:	00000513          	li	a0,0
80001408:	0140006f          	j	8000141c <rt_sem_take+0xbc>
8000140c:	00c12783          	lw	a5,12(sp)
80001410:	02079463          	bnez	a5,80001438 <rt_sem_take+0xd8>
80001414:	5b5020ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
80001418:	ffe00513          	li	a0,-2
8000141c:	02c12083          	lw	ra,44(sp)
80001420:	02812403          	lw	s0,40(sp)
80001424:	02412483          	lw	s1,36(sp)
80001428:	02012903          	lw	s2,32(sp)
8000142c:	01c12983          	lw	s3,28(sp)
80001430:	03010113          	addi	sp,sp,48
80001434:	00008067          	ret
80001438:	589020ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
8000143c:	00050493          	mv	s1,a0
80001440:	7f1010ef          	jal	ra,80003430 <rt_thread_self>
80001444:	02051863          	bnez	a0,80001474 <rt_sem_take+0x114>
80001448:	0000b597          	auipc	a1,0xb
8000144c:	47058593          	addi	a1,a1,1136 # 8000c8b8 <__FUNCTION__.3085>
80001450:	0000b517          	auipc	a0,0xb
80001454:	42450513          	addi	a0,a0,1060 # 8000c874 <__FUNCTION__.3055+0xb4>
80001458:	415000ef          	jal	ra,8000206c <rt_kprintf>
8000145c:	17100613          	li	a2,369
80001460:	0000b597          	auipc	a1,0xb
80001464:	45858593          	addi	a1,a1,1112 # 8000c8b8 <__FUNCTION__.3085>
80001468:	0000b517          	auipc	a0,0xb
8000146c:	34c50513          	addi	a0,a0,844 # 8000c7b4 <__FUNCTION__.3020+0x44>
80001470:	57d000ef          	jal	ra,800021ec <rt_assert_handler>
80001474:	54d020ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
80001478:	00050913          	mv	s2,a0
8000147c:	210000ef          	jal	ra,8000168c <rt_interrupt_get_nest>
80001480:	02050863          	beqz	a0,800014b0 <rt_sem_take+0x150>
80001484:	0000b597          	auipc	a1,0xb
80001488:	43458593          	addi	a1,a1,1076 # 8000c8b8 <__FUNCTION__.3085>
8000148c:	0000b517          	auipc	a0,0xb
80001490:	30050513          	addi	a0,a0,768 # 8000c78c <__FUNCTION__.3020+0x1c>
80001494:	3d9000ef          	jal	ra,8000206c <rt_kprintf>
80001498:	17100613          	li	a2,369
8000149c:	0000b597          	auipc	a1,0xb
800014a0:	41c58593          	addi	a1,a1,1052 # 8000c8b8 <__FUNCTION__.3085>
800014a4:	0000b517          	auipc	a0,0xb
800014a8:	31050513          	addi	a0,a0,784 # 8000c7b4 <__FUNCTION__.3020+0x44>
800014ac:	541000ef          	jal	ra,800021ec <rt_assert_handler>
800014b0:	00090513          	mv	a0,s2
800014b4:	515020ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
800014b8:	00048513          	mv	a0,s1
800014bc:	50d020ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
800014c0:	771010ef          	jal	ra,80003430 <rt_thread_self>
800014c4:	02052e23          	sw	zero,60(a0)
800014c8:	01544603          	lbu	a2,21(s0)
800014cc:	00050593          	mv	a1,a0
800014d0:	00050493          	mv	s1,a0
800014d4:	02040513          	addi	a0,s0,32
800014d8:	d3dff0ef          	jal	ra,80001214 <rt_ipc_list_suspend>
800014dc:	00c12783          	lw	a5,12(sp)
800014e0:	02f05063          	blez	a5,80001500 <rt_sem_take+0x1a0>
800014e4:	05848913          	addi	s2,s1,88
800014e8:	00c10613          	addi	a2,sp,12
800014ec:	00000593          	li	a1,0
800014f0:	00090513          	mv	a0,s2
800014f4:	728020ef          	jal	ra,80003c1c <rt_timer_control>
800014f8:	00090513          	mv	a0,s2
800014fc:	4e0020ef          	jal	ra,800039dc <rt_timer_start>
80001500:	00098513          	mv	a0,s3
80001504:	4c5020ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
80001508:	1e1010ef          	jal	ra,80002ee8 <rt_schedule>
8000150c:	03c4a503          	lw	a0,60(s1)
80001510:	ee0500e3          	beqz	a0,800013f0 <rt_sem_take+0x90>
80001514:	f09ff06f          	j	8000141c <rt_sem_take+0xbc>

80001518 <rt_sem_trytake>:
80001518:	00000593          	li	a1,0
8000151c:	e45ff06f          	j	80001360 <rt_sem_take>

80001520 <rt_sem_release>:
80001520:	ff010113          	addi	sp,sp,-16
80001524:	00812423          	sw	s0,8(sp)
80001528:	00112623          	sw	ra,12(sp)
8000152c:	00912223          	sw	s1,4(sp)
80001530:	00050413          	mv	s0,a0
80001534:	00051e63          	bnez	a0,80001550 <rt_sem_release+0x30>
80001538:	1bd00613          	li	a2,445
8000153c:	0000b597          	auipc	a1,0xb
80001540:	38858593          	addi	a1,a1,904 # 8000c8c4 <__FUNCTION__.3096>
80001544:	0000b517          	auipc	a0,0xb
80001548:	29450513          	addi	a0,a0,660 # 8000c7d8 <__FUNCTION__.3055+0x18>
8000154c:	4a1000ef          	jal	ra,800021ec <rt_assert_handler>
80001550:	00040513          	mv	a0,s0
80001554:	7a4010ef          	jal	ra,80002cf8 <rt_object_get_type>
80001558:	00200793          	li	a5,2
8000155c:	00f50e63          	beq	a0,a5,80001578 <rt_sem_release+0x58>
80001560:	1be00613          	li	a2,446
80001564:	0000b597          	auipc	a1,0xb
80001568:	36058593          	addi	a1,a1,864 # 8000c8c4 <__FUNCTION__.3096>
8000156c:	0000b517          	auipc	a0,0xb
80001570:	29050513          	addi	a0,a0,656 # 8000c7fc <__FUNCTION__.3055+0x3c>
80001574:	479000ef          	jal	ra,800021ec <rt_assert_handler>
80001578:	86c1a783          	lw	a5,-1940(gp) # 800202cc <rt_object_put_hook>
8000157c:	00078663          	beqz	a5,80001588 <rt_sem_release+0x68>
80001580:	00040513          	mv	a0,s0
80001584:	000780e7          	jalr	a5
80001588:	439020ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
8000158c:	02042783          	lw	a5,32(s0)
80001590:	02040713          	addi	a4,s0,32
80001594:	00050493          	mv	s1,a0
80001598:	02e78663          	beq	a5,a4,800015c4 <rt_sem_release+0xa4>
8000159c:	00078513          	mv	a0,a5
800015a0:	c55ff0ef          	jal	ra,800011f4 <rt_ipc_list_resume.isra.0>
800015a4:	00100413          	li	s0,1
800015a8:	00048513          	mv	a0,s1
800015ac:	41d020ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
800015b0:	00100793          	li	a5,1
800015b4:	02f41c63          	bne	s0,a5,800015ec <rt_sem_release+0xcc>
800015b8:	131010ef          	jal	ra,80002ee8 <rt_schedule>
800015bc:	00000413          	li	s0,0
800015c0:	02c0006f          	j	800015ec <rt_sem_release+0xcc>
800015c4:	02845783          	lhu	a5,40(s0)
800015c8:	00010737          	lui	a4,0x10
800015cc:	fff70713          	addi	a4,a4,-1 # ffff <__HEAP_SIZE+0xdfff>
800015d0:	00e78a63          	beq	a5,a4,800015e4 <rt_sem_release+0xc4>
800015d4:	00178793          	addi	a5,a5,1
800015d8:	02f41423          	sh	a5,40(s0)
800015dc:	00000413          	li	s0,0
800015e0:	fc9ff06f          	j	800015a8 <rt_sem_release+0x88>
800015e4:	3e5020ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
800015e8:	ffd00413          	li	s0,-3
800015ec:	00c12083          	lw	ra,12(sp)
800015f0:	00040513          	mv	a0,s0
800015f4:	00812403          	lw	s0,8(sp)
800015f8:	00412483          	lw	s1,4(sp)
800015fc:	01010113          	addi	sp,sp,16
80001600:	00008067          	ret

80001604 <rt_interrupt_enter>:
80001604:	fe010113          	addi	sp,sp,-32
80001608:	00112e23          	sw	ra,28(sp)
8000160c:	3b5020ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
80001610:	0001f797          	auipc	a5,0x1f
80001614:	c847c783          	lbu	a5,-892(a5) # 80020294 <rt_interrupt_nest>
80001618:	00178793          	addi	a5,a5,1
8000161c:	0001f717          	auipc	a4,0x1f
80001620:	c6f70c23          	sb	a5,-904(a4) # 80020294 <rt_interrupt_nest>
80001624:	0001f797          	auipc	a5,0x1f
80001628:	c687a783          	lw	a5,-920(a5) # 8002028c <rt_interrupt_enter_hook>
8000162c:	00078863          	beqz	a5,8000163c <rt_interrupt_enter+0x38>
80001630:	00a12623          	sw	a0,12(sp)
80001634:	000780e7          	jalr	a5
80001638:	00c12503          	lw	a0,12(sp)
8000163c:	01c12083          	lw	ra,28(sp)
80001640:	02010113          	addi	sp,sp,32
80001644:	3850206f          	j	800041c8 <rt_hw_interrupt_enable>

80001648 <rt_interrupt_leave>:
80001648:	fe010113          	addi	sp,sp,-32
8000164c:	00112e23          	sw	ra,28(sp)
80001650:	371020ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
80001654:	0001f797          	auipc	a5,0x1f
80001658:	c407c783          	lbu	a5,-960(a5) # 80020294 <rt_interrupt_nest>
8000165c:	fff78793          	addi	a5,a5,-1
80001660:	0001f717          	auipc	a4,0x1f
80001664:	c2f70a23          	sb	a5,-972(a4) # 80020294 <rt_interrupt_nest>
80001668:	0001f797          	auipc	a5,0x1f
8000166c:	c287a783          	lw	a5,-984(a5) # 80020290 <rt_interrupt_leave_hook>
80001670:	00078863          	beqz	a5,80001680 <rt_interrupt_leave+0x38>
80001674:	00a12623          	sw	a0,12(sp)
80001678:	000780e7          	jalr	a5
8000167c:	00c12503          	lw	a0,12(sp)
80001680:	01c12083          	lw	ra,28(sp)
80001684:	02010113          	addi	sp,sp,32
80001688:	3410206f          	j	800041c8 <rt_hw_interrupt_enable>

8000168c <rt_interrupt_get_nest>:
8000168c:	ff010113          	addi	sp,sp,-16
80001690:	00112623          	sw	ra,12(sp)
80001694:	00812423          	sw	s0,8(sp)
80001698:	329020ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
8000169c:	0001f417          	auipc	s0,0x1f
800016a0:	bf844403          	lbu	s0,-1032(s0) # 80020294 <rt_interrupt_nest>
800016a4:	325020ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
800016a8:	00c12083          	lw	ra,12(sp)
800016ac:	00040513          	mv	a0,s0
800016b0:	00812403          	lw	s0,8(sp)
800016b4:	01010113          	addi	sp,sp,16
800016b8:	00008067          	ret

800016bc <print_number>:
800016bc:	04087893          	andi	a7,a6,64
800016c0:	ff010113          	addi	sp,sp,-16
800016c4:	0000b297          	auipc	t0,0xb
800016c8:	44428293          	addi	t0,t0,1092 # 8000cb08 <small_digits.3193>
800016cc:	00088663          	beqz	a7,800016d8 <print_number+0x1c>
800016d0:	0000b297          	auipc	t0,0xb
800016d4:	42428293          	addi	t0,t0,1060 # 8000caf4 <large_digits.3194>
800016d8:	01087f93          	andi	t6,a6,16
800016dc:	040f8a63          	beqz	t6,80001730 <print_number+0x74>
800016e0:	ffe87813          	andi	a6,a6,-2
800016e4:	02000e13          	li	t3,32
800016e8:	00287893          	andi	a7,a6,2
800016ec:	0e088c63          	beqz	a7,800017e4 <print_number+0x128>
800016f0:	04065a63          	bgez	a2,80001744 <print_number+0x88>
800016f4:	40c00633          	neg	a2,a2
800016f8:	02d00893          	li	a7,45
800016fc:	00010f13          	mv	t5,sp
80001700:	00000e93          	li	t4,0
80001704:	00a00393          	li	t2,10
80001708:	0e769263          	bne	a3,t2,800017ec <print_number+0x130>
8000170c:	02d67333          	remu	t1,a2,a3
80001710:	02d65633          	divu	a2,a2,a3
80001714:	00628333          	add	t1,t0,t1
80001718:	00034303          	lbu	t1,0(t1)
8000171c:	001e8e93          	addi	t4,t4,1
80001720:	001f0f13          	addi	t5,t5,1
80001724:	fe6f0fa3          	sb	t1,-1(t5)
80001728:	fe0610e3          	bnez	a2,80001708 <print_number+0x4c>
8000172c:	0400006f          	j	8000176c <print_number+0xb0>
80001730:	00187893          	andi	a7,a6,1
80001734:	02000e13          	li	t3,32
80001738:	fa0888e3          	beqz	a7,800016e8 <print_number+0x2c>
8000173c:	03000e13          	li	t3,48
80001740:	fa9ff06f          	j	800016e8 <print_number+0x2c>
80001744:	00487313          	andi	t1,a6,4
80001748:	02b00893          	li	a7,43
8000174c:	00031863          	bnez	t1,8000175c <print_number+0xa0>
80001750:	00887893          	andi	a7,a6,8
80001754:	011038b3          	snez	a7,a7
80001758:	00589893          	slli	a7,a7,0x5
8000175c:	fa0610e3          	bnez	a2,800016fc <print_number+0x40>
80001760:	03000693          	li	a3,48
80001764:	00d10023          	sb	a3,0(sp)
80001768:	00100e93          	li	t4,1
8000176c:	000e8613          	mv	a2,t4
80001770:	00fed463          	bge	t4,a5,80001778 <print_number+0xbc>
80001774:	00078613          	mv	a2,a5
80001778:	01187813          	andi	a6,a6,17
8000177c:	40c70733          	sub	a4,a4,a2
80001780:	02081e63          	bnez	a6,800017bc <print_number+0x100>
80001784:	00088663          	beqz	a7,80001790 <print_number+0xd4>
80001788:	00e05463          	blez	a4,80001790 <print_number+0xd4>
8000178c:	fff70713          	addi	a4,a4,-1
80001790:	00050813          	mv	a6,a0
80001794:	00e50333          	add	t1,a0,a4
80001798:	02000f13          	li	t5,32
8000179c:	410306b3          	sub	a3,t1,a6
800017a0:	04d04c63          	bgtz	a3,800017f8 <print_number+0x13c>
800017a4:	00070813          	mv	a6,a4
800017a8:	00075463          	bgez	a4,800017b0 <print_number+0xf4>
800017ac:	00000813          	li	a6,0
800017b0:	fff70713          	addi	a4,a4,-1
800017b4:	01050533          	add	a0,a0,a6
800017b8:	41070733          	sub	a4,a4,a6
800017bc:	00088a63          	beqz	a7,800017d0 <print_number+0x114>
800017c0:	00b57463          	bgeu	a0,a1,800017c8 <print_number+0x10c>
800017c4:	01150023          	sb	a7,0(a0)
800017c8:	fff70713          	addi	a4,a4,-1
800017cc:	00150513          	addi	a0,a0,1
800017d0:	060f8463          	beqz	t6,80001838 <print_number+0x17c>
800017d4:	00050813          	mv	a6,a0
800017d8:	00c508b3          	add	a7,a0,a2
800017dc:	03000313          	li	t1,48
800017e0:	0700006f          	j	80001850 <print_number+0x194>
800017e4:	00000893          	li	a7,0
800017e8:	f75ff06f          	j	8000175c <print_number+0xa0>
800017ec:	00f67313          	andi	t1,a2,15
800017f0:	00465613          	srli	a2,a2,0x4
800017f4:	f21ff06f          	j	80001714 <print_number+0x58>
800017f8:	00b87463          	bgeu	a6,a1,80001800 <print_number+0x144>
800017fc:	01e80023          	sb	t5,0(a6)
80001800:	00180813          	addi	a6,a6,1
80001804:	f99ff06f          	j	8000179c <print_number+0xe0>
80001808:	00b87463          	bgeu	a6,a1,80001810 <print_number+0x154>
8000180c:	01c80023          	sb	t3,0(a6)
80001810:	00180813          	addi	a6,a6,1
80001814:	410886b3          	sub	a3,a7,a6
80001818:	fed048e3          	bgtz	a3,80001808 <print_number+0x14c>
8000181c:	00070813          	mv	a6,a4
80001820:	00075463          	bgez	a4,80001828 <print_number+0x16c>
80001824:	00000813          	li	a6,0
80001828:	fff70713          	addi	a4,a4,-1
8000182c:	01050533          	add	a0,a0,a6
80001830:	41070733          	sub	a4,a4,a6
80001834:	fa1ff06f          	j	800017d4 <print_number+0x118>
80001838:	00050813          	mv	a6,a0
8000183c:	00e508b3          	add	a7,a0,a4
80001840:	fd5ff06f          	j	80001814 <print_number+0x158>
80001844:	00b87463          	bgeu	a6,a1,8000184c <print_number+0x190>
80001848:	00680023          	sb	t1,0(a6)
8000184c:	00180813          	addi	a6,a6,1
80001850:	410886b3          	sub	a3,a7,a6
80001854:	fedec8e3          	blt	t4,a3,80001844 <print_number+0x188>
80001858:	00000693          	li	a3,0
8000185c:	01d64463          	blt	a2,t4,80001864 <print_number+0x1a8>
80001860:	41d606b3          	sub	a3,a2,t4
80001864:	00d506b3          	add	a3,a0,a3
80001868:	fff00613          	li	a2,-1
8000186c:	fffe8e93          	addi	t4,t4,-1
80001870:	00ce8463          	beq	t4,a2,80001878 <print_number+0x1bc>
80001874:	00079a63          	bnez	a5,80001888 <print_number+0x1cc>
80001878:	00068793          	mv	a5,a3
8000187c:	00e68533          	add	a0,a3,a4
80001880:	02000813          	li	a6,32
80001884:	0280006f          	j	800018ac <print_number+0x1f0>
80001888:	00b6f863          	bgeu	a3,a1,80001898 <print_number+0x1dc>
8000188c:	01d10533          	add	a0,sp,t4
80001890:	00054503          	lbu	a0,0(a0)
80001894:	00a68023          	sb	a0,0(a3)
80001898:	00168693          	addi	a3,a3,1
8000189c:	fd1ff06f          	j	8000186c <print_number+0x1b0>
800018a0:	00b7f463          	bgeu	a5,a1,800018a8 <print_number+0x1ec>
800018a4:	01078023          	sb	a6,0(a5)
800018a8:	00178793          	addi	a5,a5,1
800018ac:	40f50633          	sub	a2,a0,a5
800018b0:	fec048e3          	bgtz	a2,800018a0 <print_number+0x1e4>
800018b4:	00075463          	bgez	a4,800018bc <print_number+0x200>
800018b8:	00000713          	li	a4,0
800018bc:	00e68533          	add	a0,a3,a4
800018c0:	01010113          	addi	sp,sp,16
800018c4:	00008067          	ret

800018c8 <rt_set_errno>:
800018c8:	ff010113          	addi	sp,sp,-16
800018cc:	00812423          	sw	s0,8(sp)
800018d0:	00112623          	sw	ra,12(sp)
800018d4:	00050413          	mv	s0,a0
800018d8:	db5ff0ef          	jal	ra,8000168c <rt_interrupt_get_nest>
800018dc:	00050e63          	beqz	a0,800018f8 <rt_set_errno+0x30>
800018e0:	0001f797          	auipc	a5,0x1f
800018e4:	9a87ac23          	sw	s0,-1608(a5) # 80020298 <__rt_errno>
800018e8:	00c12083          	lw	ra,12(sp)
800018ec:	00812403          	lw	s0,8(sp)
800018f0:	01010113          	addi	sp,sp,16
800018f4:	00008067          	ret
800018f8:	339010ef          	jal	ra,80003430 <rt_thread_self>
800018fc:	fe0502e3          	beqz	a0,800018e0 <rt_set_errno+0x18>
80001900:	02852e23          	sw	s0,60(a0)
80001904:	fe5ff06f          	j	800018e8 <rt_set_errno+0x20>

80001908 <rt_memset>:
80001908:	00300713          	li	a4,3
8000190c:	00050793          	mv	a5,a0
80001910:	00c77863          	bgeu	a4,a2,80001920 <rt_memset+0x18>
80001914:	00357793          	andi	a5,a0,3
80001918:	00078a63          	beqz	a5,8000192c <rt_memset+0x24>
8000191c:	00050793          	mv	a5,a0
80001920:	00c78633          	add	a2,a5,a2
80001924:	08c79e63          	bne	a5,a2,800019c0 <rt_memset+0xb8>
80001928:	00008067          	ret
8000192c:	0ff5f793          	andi	a5,a1,255
80001930:	00879713          	slli	a4,a5,0x8
80001934:	00f767b3          	or	a5,a4,a5
80001938:	01079713          	slli	a4,a5,0x10
8000193c:	00f76733          	or	a4,a4,a5
80001940:	00c508b3          	add	a7,a0,a2
80001944:	00050793          	mv	a5,a0
80001948:	00f00693          	li	a3,15
8000194c:	40f88833          	sub	a6,a7,a5
80001950:	0506e663          	bltu	a3,a6,8000199c <rt_memset+0x94>
80001954:	00465793          	srli	a5,a2,0x4
80001958:	ff000693          	li	a3,-16
8000195c:	02d786b3          	mul	a3,a5,a3
80001960:	00479793          	slli	a5,a5,0x4
80001964:	00f507b3          	add	a5,a0,a5
80001968:	00300813          	li	a6,3
8000196c:	00c68633          	add	a2,a3,a2
80001970:	00c78333          	add	t1,a5,a2
80001974:	00078693          	mv	a3,a5
80001978:	40d308b3          	sub	a7,t1,a3
8000197c:	03186c63          	bltu	a6,a7,800019b4 <rt_memset+0xac>
80001980:	00265713          	srli	a4,a2,0x2
80001984:	ffc00693          	li	a3,-4
80001988:	02d706b3          	mul	a3,a4,a3
8000198c:	00271713          	slli	a4,a4,0x2
80001990:	00e787b3          	add	a5,a5,a4
80001994:	00c68633          	add	a2,a3,a2
80001998:	f89ff06f          	j	80001920 <rt_memset+0x18>
8000199c:	00e7a023          	sw	a4,0(a5)
800019a0:	00e7a223          	sw	a4,4(a5)
800019a4:	00e7a423          	sw	a4,8(a5)
800019a8:	00e7a623          	sw	a4,12(a5)
800019ac:	01078793          	addi	a5,a5,16
800019b0:	f9dff06f          	j	8000194c <rt_memset+0x44>
800019b4:	00468693          	addi	a3,a3,4
800019b8:	fee6ae23          	sw	a4,-4(a3)
800019bc:	fbdff06f          	j	80001978 <rt_memset+0x70>
800019c0:	00178793          	addi	a5,a5,1
800019c4:	feb78fa3          	sb	a1,-1(a5)
800019c8:	f5dff06f          	j	80001924 <rt_memset+0x1c>

800019cc <rt_memmove>:
800019cc:	04a5fa63          	bgeu	a1,a0,80001a20 <rt_memmove+0x54>
800019d0:	00c586b3          	add	a3,a1,a2
800019d4:	04d57663          	bgeu	a0,a3,80001a20 <rt_memmove+0x54>
800019d8:	fff64593          	not	a1,a2
800019dc:	00000793          	li	a5,0
800019e0:	fff78793          	addi	a5,a5,-1
800019e4:	00f59463          	bne	a1,a5,800019ec <rt_memmove+0x20>
800019e8:	00008067          	ret
800019ec:	00f68733          	add	a4,a3,a5
800019f0:	00074803          	lbu	a6,0(a4)
800019f4:	00f60733          	add	a4,a2,a5
800019f8:	00e50733          	add	a4,a0,a4
800019fc:	01070023          	sb	a6,0(a4)
80001a00:	fe1ff06f          	j	800019e0 <rt_memmove+0x14>
80001a04:	00f58733          	add	a4,a1,a5
80001a08:	00074683          	lbu	a3,0(a4)
80001a0c:	00f50733          	add	a4,a0,a5
80001a10:	00178793          	addi	a5,a5,1
80001a14:	00d70023          	sb	a3,0(a4)
80001a18:	fef616e3          	bne	a2,a5,80001a04 <rt_memmove+0x38>
80001a1c:	00008067          	ret
80001a20:	00000793          	li	a5,0
80001a24:	ff5ff06f          	j	80001a18 <rt_memmove+0x4c>

80001a28 <rt_strncpy>:
80001a28:	04060063          	beqz	a2,80001a68 <rt_strncpy+0x40>
80001a2c:	00050793          	mv	a5,a0
80001a30:	0005c683          	lbu	a3,0(a1)
80001a34:	00158593          	addi	a1,a1,1
80001a38:	00178793          	addi	a5,a5,1
80001a3c:	fed78fa3          	sb	a3,-1(a5)
80001a40:	00060713          	mv	a4,a2
80001a44:	fff60613          	addi	a2,a2,-1
80001a48:	00069e63          	bnez	a3,80001a64 <rt_strncpy+0x3c>
80001a4c:	00e78733          	add	a4,a5,a4
80001a50:	00178793          	addi	a5,a5,1
80001a54:	00e79463          	bne	a5,a4,80001a5c <rt_strncpy+0x34>
80001a58:	00008067          	ret
80001a5c:	fe078fa3          	sb	zero,-1(a5)
80001a60:	ff1ff06f          	j	80001a50 <rt_strncpy+0x28>
80001a64:	fc0616e3          	bnez	a2,80001a30 <rt_strncpy+0x8>
80001a68:	00008067          	ret

80001a6c <rt_strncmp>:
80001a6c:	00050693          	mv	a3,a0
80001a70:	00000713          	li	a4,0
80001a74:	00e61663          	bne	a2,a4,80001a80 <rt_strncmp+0x14>
80001a78:	00000513          	li	a0,0
80001a7c:	02c0006f          	j	80001aa8 <rt_strncmp+0x3c>
80001a80:	00e687b3          	add	a5,a3,a4
80001a84:	0007c803          	lbu	a6,0(a5)
80001a88:	00e587b3          	add	a5,a1,a4
80001a8c:	0007c783          	lbu	a5,0(a5)
80001a90:	40f807b3          	sub	a5,a6,a5
80001a94:	01879513          	slli	a0,a5,0x18
80001a98:	41855513          	srai	a0,a0,0x18
80001a9c:	00051663          	bnez	a0,80001aa8 <rt_strncmp+0x3c>
80001aa0:	00170713          	addi	a4,a4,1
80001aa4:	fc0818e3          	bnez	a6,80001a74 <rt_strncmp+0x8>
80001aa8:	00008067          	ret

80001aac <rt_strlen>:
80001aac:	00050793          	mv	a5,a0
80001ab0:	0007c703          	lbu	a4,0(a5)
80001ab4:	00071663          	bnez	a4,80001ac0 <rt_strlen+0x14>
80001ab8:	40a78533          	sub	a0,a5,a0
80001abc:	00008067          	ret
80001ac0:	00178793          	addi	a5,a5,1
80001ac4:	fedff06f          	j	80001ab0 <rt_strlen+0x4>

80001ac8 <rt_vsnprintf>:
80001ac8:	fc010113          	addi	sp,sp,-64
80001acc:	02912a23          	sw	s1,52(sp)
80001ad0:	01712e23          	sw	s7,28(sp)
80001ad4:	01812c23          	sw	s8,24(sp)
80001ad8:	02112e23          	sw	ra,60(sp)
80001adc:	02812c23          	sw	s0,56(sp)
80001ae0:	03212823          	sw	s2,48(sp)
80001ae4:	03312623          	sw	s3,44(sp)
80001ae8:	03412423          	sw	s4,40(sp)
80001aec:	03512223          	sw	s5,36(sp)
80001af0:	03612023          	sw	s6,32(sp)
80001af4:	01912a23          	sw	s9,20(sp)
80001af8:	01a12823          	sw	s10,16(sp)
80001afc:	00b50bb3          	add	s7,a0,a1
80001b00:	00050c13          	mv	s8,a0
80001b04:	00068893          	mv	a7,a3
80001b08:	00058493          	mv	s1,a1
80001b0c:	00abf663          	bgeu	s7,a0,80001b18 <rt_vsnprintf+0x50>
80001b10:	fff54493          	not	s1,a0
80001b14:	fff00b93          	li	s7,-1
80001b18:	00010937          	lui	s2,0x10
80001b1c:	000c0413          	mv	s0,s8
80001b20:	02b00993          	li	s3,43
80001b24:	02000a13          	li	s4,32
80001b28:	02300a93          	li	s5,35
80001b2c:	fff90913          	addi	s2,s2,-1 # ffff <__HEAP_SIZE+0xdfff>
80001b30:	0240006f          	j	80001b54 <rt_vsnprintf+0x8c>
80001b34:	02500713          	li	a4,37
80001b38:	06e78663          	beq	a5,a4,80001ba4 <rt_vsnprintf+0xdc>
80001b3c:	01747463          	bgeu	s0,s7,80001b44 <rt_vsnprintf+0x7c>
80001b40:	00f40023          	sb	a5,0(s0)
80001b44:	00140513          	addi	a0,s0,1
80001b48:	00060b13          	mv	s6,a2
80001b4c:	001b0613          	addi	a2,s6,1
80001b50:	00050413          	mv	s0,a0
80001b54:	00064783          	lbu	a5,0(a2)
80001b58:	fc079ee3          	bnez	a5,80001b34 <rt_vsnprintf+0x6c>
80001b5c:	00048663          	beqz	s1,80001b68 <rt_vsnprintf+0xa0>
80001b60:	45747463          	bgeu	s0,s7,80001fa8 <rt_vsnprintf+0x4e0>
80001b64:	00040023          	sb	zero,0(s0)
80001b68:	41840533          	sub	a0,s0,s8
80001b6c:	03c12083          	lw	ra,60(sp)
80001b70:	03812403          	lw	s0,56(sp)
80001b74:	03412483          	lw	s1,52(sp)
80001b78:	03012903          	lw	s2,48(sp)
80001b7c:	02c12983          	lw	s3,44(sp)
80001b80:	02812a03          	lw	s4,40(sp)
80001b84:	02412a83          	lw	s5,36(sp)
80001b88:	02012b03          	lw	s6,32(sp)
80001b8c:	01c12b83          	lw	s7,28(sp)
80001b90:	01812c03          	lw	s8,24(sp)
80001b94:	01412c83          	lw	s9,20(sp)
80001b98:	01012d03          	lw	s10,16(sp)
80001b9c:	04010113          	addi	sp,sp,64
80001ba0:	00008067          	ret
80001ba4:	00000813          	li	a6,0
80001ba8:	02d00713          	li	a4,45
80001bac:	03000693          	li	a3,48
80001bb0:	0100006f          	j	80001bc0 <rt_vsnprintf+0xf8>
80001bb4:	03379063          	bne	a5,s3,80001bd4 <rt_vsnprintf+0x10c>
80001bb8:	00486813          	ori	a6,a6,4
80001bbc:	000b0613          	mv	a2,s6
80001bc0:	00164783          	lbu	a5,1(a2)
80001bc4:	00160b13          	addi	s6,a2,1
80001bc8:	fee796e3          	bne	a5,a4,80001bb4 <rt_vsnprintf+0xec>
80001bcc:	01086813          	ori	a6,a6,16
80001bd0:	fedff06f          	j	80001bbc <rt_vsnprintf+0xf4>
80001bd4:	01479663          	bne	a5,s4,80001be0 <rt_vsnprintf+0x118>
80001bd8:	00886813          	ori	a6,a6,8
80001bdc:	fe1ff06f          	j	80001bbc <rt_vsnprintf+0xf4>
80001be0:	01579663          	bne	a5,s5,80001bec <rt_vsnprintf+0x124>
80001be4:	02086813          	ori	a6,a6,32
80001be8:	fd5ff06f          	j	80001bbc <rt_vsnprintf+0xf4>
80001bec:	00d79663          	bne	a5,a3,80001bf8 <rt_vsnprintf+0x130>
80001bf0:	00186813          	ori	a6,a6,1
80001bf4:	fc9ff06f          	j	80001bbc <rt_vsnprintf+0xf4>
80001bf8:	fd078713          	addi	a4,a5,-48
80001bfc:	00900693          	li	a3,9
80001c00:	06e6e263          	bltu	a3,a4,80001c64 <rt_vsnprintf+0x19c>
80001c04:	00000713          	li	a4,0
80001c08:	00900693          	li	a3,9
80001c0c:	00a00593          	li	a1,10
80001c10:	0140006f          	j	80001c24 <rt_vsnprintf+0x15c>
80001c14:	02b70733          	mul	a4,a4,a1
80001c18:	001b0b13          	addi	s6,s6,1
80001c1c:	00f70733          	add	a4,a4,a5
80001c20:	fd070713          	addi	a4,a4,-48
80001c24:	000b4783          	lbu	a5,0(s6)
80001c28:	fd078613          	addi	a2,a5,-48
80001c2c:	fec6f4e3          	bgeu	a3,a2,80001c14 <rt_vsnprintf+0x14c>
80001c30:	000b4603          	lbu	a2,0(s6)
80001c34:	02e00693          	li	a3,46
80001c38:	fff00793          	li	a5,-1
80001c3c:	06d61c63          	bne	a2,a3,80001cb4 <rt_vsnprintf+0x1ec>
80001c40:	001b4783          	lbu	a5,1(s6)
80001c44:	00900613          	li	a2,9
80001c48:	001b0693          	addi	a3,s6,1
80001c4c:	fd078593          	addi	a1,a5,-48
80001c50:	0cb66463          	bltu	a2,a1,80001d18 <rt_vsnprintf+0x250>
80001c54:	00000793          	li	a5,0
80001c58:	00900593          	li	a1,9
80001c5c:	00a00313          	li	t1,10
80001c60:	03c0006f          	j	80001c9c <rt_vsnprintf+0x1d4>
80001c64:	02a00693          	li	a3,42
80001c68:	fff00713          	li	a4,-1
80001c6c:	fcd792e3          	bne	a5,a3,80001c30 <rt_vsnprintf+0x168>
80001c70:	0008a703          	lw	a4,0(a7)
80001c74:	00260b13          	addi	s6,a2,2
80001c78:	00488893          	addi	a7,a7,4
80001c7c:	fa075ae3          	bgez	a4,80001c30 <rt_vsnprintf+0x168>
80001c80:	40e00733          	neg	a4,a4
80001c84:	01086813          	ori	a6,a6,16
80001c88:	fa9ff06f          	j	80001c30 <rt_vsnprintf+0x168>
80001c8c:	026787b3          	mul	a5,a5,t1
80001c90:	00168693          	addi	a3,a3,1
80001c94:	00c787b3          	add	a5,a5,a2
80001c98:	fd078793          	addi	a5,a5,-48
80001c9c:	0006c603          	lbu	a2,0(a3)
80001ca0:	fd060513          	addi	a0,a2,-48
80001ca4:	fea5f4e3          	bgeu	a1,a0,80001c8c <rt_vsnprintf+0x1c4>
80001ca8:	0007d463          	bgez	a5,80001cb0 <rt_vsnprintf+0x1e8>
80001cac:	00000793          	li	a5,0
80001cb0:	00068b13          	mv	s6,a3
80001cb4:	000b4603          	lbu	a2,0(s6)
80001cb8:	06800693          	li	a3,104
80001cbc:	0fb67593          	andi	a1,a2,251
80001cc0:	06d59e63          	bne	a1,a3,80001d3c <rt_vsnprintf+0x274>
80001cc4:	001b0b13          	addi	s6,s6,1
80001cc8:	000b4683          	lbu	a3,0(s6)
80001ccc:	07800593          	li	a1,120
80001cd0:	02d5e063          	bltu	a1,a3,80001cf0 <rt_vsnprintf+0x228>
80001cd4:	06200593          	li	a1,98
80001cd8:	06d5e663          	bltu	a1,a3,80001d44 <rt_vsnprintf+0x27c>
80001cdc:	02500593          	li	a1,37
80001ce0:	24b68a63          	beq	a3,a1,80001f34 <rt_vsnprintf+0x46c>
80001ce4:	05800593          	li	a1,88
80001ce8:	04086813          	ori	a6,a6,64
80001cec:	24b68c63          	beq	a3,a1,80001f44 <rt_vsnprintf+0x47c>
80001cf0:	01747663          	bgeu	s0,s7,80001cfc <rt_vsnprintf+0x234>
80001cf4:	02500793          	li	a5,37
80001cf8:	00f40023          	sb	a5,0(s0)
80001cfc:	000b4783          	lbu	a5,0(s6)
80001d00:	00140513          	addi	a0,s0,1
80001d04:	28078463          	beqz	a5,80001f8c <rt_vsnprintf+0x4c4>
80001d08:	01757463          	bgeu	a0,s7,80001d10 <rt_vsnprintf+0x248>
80001d0c:	00f400a3          	sb	a5,1(s0)
80001d10:	00240513          	addi	a0,s0,2
80001d14:	e39ff06f          	j	80001b4c <rt_vsnprintf+0x84>
80001d18:	02a00613          	li	a2,42
80001d1c:	00c79a63          	bne	a5,a2,80001d30 <rt_vsnprintf+0x268>
80001d20:	0008a783          	lw	a5,0(a7)
80001d24:	002b0693          	addi	a3,s6,2
80001d28:	00488893          	addi	a7,a7,4
80001d2c:	f7dff06f          	j	80001ca8 <rt_vsnprintf+0x1e0>
80001d30:	00068b13          	mv	s6,a3
80001d34:	00000793          	li	a5,0
80001d38:	f7dff06f          	j	80001cb4 <rt_vsnprintf+0x1ec>
80001d3c:	00000613          	li	a2,0
80001d40:	f89ff06f          	j	80001cc8 <rt_vsnprintf+0x200>
80001d44:	f9d68693          	addi	a3,a3,-99
80001d48:	0ff6f693          	andi	a3,a3,255
80001d4c:	01500593          	li	a1,21
80001d50:	fad5e0e3          	bltu	a1,a3,80001cf0 <rt_vsnprintf+0x228>
80001d54:	0000b597          	auipc	a1,0xb
80001d58:	b8858593          	addi	a1,a1,-1144 # 8000c8dc <__FUNCTION__.3096+0x18>
80001d5c:	00269693          	slli	a3,a3,0x2
80001d60:	00b686b3          	add	a3,a3,a1
80001d64:	0006a683          	lw	a3,0(a3)
80001d68:	00b686b3          	add	a3,a3,a1
80001d6c:	00068067          	jr	a3
80001d70:	01087813          	andi	a6,a6,16
80001d74:	04081663          	bnez	a6,80001dc0 <rt_vsnprintf+0x2f8>
80001d78:	00070693          	mv	a3,a4
80001d7c:	00040793          	mv	a5,s0
80001d80:	02000613          	li	a2,32
80001d84:	0100006f          	j	80001d94 <rt_vsnprintf+0x2cc>
80001d88:	0177f463          	bgeu	a5,s7,80001d90 <rt_vsnprintf+0x2c8>
80001d8c:	00c78023          	sb	a2,0(a5)
80001d90:	00178793          	addi	a5,a5,1
80001d94:	fff68693          	addi	a3,a3,-1
80001d98:	fed048e3          	bgtz	a3,80001d88 <rt_vsnprintf+0x2c0>
80001d9c:	fff70793          	addi	a5,a4,-1
80001da0:	00000693          	li	a3,0
80001da4:	00e05463          	blez	a4,80001dac <rt_vsnprintf+0x2e4>
80001da8:	00078693          	mv	a3,a5
80001dac:	00d40433          	add	s0,s0,a3
80001db0:	00e04463          	bgtz	a4,80001db8 <rt_vsnprintf+0x2f0>
80001db4:	00100713          	li	a4,1
80001db8:	40e78733          	sub	a4,a5,a4
80001dbc:	00170713          	addi	a4,a4,1
80001dc0:	00488613          	addi	a2,a7,4
80001dc4:	01747663          	bgeu	s0,s7,80001dd0 <rt_vsnprintf+0x308>
80001dc8:	0008a783          	lw	a5,0(a7)
80001dcc:	00f40023          	sb	a5,0(s0)
80001dd0:	00140793          	addi	a5,s0,1
80001dd4:	00078693          	mv	a3,a5
80001dd8:	00e40433          	add	s0,s0,a4
80001ddc:	02000513          	li	a0,32
80001de0:	40d405b3          	sub	a1,s0,a3
80001de4:	00b04e63          	bgtz	a1,80001e00 <rt_vsnprintf+0x338>
80001de8:	00000513          	li	a0,0
80001dec:	00e05463          	blez	a4,80001df4 <rt_vsnprintf+0x32c>
80001df0:	fff70513          	addi	a0,a4,-1
80001df4:	00a78533          	add	a0,a5,a0
80001df8:	00060893          	mv	a7,a2
80001dfc:	d51ff06f          	j	80001b4c <rt_vsnprintf+0x84>
80001e00:	0176f463          	bgeu	a3,s7,80001e08 <rt_vsnprintf+0x340>
80001e04:	00a68023          	sb	a0,0(a3)
80001e08:	00168693          	addi	a3,a3,1
80001e0c:	fd5ff06f          	j	80001de0 <rt_vsnprintf+0x318>
80001e10:	0008ac83          	lw	s9,0(a7)
80001e14:	00488d13          	addi	s10,a7,4
80001e18:	000c9663          	bnez	s9,80001e24 <rt_vsnprintf+0x35c>
80001e1c:	0000bc97          	auipc	s9,0xb
80001e20:	ab8c8c93          	addi	s9,s9,-1352 # 8000c8d4 <__FUNCTION__.3096+0x10>
80001e24:	000c8513          	mv	a0,s9
80001e28:	00f12623          	sw	a5,12(sp)
80001e2c:	00e12423          	sw	a4,8(sp)
80001e30:	01012223          	sw	a6,4(sp)
80001e34:	c79ff0ef          	jal	ra,80001aac <rt_strlen>
80001e38:	00c12783          	lw	a5,12(sp)
80001e3c:	00412803          	lw	a6,4(sp)
80001e40:	00812703          	lw	a4,8(sp)
80001e44:	00f05663          	blez	a5,80001e50 <rt_vsnprintf+0x388>
80001e48:	00a7d463          	bge	a5,a0,80001e50 <rt_vsnprintf+0x388>
80001e4c:	00078513          	mv	a0,a5
80001e50:	01087813          	andi	a6,a6,16
80001e54:	04081863          	bnez	a6,80001ea4 <rt_vsnprintf+0x3dc>
80001e58:	00040793          	mv	a5,s0
80001e5c:	00e40633          	add	a2,s0,a4
80001e60:	02000593          	li	a1,32
80001e64:	0100006f          	j	80001e74 <rt_vsnprintf+0x3ac>
80001e68:	0177f463          	bgeu	a5,s7,80001e70 <rt_vsnprintf+0x3a8>
80001e6c:	00b78023          	sb	a1,0(a5)
80001e70:	00178793          	addi	a5,a5,1
80001e74:	40f606b3          	sub	a3,a2,a5
80001e78:	fed548e3          	blt	a0,a3,80001e68 <rt_vsnprintf+0x3a0>
80001e7c:	40a706b3          	sub	a3,a4,a0
80001e80:	00000793          	li	a5,0
80001e84:	00a74463          	blt	a4,a0,80001e8c <rt_vsnprintf+0x3c4>
80001e88:	00068793          	mv	a5,a3
80001e8c:	00f40433          	add	s0,s0,a5
80001e90:	fff70613          	addi	a2,a4,-1
80001e94:	00000793          	li	a5,0
80001e98:	00a74463          	blt	a4,a0,80001ea0 <rt_vsnprintf+0x3d8>
80001e9c:	40d007b3          	neg	a5,a3
80001ea0:	00c78733          	add	a4,a5,a2
80001ea4:	00000793          	li	a5,0
80001ea8:	04a7c063          	blt	a5,a0,80001ee8 <rt_vsnprintf+0x420>
80001eac:	00050793          	mv	a5,a0
80001eb0:	00055463          	bgez	a0,80001eb8 <rt_vsnprintf+0x3f0>
80001eb4:	00000793          	li	a5,0
80001eb8:	00f40433          	add	s0,s0,a5
80001ebc:	00040793          	mv	a5,s0
80001ec0:	00e40633          	add	a2,s0,a4
80001ec4:	02000593          	li	a1,32
80001ec8:	40f606b3          	sub	a3,a2,a5
80001ecc:	02d54c63          	blt	a0,a3,80001f04 <rt_vsnprintf+0x43c>
80001ed0:	00000793          	li	a5,0
80001ed4:	00a74463          	blt	a4,a0,80001edc <rt_vsnprintf+0x414>
80001ed8:	40a707b3          	sub	a5,a4,a0
80001edc:	00f40533          	add	a0,s0,a5
80001ee0:	000d0893          	mv	a7,s10
80001ee4:	c69ff06f          	j	80001b4c <rt_vsnprintf+0x84>
80001ee8:	00f406b3          	add	a3,s0,a5
80001eec:	0176f863          	bgeu	a3,s7,80001efc <rt_vsnprintf+0x434>
80001ef0:	00fc8633          	add	a2,s9,a5
80001ef4:	00064603          	lbu	a2,0(a2)
80001ef8:	00c68023          	sb	a2,0(a3)
80001efc:	00178793          	addi	a5,a5,1
80001f00:	fa9ff06f          	j	80001ea8 <rt_vsnprintf+0x3e0>
80001f04:	0177f463          	bgeu	a5,s7,80001f0c <rt_vsnprintf+0x444>
80001f08:	00b78023          	sb	a1,0(a5)
80001f0c:	00178793          	addi	a5,a5,1
80001f10:	fb9ff06f          	j	80001ec8 <rt_vsnprintf+0x400>
80001f14:	fff00693          	li	a3,-1
80001f18:	00d71663          	bne	a4,a3,80001f24 <rt_vsnprintf+0x45c>
80001f1c:	00186813          	ori	a6,a6,1
80001f20:	00800713          	li	a4,8
80001f24:	00488c93          	addi	s9,a7,4
80001f28:	01000693          	li	a3,16
80001f2c:	0008a603          	lw	a2,0(a7)
80001f30:	03c0006f          	j	80001f6c <rt_vsnprintf+0x4a4>
80001f34:	01747463          	bgeu	s0,s7,80001f3c <rt_vsnprintf+0x474>
80001f38:	00d40023          	sb	a3,0(s0)
80001f3c:	00140513          	addi	a0,s0,1
80001f40:	c0dff06f          	j	80001b4c <rt_vsnprintf+0x84>
80001f44:	01000693          	li	a3,16
80001f48:	06c00593          	li	a1,108
80001f4c:	00488c93          	addi	s9,a7,4
80001f50:	fcb60ee3          	beq	a2,a1,80001f2c <rt_vsnprintf+0x464>
80001f54:	06800593          	li	a1,104
80001f58:	fcb61ae3          	bne	a2,a1,80001f2c <rt_vsnprintf+0x464>
80001f5c:	00287593          	andi	a1,a6,2
80001f60:	0008a603          	lw	a2,0(a7)
80001f64:	02059c63          	bnez	a1,80001f9c <rt_vsnprintf+0x4d4>
80001f68:	01267633          	and	a2,a2,s2
80001f6c:	000b8593          	mv	a1,s7
80001f70:	00040513          	mv	a0,s0
80001f74:	f48ff0ef          	jal	ra,800016bc <print_number>
80001f78:	000c8893          	mv	a7,s9
80001f7c:	bd1ff06f          	j	80001b4c <rt_vsnprintf+0x84>
80001f80:	00286813          	ori	a6,a6,2
80001f84:	00a00693          	li	a3,10
80001f88:	fc1ff06f          	j	80001f48 <rt_vsnprintf+0x480>
80001f8c:	fffb0b13          	addi	s6,s6,-1
80001f90:	bbdff06f          	j	80001b4c <rt_vsnprintf+0x84>
80001f94:	00800693          	li	a3,8
80001f98:	fb1ff06f          	j	80001f48 <rt_vsnprintf+0x480>
80001f9c:	01061613          	slli	a2,a2,0x10
80001fa0:	41065613          	srai	a2,a2,0x10
80001fa4:	fc9ff06f          	j	80001f6c <rt_vsnprintf+0x4a4>
80001fa8:	fe0b8fa3          	sb	zero,-1(s7)
80001fac:	bbdff06f          	j	80001b68 <rt_vsnprintf+0xa0>

80001fb0 <rt_vsprintf>:
80001fb0:	00060693          	mv	a3,a2
80001fb4:	00058613          	mv	a2,a1
80001fb8:	fff00593          	li	a1,-1
80001fbc:	b0dff06f          	j	80001ac8 <rt_vsnprintf>

80001fc0 <rt_sprintf>:
80001fc0:	fc010113          	addi	sp,sp,-64
80001fc4:	02c12423          	sw	a2,40(sp)
80001fc8:	02810613          	addi	a2,sp,40
80001fcc:	00112e23          	sw	ra,28(sp)
80001fd0:	02d12623          	sw	a3,44(sp)
80001fd4:	02e12823          	sw	a4,48(sp)
80001fd8:	02f12a23          	sw	a5,52(sp)
80001fdc:	03012c23          	sw	a6,56(sp)
80001fe0:	03112e23          	sw	a7,60(sp)
80001fe4:	00c12623          	sw	a2,12(sp)
80001fe8:	fc9ff0ef          	jal	ra,80001fb0 <rt_vsprintf>
80001fec:	01c12083          	lw	ra,28(sp)
80001ff0:	04010113          	addi	sp,sp,64
80001ff4:	00008067          	ret

80001ff8 <rt_console_get_device>:
80001ff8:	0001e517          	auipc	a0,0x1e
80001ffc:	2a452503          	lw	a0,676(a0) # 8002029c <_console_device>
80002000:	00008067          	ret

80002004 <rt_console_set_device>:
80002004:	ff010113          	addi	sp,sp,-16
80002008:	00812423          	sw	s0,8(sp)
8000200c:	0001e417          	auipc	s0,0x1e
80002010:	29040413          	addi	s0,s0,656 # 8002029c <_console_device>
80002014:	01212023          	sw	s2,0(sp)
80002018:	00112623          	sw	ra,12(sp)
8000201c:	00912223          	sw	s1,4(sp)
80002020:	00042903          	lw	s2,0(s0)
80002024:	a71fe0ef          	jal	ra,80000a94 <rt_device_find>
80002028:	02050263          	beqz	a0,8000204c <rt_console_set_device+0x48>
8000202c:	00050493          	mv	s1,a0
80002030:	00042503          	lw	a0,0(s0)
80002034:	00050463          	beqz	a0,8000203c <rt_console_set_device+0x38>
80002038:	cedfe0ef          	jal	ra,80000d24 <rt_device_close>
8000203c:	04300593          	li	a1,67
80002040:	00048513          	mv	a0,s1
80002044:	b89fe0ef          	jal	ra,80000bcc <rt_device_open>
80002048:	00942023          	sw	s1,0(s0)
8000204c:	00c12083          	lw	ra,12(sp)
80002050:	00812403          	lw	s0,8(sp)
80002054:	00412483          	lw	s1,4(sp)
80002058:	00090513          	mv	a0,s2
8000205c:	00012903          	lw	s2,0(sp)
80002060:	01010113          	addi	sp,sp,16
80002064:	00008067          	ret

80002068 <rt_hw_console_output>:
80002068:	00008067          	ret

8000206c <rt_kprintf>:
8000206c:	fc010113          	addi	sp,sp,-64
80002070:	02b12223          	sw	a1,36(sp)
80002074:	02c12423          	sw	a2,40(sp)
80002078:	02d12623          	sw	a3,44(sp)
8000207c:	00050613          	mv	a2,a0
80002080:	02410693          	addi	a3,sp,36
80002084:	07f00593          	li	a1,127
80002088:	bb018513          	addi	a0,gp,-1104 # 80020610 <rt_log_buf.3304>
8000208c:	02f12a23          	sw	a5,52(sp)
80002090:	00d12623          	sw	a3,12(sp)
80002094:	00112e23          	sw	ra,28(sp)
80002098:	00812c23          	sw	s0,24(sp)
8000209c:	00912a23          	sw	s1,20(sp)
800020a0:	02e12823          	sw	a4,48(sp)
800020a4:	03012c23          	sw	a6,56(sp)
800020a8:	03112e23          	sw	a7,60(sp)
800020ac:	a1dff0ef          	jal	ra,80001ac8 <rt_vsnprintf>
800020b0:	0001e797          	auipc	a5,0x1e
800020b4:	1ec78793          	addi	a5,a5,492 # 8002029c <_console_device>
800020b8:	00050693          	mv	a3,a0
800020bc:	0007a503          	lw	a0,0(a5)
800020c0:	02051063          	bnez	a0,800020e0 <rt_kprintf+0x74>
800020c4:	bb018513          	addi	a0,gp,-1104 # 80020610 <rt_log_buf.3304>
800020c8:	fa1ff0ef          	jal	ra,80002068 <rt_hw_console_output>
800020cc:	01c12083          	lw	ra,28(sp)
800020d0:	01812403          	lw	s0,24(sp)
800020d4:	01412483          	lw	s1,20(sp)
800020d8:	04010113          	addi	sp,sp,64
800020dc:	00008067          	ret
800020e0:	02655483          	lhu	s1,38(a0)
800020e4:	00078413          	mv	s0,a5
800020e8:	0404e793          	ori	a5,s1,64
800020ec:	02f51323          	sh	a5,38(a0)
800020f0:	07f00793          	li	a5,127
800020f4:	00d7f463          	bgeu	a5,a3,800020fc <rt_kprintf+0x90>
800020f8:	07f00693          	li	a3,127
800020fc:	bb018613          	addi	a2,gp,-1104 # 80020610 <rt_log_buf.3304>
80002100:	00000593          	li	a1,0
80002104:	da1fe0ef          	jal	ra,80000ea4 <rt_device_write>
80002108:	00042783          	lw	a5,0(s0)
8000210c:	02979323          	sh	s1,38(a5)
80002110:	fbdff06f          	j	800020cc <rt_kprintf+0x60>

80002114 <rt_show_version>:
80002114:	ff010113          	addi	sp,sp,-16
80002118:	0000b517          	auipc	a0,0xb
8000211c:	81c50513          	addi	a0,a0,-2020 # 8000c934 <__FUNCTION__.3096+0x70>
80002120:	00112623          	sw	ra,12(sp)
80002124:	f49ff0ef          	jal	ra,8000206c <rt_kprintf>
80002128:	0000b517          	auipc	a0,0xb
8000212c:	81850513          	addi	a0,a0,-2024 # 8000c940 <__FUNCTION__.3096+0x7c>
80002130:	f3dff0ef          	jal	ra,8000206c <rt_kprintf>
80002134:	0000b517          	auipc	a0,0xb
80002138:	83c50513          	addi	a0,a0,-1988 # 8000c970 <__FUNCTION__.3096+0xac>
8000213c:	0000b717          	auipc	a4,0xb
80002140:	82870713          	addi	a4,a4,-2008 # 8000c964 <__FUNCTION__.3096+0xa0>
80002144:	00300693          	li	a3,3
80002148:	00000613          	li	a2,0
8000214c:	00400593          	li	a1,4
80002150:	f1dff0ef          	jal	ra,8000206c <rt_kprintf>
80002154:	00c12083          	lw	ra,12(sp)
80002158:	0000b517          	auipc	a0,0xb
8000215c:	83850513          	addi	a0,a0,-1992 # 8000c990 <__FUNCTION__.3096+0xcc>
80002160:	01010113          	addi	sp,sp,16
80002164:	f09ff06f          	j	8000206c <rt_kprintf>

80002168 <__rt_ffs>:
80002168:	08050063          	beqz	a0,800021e8 <__rt_ffs+0x80>
8000216c:	0ff57713          	andi	a4,a0,255
80002170:	0000b697          	auipc	a3,0xb
80002174:	88468693          	addi	a3,a3,-1916 # 8000c9f4 <__lowest_bit_bitmap>
80002178:	00070a63          	beqz	a4,8000218c <__rt_ffs+0x24>
8000217c:	00e686b3          	add	a3,a3,a4
80002180:	0006c503          	lbu	a0,0(a3)
80002184:	00150513          	addi	a0,a0,1
80002188:	00008067          	ret
8000218c:	000107b7          	lui	a5,0x10
80002190:	f0078793          	addi	a5,a5,-256 # ff00 <__HEAP_SIZE+0xdf00>
80002194:	00f577b3          	and	a5,a0,a5
80002198:	00078e63          	beqz	a5,800021b4 <__rt_ffs+0x4c>
8000219c:	40855513          	srai	a0,a0,0x8
800021a0:	0ff57713          	andi	a4,a0,255
800021a4:	00e68733          	add	a4,a3,a4
800021a8:	00074503          	lbu	a0,0(a4)
800021ac:	00950513          	addi	a0,a0,9
800021b0:	00008067          	ret
800021b4:	00ff07b7          	lui	a5,0xff0
800021b8:	00f577b3          	and	a5,a0,a5
800021bc:	00078e63          	beqz	a5,800021d8 <__rt_ffs+0x70>
800021c0:	41055513          	srai	a0,a0,0x10
800021c4:	0ff57793          	andi	a5,a0,255
800021c8:	00f687b3          	add	a5,a3,a5
800021cc:	0007c503          	lbu	a0,0(a5) # ff0000 <__RAM_SIZE+0xfd0000>
800021d0:	01150513          	addi	a0,a0,17
800021d4:	00008067          	ret
800021d8:	01855513          	srli	a0,a0,0x18
800021dc:	00a68533          	add	a0,a3,a0
800021e0:	00054503          	lbu	a0,0(a0)
800021e4:	01950513          	addi	a0,a0,25
800021e8:	00008067          	ret

800021ec <rt_assert_handler>:
800021ec:	fe010113          	addi	sp,sp,-32
800021f0:	00112e23          	sw	ra,28(sp)
800021f4:	000107a3          	sb	zero,15(sp)
800021f8:	8401a303          	lw	t1,-1984(gp) # 800202a0 <rt_assert_hook>
800021fc:	02031a63          	bnez	t1,80002230 <rt_assert_handler+0x44>
80002200:	00060693          	mv	a3,a2
80002204:	00058613          	mv	a2,a1
80002208:	00050593          	mv	a1,a0
8000220c:	0000a517          	auipc	a0,0xa
80002210:	7b050513          	addi	a0,a0,1968 # 8000c9bc <__FUNCTION__.3096+0xf8>
80002214:	e59ff0ef          	jal	ra,8000206c <rt_kprintf>
80002218:	00f14783          	lbu	a5,15(sp)
8000221c:	0ff7f793          	andi	a5,a5,255
80002220:	fe078ce3          	beqz	a5,80002218 <rt_assert_handler+0x2c>
80002224:	01c12083          	lw	ra,28(sp)
80002228:	02010113          	addi	sp,sp,32
8000222c:	00008067          	ret
80002230:	01c12083          	lw	ra,28(sp)
80002234:	02010113          	addi	sp,sp,32
80002238:	00030067          	jr	t1

8000223c <list_mem>:
8000223c:	ff010113          	addi	sp,sp,-16
80002240:	8541a583          	lw	a1,-1964(gp) # 800202b4 <mem_size_aligned>
80002244:	0000b517          	auipc	a0,0xb
80002248:	8d850513          	addi	a0,a0,-1832 # 8000cb1c <small_digits.3193+0x14>
8000224c:	00112623          	sw	ra,12(sp)
80002250:	e1dff0ef          	jal	ra,8000206c <rt_kprintf>
80002254:	8601a583          	lw	a1,-1952(gp) # 800202c0 <used_mem>
80002258:	0000b517          	auipc	a0,0xb
8000225c:	8d850513          	addi	a0,a0,-1832 # 8000cb30 <small_digits.3193+0x28>
80002260:	e0dff0ef          	jal	ra,8000206c <rt_kprintf>
80002264:	00c12083          	lw	ra,12(sp)
80002268:	8501a583          	lw	a1,-1968(gp) # 800202b0 <max_mem>
8000226c:	0000b517          	auipc	a0,0xb
80002270:	8d850513          	addi	a0,a0,-1832 # 8000cb44 <small_digits.3193+0x3c>
80002274:	01010113          	addi	sp,sp,16
80002278:	df5ff06f          	j	8000206c <rt_kprintf>

8000227c <plug_holes>:
8000227c:	84818793          	addi	a5,gp,-1976 # 800202a8 <heap_ptr>
80002280:	0007a703          	lw	a4,0(a5)
80002284:	ff010113          	addi	sp,sp,-16
80002288:	00812423          	sw	s0,8(sp)
8000228c:	01212023          	sw	s2,0(sp)
80002290:	00112623          	sw	ra,12(sp)
80002294:	00912223          	sw	s1,4(sp)
80002298:	00050413          	mv	s0,a0
8000229c:	00078913          	mv	s2,a5
800022a0:	00e57e63          	bgeu	a0,a4,800022bc <plug_holes+0x40>
800022a4:	0a100613          	li	a2,161
800022a8:	0000b597          	auipc	a1,0xb
800022ac:	b1c58593          	addi	a1,a1,-1252 # 8000cdc4 <__FUNCTION__.3051>
800022b0:	0000b517          	auipc	a0,0xb
800022b4:	8b450513          	addi	a0,a0,-1868 # 8000cb64 <small_digits.3193+0x5c>
800022b8:	f35ff0ef          	jal	ra,800021ec <rt_assert_handler>
800022bc:	84418793          	addi	a5,gp,-1980 # 800202a4 <heap_end>
800022c0:	0007a703          	lw	a4,0(a5)
800022c4:	00078493          	mv	s1,a5
800022c8:	00e46e63          	bltu	s0,a4,800022e4 <plug_holes+0x68>
800022cc:	0a200613          	li	a2,162
800022d0:	0000b597          	auipc	a1,0xb
800022d4:	af458593          	addi	a1,a1,-1292 # 8000cdc4 <__FUNCTION__.3051>
800022d8:	0000b517          	auipc	a0,0xb
800022dc:	8ac50513          	addi	a0,a0,-1876 # 8000cb84 <small_digits.3193+0x7c>
800022e0:	f0dff0ef          	jal	ra,800021ec <rt_assert_handler>
800022e4:	00245783          	lhu	a5,2(s0)
800022e8:	00078e63          	beqz	a5,80002304 <plug_holes+0x88>
800022ec:	0a300613          	li	a2,163
800022f0:	0000b597          	auipc	a1,0xb
800022f4:	ad458593          	addi	a1,a1,-1324 # 8000cdc4 <__FUNCTION__.3051>
800022f8:	0000b517          	auipc	a0,0xb
800022fc:	8b850513          	addi	a0,a0,-1864 # 8000cbb0 <small_digits.3193+0xa8>
80002300:	eedff0ef          	jal	ra,800021ec <rt_assert_handler>
80002304:	00092703          	lw	a4,0(s2)
80002308:	00442783          	lw	a5,4(s0)
8000230c:	00f707b3          	add	a5,a4,a5
80002310:	02f40e63          	beq	s0,a5,8000234c <plug_holes+0xd0>
80002314:	0027d683          	lhu	a3,2(a5)
80002318:	02069a63          	bnez	a3,8000234c <plug_holes+0xd0>
8000231c:	0004a683          	lw	a3,0(s1)
80002320:	02f68663          	beq	a3,a5,8000234c <plug_holes+0xd0>
80002324:	84c18693          	addi	a3,gp,-1972 # 800202ac <lfree>
80002328:	0006a603          	lw	a2,0(a3)
8000232c:	00f61463          	bne	a2,a5,80002334 <plug_holes+0xb8>
80002330:	0086a023          	sw	s0,0(a3)
80002334:	0047a683          	lw	a3,4(a5)
80002338:	00d42223          	sw	a3,4(s0)
8000233c:	0047a783          	lw	a5,4(a5)
80002340:	40e406b3          	sub	a3,s0,a4
80002344:	00f707b3          	add	a5,a4,a5
80002348:	00d7a423          	sw	a3,8(a5)
8000234c:	00842683          	lw	a3,8(s0)
80002350:	00d707b3          	add	a5,a4,a3
80002354:	02f40863          	beq	s0,a5,80002384 <plug_holes+0x108>
80002358:	0027d603          	lhu	a2,2(a5)
8000235c:	02061463          	bnez	a2,80002384 <plug_holes+0x108>
80002360:	84c18613          	addi	a2,gp,-1972 # 800202ac <lfree>
80002364:	00062583          	lw	a1,0(a2)
80002368:	00859463          	bne	a1,s0,80002370 <plug_holes+0xf4>
8000236c:	00f62023          	sw	a5,0(a2)
80002370:	00442603          	lw	a2,4(s0)
80002374:	00c7a223          	sw	a2,4(a5)
80002378:	00442783          	lw	a5,4(s0)
8000237c:	00f70733          	add	a4,a4,a5
80002380:	00d72423          	sw	a3,8(a4)
80002384:	00c12083          	lw	ra,12(sp)
80002388:	00812403          	lw	s0,8(sp)
8000238c:	00412483          	lw	s1,4(sp)
80002390:	00012903          	lw	s2,0(sp)
80002394:	01010113          	addi	sp,sp,16
80002398:	00008067          	ret

8000239c <rt_system_heap_init>:
8000239c:	fe010113          	addi	sp,sp,-32
800023a0:	00812c23          	sw	s0,24(sp)
800023a4:	00912a23          	sw	s1,20(sp)
800023a8:	01212823          	sw	s2,16(sp)
800023ac:	01312623          	sw	s3,12(sp)
800023b0:	01412423          	sw	s4,8(sp)
800023b4:	00112e23          	sw	ra,28(sp)
800023b8:	00350413          	addi	s0,a0,3
800023bc:	00050913          	mv	s2,a0
800023c0:	00058993          	mv	s3,a1
800023c4:	ffc5f493          	andi	s1,a1,-4
800023c8:	5f9010ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
800023cc:	ffc47413          	andi	s0,s0,-4
800023d0:	00050a13          	mv	s4,a0
800023d4:	ab8ff0ef          	jal	ra,8000168c <rt_interrupt_get_nest>
800023d8:	02050863          	beqz	a0,80002408 <rt_system_heap_init+0x6c>
800023dc:	0000b597          	auipc	a1,0xb
800023e0:	9f458593          	addi	a1,a1,-1548 # 8000cdd0 <__FUNCTION__.3060>
800023e4:	0000a517          	auipc	a0,0xa
800023e8:	3a850513          	addi	a0,a0,936 # 8000c78c <__FUNCTION__.3020+0x1c>
800023ec:	c81ff0ef          	jal	ra,8000206c <rt_kprintf>
800023f0:	0d200613          	li	a2,210
800023f4:	0000b597          	auipc	a1,0xb
800023f8:	9dc58593          	addi	a1,a1,-1572 # 8000cdd0 <__FUNCTION__.3060>
800023fc:	0000a517          	auipc	a0,0xa
80002400:	3b850513          	addi	a0,a0,952 # 8000c7b4 <__FUNCTION__.3020+0x44>
80002404:	de9ff0ef          	jal	ra,800021ec <rt_assert_handler>
80002408:	000a0513          	mv	a0,s4
8000240c:	5bd010ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
80002410:	01800793          	li	a5,24
80002414:	0897fa63          	bgeu	a5,s1,800024a8 <rt_system_heap_init+0x10c>
80002418:	fe848793          	addi	a5,s1,-24
8000241c:	0887e663          	bltu	a5,s0,800024a8 <rt_system_heap_init+0x10c>
80002420:	408487b3          	sub	a5,s1,s0
80002424:	fe878713          	addi	a4,a5,-24
80002428:	84e1aa23          	sw	a4,-1964(gp) # 800202b4 <mem_size_aligned>
8000242c:	00002737          	lui	a4,0x2
80002430:	ff478793          	addi	a5,a5,-12
80002434:	84818493          	addi	s1,gp,-1976 # 800202a8 <heap_ptr>
80002438:	ea070713          	addi	a4,a4,-352 # 1ea0 <__HEAP_SIZE-0x160>
8000243c:	00e42023          	sw	a4,0(s0)
80002440:	00f42223          	sw	a5,4(s0)
80002444:	0084a023          	sw	s0,0(s1)
80002448:	00042423          	sw	zero,8(s0)
8000244c:	00f40433          	add	s0,s0,a5
80002450:	8481a223          	sw	s0,-1980(gp) # 800202a4 <heap_end>
80002454:	00012737          	lui	a4,0x12
80002458:	ea070713          	addi	a4,a4,-352 # 11ea0 <__HEAP_SIZE+0xfea0>
8000245c:	00e42023          	sw	a4,0(s0)
80002460:	00f42223          	sw	a5,4(s0)
80002464:	00f42423          	sw	a5,8(s0)
80002468:	00000693          	li	a3,0
8000246c:	00100613          	li	a2,1
80002470:	0000a597          	auipc	a1,0xa
80002474:	75058593          	addi	a1,a1,1872 # 8000cbc0 <small_digits.3193+0xb8>
80002478:	c3018513          	addi	a0,gp,-976 # 80020690 <heap_sem>
8000247c:	e3dfe0ef          	jal	ra,800012b8 <rt_sem_init>
80002480:	0004a783          	lw	a5,0(s1)
80002484:	01c12083          	lw	ra,28(sp)
80002488:	01812403          	lw	s0,24(sp)
8000248c:	84f1a623          	sw	a5,-1972(gp) # 800202ac <lfree>
80002490:	01412483          	lw	s1,20(sp)
80002494:	01012903          	lw	s2,16(sp)
80002498:	00c12983          	lw	s3,12(sp)
8000249c:	00812a03          	lw	s4,8(sp)
800024a0:	02010113          	addi	sp,sp,32
800024a4:	00008067          	ret
800024a8:	01812403          	lw	s0,24(sp)
800024ac:	01c12083          	lw	ra,28(sp)
800024b0:	01412483          	lw	s1,20(sp)
800024b4:	00812a03          	lw	s4,8(sp)
800024b8:	00098613          	mv	a2,s3
800024bc:	00090593          	mv	a1,s2
800024c0:	00c12983          	lw	s3,12(sp)
800024c4:	01012903          	lw	s2,16(sp)
800024c8:	0000a517          	auipc	a0,0xa
800024cc:	70050513          	addi	a0,a0,1792 # 8000cbc8 <small_digits.3193+0xc0>
800024d0:	02010113          	addi	sp,sp,32
800024d4:	b99ff06f          	j	8000206c <rt_kprintf>

800024d8 <rt_malloc>:
800024d8:	fe010113          	addi	sp,sp,-32
800024dc:	00112e23          	sw	ra,28(sp)
800024e0:	00812c23          	sw	s0,24(sp)
800024e4:	00912a23          	sw	s1,20(sp)
800024e8:	01212823          	sw	s2,16(sp)
800024ec:	01312623          	sw	s3,12(sp)
800024f0:	00051663          	bnez	a0,800024fc <rt_malloc+0x24>
800024f4:	00000913          	li	s2,0
800024f8:	1e40006f          	j	800026dc <rt_malloc+0x204>
800024fc:	00050413          	mv	s0,a0
80002500:	4c1010ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
80002504:	00050493          	mv	s1,a0
80002508:	984ff0ef          	jal	ra,8000168c <rt_interrupt_get_nest>
8000250c:	02050863          	beqz	a0,8000253c <rt_malloc+0x64>
80002510:	0000b597          	auipc	a1,0xb
80002514:	8d458593          	addi	a1,a1,-1836 # 8000cde4 <__FUNCTION__.3069>
80002518:	0000a517          	auipc	a0,0xa
8000251c:	27450513          	addi	a0,a0,628 # 8000c78c <__FUNCTION__.3020+0x1c>
80002520:	b4dff0ef          	jal	ra,8000206c <rt_kprintf>
80002524:	11800613          	li	a2,280
80002528:	0000b597          	auipc	a1,0xb
8000252c:	8bc58593          	addi	a1,a1,-1860 # 8000cde4 <__FUNCTION__.3069>
80002530:	0000a517          	auipc	a0,0xa
80002534:	28450513          	addi	a0,a0,644 # 8000c7b4 <__FUNCTION__.3020+0x44>
80002538:	cb5ff0ef          	jal	ra,800021ec <rt_assert_handler>
8000253c:	00048513          	mv	a0,s1
80002540:	489010ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
80002544:	85418793          	addi	a5,gp,-1964 # 800202b4 <mem_size_aligned>
80002548:	0007a703          	lw	a4,0(a5)
8000254c:	00340413          	addi	s0,s0,3
80002550:	ffc47413          	andi	s0,s0,-4
80002554:	00078493          	mv	s1,a5
80002558:	f8876ee3          	bltu	a4,s0,800024f4 <rt_malloc+0x1c>
8000255c:	00c00793          	li	a5,12
80002560:	00f47463          	bgeu	s0,a5,80002568 <rt_malloc+0x90>
80002564:	00c00413          	li	s0,12
80002568:	fff00593          	li	a1,-1
8000256c:	c3018513          	addi	a0,gp,-976 # 80020690 <heap_sem>
80002570:	df1fe0ef          	jal	ra,80001360 <rt_sem_take>
80002574:	84c18513          	addi	a0,gp,-1972 # 800202ac <lfree>
80002578:	00052783          	lw	a5,0(a0)
8000257c:	0004a803          	lw	a6,0(s1)
80002580:	8481a583          	lw	a1,-1976(gp) # 800202a8 <heap_ptr>
80002584:	40b786b3          	sub	a3,a5,a1
80002588:	40880733          	sub	a4,a6,s0
8000258c:	00e6e863          	bltu	a3,a4,8000259c <rt_malloc+0xc4>
80002590:	c3018513          	addi	a0,gp,-976 # 80020690 <heap_sem>
80002594:	f8dfe0ef          	jal	ra,80001520 <rt_sem_release>
80002598:	f5dff06f          	j	800024f4 <rt_malloc+0x1c>
8000259c:	00d584b3          	add	s1,a1,a3
800025a0:	0024d603          	lhu	a2,2(s1)
800025a4:	0044a883          	lw	a7,4(s1)
800025a8:	18061863          	bnez	a2,80002738 <rt_malloc+0x260>
800025ac:	40d88633          	sub	a2,a7,a3
800025b0:	ff460f93          	addi	t6,a2,-12
800025b4:	188fe263          	bltu	t6,s0,80002738 <rt_malloc+0x260>
800025b8:	86018e13          	addi	t3,gp,-1952 # 800202c0 <used_mem>
800025bc:	85018313          	addi	t1,gp,-1968 # 800202b0 <max_mem>
800025c0:	01840e93          	addi	t4,s0,24
800025c4:	000e2703          	lw	a4,0(t3)
800025c8:	00032f03          	lw	t5,0(t1)
800025cc:	00c40913          	addi	s2,s0,12
800025d0:	000e0393          	mv	t2,t3
800025d4:	00030293          	mv	t0,t1
800025d8:	13dfe263          	bltu	t6,t4,800026fc <rt_malloc+0x224>
800025dc:	01268333          	add	t1,a3,s2
800025e0:	00002e37          	lui	t3,0x2
800025e4:	00658633          	add	a2,a1,t1
800025e8:	ea0e0e13          	addi	t3,t3,-352 # 1ea0 <__HEAP_SIZE-0x160>
800025ec:	01162223          	sw	a7,4(a2)
800025f0:	00d62423          	sw	a3,8(a2)
800025f4:	01c62023          	sw	t3,0(a2)
800025f8:	00100693          	li	a3,1
800025fc:	0064a223          	sw	t1,4(s1)
80002600:	00d49123          	sh	a3,2(s1)
80002604:	00462683          	lw	a3,4(a2)
80002608:	00c80813          	addi	a6,a6,12
8000260c:	01068663          	beq	a3,a6,80002618 <rt_malloc+0x140>
80002610:	00d586b3          	add	a3,a1,a3
80002614:	0066a423          	sw	t1,8(a3)
80002618:	00c70713          	addi	a4,a4,12
8000261c:	00870733          	add	a4,a4,s0
80002620:	00e3a023          	sw	a4,0(t2)
80002624:	00ef7463          	bgeu	t5,a4,8000262c <rt_malloc+0x154>
80002628:	00e2a023          	sw	a4,0(t0)
8000262c:	00002737          	lui	a4,0x2
80002630:	ea070713          	addi	a4,a4,-352 # 1ea0 <__HEAP_SIZE-0x160>
80002634:	00e49023          	sh	a4,0(s1)
80002638:	84418993          	addi	s3,gp,-1980 # 800202a4 <heap_end>
8000263c:	00979e63          	bne	a5,s1,80002658 <rt_malloc+0x180>
80002640:	0009a683          	lw	a3,0(s3)
80002644:	00000713          	li	a4,0
80002648:	0027d603          	lhu	a2,2(a5)
8000264c:	0c061e63          	bnez	a2,80002728 <rt_malloc+0x250>
80002650:	00070463          	beqz	a4,80002658 <rt_malloc+0x180>
80002654:	00f52023          	sw	a5,0(a0)
80002658:	c3018513          	addi	a0,gp,-976 # 80020690 <heap_sem>
8000265c:	ec5fe0ef          	jal	ra,80001520 <rt_sem_release>
80002660:	0009a783          	lw	a5,0(s3)
80002664:	01248933          	add	s2,s1,s2
80002668:	0127fe63          	bgeu	a5,s2,80002684 <rt_malloc+0x1ac>
8000266c:	18600613          	li	a2,390
80002670:	0000a597          	auipc	a1,0xa
80002674:	77458593          	addi	a1,a1,1908 # 8000cde4 <__FUNCTION__.3069>
80002678:	0000a517          	auipc	a0,0xa
8000267c:	58c50513          	addi	a0,a0,1420 # 8000cc04 <small_digits.3193+0xfc>
80002680:	b6dff0ef          	jal	ra,800021ec <rt_assert_handler>
80002684:	0034f793          	andi	a5,s1,3
80002688:	00c48913          	addi	s2,s1,12
8000268c:	00078e63          	beqz	a5,800026a8 <rt_malloc+0x1d0>
80002690:	18700613          	li	a2,391
80002694:	0000a597          	auipc	a1,0xa
80002698:	75058593          	addi	a1,a1,1872 # 8000cde4 <__FUNCTION__.3069>
8000269c:	0000a517          	auipc	a0,0xa
800026a0:	5ac50513          	addi	a0,a0,1452 # 8000cc48 <small_digits.3193+0x140>
800026a4:	b49ff0ef          	jal	ra,800021ec <rt_assert_handler>
800026a8:	0034f493          	andi	s1,s1,3
800026ac:	00048e63          	beqz	s1,800026c8 <rt_malloc+0x1f0>
800026b0:	18800613          	li	a2,392
800026b4:	0000a597          	auipc	a1,0xa
800026b8:	73058593          	addi	a1,a1,1840 # 8000cde4 <__FUNCTION__.3069>
800026bc:	0000a517          	auipc	a0,0xa
800026c0:	5d850513          	addi	a0,a0,1496 # 8000cc94 <small_digits.3193+0x18c>
800026c4:	b29ff0ef          	jal	ra,800021ec <rt_assert_handler>
800026c8:	85c1a783          	lw	a5,-1956(gp) # 800202bc <rt_malloc_hook>
800026cc:	00078863          	beqz	a5,800026dc <rt_malloc+0x204>
800026d0:	00040593          	mv	a1,s0
800026d4:	00090513          	mv	a0,s2
800026d8:	000780e7          	jalr	a5
800026dc:	01c12083          	lw	ra,28(sp)
800026e0:	01812403          	lw	s0,24(sp)
800026e4:	01412483          	lw	s1,20(sp)
800026e8:	00c12983          	lw	s3,12(sp)
800026ec:	00090513          	mv	a0,s2
800026f0:	01012903          	lw	s2,16(sp)
800026f4:	02010113          	addi	sp,sp,32
800026f8:	00008067          	ret
800026fc:	00100693          	li	a3,1
80002700:	00e60733          	add	a4,a2,a4
80002704:	00d49123          	sh	a3,2(s1)
80002708:	00ee2023          	sw	a4,0(t3)
8000270c:	f2ef70e3          	bgeu	t5,a4,8000262c <rt_malloc+0x154>
80002710:	00e32023          	sw	a4,0(t1)
80002714:	f19ff06f          	j	8000262c <rt_malloc+0x154>
80002718:	0047a783          	lw	a5,4(a5)
8000271c:	00100713          	li	a4,1
80002720:	00f587b3          	add	a5,a1,a5
80002724:	f25ff06f          	j	80002648 <rt_malloc+0x170>
80002728:	fef698e3          	bne	a3,a5,80002718 <rt_malloc+0x240>
8000272c:	f20706e3          	beqz	a4,80002658 <rt_malloc+0x180>
80002730:	00d52023          	sw	a3,0(a0)
80002734:	f25ff06f          	j	80002658 <rt_malloc+0x180>
80002738:	00088693          	mv	a3,a7
8000273c:	e51ff06f          	j	8000258c <rt_malloc+0xb4>

80002740 <rt_calloc>:
80002740:	02b50633          	mul	a2,a0,a1
80002744:	fe010113          	addi	sp,sp,-32
80002748:	00812c23          	sw	s0,24(sp)
8000274c:	00112e23          	sw	ra,28(sp)
80002750:	00060513          	mv	a0,a2
80002754:	00c12623          	sw	a2,12(sp)
80002758:	d81ff0ef          	jal	ra,800024d8 <rt_malloc>
8000275c:	00050413          	mv	s0,a0
80002760:	00050863          	beqz	a0,80002770 <rt_calloc+0x30>
80002764:	00c12603          	lw	a2,12(sp)
80002768:	00000593          	li	a1,0
8000276c:	99cff0ef          	jal	ra,80001908 <rt_memset>
80002770:	01c12083          	lw	ra,28(sp)
80002774:	00040513          	mv	a0,s0
80002778:	01812403          	lw	s0,24(sp)
8000277c:	02010113          	addi	sp,sp,32
80002780:	00008067          	ret

80002784 <rt_free>:
80002784:	1c050263          	beqz	a0,80002948 <rt_free+0x1c4>
80002788:	ff010113          	addi	sp,sp,-16
8000278c:	00812423          	sw	s0,8(sp)
80002790:	00912223          	sw	s1,4(sp)
80002794:	00112623          	sw	ra,12(sp)
80002798:	01212023          	sw	s2,0(sp)
8000279c:	00050413          	mv	s0,a0
800027a0:	221010ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
800027a4:	00050493          	mv	s1,a0
800027a8:	ee5fe0ef          	jal	ra,8000168c <rt_interrupt_get_nest>
800027ac:	02050463          	beqz	a0,800027d4 <rt_free+0x50>
800027b0:	80818593          	addi	a1,gp,-2040 # 80020268 <__FUNCTION__.3098>
800027b4:	0000a517          	auipc	a0,0xa
800027b8:	fd850513          	addi	a0,a0,-40 # 8000c78c <__FUNCTION__.3020+0x1c>
800027bc:	8b1ff0ef          	jal	ra,8000206c <rt_kprintf>
800027c0:	22f00613          	li	a2,559
800027c4:	80818593          	addi	a1,gp,-2040 # 80020268 <__FUNCTION__.3098>
800027c8:	0000a517          	auipc	a0,0xa
800027cc:	fec50513          	addi	a0,a0,-20 # 8000c7b4 <__FUNCTION__.3020+0x44>
800027d0:	a1dff0ef          	jal	ra,800021ec <rt_assert_handler>
800027d4:	00048513          	mv	a0,s1
800027d8:	1f1010ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
800027dc:	00347793          	andi	a5,s0,3
800027e0:	00078c63          	beqz	a5,800027f8 <rt_free+0x74>
800027e4:	23100613          	li	a2,561
800027e8:	80818593          	addi	a1,gp,-2040 # 80020268 <__FUNCTION__.3098>
800027ec:	0000a517          	auipc	a0,0xa
800027f0:	4d850513          	addi	a0,a0,1240 # 8000ccc4 <small_digits.3193+0x1bc>
800027f4:	9f9ff0ef          	jal	ra,800021ec <rt_assert_handler>
800027f8:	84818913          	addi	s2,gp,-1976 # 800202a8 <heap_ptr>
800027fc:	00092783          	lw	a5,0(s2)
80002800:	00f46663          	bltu	s0,a5,8000280c <rt_free+0x88>
80002804:	8441a783          	lw	a5,-1980(gp) # 800202a4 <heap_end>
80002808:	00f46c63          	bltu	s0,a5,80002820 <rt_free+0x9c>
8000280c:	23200613          	li	a2,562
80002810:	80818593          	addi	a1,gp,-2040 # 80020268 <__FUNCTION__.3098>
80002814:	0000a517          	auipc	a0,0xa
80002818:	4e050513          	addi	a0,a0,1248 # 8000ccf4 <small_digits.3193+0x1ec>
8000281c:	9d1ff0ef          	jal	ra,800021ec <rt_assert_handler>
80002820:	8581a783          	lw	a5,-1960(gp) # 800202b8 <rt_free_hook>
80002824:	00078663          	beqz	a5,80002830 <rt_free+0xac>
80002828:	00040513          	mv	a0,s0
8000282c:	000780e7          	jalr	a5
80002830:	00092783          	lw	a5,0(s2)
80002834:	0ef46e63          	bltu	s0,a5,80002930 <rt_free+0x1ac>
80002838:	8441a783          	lw	a5,-1980(gp) # 800202a4 <heap_end>
8000283c:	0ef47a63          	bgeu	s0,a5,80002930 <rt_free+0x1ac>
80002840:	fff00593          	li	a1,-1
80002844:	c3018513          	addi	a0,gp,-976 # 80020690 <heap_sem>
80002848:	b19fe0ef          	jal	ra,80001360 <rt_sem_take>
8000284c:	ff645783          	lhu	a5,-10(s0)
80002850:	ff440493          	addi	s1,s0,-12
80002854:	00078a63          	beqz	a5,80002868 <rt_free+0xe4>
80002858:	ff445703          	lhu	a4,-12(s0)
8000285c:	000027b7          	lui	a5,0x2
80002860:	ea078793          	addi	a5,a5,-352 # 1ea0 <__HEAP_SIZE-0x160>
80002864:	06f70463          	beq	a4,a5,800028cc <rt_free+0x148>
80002868:	0000a517          	auipc	a0,0xa
8000286c:	4e850513          	addi	a0,a0,1256 # 8000cd50 <small_digits.3193+0x248>
80002870:	ffcff0ef          	jal	ra,8000206c <rt_kprintf>
80002874:	ff445683          	lhu	a3,-12(s0)
80002878:	ff645603          	lhu	a2,-10(s0)
8000287c:	00048593          	mv	a1,s1
80002880:	0000a517          	auipc	a0,0xa
80002884:	4ec50513          	addi	a0,a0,1260 # 8000cd6c <small_digits.3193+0x264>
80002888:	fe4ff0ef          	jal	ra,8000206c <rt_kprintf>
8000288c:	ff645783          	lhu	a5,-10(s0)
80002890:	00079c63          	bnez	a5,800028a8 <rt_free+0x124>
80002894:	25100613          	li	a2,593
80002898:	80818593          	addi	a1,gp,-2040 # 80020268 <__FUNCTION__.3098>
8000289c:	0000a517          	auipc	a0,0xa
800028a0:	50050513          	addi	a0,a0,1280 # 8000cd9c <small_digits.3193+0x294>
800028a4:	949ff0ef          	jal	ra,800021ec <rt_assert_handler>
800028a8:	ff445703          	lhu	a4,-12(s0)
800028ac:	000027b7          	lui	a5,0x2
800028b0:	ea078793          	addi	a5,a5,-352 # 1ea0 <__HEAP_SIZE-0x160>
800028b4:	00f70c63          	beq	a4,a5,800028cc <rt_free+0x148>
800028b8:	25200613          	li	a2,594
800028bc:	80818593          	addi	a1,gp,-2040 # 80020268 <__FUNCTION__.3098>
800028c0:	0000a517          	auipc	a0,0xa
800028c4:	4e850513          	addi	a0,a0,1256 # 8000cda8 <small_digits.3193+0x2a0>
800028c8:	925ff0ef          	jal	ra,800021ec <rt_assert_handler>
800028cc:	000027b7          	lui	a5,0x2
800028d0:	ea078793          	addi	a5,a5,-352 # 1ea0 <__HEAP_SIZE-0x160>
800028d4:	fef41a23          	sh	a5,-12(s0)
800028d8:	84c18793          	addi	a5,gp,-1972 # 800202ac <lfree>
800028dc:	0007a703          	lw	a4,0(a5)
800028e0:	fe041b23          	sh	zero,-10(s0)
800028e4:	00e4f463          	bgeu	s1,a4,800028ec <rt_free+0x168>
800028e8:	0097a023          	sw	s1,0(a5)
800028ec:	86018693          	addi	a3,gp,-1952 # 800202c0 <used_mem>
800028f0:	ff842703          	lw	a4,-8(s0)
800028f4:	0006a783          	lw	a5,0(a3)
800028f8:	00048513          	mv	a0,s1
800028fc:	40e787b3          	sub	a5,a5,a4
80002900:	00092703          	lw	a4,0(s2)
80002904:	40e48733          	sub	a4,s1,a4
80002908:	00e787b3          	add	a5,a5,a4
8000290c:	00f6a023          	sw	a5,0(a3)
80002910:	96dff0ef          	jal	ra,8000227c <plug_holes>
80002914:	00812403          	lw	s0,8(sp)
80002918:	00c12083          	lw	ra,12(sp)
8000291c:	00412483          	lw	s1,4(sp)
80002920:	00012903          	lw	s2,0(sp)
80002924:	c3018513          	addi	a0,gp,-976 # 80020690 <heap_sem>
80002928:	01010113          	addi	sp,sp,16
8000292c:	bf5fe06f          	j	80001520 <rt_sem_release>
80002930:	00c12083          	lw	ra,12(sp)
80002934:	00812403          	lw	s0,8(sp)
80002938:	00412483          	lw	s1,4(sp)
8000293c:	00012903          	lw	s2,0(sp)
80002940:	01010113          	addi	sp,sp,16
80002944:	00008067          	ret
80002948:	00008067          	ret

8000294c <rt_object_get_information>:
8000294c:	0001d697          	auipc	a3,0x1d
80002950:	6b468693          	addi	a3,a3,1716 # 80020000 <__RAM_BASE>
80002954:	00000793          	li	a5,0
80002958:	00068713          	mv	a4,a3
8000295c:	00900613          	li	a2,9
80002960:	0006a583          	lw	a1,0(a3)
80002964:	00a59863          	bne	a1,a0,80002974 <rt_object_get_information+0x28>
80002968:	00479793          	slli	a5,a5,0x4
8000296c:	00f70533          	add	a0,a4,a5
80002970:	00008067          	ret
80002974:	00178793          	addi	a5,a5,1
80002978:	01068693          	addi	a3,a3,16
8000297c:	fec792e3          	bne	a5,a2,80002960 <rt_object_get_information+0x14>
80002980:	00000513          	li	a0,0
80002984:	00008067          	ret

80002988 <rt_object_init>:
80002988:	fd010113          	addi	sp,sp,-48
8000298c:	02812423          	sw	s0,40(sp)
80002990:	00050413          	mv	s0,a0
80002994:	00058513          	mv	a0,a1
80002998:	02912223          	sw	s1,36(sp)
8000299c:	03212023          	sw	s2,32(sp)
800029a0:	01412c23          	sw	s4,24(sp)
800029a4:	02112623          	sw	ra,44(sp)
800029a8:	01312e23          	sw	s3,28(sp)
800029ac:	01512a23          	sw	s5,20(sp)
800029b0:	01612823          	sw	s6,16(sp)
800029b4:	01712623          	sw	s7,12(sp)
800029b8:	00058913          	mv	s2,a1
800029bc:	00060a13          	mv	s4,a2
800029c0:	f8dff0ef          	jal	ra,8000294c <rt_object_get_information>
800029c4:	00050493          	mv	s1,a0
800029c8:	00051e63          	bnez	a0,800029e4 <rt_object_init+0x5c>
800029cc:	14500613          	li	a2,325
800029d0:	0000a597          	auipc	a1,0xa
800029d4:	49c58593          	addi	a1,a1,1180 # 8000ce6c <__FUNCTION__.3104>
800029d8:	0000a517          	auipc	a0,0xa
800029dc:	ce450513          	addi	a0,a0,-796 # 8000c6bc <__rti_rti_start_name+0x80>
800029e0:	80dff0ef          	jal	ra,800021ec <rt_assert_handler>
800029e4:	6a4000ef          	jal	ra,80003088 <rt_enter_critical>
800029e8:	0044a983          	lw	s3,4(s1)
800029ec:	00448a93          	addi	s5,s1,4
800029f0:	0000ab17          	auipc	s6,0xa
800029f4:	47cb0b13          	addi	s6,s6,1148 # 8000ce6c <__FUNCTION__.3104>
800029f8:	0000ab97          	auipc	s7,0xa
800029fc:	424b8b93          	addi	s7,s7,1060 # 8000ce1c <__fsym_list_mem_name+0xc>
80002a00:	07599c63          	bne	s3,s5,80002a78 <rt_object_init+0xf0>
80002a04:	6ac000ef          	jal	ra,800030b0 <rt_exit_critical>
80002a08:	f8096913          	ori	s2,s2,-128
80002a0c:	01240a23          	sb	s2,20(s0)
80002a10:	01400613          	li	a2,20
80002a14:	000a0593          	mv	a1,s4
80002a18:	00040513          	mv	a0,s0
80002a1c:	80cff0ef          	jal	ra,80001a28 <rt_strncpy>
80002a20:	8641a783          	lw	a5,-1948(gp) # 800202c4 <rt_object_attach_hook>
80002a24:	00078663          	beqz	a5,80002a30 <rt_object_init+0xa8>
80002a28:	00040513          	mv	a0,s0
80002a2c:	000780e7          	jalr	a5
80002a30:	790010ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
80002a34:	0044a703          	lw	a4,4(s1)
80002a38:	01840793          	addi	a5,s0,24
80002a3c:	02c12083          	lw	ra,44(sp)
80002a40:	00f72223          	sw	a5,4(a4)
80002a44:	00e42c23          	sw	a4,24(s0)
80002a48:	00f4a223          	sw	a5,4(s1)
80002a4c:	01342e23          	sw	s3,28(s0)
80002a50:	02812403          	lw	s0,40(sp)
80002a54:	02412483          	lw	s1,36(sp)
80002a58:	02012903          	lw	s2,32(sp)
80002a5c:	01c12983          	lw	s3,28(sp)
80002a60:	01812a03          	lw	s4,24(sp)
80002a64:	01412a83          	lw	s5,20(sp)
80002a68:	01012b03          	lw	s6,16(sp)
80002a6c:	00c12b83          	lw	s7,12(sp)
80002a70:	03010113          	addi	sp,sp,48
80002a74:	7540106f          	j	800041c8 <rt_hw_interrupt_enable>
80002a78:	fe898793          	addi	a5,s3,-24
80002a7c:	00f41a63          	bne	s0,a5,80002a90 <rt_object_init+0x108>
80002a80:	15500613          	li	a2,341
80002a84:	000b0593          	mv	a1,s6
80002a88:	000b8513          	mv	a0,s7
80002a8c:	f60ff0ef          	jal	ra,800021ec <rt_assert_handler>
80002a90:	0009a983          	lw	s3,0(s3)
80002a94:	f6dff06f          	j	80002a00 <rt_object_init+0x78>

80002a98 <rt_object_detach>:
80002a98:	ff010113          	addi	sp,sp,-16
80002a9c:	00812423          	sw	s0,8(sp)
80002aa0:	00112623          	sw	ra,12(sp)
80002aa4:	00050413          	mv	s0,a0
80002aa8:	00051e63          	bnez	a0,80002ac4 <rt_object_detach+0x2c>
80002aac:	18200613          	li	a2,386
80002ab0:	0000a597          	auipc	a1,0xa
80002ab4:	3cc58593          	addi	a1,a1,972 # 8000ce7c <__FUNCTION__.3113>
80002ab8:	0000a517          	auipc	a0,0xa
80002abc:	37450513          	addi	a0,a0,884 # 8000ce2c <__fsym_list_mem_name+0x1c>
80002ac0:	f2cff0ef          	jal	ra,800021ec <rt_assert_handler>
80002ac4:	8681a783          	lw	a5,-1944(gp) # 800202c8 <rt_object_detach_hook>
80002ac8:	00078663          	beqz	a5,80002ad4 <rt_object_detach+0x3c>
80002acc:	00040513          	mv	a0,s0
80002ad0:	000780e7          	jalr	a5
80002ad4:	00040a23          	sb	zero,20(s0)
80002ad8:	6e8010ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
80002adc:	01842683          	lw	a3,24(s0)
80002ae0:	01c42703          	lw	a4,28(s0)
80002ae4:	01840793          	addi	a5,s0,24
80002ae8:	00c12083          	lw	ra,12(sp)
80002aec:	00e6a223          	sw	a4,4(a3)
80002af0:	00d72023          	sw	a3,0(a4)
80002af4:	00f42e23          	sw	a5,28(s0)
80002af8:	00f42c23          	sw	a5,24(s0)
80002afc:	00812403          	lw	s0,8(sp)
80002b00:	01010113          	addi	sp,sp,16
80002b04:	6c40106f          	j	800041c8 <rt_hw_interrupt_enable>

80002b08 <rt_object_allocate>:
80002b08:	fe010113          	addi	sp,sp,-32
80002b0c:	00812c23          	sw	s0,24(sp)
80002b10:	01212823          	sw	s2,16(sp)
80002b14:	01312623          	sw	s3,12(sp)
80002b18:	00112e23          	sw	ra,28(sp)
80002b1c:	00912a23          	sw	s1,20(sp)
80002b20:	00050913          	mv	s2,a0
80002b24:	00058993          	mv	s3,a1
80002b28:	698010ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
80002b2c:	00050413          	mv	s0,a0
80002b30:	b5dfe0ef          	jal	ra,8000168c <rt_interrupt_get_nest>
80002b34:	02050863          	beqz	a0,80002b64 <rt_object_allocate+0x5c>
80002b38:	0000a597          	auipc	a1,0xa
80002b3c:	35858593          	addi	a1,a1,856 # 8000ce90 <__FUNCTION__.3122>
80002b40:	0000a517          	auipc	a0,0xa
80002b44:	c4c50513          	addi	a0,a0,-948 # 8000c78c <__FUNCTION__.3020+0x1c>
80002b48:	d24ff0ef          	jal	ra,8000206c <rt_kprintf>
80002b4c:	1a500613          	li	a2,421
80002b50:	0000a597          	auipc	a1,0xa
80002b54:	34058593          	addi	a1,a1,832 # 8000ce90 <__FUNCTION__.3122>
80002b58:	0000a517          	auipc	a0,0xa
80002b5c:	c5c50513          	addi	a0,a0,-932 # 8000c7b4 <__FUNCTION__.3020+0x44>
80002b60:	e8cff0ef          	jal	ra,800021ec <rt_assert_handler>
80002b64:	00040513          	mv	a0,s0
80002b68:	660010ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
80002b6c:	00090513          	mv	a0,s2
80002b70:	dddff0ef          	jal	ra,8000294c <rt_object_get_information>
80002b74:	00050493          	mv	s1,a0
80002b78:	00051e63          	bnez	a0,80002b94 <rt_object_allocate+0x8c>
80002b7c:	1a900613          	li	a2,425
80002b80:	0000a597          	auipc	a1,0xa
80002b84:	31058593          	addi	a1,a1,784 # 8000ce90 <__FUNCTION__.3122>
80002b88:	0000a517          	auipc	a0,0xa
80002b8c:	b3450513          	addi	a0,a0,-1228 # 8000c6bc <__rti_rti_start_name+0x80>
80002b90:	e5cff0ef          	jal	ra,800021ec <rt_assert_handler>
80002b94:	00c4a503          	lw	a0,12(s1)
80002b98:	941ff0ef          	jal	ra,800024d8 <rt_malloc>
80002b9c:	00050413          	mv	s0,a0
80002ba0:	04050e63          	beqz	a0,80002bfc <rt_object_allocate+0xf4>
80002ba4:	00c4a603          	lw	a2,12(s1)
80002ba8:	00000593          	li	a1,0
80002bac:	d5dfe0ef          	jal	ra,80001908 <rt_memset>
80002bb0:	01400613          	li	a2,20
80002bb4:	01240a23          	sb	s2,20(s0)
80002bb8:	00040aa3          	sb	zero,21(s0)
80002bbc:	00098593          	mv	a1,s3
80002bc0:	00040513          	mv	a0,s0
80002bc4:	e65fe0ef          	jal	ra,80001a28 <rt_strncpy>
80002bc8:	8641a783          	lw	a5,-1948(gp) # 800202c4 <rt_object_attach_hook>
80002bcc:	00078663          	beqz	a5,80002bd8 <rt_object_allocate+0xd0>
80002bd0:	00040513          	mv	a0,s0
80002bd4:	000780e7          	jalr	a5
80002bd8:	5e8010ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
80002bdc:	0044a703          	lw	a4,4(s1)
80002be0:	01840793          	addi	a5,s0,24
80002be4:	00448493          	addi	s1,s1,4
80002be8:	00f72223          	sw	a5,4(a4)
80002bec:	00e42c23          	sw	a4,24(s0)
80002bf0:	00f4a023          	sw	a5,0(s1)
80002bf4:	00942e23          	sw	s1,28(s0)
80002bf8:	5d0010ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
80002bfc:	01c12083          	lw	ra,28(sp)
80002c00:	00040513          	mv	a0,s0
80002c04:	01812403          	lw	s0,24(sp)
80002c08:	01412483          	lw	s1,20(sp)
80002c0c:	01012903          	lw	s2,16(sp)
80002c10:	00c12983          	lw	s3,12(sp)
80002c14:	02010113          	addi	sp,sp,32
80002c18:	00008067          	ret

80002c1c <rt_object_delete>:
80002c1c:	ff010113          	addi	sp,sp,-16
80002c20:	00812423          	sw	s0,8(sp)
80002c24:	00112623          	sw	ra,12(sp)
80002c28:	00050413          	mv	s0,a0
80002c2c:	00051e63          	bnez	a0,80002c48 <rt_object_delete+0x2c>
80002c30:	1e300613          	li	a2,483
80002c34:	0000a597          	auipc	a1,0xa
80002c38:	27058593          	addi	a1,a1,624 # 8000cea4 <__FUNCTION__.3127>
80002c3c:	0000a517          	auipc	a0,0xa
80002c40:	1f050513          	addi	a0,a0,496 # 8000ce2c <__fsym_list_mem_name+0x1c>
80002c44:	da8ff0ef          	jal	ra,800021ec <rt_assert_handler>
80002c48:	01440783          	lb	a5,20(s0)
80002c4c:	0007de63          	bgez	a5,80002c68 <rt_object_delete+0x4c>
80002c50:	1e400613          	li	a2,484
80002c54:	0000a597          	auipc	a1,0xa
80002c58:	25058593          	addi	a1,a1,592 # 8000cea4 <__FUNCTION__.3127>
80002c5c:	0000a517          	auipc	a0,0xa
80002c60:	1e450513          	addi	a0,a0,484 # 8000ce40 <__fsym_list_mem_name+0x30>
80002c64:	d88ff0ef          	jal	ra,800021ec <rt_assert_handler>
80002c68:	8681a783          	lw	a5,-1944(gp) # 800202c8 <rt_object_detach_hook>
80002c6c:	00078663          	beqz	a5,80002c78 <rt_object_delete+0x5c>
80002c70:	00040513          	mv	a0,s0
80002c74:	000780e7          	jalr	a5
80002c78:	00040a23          	sb	zero,20(s0)
80002c7c:	544010ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
80002c80:	01842683          	lw	a3,24(s0)
80002c84:	01c42703          	lw	a4,28(s0)
80002c88:	01840793          	addi	a5,s0,24
80002c8c:	00e6a223          	sw	a4,4(a3)
80002c90:	00d72023          	sw	a3,0(a4)
80002c94:	00f42e23          	sw	a5,28(s0)
80002c98:	00f42c23          	sw	a5,24(s0)
80002c9c:	52c010ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
80002ca0:	00040513          	mv	a0,s0
80002ca4:	00812403          	lw	s0,8(sp)
80002ca8:	00c12083          	lw	ra,12(sp)
80002cac:	01010113          	addi	sp,sp,16
80002cb0:	ad5ff06f          	j	80002784 <rt_free>

80002cb4 <rt_object_is_systemobject>:
80002cb4:	ff010113          	addi	sp,sp,-16
80002cb8:	00812423          	sw	s0,8(sp)
80002cbc:	00112623          	sw	ra,12(sp)
80002cc0:	00050413          	mv	s0,a0
80002cc4:	00051e63          	bnez	a0,80002ce0 <rt_object_is_systemobject+0x2c>
80002cc8:	20500613          	li	a2,517
80002ccc:	0000a597          	auipc	a1,0xa
80002cd0:	1ec58593          	addi	a1,a1,492 # 8000ceb8 <__FUNCTION__.3131>
80002cd4:	0000a517          	auipc	a0,0xa
80002cd8:	15850513          	addi	a0,a0,344 # 8000ce2c <__fsym_list_mem_name+0x1c>
80002cdc:	d10ff0ef          	jal	ra,800021ec <rt_assert_handler>
80002ce0:	01440503          	lb	a0,20(s0)
80002ce4:	00c12083          	lw	ra,12(sp)
80002ce8:	00812403          	lw	s0,8(sp)
80002cec:	01f55513          	srli	a0,a0,0x1f
80002cf0:	01010113          	addi	sp,sp,16
80002cf4:	00008067          	ret

80002cf8 <rt_object_get_type>:
80002cf8:	ff010113          	addi	sp,sp,-16
80002cfc:	00812423          	sw	s0,8(sp)
80002d00:	00112623          	sw	ra,12(sp)
80002d04:	00050413          	mv	s0,a0
80002d08:	00051e63          	bnez	a0,80002d24 <rt_object_get_type+0x2c>
80002d0c:	21800613          	li	a2,536
80002d10:	0000a597          	auipc	a1,0xa
80002d14:	1c458593          	addi	a1,a1,452 # 8000ced4 <__FUNCTION__.3135>
80002d18:	0000a517          	auipc	a0,0xa
80002d1c:	11450513          	addi	a0,a0,276 # 8000ce2c <__fsym_list_mem_name+0x1c>
80002d20:	cccff0ef          	jal	ra,800021ec <rt_assert_handler>
80002d24:	01444503          	lbu	a0,20(s0)
80002d28:	00c12083          	lw	ra,12(sp)
80002d2c:	00812403          	lw	s0,8(sp)
80002d30:	07f57513          	andi	a0,a0,127
80002d34:	01010113          	addi	sp,sp,16
80002d38:	00008067          	ret

80002d3c <rt_system_scheduler_init>:
80002d3c:	88019223          	sh	zero,-1916(gp) # 800202e4 <rt_scheduler_lock_nest>
80002d40:	c5c18793          	addi	a5,gp,-932 # 800206bc <rt_thread_priority_table>
80002d44:	d5c18713          	addi	a4,gp,-676 # 800207bc <timer_thread>
80002d48:	00f7a223          	sw	a5,4(a5)
80002d4c:	00f7a023          	sw	a5,0(a5)
80002d50:	00878793          	addi	a5,a5,8
80002d54:	fee79ae3          	bne	a5,a4,80002d48 <rt_system_scheduler_init+0xc>
80002d58:	8801a823          	sw	zero,-1904(gp) # 800202f0 <rt_thread_ready_priority_group>
80002d5c:	88818793          	addi	a5,gp,-1912 # 800202e8 <rt_thread_defunct>
80002d60:	00f7a223          	sw	a5,4(a5)
80002d64:	00f7a023          	sw	a5,0(a5)
80002d68:	00008067          	ret

80002d6c <rt_schedule_insert_thread>:
80002d6c:	ff010113          	addi	sp,sp,-16
80002d70:	00812423          	sw	s0,8(sp)
80002d74:	00112623          	sw	ra,12(sp)
80002d78:	00050413          	mv	s0,a0
80002d7c:	00051e63          	bnez	a0,80002d98 <rt_schedule_insert_thread+0x2c>
80002d80:	2c400613          	li	a2,708
80002d84:	0000a597          	auipc	a1,0xa
80002d88:	1cc58593          	addi	a1,a1,460 # 8000cf50 <__FUNCTION__.3079>
80002d8c:	0000a517          	auipc	a0,0xa
80002d90:	15c50513          	addi	a0,a0,348 # 8000cee8 <__FUNCTION__.3135+0x14>
80002d94:	c58ff0ef          	jal	ra,800021ec <rt_assert_handler>
80002d98:	428010ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
80002d9c:	04044783          	lbu	a5,64(s0)
80002da0:	87c1a703          	lw	a4,-1924(gp) # 800202dc <rt_current_thread>
80002da4:	ff87f793          	andi	a5,a5,-8
80002da8:	00871e63          	bne	a4,s0,80002dc4 <rt_schedule_insert_thread+0x58>
80002dac:	0037e793          	ori	a5,a5,3
80002db0:	04f40023          	sb	a5,64(s0)
80002db4:	00812403          	lw	s0,8(sp)
80002db8:	00c12083          	lw	ra,12(sp)
80002dbc:	01010113          	addi	sp,sp,16
80002dc0:	4080106f          	j	800041c8 <rt_hw_interrupt_enable>
80002dc4:	0017e793          	ori	a5,a5,1
80002dc8:	04f40023          	sb	a5,64(s0)
80002dcc:	04144783          	lbu	a5,65(s0)
80002dd0:	02040693          	addi	a3,s0,32
80002dd4:	00379713          	slli	a4,a5,0x3
80002dd8:	c5c18793          	addi	a5,gp,-932 # 800206bc <rt_thread_priority_table>
80002ddc:	00e787b3          	add	a5,a5,a4
80002de0:	0047a703          	lw	a4,4(a5)
80002de4:	00d72023          	sw	a3,0(a4)
80002de8:	02e42223          	sw	a4,36(s0)
80002dec:	00d7a223          	sw	a3,4(a5)
80002df0:	89018713          	addi	a4,gp,-1904 # 800202f0 <rt_thread_ready_priority_group>
80002df4:	00072683          	lw	a3,0(a4)
80002df8:	02f42023          	sw	a5,32(s0)
80002dfc:	04442783          	lw	a5,68(s0)
80002e00:	00d7e7b3          	or	a5,a5,a3
80002e04:	00f72023          	sw	a5,0(a4)
80002e08:	fadff06f          	j	80002db4 <rt_schedule_insert_thread+0x48>

80002e0c <rt_schedule_remove_thread>:
80002e0c:	ff010113          	addi	sp,sp,-16
80002e10:	00812423          	sw	s0,8(sp)
80002e14:	00112623          	sw	ra,12(sp)
80002e18:	00050413          	mv	s0,a0
80002e1c:	00051e63          	bnez	a0,80002e38 <rt_schedule_remove_thread+0x2c>
80002e20:	32500613          	li	a2,805
80002e24:	0000a597          	auipc	a1,0xa
80002e28:	14858593          	addi	a1,a1,328 # 8000cf6c <__FUNCTION__.3085>
80002e2c:	0000a517          	auipc	a0,0xa
80002e30:	0bc50513          	addi	a0,a0,188 # 8000cee8 <__FUNCTION__.3135+0x14>
80002e34:	bb8ff0ef          	jal	ra,800021ec <rt_assert_handler>
80002e38:	388010ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
80002e3c:	02442703          	lw	a4,36(s0)
80002e40:	02042683          	lw	a3,32(s0)
80002e44:	02040793          	addi	a5,s0,32
80002e48:	00e6a223          	sw	a4,4(a3)
80002e4c:	00d72023          	sw	a3,0(a4)
80002e50:	02f42023          	sw	a5,32(s0)
80002e54:	02f42223          	sw	a5,36(s0)
80002e58:	04144783          	lbu	a5,65(s0)
80002e5c:	00379713          	slli	a4,a5,0x3
80002e60:	c5c18793          	addi	a5,gp,-932 # 800206bc <rt_thread_priority_table>
80002e64:	00e787b3          	add	a5,a5,a4
80002e68:	0007a703          	lw	a4,0(a5)
80002e6c:	00f71e63          	bne	a4,a5,80002e88 <rt_schedule_remove_thread+0x7c>
80002e70:	89018713          	addi	a4,gp,-1904 # 800202f0 <rt_thread_ready_priority_group>
80002e74:	04442783          	lw	a5,68(s0)
80002e78:	00072683          	lw	a3,0(a4)
80002e7c:	fff7c793          	not	a5,a5
80002e80:	00d7f7b3          	and	a5,a5,a3
80002e84:	00f72023          	sw	a5,0(a4)
80002e88:	00812403          	lw	s0,8(sp)
80002e8c:	00c12083          	lw	ra,12(sp)
80002e90:	01010113          	addi	sp,sp,16
80002e94:	3340106f          	j	800041c8 <rt_hw_interrupt_enable>

80002e98 <rt_system_scheduler_start>:
80002e98:	ff010113          	addi	sp,sp,-16
80002e9c:	8901a503          	lw	a0,-1904(gp) # 800202f0 <rt_thread_ready_priority_group>
80002ea0:	00112623          	sw	ra,12(sp)
80002ea4:	00812423          	sw	s0,8(sp)
80002ea8:	ac0ff0ef          	jal	ra,80002168 <__rt_ffs>
80002eac:	fff50513          	addi	a0,a0,-1
80002eb0:	c5c18793          	addi	a5,gp,-932 # 800206bc <rt_thread_priority_table>
80002eb4:	00351513          	slli	a0,a0,0x3
80002eb8:	00a78533          	add	a0,a5,a0
80002ebc:	00052403          	lw	s0,0(a0)
80002ec0:	fe040513          	addi	a0,s0,-32
80002ec4:	86a1ae23          	sw	a0,-1924(gp) # 800202dc <rt_current_thread>
80002ec8:	f45ff0ef          	jal	ra,80002e0c <rt_schedule_remove_thread>
80002ecc:	00300793          	li	a5,3
80002ed0:	02f40023          	sb	a5,32(s0)
80002ed4:	00840513          	addi	a0,s0,8
80002ed8:	00812403          	lw	s0,8(sp)
80002edc:	00c12083          	lw	ra,12(sp)
80002ee0:	01010113          	addi	sp,sp,16
80002ee4:	45c0106f          	j	80004340 <rt_hw_context_switch_to>

80002ee8 <rt_schedule>:
80002ee8:	fe010113          	addi	sp,sp,-32
80002eec:	01312623          	sw	s3,12(sp)
80002ef0:	00112e23          	sw	ra,28(sp)
80002ef4:	00812c23          	sw	s0,24(sp)
80002ef8:	00912a23          	sw	s1,20(sp)
80002efc:	01212823          	sw	s2,16(sp)
80002f00:	01412423          	sw	s4,8(sp)
80002f04:	2bc010ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
80002f08:	88419783          	lh	a5,-1916(gp) # 800202e4 <rt_scheduler_lock_nest>
80002f0c:	00050993          	mv	s3,a0
80002f10:	10079463          	bnez	a5,80003018 <rt_schedule+0x130>
80002f14:	8901a503          	lw	a0,-1904(gp) # 800202f0 <rt_thread_ready_priority_group>
80002f18:	10050063          	beqz	a0,80003018 <rt_schedule+0x130>
80002f1c:	a4cff0ef          	jal	ra,80002168 <__rt_ffs>
80002f20:	87c18913          	addi	s2,gp,-1924 # 800202dc <rt_current_thread>
80002f24:	00092483          	lw	s1,0(s2)
80002f28:	fff50793          	addi	a5,a0,-1
80002f2c:	00379693          	slli	a3,a5,0x3
80002f30:	c5c18713          	addi	a4,gp,-932 # 800206bc <rt_thread_priority_table>
80002f34:	00d70733          	add	a4,a4,a3
80002f38:	00072403          	lw	s0,0(a4)
80002f3c:	0404c703          	lbu	a4,64(s1)
80002f40:	00300693          	li	a3,3
80002f44:	fe040413          	addi	s0,s0,-32
80002f48:	00777613          	andi	a2,a4,7
80002f4c:	00000a13          	li	s4,0
80002f50:	02d61663          	bne	a2,a3,80002f7c <rt_schedule+0x94>
80002f54:	0414c683          	lbu	a3,65(s1)
80002f58:	0ef6e263          	bltu	a3,a5,8000303c <rt_schedule+0x154>
80002f5c:	00100a13          	li	s4,1
80002f60:	00f69a63          	bne	a3,a5,80002f74 <rt_schedule+0x8c>
80002f64:	00877693          	andi	a3,a4,8
80002f68:	00069663          	bnez	a3,80002f74 <rt_schedule+0x8c>
80002f6c:	00048413          	mv	s0,s1
80002f70:	00000a13          	li	s4,0
80002f74:	ff777713          	andi	a4,a4,-9
80002f78:	04e48023          	sb	a4,64(s1)
80002f7c:	0e848663          	beq	s1,s0,80003068 <rt_schedule+0x180>
80002f80:	86f18c23          	sb	a5,-1928(gp) # 800202d8 <rt_current_priority>
80002f84:	00892023          	sw	s0,0(s2)
80002f88:	8801a783          	lw	a5,-1920(gp) # 800202e0 <rt_scheduler_hook>
80002f8c:	00078863          	beqz	a5,80002f9c <rt_schedule+0xb4>
80002f90:	00040593          	mv	a1,s0
80002f94:	00048513          	mv	a0,s1
80002f98:	000780e7          	jalr	a5
80002f9c:	000a0663          	beqz	s4,80002fa8 <rt_schedule+0xc0>
80002fa0:	00048513          	mv	a0,s1
80002fa4:	dc9ff0ef          	jal	ra,80002d6c <rt_schedule_insert_thread>
80002fa8:	00040513          	mv	a0,s0
80002fac:	e61ff0ef          	jal	ra,80002e0c <rt_schedule_remove_thread>
80002fb0:	04044783          	lbu	a5,64(s0)
80002fb4:	02300713          	li	a4,35
80002fb8:	ff87f793          	andi	a5,a5,-8
80002fbc:	0037e793          	ori	a5,a5,3
80002fc0:	04f40023          	sb	a5,64(s0)
80002fc4:	03442783          	lw	a5,52(s0)
80002fc8:	0007c683          	lbu	a3,0(a5)
80002fcc:	00e69c63          	bne	a3,a4,80002fe4 <rt_schedule+0xfc>
80002fd0:	02842703          	lw	a4,40(s0)
80002fd4:	00e7f863          	bgeu	a5,a4,80002fe4 <rt_schedule+0xfc>
80002fd8:	03842683          	lw	a3,56(s0)
80002fdc:	00d786b3          	add	a3,a5,a3
80002fe0:	06e6f263          	bgeu	a3,a4,80003044 <rt_schedule+0x15c>
80002fe4:	00040593          	mv	a1,s0
80002fe8:	0000a517          	auipc	a0,0xa
80002fec:	f1450513          	addi	a0,a0,-236 # 8000cefc <__FUNCTION__.3135+0x28>
80002ff0:	87cff0ef          	jal	ra,8000206c <rt_kprintf>
80002ff4:	4b4030ef          	jal	ra,800064a8 <list_thread>
80002ff8:	1c8010ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
80002ffc:	00051063          	bnez	a0,80002ffc <rt_schedule+0x114>
80003000:	0001d797          	auipc	a5,0x1d
80003004:	2947c783          	lbu	a5,660(a5) # 80020294 <rt_interrupt_nest>
80003008:	02848513          	addi	a0,s1,40
8000300c:	02840593          	addi	a1,s0,40
80003010:	04079863          	bnez	a5,80003060 <rt_schedule+0x178>
80003014:	12c010ef          	jal	ra,80004140 <rt_hw_context_switch>
80003018:	01812403          	lw	s0,24(sp)
8000301c:	01c12083          	lw	ra,28(sp)
80003020:	01412483          	lw	s1,20(sp)
80003024:	01012903          	lw	s2,16(sp)
80003028:	00812a03          	lw	s4,8(sp)
8000302c:	00098513          	mv	a0,s3
80003030:	00c12983          	lw	s3,12(sp)
80003034:	02010113          	addi	sp,sp,32
80003038:	1900106f          	j	800041c8 <rt_hw_interrupt_enable>
8000303c:	00048413          	mv	s0,s1
80003040:	f35ff06f          	j	80002f74 <rt_schedule+0x8c>
80003044:	02078793          	addi	a5,a5,32
80003048:	fae7ece3          	bltu	a5,a4,80003000 <rt_schedule+0x118>
8000304c:	00040593          	mv	a1,s0
80003050:	0000a517          	auipc	a0,0xa
80003054:	ec850513          	addi	a0,a0,-312 # 8000cf18 <__FUNCTION__.3135+0x44>
80003058:	814ff0ef          	jal	ra,8000206c <rt_kprintf>
8000305c:	fa5ff06f          	j	80003000 <rt_schedule+0x118>
80003060:	0a4010ef          	jal	ra,80004104 <rt_hw_context_switch_interrupt>
80003064:	fb5ff06f          	j	80003018 <rt_schedule+0x130>
80003068:	00048513          	mv	a0,s1
8000306c:	da1ff0ef          	jal	ra,80002e0c <rt_schedule_remove_thread>
80003070:	00092703          	lw	a4,0(s2)
80003074:	04074783          	lbu	a5,64(a4)
80003078:	ff87f793          	andi	a5,a5,-8
8000307c:	0037e793          	ori	a5,a5,3
80003080:	04f70023          	sb	a5,64(a4)
80003084:	f95ff06f          	j	80003018 <rt_schedule+0x130>

80003088 <rt_enter_critical>:
80003088:	ff010113          	addi	sp,sp,-16
8000308c:	00112623          	sw	ra,12(sp)
80003090:	130010ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
80003094:	88418713          	addi	a4,gp,-1916 # 800202e4 <rt_scheduler_lock_nest>
80003098:	00075783          	lhu	a5,0(a4)
8000309c:	00c12083          	lw	ra,12(sp)
800030a0:	00178793          	addi	a5,a5,1
800030a4:	00f71023          	sh	a5,0(a4)
800030a8:	01010113          	addi	sp,sp,16
800030ac:	11c0106f          	j	800041c8 <rt_hw_interrupt_enable>

800030b0 <rt_exit_critical>:
800030b0:	ff010113          	addi	sp,sp,-16
800030b4:	00112623          	sw	ra,12(sp)
800030b8:	108010ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
800030bc:	88418713          	addi	a4,gp,-1916 # 800202e4 <rt_scheduler_lock_nest>
800030c0:	00075783          	lhu	a5,0(a4)
800030c4:	fff78793          	addi	a5,a5,-1
800030c8:	01079793          	slli	a5,a5,0x10
800030cc:	4107d793          	srai	a5,a5,0x10
800030d0:	00f71023          	sh	a5,0(a4)
800030d4:	02f04063          	bgtz	a5,800030f4 <rt_exit_critical+0x44>
800030d8:	88019223          	sh	zero,-1916(gp) # 800202e4 <rt_scheduler_lock_nest>
800030dc:	0ec010ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
800030e0:	87c1a783          	lw	a5,-1924(gp) # 800202dc <rt_current_thread>
800030e4:	00078e63          	beqz	a5,80003100 <rt_exit_critical+0x50>
800030e8:	00c12083          	lw	ra,12(sp)
800030ec:	01010113          	addi	sp,sp,16
800030f0:	df9ff06f          	j	80002ee8 <rt_schedule>
800030f4:	00c12083          	lw	ra,12(sp)
800030f8:	01010113          	addi	sp,sp,16
800030fc:	0cc0106f          	j	800041c8 <rt_hw_interrupt_enable>
80003100:	00c12083          	lw	ra,12(sp)
80003104:	01010113          	addi	sp,sp,16
80003108:	00008067          	ret

8000310c <rt_thread_exit>:
8000310c:	ff010113          	addi	sp,sp,-16
80003110:	00112623          	sw	ra,12(sp)
80003114:	00812423          	sw	s0,8(sp)
80003118:	00912223          	sw	s1,4(sp)
8000311c:	87c1a403          	lw	s0,-1924(gp) # 800202dc <rt_current_thread>
80003120:	0a0010ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
80003124:	00050493          	mv	s1,a0
80003128:	00040513          	mv	a0,s0
8000312c:	ce1ff0ef          	jal	ra,80002e0c <rt_schedule_remove_thread>
80003130:	00400793          	li	a5,4
80003134:	04f40023          	sb	a5,64(s0)
80003138:	05840513          	addi	a0,s0,88
8000313c:	7e0000ef          	jal	ra,8000391c <rt_timer_detach>
80003140:	00040513          	mv	a0,s0
80003144:	b71ff0ef          	jal	ra,80002cb4 <rt_object_is_systemobject>
80003148:	00100793          	li	a5,1
8000314c:	02f51863          	bne	a0,a5,8000317c <rt_thread_exit+0x70>
80003150:	09042783          	lw	a5,144(s0)
80003154:	02079463          	bnez	a5,8000317c <rt_thread_exit+0x70>
80003158:	00040513          	mv	a0,s0
8000315c:	93dff0ef          	jal	ra,80002a98 <rt_object_detach>
80003160:	d89ff0ef          	jal	ra,80002ee8 <rt_schedule>
80003164:	00812403          	lw	s0,8(sp)
80003168:	00c12083          	lw	ra,12(sp)
8000316c:	00048513          	mv	a0,s1
80003170:	00412483          	lw	s1,4(sp)
80003174:	01010113          	addi	sp,sp,16
80003178:	0500106f          	j	800041c8 <rt_hw_interrupt_enable>
8000317c:	88818793          	addi	a5,gp,-1912 # 800202e8 <rt_thread_defunct>
80003180:	0007a683          	lw	a3,0(a5)
80003184:	02040713          	addi	a4,s0,32
80003188:	00e7a023          	sw	a4,0(a5)
8000318c:	00e6a223          	sw	a4,4(a3)
80003190:	02d42023          	sw	a3,32(s0)
80003194:	02f42223          	sw	a5,36(s0)
80003198:	fc9ff06f          	j	80003160 <rt_thread_exit+0x54>

8000319c <_rt_thread_init.isra.0>:
8000319c:	ff010113          	addi	sp,sp,-16
800031a0:	00812423          	sw	s0,8(sp)
800031a4:	00050413          	mv	s0,a0
800031a8:	00912223          	sw	s1,4(sp)
800031ac:	00078493          	mv	s1,a5
800031b0:	02040793          	addi	a5,s0,32
800031b4:	00068513          	mv	a0,a3
800031b8:	02f42223          	sw	a5,36(s0)
800031bc:	02f42023          	sw	a5,32(s0)
800031c0:	02b42623          	sw	a1,44(s0)
800031c4:	02c42823          	sw	a2,48(s0)
800031c8:	02d42a23          	sw	a3,52(s0)
800031cc:	00070613          	mv	a2,a4
800031d0:	02e42c23          	sw	a4,56(s0)
800031d4:	02300593          	li	a1,35
800031d8:	00112623          	sw	ra,12(sp)
800031dc:	01212023          	sw	s2,0(sp)
800031e0:	00080913          	mv	s2,a6
800031e4:	f24fe0ef          	jal	ra,80001908 <rt_memset>
800031e8:	03842783          	lw	a5,56(s0)
800031ec:	03442603          	lw	a2,52(s0)
800031f0:	03042583          	lw	a1,48(s0)
800031f4:	02c42503          	lw	a0,44(s0)
800031f8:	ffc78793          	addi	a5,a5,-4
800031fc:	00f60633          	add	a2,a2,a5
80003200:	00000697          	auipc	a3,0x0
80003204:	f0c68693          	addi	a3,a3,-244 # 8000310c <rt_thread_exit>
80003208:	6b5000ef          	jal	ra,800040bc <rt_hw_stack_init>
8000320c:	02a42423          	sw	a0,40(s0)
80003210:	01f00793          	li	a5,31
80003214:	0097fe63          	bgeu	a5,s1,80003230 <_rt_thread_init.isra.0+0x94>
80003218:	09500613          	li	a2,149
8000321c:	0000a597          	auipc	a1,0xa
80003220:	e7c58593          	addi	a1,a1,-388 # 8000d098 <__FUNCTION__.3055>
80003224:	0000a517          	auipc	a0,0xa
80003228:	d6450513          	addi	a0,a0,-668 # 8000cf88 <__FUNCTION__.3085+0x1c>
8000322c:	fc1fe0ef          	jal	ra,800021ec <rt_assert_handler>
80003230:	00000793          	li	a5,0
80003234:	04940123          	sb	s1,66(s0)
80003238:	049400a3          	sb	s1,65(s0)
8000323c:	04042223          	sw	zero,68(s0)
80003240:	05242823          	sw	s2,80(s0)
80003244:	05242a23          	sw	s2,84(s0)
80003248:	02042e23          	sw	zero,60(s0)
8000324c:	04040023          	sb	zero,64(s0)
80003250:	08042823          	sw	zero,144(s0)
80003254:	08042a23          	sw	zero,148(s0)
80003258:	00000713          	li	a4,0
8000325c:	00040693          	mv	a3,s0
80003260:	00000617          	auipc	a2,0x0
80003264:	04060613          	addi	a2,a2,64 # 800032a0 <rt_thread_timeout>
80003268:	00040593          	mv	a1,s0
8000326c:	05840513          	addi	a0,s0,88
80003270:	600000ef          	jal	ra,80003870 <rt_timer_init>
80003274:	8941a783          	lw	a5,-1900(gp) # 800202f4 <rt_thread_inited_hook>
80003278:	00078663          	beqz	a5,80003284 <_rt_thread_init.isra.0+0xe8>
8000327c:	00040513          	mv	a0,s0
80003280:	000780e7          	jalr	a5
80003284:	00c12083          	lw	ra,12(sp)
80003288:	00812403          	lw	s0,8(sp)
8000328c:	00412483          	lw	s1,4(sp)
80003290:	00012903          	lw	s2,0(sp)
80003294:	00000513          	li	a0,0
80003298:	01010113          	addi	sp,sp,16
8000329c:	00008067          	ret

800032a0 <rt_thread_timeout>:
800032a0:	ff010113          	addi	sp,sp,-16
800032a4:	00812423          	sw	s0,8(sp)
800032a8:	00112623          	sw	ra,12(sp)
800032ac:	00050413          	mv	s0,a0
800032b0:	00051e63          	bnez	a0,800032cc <rt_thread_timeout+0x2c>
800032b4:	34400613          	li	a2,836
800032b8:	0000a597          	auipc	a1,0xa
800032bc:	e4c58593          	addi	a1,a1,-436 # 8000d104 <__FUNCTION__.3150>
800032c0:	0000a517          	auipc	a0,0xa
800032c4:	c2850513          	addi	a0,a0,-984 # 8000cee8 <__FUNCTION__.3135+0x14>
800032c8:	f25fe0ef          	jal	ra,800021ec <rt_assert_handler>
800032cc:	04044783          	lbu	a5,64(s0)
800032d0:	00200713          	li	a4,2
800032d4:	0077f793          	andi	a5,a5,7
800032d8:	00e78e63          	beq	a5,a4,800032f4 <rt_thread_timeout+0x54>
800032dc:	34500613          	li	a2,837
800032e0:	0000a597          	auipc	a1,0xa
800032e4:	e2458593          	addi	a1,a1,-476 # 8000d104 <__FUNCTION__.3150>
800032e8:	0000a517          	auipc	a0,0xa
800032ec:	cc450513          	addi	a0,a0,-828 # 8000cfac <__FUNCTION__.3085+0x40>
800032f0:	efdfe0ef          	jal	ra,800021ec <rt_assert_handler>
800032f4:	00040513          	mv	a0,s0
800032f8:	a01ff0ef          	jal	ra,80002cf8 <rt_object_get_type>
800032fc:	00100793          	li	a5,1
80003300:	00f50e63          	beq	a0,a5,8000331c <rt_thread_timeout+0x7c>
80003304:	34600613          	li	a2,838
80003308:	0000a597          	auipc	a1,0xa
8000330c:	dfc58593          	addi	a1,a1,-516 # 8000d104 <__FUNCTION__.3150>
80003310:	0000a517          	auipc	a0,0xa
80003314:	cd850513          	addi	a0,a0,-808 # 8000cfe8 <__FUNCTION__.3085+0x7c>
80003318:	ed5fe0ef          	jal	ra,800021ec <rt_assert_handler>
8000331c:	02042683          	lw	a3,32(s0)
80003320:	02442703          	lw	a4,36(s0)
80003324:	ffe00793          	li	a5,-2
80003328:	02f42e23          	sw	a5,60(s0)
8000332c:	00e6a223          	sw	a4,4(a3)
80003330:	02040793          	addi	a5,s0,32
80003334:	00d72023          	sw	a3,0(a4)
80003338:	02f42223          	sw	a5,36(s0)
8000333c:	02f42023          	sw	a5,32(s0)
80003340:	00040513          	mv	a0,s0
80003344:	a29ff0ef          	jal	ra,80002d6c <rt_schedule_insert_thread>
80003348:	00812403          	lw	s0,8(sp)
8000334c:	00c12083          	lw	ra,12(sp)
80003350:	01010113          	addi	sp,sp,16
80003354:	b95ff06f          	j	80002ee8 <rt_schedule>

80003358 <rt_thread_init>:
80003358:	fd010113          	addi	sp,sp,-48
8000335c:	02812423          	sw	s0,40(sp)
80003360:	02912223          	sw	s1,36(sp)
80003364:	03212023          	sw	s2,32(sp)
80003368:	01312e23          	sw	s3,28(sp)
8000336c:	01412c23          	sw	s4,24(sp)
80003370:	01512a23          	sw	s5,20(sp)
80003374:	01612823          	sw	s6,16(sp)
80003378:	01712623          	sw	s7,12(sp)
8000337c:	02112623          	sw	ra,44(sp)
80003380:	00050413          	mv	s0,a0
80003384:	00058b93          	mv	s7,a1
80003388:	00060913          	mv	s2,a2
8000338c:	00068993          	mv	s3,a3
80003390:	00070493          	mv	s1,a4
80003394:	00078a13          	mv	s4,a5
80003398:	00080a93          	mv	s5,a6
8000339c:	00088b13          	mv	s6,a7
800033a0:	00051e63          	bnez	a0,800033bc <rt_thread_init+0x64>
800033a4:	0f200613          	li	a2,242
800033a8:	0000a597          	auipc	a1,0xa
800033ac:	d0058593          	addi	a1,a1,-768 # 8000d0a8 <__FUNCTION__.3067>
800033b0:	0000a517          	auipc	a0,0xa
800033b4:	b3850513          	addi	a0,a0,-1224 # 8000cee8 <__FUNCTION__.3135+0x14>
800033b8:	e35fe0ef          	jal	ra,800021ec <rt_assert_handler>
800033bc:	00049e63          	bnez	s1,800033d8 <rt_thread_init+0x80>
800033c0:	0f300613          	li	a2,243
800033c4:	0000a597          	auipc	a1,0xa
800033c8:	ce458593          	addi	a1,a1,-796 # 8000d0a8 <__FUNCTION__.3067>
800033cc:	0000a517          	auipc	a0,0xa
800033d0:	c6050513          	addi	a0,a0,-928 # 8000d02c <__FUNCTION__.3085+0xc0>
800033d4:	e19fe0ef          	jal	ra,800021ec <rt_assert_handler>
800033d8:	000b8613          	mv	a2,s7
800033dc:	00040513          	mv	a0,s0
800033e0:	00100593          	li	a1,1
800033e4:	da4ff0ef          	jal	ra,80002988 <rt_object_init>
800033e8:	00040513          	mv	a0,s0
800033ec:	02812403          	lw	s0,40(sp)
800033f0:	02c12083          	lw	ra,44(sp)
800033f4:	00c12b83          	lw	s7,12(sp)
800033f8:	000b0813          	mv	a6,s6
800033fc:	000a8793          	mv	a5,s5
80003400:	01012b03          	lw	s6,16(sp)
80003404:	01412a83          	lw	s5,20(sp)
80003408:	000a0713          	mv	a4,s4
8000340c:	00048693          	mv	a3,s1
80003410:	01812a03          	lw	s4,24(sp)
80003414:	02412483          	lw	s1,36(sp)
80003418:	00098613          	mv	a2,s3
8000341c:	00090593          	mv	a1,s2
80003420:	01c12983          	lw	s3,28(sp)
80003424:	02012903          	lw	s2,32(sp)
80003428:	03010113          	addi	sp,sp,48
8000342c:	d71ff06f          	j	8000319c <_rt_thread_init.isra.0>

80003430 <rt_thread_self>:
80003430:	87c1a503          	lw	a0,-1924(gp) # 800202dc <rt_current_thread>
80003434:	00008067          	ret

80003438 <rt_thread_create>:
80003438:	fe010113          	addi	sp,sp,-32
8000343c:	01212823          	sw	s2,16(sp)
80003440:	00058913          	mv	s2,a1
80003444:	00050593          	mv	a1,a0
80003448:	00100513          	li	a0,1
8000344c:	00812c23          	sw	s0,24(sp)
80003450:	00912a23          	sw	s1,20(sp)
80003454:	01312623          	sw	s3,12(sp)
80003458:	01412423          	sw	s4,8(sp)
8000345c:	01512223          	sw	s5,4(sp)
80003460:	00112e23          	sw	ra,28(sp)
80003464:	00060993          	mv	s3,a2
80003468:	00068493          	mv	s1,a3
8000346c:	00070a13          	mv	s4,a4
80003470:	00078a93          	mv	s5,a5
80003474:	e94ff0ef          	jal	ra,80002b08 <rt_object_allocate>
80003478:	00050413          	mv	s0,a0
8000347c:	02050063          	beqz	a0,8000349c <rt_thread_create+0x64>
80003480:	00048513          	mv	a0,s1
80003484:	854ff0ef          	jal	ra,800024d8 <rt_malloc>
80003488:	00050693          	mv	a3,a0
8000348c:	02051c63          	bnez	a0,800034c4 <rt_thread_create+0x8c>
80003490:	00040513          	mv	a0,s0
80003494:	f88ff0ef          	jal	ra,80002c1c <rt_object_delete>
80003498:	00000413          	li	s0,0
8000349c:	01c12083          	lw	ra,28(sp)
800034a0:	00040513          	mv	a0,s0
800034a4:	01812403          	lw	s0,24(sp)
800034a8:	01412483          	lw	s1,20(sp)
800034ac:	01012903          	lw	s2,16(sp)
800034b0:	00c12983          	lw	s3,12(sp)
800034b4:	00812a03          	lw	s4,8(sp)
800034b8:	00412a83          	lw	s5,4(sp)
800034bc:	02010113          	addi	sp,sp,32
800034c0:	00008067          	ret
800034c4:	000a8813          	mv	a6,s5
800034c8:	000a0793          	mv	a5,s4
800034cc:	00048713          	mv	a4,s1
800034d0:	00098613          	mv	a2,s3
800034d4:	00090593          	mv	a1,s2
800034d8:	00040513          	mv	a0,s0
800034dc:	cc1ff0ef          	jal	ra,8000319c <_rt_thread_init.isra.0>
800034e0:	fbdff06f          	j	8000349c <rt_thread_create+0x64>

800034e4 <rt_thread_suspend>:
800034e4:	ff010113          	addi	sp,sp,-16
800034e8:	00812423          	sw	s0,8(sp)
800034ec:	00112623          	sw	ra,12(sp)
800034f0:	00912223          	sw	s1,4(sp)
800034f4:	01212023          	sw	s2,0(sp)
800034f8:	00050413          	mv	s0,a0
800034fc:	00051e63          	bnez	a0,80003518 <rt_thread_suspend+0x34>
80003500:	2e700613          	li	a2,743
80003504:	0000a597          	auipc	a1,0xa
80003508:	bd858593          	addi	a1,a1,-1064 # 8000d0dc <__FUNCTION__.3140>
8000350c:	0000a517          	auipc	a0,0xa
80003510:	9dc50513          	addi	a0,a0,-1572 # 8000cee8 <__FUNCTION__.3135+0x14>
80003514:	cd9fe0ef          	jal	ra,800021ec <rt_assert_handler>
80003518:	00040513          	mv	a0,s0
8000351c:	fdcff0ef          	jal	ra,80002cf8 <rt_object_get_type>
80003520:	00100793          	li	a5,1
80003524:	00f50e63          	beq	a0,a5,80003540 <rt_thread_suspend+0x5c>
80003528:	2e800613          	li	a2,744
8000352c:	0000a597          	auipc	a1,0xa
80003530:	bb058593          	addi	a1,a1,-1104 # 8000d0dc <__FUNCTION__.3140>
80003534:	0000a517          	auipc	a0,0xa
80003538:	ab450513          	addi	a0,a0,-1356 # 8000cfe8 <__FUNCTION__.3085+0x7c>
8000353c:	cb1fe0ef          	jal	ra,800021ec <rt_assert_handler>
80003540:	04044783          	lbu	a5,64(s0)
80003544:	00100713          	li	a4,1
80003548:	fff00513          	li	a0,-1
8000354c:	0077f913          	andi	s2,a5,7
80003550:	0057f793          	andi	a5,a5,5
80003554:	06e79a63          	bne	a5,a4,800035c8 <rt_thread_suspend+0xe4>
80003558:	469000ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
8000355c:	00300793          	li	a5,3
80003560:	00050493          	mv	s1,a0
80003564:	02f91263          	bne	s2,a5,80003588 <rt_thread_suspend+0xa4>
80003568:	87c1a783          	lw	a5,-1924(gp) # 800202dc <rt_current_thread>
8000356c:	00f40e63          	beq	s0,a5,80003588 <rt_thread_suspend+0xa4>
80003570:	2f900613          	li	a2,761
80003574:	0000a597          	auipc	a1,0xa
80003578:	b6858593          	addi	a1,a1,-1176 # 8000d0dc <__FUNCTION__.3140>
8000357c:	0000a517          	auipc	a0,0xa
80003580:	ac850513          	addi	a0,a0,-1336 # 8000d044 <__FUNCTION__.3085+0xd8>
80003584:	c69fe0ef          	jal	ra,800021ec <rt_assert_handler>
80003588:	00040513          	mv	a0,s0
8000358c:	881ff0ef          	jal	ra,80002e0c <rt_schedule_remove_thread>
80003590:	04044783          	lbu	a5,64(s0)
80003594:	05840513          	addi	a0,s0,88
80003598:	ff87f793          	andi	a5,a5,-8
8000359c:	0027e793          	ori	a5,a5,2
800035a0:	04f40023          	sb	a5,64(s0)
800035a4:	5c4000ef          	jal	ra,80003b68 <rt_timer_stop>
800035a8:	00048513          	mv	a0,s1
800035ac:	41d000ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
800035b0:	89c1a783          	lw	a5,-1892(gp) # 800202fc <rt_thread_suspend_hook>
800035b4:	00000513          	li	a0,0
800035b8:	00078863          	beqz	a5,800035c8 <rt_thread_suspend+0xe4>
800035bc:	00040513          	mv	a0,s0
800035c0:	000780e7          	jalr	a5
800035c4:	00000513          	li	a0,0
800035c8:	00c12083          	lw	ra,12(sp)
800035cc:	00812403          	lw	s0,8(sp)
800035d0:	00412483          	lw	s1,4(sp)
800035d4:	00012903          	lw	s2,0(sp)
800035d8:	01010113          	addi	sp,sp,16
800035dc:	00008067          	ret

800035e0 <rt_thread_sleep>:
800035e0:	fe010113          	addi	sp,sp,-32
800035e4:	00812c23          	sw	s0,24(sp)
800035e8:	00112e23          	sw	ra,28(sp)
800035ec:	00912a23          	sw	s1,20(sp)
800035f0:	01212823          	sw	s2,16(sp)
800035f4:	00a12623          	sw	a0,12(sp)
800035f8:	87c1a403          	lw	s0,-1924(gp) # 800202dc <rt_current_thread>
800035fc:	00041e63          	bnez	s0,80003618 <rt_thread_sleep+0x38>
80003600:	1fd00613          	li	a2,509
80003604:	0000a597          	auipc	a1,0xa
80003608:	ac858593          	addi	a1,a1,-1336 # 8000d0cc <__FUNCTION__.3108>
8000360c:	0000a517          	auipc	a0,0xa
80003610:	8dc50513          	addi	a0,a0,-1828 # 8000cee8 <__FUNCTION__.3135+0x14>
80003614:	bd9fe0ef          	jal	ra,800021ec <rt_assert_handler>
80003618:	00040513          	mv	a0,s0
8000361c:	edcff0ef          	jal	ra,80002cf8 <rt_object_get_type>
80003620:	00100793          	li	a5,1
80003624:	00f50e63          	beq	a0,a5,80003640 <rt_thread_sleep+0x60>
80003628:	1fe00613          	li	a2,510
8000362c:	0000a597          	auipc	a1,0xa
80003630:	aa058593          	addi	a1,a1,-1376 # 8000d0cc <__FUNCTION__.3108>
80003634:	0000a517          	auipc	a0,0xa
80003638:	9b450513          	addi	a0,a0,-1612 # 8000cfe8 <__FUNCTION__.3085+0x7c>
8000363c:	bb1fe0ef          	jal	ra,800021ec <rt_assert_handler>
80003640:	381000ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
80003644:	00050913          	mv	s2,a0
80003648:	00040513          	mv	a0,s0
8000364c:	e99ff0ef          	jal	ra,800034e4 <rt_thread_suspend>
80003650:	05840493          	addi	s1,s0,88
80003654:	00c10613          	addi	a2,sp,12
80003658:	00000593          	li	a1,0
8000365c:	00048513          	mv	a0,s1
80003660:	5bc000ef          	jal	ra,80003c1c <rt_timer_control>
80003664:	00048513          	mv	a0,s1
80003668:	374000ef          	jal	ra,800039dc <rt_timer_start>
8000366c:	00090513          	mv	a0,s2
80003670:	359000ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
80003674:	875ff0ef          	jal	ra,80002ee8 <rt_schedule>
80003678:	03c42703          	lw	a4,60(s0)
8000367c:	ffe00793          	li	a5,-2
80003680:	00f71463          	bne	a4,a5,80003688 <rt_thread_sleep+0xa8>
80003684:	02042e23          	sw	zero,60(s0)
80003688:	01c12083          	lw	ra,28(sp)
8000368c:	01812403          	lw	s0,24(sp)
80003690:	01412483          	lw	s1,20(sp)
80003694:	01012903          	lw	s2,16(sp)
80003698:	00000513          	li	a0,0
8000369c:	02010113          	addi	sp,sp,32
800036a0:	00008067          	ret

800036a4 <rt_thread_delay>:
800036a4:	f3dff06f          	j	800035e0 <rt_thread_sleep>

800036a8 <rt_thread_mdelay>:
800036a8:	ff010113          	addi	sp,sp,-16
800036ac:	00112623          	sw	ra,12(sp)
800036b0:	9b0fd0ef          	jal	ra,80000860 <rt_tick_from_millisecond>
800036b4:	00c12083          	lw	ra,12(sp)
800036b8:	01010113          	addi	sp,sp,16
800036bc:	f25ff06f          	j	800035e0 <rt_thread_sleep>

800036c0 <rt_thread_resume>:
800036c0:	ff010113          	addi	sp,sp,-16
800036c4:	00812423          	sw	s0,8(sp)
800036c8:	00112623          	sw	ra,12(sp)
800036cc:	00912223          	sw	s1,4(sp)
800036d0:	00050413          	mv	s0,a0
800036d4:	00051e63          	bnez	a0,800036f0 <rt_thread_resume+0x30>
800036d8:	31700613          	li	a2,791
800036dc:	0000a597          	auipc	a1,0xa
800036e0:	a1458593          	addi	a1,a1,-1516 # 8000d0f0 <__FUNCTION__.3145>
800036e4:	0000a517          	auipc	a0,0xa
800036e8:	80450513          	addi	a0,a0,-2044 # 8000cee8 <__FUNCTION__.3135+0x14>
800036ec:	b01fe0ef          	jal	ra,800021ec <rt_assert_handler>
800036f0:	00040513          	mv	a0,s0
800036f4:	e04ff0ef          	jal	ra,80002cf8 <rt_object_get_type>
800036f8:	00100793          	li	a5,1
800036fc:	00f50e63          	beq	a0,a5,80003718 <rt_thread_resume+0x58>
80003700:	31800613          	li	a2,792
80003704:	0000a597          	auipc	a1,0xa
80003708:	9ec58593          	addi	a1,a1,-1556 # 8000d0f0 <__FUNCTION__.3145>
8000370c:	0000a517          	auipc	a0,0xa
80003710:	8dc50513          	addi	a0,a0,-1828 # 8000cfe8 <__FUNCTION__.3085+0x7c>
80003714:	ad9fe0ef          	jal	ra,800021ec <rt_assert_handler>
80003718:	04044783          	lbu	a5,64(s0)
8000371c:	00200713          	li	a4,2
80003720:	fff00513          	li	a0,-1
80003724:	0077f793          	andi	a5,a5,7
80003728:	04e79c63          	bne	a5,a4,80003780 <rt_thread_resume+0xc0>
8000372c:	295000ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
80003730:	02042683          	lw	a3,32(s0)
80003734:	02442703          	lw	a4,36(s0)
80003738:	02040793          	addi	a5,s0,32
8000373c:	00050493          	mv	s1,a0
80003740:	00e6a223          	sw	a4,4(a3)
80003744:	00d72023          	sw	a3,0(a4)
80003748:	02f42223          	sw	a5,36(s0)
8000374c:	02f42023          	sw	a5,32(s0)
80003750:	05840513          	addi	a0,s0,88
80003754:	414000ef          	jal	ra,80003b68 <rt_timer_stop>
80003758:	00048513          	mv	a0,s1
8000375c:	26d000ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
80003760:	00040513          	mv	a0,s0
80003764:	e08ff0ef          	jal	ra,80002d6c <rt_schedule_insert_thread>
80003768:	8981a783          	lw	a5,-1896(gp) # 800202f8 <rt_thread_resume_hook>
8000376c:	00000513          	li	a0,0
80003770:	00078863          	beqz	a5,80003780 <rt_thread_resume+0xc0>
80003774:	00040513          	mv	a0,s0
80003778:	000780e7          	jalr	a5
8000377c:	00000513          	li	a0,0
80003780:	00c12083          	lw	ra,12(sp)
80003784:	00812403          	lw	s0,8(sp)
80003788:	00412483          	lw	s1,4(sp)
8000378c:	01010113          	addi	sp,sp,16
80003790:	00008067          	ret

80003794 <rt_thread_startup>:
80003794:	ff010113          	addi	sp,sp,-16
80003798:	00812423          	sw	s0,8(sp)
8000379c:	00112623          	sw	ra,12(sp)
800037a0:	00050413          	mv	s0,a0
800037a4:	00051e63          	bnez	a0,800037c0 <rt_thread_startup+0x2c>
800037a8:	12400613          	li	a2,292
800037ac:	0000a597          	auipc	a1,0xa
800037b0:	90c58593          	addi	a1,a1,-1780 # 8000d0b8 <__FUNCTION__.3076>
800037b4:	00009517          	auipc	a0,0x9
800037b8:	73450513          	addi	a0,a0,1844 # 8000cee8 <__FUNCTION__.3135+0x14>
800037bc:	a31fe0ef          	jal	ra,800021ec <rt_assert_handler>
800037c0:	04044783          	lbu	a5,64(s0)
800037c4:	0077f793          	andi	a5,a5,7
800037c8:	00078e63          	beqz	a5,800037e4 <rt_thread_startup+0x50>
800037cc:	12500613          	li	a2,293
800037d0:	0000a597          	auipc	a1,0xa
800037d4:	8e858593          	addi	a1,a1,-1816 # 8000d0b8 <__FUNCTION__.3076>
800037d8:	0000a517          	auipc	a0,0xa
800037dc:	88850513          	addi	a0,a0,-1912 # 8000d060 <__FUNCTION__.3085+0xf4>
800037e0:	a0dfe0ef          	jal	ra,800021ec <rt_assert_handler>
800037e4:	00040513          	mv	a0,s0
800037e8:	d10ff0ef          	jal	ra,80002cf8 <rt_object_get_type>
800037ec:	00100793          	li	a5,1
800037f0:	00f50e63          	beq	a0,a5,8000380c <rt_thread_startup+0x78>
800037f4:	12600613          	li	a2,294
800037f8:	0000a597          	auipc	a1,0xa
800037fc:	8c058593          	addi	a1,a1,-1856 # 8000d0b8 <__FUNCTION__.3076>
80003800:	00009517          	auipc	a0,0x9
80003804:	7e850513          	addi	a0,a0,2024 # 8000cfe8 <__FUNCTION__.3085+0x7c>
80003808:	9e5fe0ef          	jal	ra,800021ec <rt_assert_handler>
8000380c:	04244703          	lbu	a4,66(s0)
80003810:	00100793          	li	a5,1
80003814:	00040513          	mv	a0,s0
80003818:	00e797b3          	sll	a5,a5,a4
8000381c:	04f42223          	sw	a5,68(s0)
80003820:	00200793          	li	a5,2
80003824:	04f40023          	sb	a5,64(s0)
80003828:	04e400a3          	sb	a4,65(s0)
8000382c:	e95ff0ef          	jal	ra,800036c0 <rt_thread_resume>
80003830:	87c1a783          	lw	a5,-1924(gp) # 800202dc <rt_current_thread>
80003834:	00078463          	beqz	a5,8000383c <rt_thread_startup+0xa8>
80003838:	eb0ff0ef          	jal	ra,80002ee8 <rt_schedule>
8000383c:	00c12083          	lw	ra,12(sp)
80003840:	00812403          	lw	s0,8(sp)
80003844:	00000513          	li	a0,0
80003848:	01010113          	addi	sp,sp,16
8000384c:	00008067          	ret

80003850 <_rt_timer_remove>:
80003850:	02052683          	lw	a3,32(a0)
80003854:	02452703          	lw	a4,36(a0)
80003858:	02050793          	addi	a5,a0,32
8000385c:	00e6a223          	sw	a4,4(a3)
80003860:	00d72023          	sw	a3,0(a4)
80003864:	02f52223          	sw	a5,36(a0)
80003868:	02f52023          	sw	a5,32(a0)
8000386c:	00008067          	ret

80003870 <rt_timer_init>:
80003870:	fe010113          	addi	sp,sp,-32
80003874:	00812c23          	sw	s0,24(sp)
80003878:	00912a23          	sw	s1,20(sp)
8000387c:	01212823          	sw	s2,16(sp)
80003880:	01312623          	sw	s3,12(sp)
80003884:	01412423          	sw	s4,8(sp)
80003888:	01512223          	sw	s5,4(sp)
8000388c:	00112e23          	sw	ra,28(sp)
80003890:	00050413          	mv	s0,a0
80003894:	00058a93          	mv	s5,a1
80003898:	00060a13          	mv	s4,a2
8000389c:	00068993          	mv	s3,a3
800038a0:	00070913          	mv	s2,a4
800038a4:	00078493          	mv	s1,a5
800038a8:	00051e63          	bnez	a0,800038c4 <rt_timer_init+0x54>
800038ac:	0c900613          	li	a2,201
800038b0:	0000a597          	auipc	a1,0xa
800038b4:	92458593          	addi	a1,a1,-1756 # 8000d1d4 <__FUNCTION__.3075>
800038b8:	0000a517          	auipc	a0,0xa
800038bc:	86050513          	addi	a0,a0,-1952 # 8000d118 <__FUNCTION__.3150+0x14>
800038c0:	92dfe0ef          	jal	ra,800021ec <rt_assert_handler>
800038c4:	000a8613          	mv	a2,s5
800038c8:	00040513          	mv	a0,s0
800038cc:	00a00593          	li	a1,10
800038d0:	8b8ff0ef          	jal	ra,80002988 <rt_object_init>
800038d4:	02040793          	addi	a5,s0,32
800038d8:	ffe4f493          	andi	s1,s1,-2
800038dc:	00940aa3          	sb	s1,21(s0)
800038e0:	03442423          	sw	s4,40(s0)
800038e4:	03342623          	sw	s3,44(s0)
800038e8:	03242823          	sw	s2,48(s0)
800038ec:	01c12083          	lw	ra,28(sp)
800038f0:	02042a23          	sw	zero,52(s0)
800038f4:	02f42223          	sw	a5,36(s0)
800038f8:	02f42023          	sw	a5,32(s0)
800038fc:	01812403          	lw	s0,24(sp)
80003900:	01412483          	lw	s1,20(sp)
80003904:	01012903          	lw	s2,16(sp)
80003908:	00c12983          	lw	s3,12(sp)
8000390c:	00812a03          	lw	s4,8(sp)
80003910:	00412a83          	lw	s5,4(sp)
80003914:	02010113          	addi	sp,sp,32
80003918:	00008067          	ret

8000391c <rt_timer_detach>:
8000391c:	ff010113          	addi	sp,sp,-16
80003920:	00812423          	sw	s0,8(sp)
80003924:	00112623          	sw	ra,12(sp)
80003928:	00912223          	sw	s1,4(sp)
8000392c:	00050413          	mv	s0,a0
80003930:	00051e63          	bnez	a0,8000394c <rt_timer_detach+0x30>
80003934:	0de00613          	li	a2,222
80003938:	0000a597          	auipc	a1,0xa
8000393c:	8ac58593          	addi	a1,a1,-1876 # 8000d1e4 <__FUNCTION__.3080>
80003940:	00009517          	auipc	a0,0x9
80003944:	7d850513          	addi	a0,a0,2008 # 8000d118 <__FUNCTION__.3150+0x14>
80003948:	8a5fe0ef          	jal	ra,800021ec <rt_assert_handler>
8000394c:	00040513          	mv	a0,s0
80003950:	ba8ff0ef          	jal	ra,80002cf8 <rt_object_get_type>
80003954:	00a00793          	li	a5,10
80003958:	00f50e63          	beq	a0,a5,80003974 <rt_timer_detach+0x58>
8000395c:	0df00613          	li	a2,223
80003960:	0000a597          	auipc	a1,0xa
80003964:	88458593          	addi	a1,a1,-1916 # 8000d1e4 <__FUNCTION__.3080>
80003968:	00009517          	auipc	a0,0x9
8000396c:	7c450513          	addi	a0,a0,1988 # 8000d12c <__FUNCTION__.3150+0x28>
80003970:	87dfe0ef          	jal	ra,800021ec <rt_assert_handler>
80003974:	00040513          	mv	a0,s0
80003978:	b3cff0ef          	jal	ra,80002cb4 <rt_object_is_systemobject>
8000397c:	00051e63          	bnez	a0,80003998 <rt_timer_detach+0x7c>
80003980:	0e000613          	li	a2,224
80003984:	0000a597          	auipc	a1,0xa
80003988:	86058593          	addi	a1,a1,-1952 # 8000d1e4 <__FUNCTION__.3080>
8000398c:	00009517          	auipc	a0,0x9
80003990:	7dc50513          	addi	a0,a0,2012 # 8000d168 <__FUNCTION__.3150+0x64>
80003994:	859fe0ef          	jal	ra,800021ec <rt_assert_handler>
80003998:	029000ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
8000399c:	00050493          	mv	s1,a0
800039a0:	00040513          	mv	a0,s0
800039a4:	eadff0ef          	jal	ra,80003850 <_rt_timer_remove>
800039a8:	01544783          	lbu	a5,21(s0)
800039ac:	00048513          	mv	a0,s1
800039b0:	ffe7f793          	andi	a5,a5,-2
800039b4:	00f40aa3          	sb	a5,21(s0)
800039b8:	011000ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
800039bc:	00040513          	mv	a0,s0
800039c0:	8d8ff0ef          	jal	ra,80002a98 <rt_object_detach>
800039c4:	00c12083          	lw	ra,12(sp)
800039c8:	00812403          	lw	s0,8(sp)
800039cc:	00412483          	lw	s1,4(sp)
800039d0:	00000513          	li	a0,0
800039d4:	01010113          	addi	sp,sp,16
800039d8:	00008067          	ret

800039dc <rt_timer_start>:
800039dc:	ff010113          	addi	sp,sp,-16
800039e0:	00812423          	sw	s0,8(sp)
800039e4:	00112623          	sw	ra,12(sp)
800039e8:	00912223          	sw	s1,4(sp)
800039ec:	00050413          	mv	s0,a0
800039f0:	00051e63          	bnez	a0,80003a0c <rt_timer_start+0x30>
800039f4:	14500613          	li	a2,325
800039f8:	00009597          	auipc	a1,0x9
800039fc:	7fc58593          	addi	a1,a1,2044 # 8000d1f4 <__FUNCTION__.3104>
80003a00:	00009517          	auipc	a0,0x9
80003a04:	71850513          	addi	a0,a0,1816 # 8000d118 <__FUNCTION__.3150+0x14>
80003a08:	fe4fe0ef          	jal	ra,800021ec <rt_assert_handler>
80003a0c:	00040513          	mv	a0,s0
80003a10:	ae8ff0ef          	jal	ra,80002cf8 <rt_object_get_type>
80003a14:	00a00793          	li	a5,10
80003a18:	00f50e63          	beq	a0,a5,80003a34 <rt_timer_start+0x58>
80003a1c:	14600613          	li	a2,326
80003a20:	00009597          	auipc	a1,0x9
80003a24:	7d458593          	addi	a1,a1,2004 # 8000d1f4 <__FUNCTION__.3104>
80003a28:	00009517          	auipc	a0,0x9
80003a2c:	70450513          	addi	a0,a0,1796 # 8000d12c <__FUNCTION__.3150+0x28>
80003a30:	fbcfe0ef          	jal	ra,800021ec <rt_assert_handler>
80003a34:	78c000ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
80003a38:	00050493          	mv	s1,a0
80003a3c:	00040513          	mv	a0,s0
80003a40:	e11ff0ef          	jal	ra,80003850 <_rt_timer_remove>
80003a44:	01544783          	lbu	a5,21(s0)
80003a48:	00048513          	mv	a0,s1
80003a4c:	ffe7f793          	andi	a5,a5,-2
80003a50:	00f40aa3          	sb	a5,21(s0)
80003a54:	774000ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
80003a58:	8701a783          	lw	a5,-1936(gp) # 800202d0 <rt_object_take_hook>
80003a5c:	00078663          	beqz	a5,80003a68 <rt_timer_start+0x8c>
80003a60:	00040513          	mv	a0,s0
80003a64:	000780e7          	jalr	a5
80003a68:	03042703          	lw	a4,48(s0)
80003a6c:	800007b7          	lui	a5,0x80000
80003a70:	ffe7c793          	xori	a5,a5,-2
80003a74:	00e7fe63          	bgeu	a5,a4,80003a90 <rt_timer_start+0xb4>
80003a78:	15600613          	li	a2,342
80003a7c:	00009597          	auipc	a1,0x9
80003a80:	77858593          	addi	a1,a1,1912 # 8000d1f4 <__FUNCTION__.3104>
80003a84:	00009517          	auipc	a0,0x9
80003a88:	71050513          	addi	a0,a0,1808 # 8000d194 <__FUNCTION__.3150+0x90>
80003a8c:	f60fe0ef          	jal	ra,800021ec <rt_assert_handler>
80003a90:	d71fc0ef          	jal	ra,80000800 <rt_tick_get>
80003a94:	03042783          	lw	a5,48(s0)
80003a98:	00a787b3          	add	a5,a5,a0
80003a9c:	02f42a23          	sw	a5,52(s0)
80003aa0:	720000ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
80003aa4:	01544703          	lbu	a4,21(s0)
80003aa8:	8a418793          	addi	a5,gp,-1884 # 80020304 <rt_soft_timer_list>
80003aac:	00477713          	andi	a4,a4,4
80003ab0:	00071463          	bnez	a4,80003ab8 <rt_timer_start+0xdc>
80003ab4:	8b418793          	addi	a5,gp,-1868 # 80020314 <rt_timer_list>
80003ab8:	0047a803          	lw	a6,4(a5) # 80000004 <_sp+0xfffc0004>
80003abc:	80000637          	lui	a2,0x80000
80003ac0:	ffe64613          	xori	a2,a2,-2
80003ac4:	0007a703          	lw	a4,0(a5)
80003ac8:	08f81263          	bne	a6,a5,80003b4c <rt_timer_start+0x170>
80003acc:	8a018613          	addi	a2,gp,-1888 # 80020300 <random_nr.3103>
80003ad0:	00062683          	lw	a3,0(a2) # 80000000 <_sp+0xfffc0000>
80003ad4:	00168693          	addi	a3,a3,1
80003ad8:	00d62023          	sw	a3,0(a2)
80003adc:	02040693          	addi	a3,s0,32
80003ae0:	00d72223          	sw	a3,4(a4)
80003ae4:	02e42023          	sw	a4,32(s0)
80003ae8:	00d7a023          	sw	a3,0(a5)
80003aec:	02f42223          	sw	a5,36(s0)
80003af0:	01544783          	lbu	a5,21(s0)
80003af4:	0017e793          	ori	a5,a5,1
80003af8:	00f40aa3          	sb	a5,21(s0)
80003afc:	6cc000ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
80003b00:	01544783          	lbu	a5,21(s0)
80003b04:	0047f793          	andi	a5,a5,4
80003b08:	02078663          	beqz	a5,80003b34 <rt_timer_start+0x158>
80003b0c:	8101c703          	lbu	a4,-2032(gp) # 80020270 <soft_timer_status>
80003b10:	00100793          	li	a5,1
80003b14:	02f71063          	bne	a4,a5,80003b34 <rt_timer_start+0x158>
80003b18:	d5c18513          	addi	a0,gp,-676 # 800207bc <timer_thread>
80003b1c:	04054783          	lbu	a5,64(a0)
80003b20:	00200713          	li	a4,2
80003b24:	0077f793          	andi	a5,a5,7
80003b28:	00e79663          	bne	a5,a4,80003b34 <rt_timer_start+0x158>
80003b2c:	b95ff0ef          	jal	ra,800036c0 <rt_thread_resume>
80003b30:	bb8ff0ef          	jal	ra,80002ee8 <rt_schedule>
80003b34:	00c12083          	lw	ra,12(sp)
80003b38:	00812403          	lw	s0,8(sp)
80003b3c:	00412483          	lw	s1,4(sp)
80003b40:	00000513          	li	a0,0
80003b44:	01010113          	addi	sp,sp,16
80003b48:	00008067          	ret
80003b4c:	01472683          	lw	a3,20(a4)
80003b50:	03442583          	lw	a1,52(s0)
80003b54:	00b68663          	beq	a3,a1,80003b60 <rt_timer_start+0x184>
80003b58:	40b686b3          	sub	a3,a3,a1
80003b5c:	f6d678e3          	bgeu	a2,a3,80003acc <rt_timer_start+0xf0>
80003b60:	00070793          	mv	a5,a4
80003b64:	f61ff06f          	j	80003ac4 <rt_timer_start+0xe8>

80003b68 <rt_timer_stop>:
80003b68:	ff010113          	addi	sp,sp,-16
80003b6c:	00812423          	sw	s0,8(sp)
80003b70:	00112623          	sw	ra,12(sp)
80003b74:	00912223          	sw	s1,4(sp)
80003b78:	00050413          	mv	s0,a0
80003b7c:	00051e63          	bnez	a0,80003b98 <rt_timer_stop+0x30>
80003b80:	1bf00613          	li	a2,447
80003b84:	00009597          	auipc	a1,0x9
80003b88:	68058593          	addi	a1,a1,1664 # 8000d204 <__FUNCTION__.3121>
80003b8c:	00009517          	auipc	a0,0x9
80003b90:	58c50513          	addi	a0,a0,1420 # 8000d118 <__FUNCTION__.3150+0x14>
80003b94:	e58fe0ef          	jal	ra,800021ec <rt_assert_handler>
80003b98:	00040513          	mv	a0,s0
80003b9c:	95cff0ef          	jal	ra,80002cf8 <rt_object_get_type>
80003ba0:	00a00793          	li	a5,10
80003ba4:	00f50e63          	beq	a0,a5,80003bc0 <rt_timer_stop+0x58>
80003ba8:	1c000613          	li	a2,448
80003bac:	00009597          	auipc	a1,0x9
80003bb0:	65858593          	addi	a1,a1,1624 # 8000d204 <__FUNCTION__.3121>
80003bb4:	00009517          	auipc	a0,0x9
80003bb8:	57850513          	addi	a0,a0,1400 # 8000d12c <__FUNCTION__.3150+0x28>
80003bbc:	e30fe0ef          	jal	ra,800021ec <rt_assert_handler>
80003bc0:	01544783          	lbu	a5,21(s0)
80003bc4:	fff00513          	li	a0,-1
80003bc8:	0017f793          	andi	a5,a5,1
80003bcc:	02078e63          	beqz	a5,80003c08 <rt_timer_stop+0xa0>
80003bd0:	86c1a783          	lw	a5,-1940(gp) # 800202cc <rt_object_put_hook>
80003bd4:	00078663          	beqz	a5,80003be0 <rt_timer_stop+0x78>
80003bd8:	00040513          	mv	a0,s0
80003bdc:	000780e7          	jalr	a5
80003be0:	5e0000ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
80003be4:	00050493          	mv	s1,a0
80003be8:	00040513          	mv	a0,s0
80003bec:	c65ff0ef          	jal	ra,80003850 <_rt_timer_remove>
80003bf0:	01544783          	lbu	a5,21(s0)
80003bf4:	00048513          	mv	a0,s1
80003bf8:	ffe7f793          	andi	a5,a5,-2
80003bfc:	00f40aa3          	sb	a5,21(s0)
80003c00:	5c8000ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
80003c04:	00000513          	li	a0,0
80003c08:	00c12083          	lw	ra,12(sp)
80003c0c:	00812403          	lw	s0,8(sp)
80003c10:	00412483          	lw	s1,4(sp)
80003c14:	01010113          	addi	sp,sp,16
80003c18:	00008067          	ret

80003c1c <rt_timer_control>:
80003c1c:	ff010113          	addi	sp,sp,-16
80003c20:	00812423          	sw	s0,8(sp)
80003c24:	00912223          	sw	s1,4(sp)
80003c28:	01212023          	sw	s2,0(sp)
80003c2c:	00112623          	sw	ra,12(sp)
80003c30:	00050413          	mv	s0,a0
80003c34:	00058493          	mv	s1,a1
80003c38:	00060913          	mv	s2,a2
80003c3c:	00051e63          	bnez	a0,80003c58 <rt_timer_control+0x3c>
80003c40:	1e300613          	li	a2,483
80003c44:	00009597          	auipc	a1,0x9
80003c48:	5d058593          	addi	a1,a1,1488 # 8000d214 <__FUNCTION__.3128>
80003c4c:	00009517          	auipc	a0,0x9
80003c50:	4cc50513          	addi	a0,a0,1228 # 8000d118 <__FUNCTION__.3150+0x14>
80003c54:	d98fe0ef          	jal	ra,800021ec <rt_assert_handler>
80003c58:	00040513          	mv	a0,s0
80003c5c:	89cff0ef          	jal	ra,80002cf8 <rt_object_get_type>
80003c60:	00a00793          	li	a5,10
80003c64:	00f50e63          	beq	a0,a5,80003c80 <rt_timer_control+0x64>
80003c68:	1e400613          	li	a2,484
80003c6c:	00009597          	auipc	a1,0x9
80003c70:	5a858593          	addi	a1,a1,1448 # 8000d214 <__FUNCTION__.3128>
80003c74:	00009517          	auipc	a0,0x9
80003c78:	4b850513          	addi	a0,a0,1208 # 8000d12c <__FUNCTION__.3150+0x28>
80003c7c:	d70fe0ef          	jal	ra,800021ec <rt_assert_handler>
80003c80:	540000ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
80003c84:	00400793          	li	a5,4
80003c88:	0297ea63          	bltu	a5,s1,80003cbc <rt_timer_control+0xa0>
80003c8c:	00009717          	auipc	a4,0x9
80003c90:	52c70713          	addi	a4,a4,1324 # 8000d1b8 <__FUNCTION__.3150+0xb4>
80003c94:	00249493          	slli	s1,s1,0x2
80003c98:	00e484b3          	add	s1,s1,a4
80003c9c:	0004a783          	lw	a5,0(s1)
80003ca0:	00e787b3          	add	a5,a5,a4
80003ca4:	00078067          	jr	a5
80003ca8:	03042783          	lw	a5,48(s0)
80003cac:	00f92023          	sw	a5,0(s2)
80003cb0:	00c0006f          	j	80003cbc <rt_timer_control+0xa0>
80003cb4:	00092783          	lw	a5,0(s2)
80003cb8:	02f42823          	sw	a5,48(s0)
80003cbc:	50c000ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
80003cc0:	00c12083          	lw	ra,12(sp)
80003cc4:	00812403          	lw	s0,8(sp)
80003cc8:	00412483          	lw	s1,4(sp)
80003ccc:	00012903          	lw	s2,0(sp)
80003cd0:	00000513          	li	a0,0
80003cd4:	01010113          	addi	sp,sp,16
80003cd8:	00008067          	ret
80003cdc:	01544783          	lbu	a5,21(s0)
80003ce0:	ffd7f793          	andi	a5,a5,-3
80003ce4:	00f40aa3          	sb	a5,21(s0)
80003ce8:	fd5ff06f          	j	80003cbc <rt_timer_control+0xa0>
80003cec:	01544783          	lbu	a5,21(s0)
80003cf0:	0027e793          	ori	a5,a5,2
80003cf4:	ff1ff06f          	j	80003ce4 <rt_timer_control+0xc8>
80003cf8:	01544783          	lbu	a5,21(s0)
80003cfc:	0017f793          	andi	a5,a5,1
80003d00:	00078663          	beqz	a5,80003d0c <rt_timer_control+0xf0>
80003d04:	00100793          	li	a5,1
80003d08:	fa5ff06f          	j	80003cac <rt_timer_control+0x90>
80003d0c:	00092023          	sw	zero,0(s2)
80003d10:	fadff06f          	j	80003cbc <rt_timer_control+0xa0>

80003d14 <rt_timer_check>:
80003d14:	fc010113          	addi	sp,sp,-64
80003d18:	03212823          	sw	s2,48(sp)
80003d1c:	00810913          	addi	s2,sp,8
80003d20:	02112e23          	sw	ra,60(sp)
80003d24:	02912a23          	sw	s1,52(sp)
80003d28:	03412423          	sw	s4,40(sp)
80003d2c:	03512223          	sw	s5,36(sp)
80003d30:	03612023          	sw	s6,32(sp)
80003d34:	01712e23          	sw	s7,28(sp)
80003d38:	01812c23          	sw	s8,24(sp)
80003d3c:	01912a23          	sw	s9,20(sp)
80003d40:	02812c23          	sw	s0,56(sp)
80003d44:	03312623          	sw	s3,44(sp)
80003d48:	01212423          	sw	s2,8(sp)
80003d4c:	01212623          	sw	s2,12(sp)
80003d50:	ab1fc0ef          	jal	ra,80000800 <rt_tick_get>
80003d54:	00050493          	mv	s1,a0
80003d58:	80000ab7          	lui	s5,0x80000
80003d5c:	464000ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
80003d60:	00050a13          	mv	s4,a0
80003d64:	8b418b13          	addi	s6,gp,-1868 # 80020314 <rt_timer_list>
80003d68:	ffeaca93          	xori	s5,s5,-2
80003d6c:	8ac18b93          	addi	s7,gp,-1876 # 8002030c <rt_timer_enter_hook>
80003d70:	8b018c13          	addi	s8,gp,-1872 # 80020310 <rt_timer_exit_hook>
80003d74:	00300c93          	li	s9,3
80003d78:	000b2403          	lw	s0,0(s6)
80003d7c:	05641063          	bne	s0,s6,80003dbc <rt_timer_check+0xa8>
80003d80:	000a0513          	mv	a0,s4
80003d84:	444000ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
80003d88:	03c12083          	lw	ra,60(sp)
80003d8c:	03812403          	lw	s0,56(sp)
80003d90:	03412483          	lw	s1,52(sp)
80003d94:	03012903          	lw	s2,48(sp)
80003d98:	02c12983          	lw	s3,44(sp)
80003d9c:	02812a03          	lw	s4,40(sp)
80003da0:	02412a83          	lw	s5,36(sp)
80003da4:	02012b03          	lw	s6,32(sp)
80003da8:	01c12b83          	lw	s7,28(sp)
80003dac:	01812c03          	lw	s8,24(sp)
80003db0:	01412c83          	lw	s9,20(sp)
80003db4:	04010113          	addi	sp,sp,64
80003db8:	00008067          	ret
80003dbc:	01442503          	lw	a0,20(s0)
80003dc0:	fe040993          	addi	s3,s0,-32
80003dc4:	40a484b3          	sub	s1,s1,a0
80003dc8:	fa9aece3          	bltu	s5,s1,80003d80 <rt_timer_check+0x6c>
80003dcc:	000ba783          	lw	a5,0(s7)
80003dd0:	00078663          	beqz	a5,80003ddc <rt_timer_check+0xc8>
80003dd4:	00098513          	mv	a0,s3
80003dd8:	000780e7          	jalr	a5
80003ddc:	00098513          	mv	a0,s3
80003de0:	a71ff0ef          	jal	ra,80003850 <_rt_timer_remove>
80003de4:	ff544783          	lbu	a5,-11(s0)
80003de8:	0027f713          	andi	a4,a5,2
80003dec:	00071663          	bnez	a4,80003df8 <rt_timer_check+0xe4>
80003df0:	ffe7f793          	andi	a5,a5,-2
80003df4:	fef40aa3          	sb	a5,-11(s0)
80003df8:	00812783          	lw	a5,8(sp)
80003dfc:	00c42503          	lw	a0,12(s0)
80003e00:	0087a223          	sw	s0,4(a5)
80003e04:	00f42023          	sw	a5,0(s0)
80003e08:	00842783          	lw	a5,8(s0)
80003e0c:	00812423          	sw	s0,8(sp)
80003e10:	01242223          	sw	s2,4(s0)
80003e14:	000780e7          	jalr	a5
80003e18:	9e9fc0ef          	jal	ra,80000800 <rt_tick_get>
80003e1c:	000c2783          	lw	a5,0(s8)
80003e20:	00050493          	mv	s1,a0
80003e24:	00078663          	beqz	a5,80003e30 <rt_timer_check+0x11c>
80003e28:	00098513          	mv	a0,s3
80003e2c:	000780e7          	jalr	a5
80003e30:	00812783          	lw	a5,8(sp)
80003e34:	f52782e3          	beq	a5,s2,80003d78 <rt_timer_check+0x64>
80003e38:	ff544783          	lbu	a5,-11(s0)
80003e3c:	0037f713          	andi	a4,a5,3
80003e40:	f3971ce3          	bne	a4,s9,80003d78 <rt_timer_check+0x64>
80003e44:	ffe7f793          	andi	a5,a5,-2
80003e48:	fef40aa3          	sb	a5,-11(s0)
80003e4c:	00098513          	mv	a0,s3
80003e50:	b8dff0ef          	jal	ra,800039dc <rt_timer_start>
80003e54:	f25ff06f          	j	80003d78 <rt_timer_check+0x64>

80003e58 <rt_soft_timer_check>:
80003e58:	fc010113          	addi	sp,sp,-64
80003e5c:	03212823          	sw	s2,48(sp)
80003e60:	00810913          	addi	s2,sp,8
80003e64:	02912a23          	sw	s1,52(sp)
80003e68:	03412423          	sw	s4,40(sp)
80003e6c:	03512223          	sw	s5,36(sp)
80003e70:	03612023          	sw	s6,32(sp)
80003e74:	01712e23          	sw	s7,28(sp)
80003e78:	01812c23          	sw	s8,24(sp)
80003e7c:	01912a23          	sw	s9,20(sp)
80003e80:	01a12823          	sw	s10,16(sp)
80003e84:	02112e23          	sw	ra,60(sp)
80003e88:	02812c23          	sw	s0,56(sp)
80003e8c:	03312623          	sw	s3,44(sp)
80003e90:	01212423          	sw	s2,8(sp)
80003e94:	01212623          	sw	s2,12(sp)
80003e98:	80000a37          	lui	s4,0x80000
80003e9c:	324000ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
80003ea0:	00050493          	mv	s1,a0
80003ea4:	8a418a93          	addi	s5,gp,-1884 # 80020304 <rt_soft_timer_list>
80003ea8:	ffea4a13          	xori	s4,s4,-2
80003eac:	8ac18b13          	addi	s6,gp,-1876 # 8002030c <rt_timer_enter_hook>
80003eb0:	8b018b93          	addi	s7,gp,-1872 # 80020310 <rt_timer_exit_hook>
80003eb4:	81018c13          	addi	s8,gp,-2032 # 80020270 <soft_timer_status>
80003eb8:	00100c93          	li	s9,1
80003ebc:	00300d13          	li	s10,3
80003ec0:	000aa403          	lw	s0,0(s5) # 80000000 <_sp+0xfffc0000>
80003ec4:	01540c63          	beq	s0,s5,80003edc <rt_soft_timer_check+0x84>
80003ec8:	939fc0ef          	jal	ra,80000800 <rt_tick_get>
80003ecc:	01442783          	lw	a5,20(s0)
80003ed0:	fe040993          	addi	s3,s0,-32
80003ed4:	40f50533          	sub	a0,a0,a5
80003ed8:	04aa7263          	bgeu	s4,a0,80003f1c <rt_soft_timer_check+0xc4>
80003edc:	00048513          	mv	a0,s1
80003ee0:	2e8000ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
80003ee4:	03c12083          	lw	ra,60(sp)
80003ee8:	03812403          	lw	s0,56(sp)
80003eec:	03412483          	lw	s1,52(sp)
80003ef0:	03012903          	lw	s2,48(sp)
80003ef4:	02c12983          	lw	s3,44(sp)
80003ef8:	02812a03          	lw	s4,40(sp)
80003efc:	02412a83          	lw	s5,36(sp)
80003f00:	02012b03          	lw	s6,32(sp)
80003f04:	01c12b83          	lw	s7,28(sp)
80003f08:	01812c03          	lw	s8,24(sp)
80003f0c:	01412c83          	lw	s9,20(sp)
80003f10:	01012d03          	lw	s10,16(sp)
80003f14:	04010113          	addi	sp,sp,64
80003f18:	00008067          	ret
80003f1c:	000b2783          	lw	a5,0(s6)
80003f20:	00078663          	beqz	a5,80003f2c <rt_soft_timer_check+0xd4>
80003f24:	00098513          	mv	a0,s3
80003f28:	000780e7          	jalr	a5
80003f2c:	00098513          	mv	a0,s3
80003f30:	921ff0ef          	jal	ra,80003850 <_rt_timer_remove>
80003f34:	ff544783          	lbu	a5,-11(s0)
80003f38:	0027f713          	andi	a4,a5,2
80003f3c:	00071663          	bnez	a4,80003f48 <rt_soft_timer_check+0xf0>
80003f40:	ffe7f793          	andi	a5,a5,-2
80003f44:	fef40aa3          	sb	a5,-11(s0)
80003f48:	00812783          	lw	a5,8(sp)
80003f4c:	00048513          	mv	a0,s1
80003f50:	0087a223          	sw	s0,4(a5)
80003f54:	00f42023          	sw	a5,0(s0)
80003f58:	01242223          	sw	s2,4(s0)
80003f5c:	80018823          	sb	zero,-2032(gp) # 80020270 <soft_timer_status>
80003f60:	00812423          	sw	s0,8(sp)
80003f64:	264000ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
80003f68:	00842783          	lw	a5,8(s0)
80003f6c:	00c42503          	lw	a0,12(s0)
80003f70:	000780e7          	jalr	a5
80003f74:	000ba783          	lw	a5,0(s7)
80003f78:	00078663          	beqz	a5,80003f84 <rt_soft_timer_check+0x12c>
80003f7c:	00098513          	mv	a0,s3
80003f80:	000780e7          	jalr	a5
80003f84:	23c000ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
80003f88:	00812783          	lw	a5,8(sp)
80003f8c:	019c0023          	sb	s9,0(s8)
80003f90:	00050493          	mv	s1,a0
80003f94:	f32786e3          	beq	a5,s2,80003ec0 <rt_soft_timer_check+0x68>
80003f98:	ff544783          	lbu	a5,-11(s0)
80003f9c:	0037f713          	andi	a4,a5,3
80003fa0:	f3a710e3          	bne	a4,s10,80003ec0 <rt_soft_timer_check+0x68>
80003fa4:	ffe7f793          	andi	a5,a5,-2
80003fa8:	fef40aa3          	sb	a5,-11(s0)
80003fac:	00098513          	mv	a0,s3
80003fb0:	a2dff0ef          	jal	ra,800039dc <rt_timer_start>
80003fb4:	f0dff06f          	j	80003ec0 <rt_soft_timer_check+0x68>

80003fb8 <rt_thread_timer_entry>:
80003fb8:	fe010113          	addi	sp,sp,-32
80003fbc:	00912a23          	sw	s1,20(sp)
80003fc0:	800004b7          	lui	s1,0x80000
80003fc4:	01212823          	sw	s2,16(sp)
80003fc8:	01312623          	sw	s3,12(sp)
80003fcc:	00112e23          	sw	ra,28(sp)
80003fd0:	00812c23          	sw	s0,24(sp)
80003fd4:	8a418913          	addi	s2,gp,-1884 # 80020304 <rt_soft_timer_list>
80003fd8:	fff00993          	li	s3,-1
80003fdc:	ffe4c493          	xori	s1,s1,-2
80003fe0:	1e0000ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
80003fe4:	00092783          	lw	a5,0(s2)
80003fe8:	fff00413          	li	s0,-1
80003fec:	01278463          	beq	a5,s2,80003ff4 <rt_thread_timer_entry+0x3c>
80003ff0:	0147a403          	lw	s0,20(a5)
80003ff4:	1d4000ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
80003ff8:	01341c63          	bne	s0,s3,80004010 <rt_thread_timer_entry+0x58>
80003ffc:	c34ff0ef          	jal	ra,80003430 <rt_thread_self>
80004000:	ce4ff0ef          	jal	ra,800034e4 <rt_thread_suspend>
80004004:	ee5fe0ef          	jal	ra,80002ee8 <rt_schedule>
80004008:	e51ff0ef          	jal	ra,80003e58 <rt_soft_timer_check>
8000400c:	fd5ff06f          	j	80003fe0 <rt_thread_timer_entry+0x28>
80004010:	ff0fc0ef          	jal	ra,80000800 <rt_tick_get>
80004014:	40a40533          	sub	a0,s0,a0
80004018:	fea4e8e3          	bltu	s1,a0,80004008 <rt_thread_timer_entry+0x50>
8000401c:	e88ff0ef          	jal	ra,800036a4 <rt_thread_delay>
80004020:	fe9ff06f          	j	80004008 <rt_thread_timer_entry+0x50>

80004024 <rt_system_timer_init>:
80004024:	8b418793          	addi	a5,gp,-1868 # 80020314 <rt_timer_list>
80004028:	00f7a223          	sw	a5,4(a5)
8000402c:	00f7a023          	sw	a5,0(a5)
80004030:	00008067          	ret

80004034 <rt_system_timer_thread_init>:
80004034:	ff010113          	addi	sp,sp,-16
80004038:	00812423          	sw	s0,8(sp)
8000403c:	00112623          	sw	ra,12(sp)
80004040:	8a418793          	addi	a5,gp,-1884 # 80020304 <rt_soft_timer_list>
80004044:	d5c18413          	addi	s0,gp,-676 # 800207bc <timer_thread>
80004048:	00f7a223          	sw	a5,4(a5)
8000404c:	00f7a023          	sw	a5,0(a5)
80004050:	00040513          	mv	a0,s0
80004054:	00a00893          	li	a7,10
80004058:	00400813          	li	a6,4
8000405c:	20000793          	li	a5,512
80004060:	df418713          	addi	a4,gp,-524 # 80020854 <timer_thread_stack>
80004064:	00000693          	li	a3,0
80004068:	00000617          	auipc	a2,0x0
8000406c:	f5060613          	addi	a2,a2,-176 # 80003fb8 <rt_thread_timer_entry>
80004070:	00009597          	auipc	a1,0x9
80004074:	15c58593          	addi	a1,a1,348 # 8000d1cc <__FUNCTION__.3150+0xc8>
80004078:	ae0ff0ef          	jal	ra,80003358 <rt_thread_init>
8000407c:	00040513          	mv	a0,s0
80004080:	00812403          	lw	s0,8(sp)
80004084:	00c12083          	lw	ra,12(sp)
80004088:	01010113          	addi	sp,sp,16
8000408c:	f08ff06f          	j	80003794 <rt_thread_startup>

80004090 <systick_handler>:
80004090:	0000c537          	lui	a0,0xc
80004094:	ff010113          	addi	sp,sp,-16
80004098:	35050513          	addi	a0,a0,848 # c350 <__HEAP_SIZE+0xa350>
8000409c:	00000593          	li	a1,0
800040a0:	00112623          	sw	ra,12(sp)
800040a4:	bf4fc0ef          	jal	ra,80000498 <systick_reload>
800040a8:	d5cfd0ef          	jal	ra,80001604 <rt_interrupt_enter>
800040ac:	f60fc0ef          	jal	ra,8000080c <rt_tick_increase>
800040b0:	00c12083          	lw	ra,12(sp)
800040b4:	01010113          	addi	sp,sp,16
800040b8:	d90fd06f          	j	80001648 <rt_interrupt_leave>

800040bc <rt_hw_stack_init>:
800040bc:	00460613          	addi	a2,a2,4
800040c0:	ffc67613          	andi	a2,a2,-4
800040c4:	00050713          	mv	a4,a0
800040c8:	deadc837          	lui	a6,0xdeadc
800040cc:	f8860513          	addi	a0,a2,-120
800040d0:	00050793          	mv	a5,a0
800040d4:	eef80813          	addi	a6,a6,-273 # deadbeef <_sp+0x5ea9beef>
800040d8:	02f61063          	bne	a2,a5,800040f8 <rt_hw_stack_init+0x3c>
800040dc:	000047b7          	lui	a5,0x4
800040e0:	88078793          	addi	a5,a5,-1920 # 3880 <__HEAP_SIZE+0x1880>
800040e4:	f8d62623          	sw	a3,-116(a2)
800040e8:	fab62223          	sw	a1,-92(a2)
800040ec:	f8e62423          	sw	a4,-120(a2)
800040f0:	fef62e23          	sw	a5,-4(a2)
800040f4:	00008067          	ret
800040f8:	0107a023          	sw	a6,0(a5)
800040fc:	00478793          	addi	a5,a5,4
80004100:	fd9ff06f          	j	800040d8 <rt_hw_stack_init+0x1c>

80004104 <rt_hw_context_switch_interrupt>:
80004104:	8c418793          	addi	a5,gp,-1852 # 80020324 <rt_thread_switch_interrupt_flag>
80004108:	0007a703          	lw	a4,0(a5)
8000410c:	ff010113          	addi	sp,sp,-16
80004110:	00112623          	sw	ra,12(sp)
80004114:	00071463          	bnez	a4,8000411c <rt_hw_context_switch_interrupt+0x18>
80004118:	8aa1ae23          	sw	a0,-1860(gp) # 8002031c <rt_interrupt_from_thread>
8000411c:	8cb1a023          	sw	a1,-1856(gp) # 80020320 <rt_interrupt_to_thread>
80004120:	00100713          	li	a4,1
80004124:	00e7a023          	sw	a4,0(a5)
80004128:	b18fc0ef          	jal	ra,80000440 <clint_yield_swi>
8000412c:	0ff0000f          	fence
80004130:	0000100f          	fence.i
80004134:	00c12083          	lw	ra,12(sp)
80004138:	01010113          	addi	sp,sp,16
8000413c:	00008067          	ret

80004140 <rt_hw_context_switch>:
80004140:	ff010113          	addi	sp,sp,-16
80004144:	8aa1ae23          	sw	a0,-1860(gp) # 8002031c <rt_interrupt_from_thread>
80004148:	00112623          	sw	ra,12(sp)
8000414c:	8cb1a023          	sw	a1,-1856(gp) # 80020320 <rt_interrupt_to_thread>
80004150:	af0fc0ef          	jal	ra,80000440 <clint_yield_swi>
80004154:	0ff0000f          	fence
80004158:	0000100f          	fence.i
8000415c:	00c12083          	lw	ra,12(sp)
80004160:	01010113          	addi	sp,sp,16
80004164:	00008067          	ret

80004168 <rt_hw_taskswitch>:
80004168:	ff010113          	addi	sp,sp,-16
8000416c:	00112623          	sw	ra,12(sp)
80004170:	ae4fc0ef          	jal	ra,80000454 <clint_clear_swi_flag>
80004174:	00c12083          	lw	ra,12(sp)
80004178:	8c01a223          	sw	zero,-1852(gp) # 80020324 <rt_thread_switch_interrupt_flag>
8000417c:	01010113          	addi	sp,sp,16
80004180:	00008067          	ret

80004184 <rt_hw_ticksetup>:
80004184:	0000c537          	lui	a0,0xc
80004188:	ff010113          	addi	sp,sp,-16
8000418c:	35050513          	addi	a0,a0,848 # c350 <__HEAP_SIZE+0xa350>
80004190:	00000593          	li	a1,0
80004194:	00112623          	sw	ra,12(sp)
80004198:	ad4fc0ef          	jal	ra,8000046c <systick_config>
8000419c:	00000597          	auipc	a1,0x0
800041a0:	ef458593          	addi	a1,a1,-268 # 80004090 <systick_handler>
800041a4:	00700513          	li	a0,7
800041a8:	13c000ef          	jal	ra,800042e4 <riscv_set_trap_int_handler>
800041ac:	03c000ef          	jal	ra,800041e8 <enable_systimer_irq>
800041b0:	044000ef          	jal	ra,800041f4 <enable_software_irq>
800041b4:	00c12083          	lw	ra,12(sp)
800041b8:	01010113          	addi	sp,sp,16
800041bc:	aacfc06f          	j	80000468 <systimer_start>

800041c0 <rt_hw_interrupt_disable>:
800041c0:	30047573          	csrrci	a0,mstatus,8
800041c4:	00008067          	ret

800041c8 <rt_hw_interrupt_enable>:
800041c8:	30051073          	csrw	mstatus,a0
800041cc:	00008067          	ret

800041d0 <default_trap_handler>:
800041d0:	ff010113          	addi	sp,sp,-16
800041d4:	00009517          	auipc	a0,0x9
800041d8:	05450513          	addi	a0,a0,84 # 8000d228 <__FUNCTION__.3128+0x14>
800041dc:	00112623          	sw	ra,12(sp)
800041e0:	e8dfd0ef          	jal	ra,8000206c <rt_kprintf>
800041e4:	0000006f          	j	800041e4 <default_trap_handler+0x14>

800041e8 <enable_systimer_irq>:
800041e8:	08000793          	li	a5,128
800041ec:	3047a073          	csrs	mie,a5
800041f0:	00008067          	ret

800041f4 <enable_software_irq>:
800041f4:	30446073          	csrsi	mie,8
800041f8:	00008067          	ret

800041fc <disable_external_irq>:
800041fc:	000017b7          	lui	a5,0x1
80004200:	80078793          	addi	a5,a5,-2048 # 800 <__HEAP_SIZE-0x1800>
80004204:	3047b073          	csrc	mie,a5
80004208:	00008067          	ret

8000420c <core_exception_handler>:
8000420c:	00151793          	slli	a5,a0,0x1
80004210:	fe010113          	addi	sp,sp,-32
80004214:	0017d793          	srli	a5,a5,0x1
80004218:	00812c23          	sw	s0,24(sp)
8000421c:	00112e23          	sw	ra,28(sp)
80004220:	00f12623          	sw	a5,12(sp)
80004224:	00279413          	slli	s0,a5,0x2
80004228:	00b00713          	li	a4,11
8000422c:	04055663          	bgez	a0,80004278 <core_exception_handler+0x6c>
80004230:	00f77e63          	bgeu	a4,a5,8000424c <core_exception_handler+0x40>
80004234:	03500613          	li	a2,53
80004238:	00009597          	auipc	a1,0x9
8000423c:	04458593          	addi	a1,a1,68 # 8000d27c <__FUNCTION__.3166>
80004240:	00009517          	auipc	a0,0x9
80004244:	ffc50513          	addi	a0,a0,-4 # 8000d23c <__FUNCTION__.3128+0x28>
80004248:	fa5fd0ef          	jal	ra,800021ec <rt_assert_handler>
8000424c:	00100793          	li	a5,1
80004250:	00f12423          	sw	a5,8(sp)
80004254:	02418793          	addi	a5,gp,36 # 80020a84 <riscv_trap_int_handler>
80004258:	008787b3          	add	a5,a5,s0
8000425c:	0007a783          	lw	a5,0(a5)
80004260:	00810513          	addi	a0,sp,8
80004264:	000780e7          	jalr	a5
80004268:	01c12083          	lw	ra,28(sp)
8000426c:	01812403          	lw	s0,24(sp)
80004270:	02010113          	addi	sp,sp,32
80004274:	00008067          	ret
80004278:	00f77e63          	bgeu	a4,a5,80004294 <core_exception_handler+0x88>
8000427c:	03b00613          	li	a2,59
80004280:	00009597          	auipc	a1,0x9
80004284:	ffc58593          	addi	a1,a1,-4 # 8000d27c <__FUNCTION__.3166>
80004288:	00009517          	auipc	a0,0x9
8000428c:	fd450513          	addi	a0,a0,-44 # 8000d25c <__FUNCTION__.3128+0x48>
80004290:	f5dfd0ef          	jal	ra,800021ec <rt_assert_handler>
80004294:	00012423          	sw	zero,8(sp)
80004298:	ff418793          	addi	a5,gp,-12 # 80020a54 <riscv_trap_exc_handler>
8000429c:	fbdff06f          	j	80004258 <core_exception_handler+0x4c>

800042a0 <riscv_trap_vector_init>:
800042a0:	00000797          	auipc	a5,0x0
800042a4:	26078793          	addi	a5,a5,608 # 80004500 <riscv_trap_handler_entry>
800042a8:	30579073          	csrw	mtvec,a5
800042ac:	00000717          	auipc	a4,0x0
800042b0:	f2470713          	addi	a4,a4,-220 # 800041d0 <default_trap_handler>
800042b4:	02418793          	addi	a5,gp,36 # 80020a84 <riscv_trap_int_handler>
800042b8:	05418613          	addi	a2,gp,84 # 80020ab4 <_hw_pin>
800042bc:	00070693          	mv	a3,a4
800042c0:	00e7a023          	sw	a4,0(a5)
800042c4:	00478793          	addi	a5,a5,4
800042c8:	fec79ce3          	bne	a5,a2,800042c0 <riscv_trap_vector_init+0x20>
800042cc:	ff418793          	addi	a5,gp,-12 # 80020a54 <riscv_trap_exc_handler>
800042d0:	02418713          	addi	a4,gp,36 # 80020a84 <riscv_trap_int_handler>
800042d4:	00d7a023          	sw	a3,0(a5)
800042d8:	00478793          	addi	a5,a5,4
800042dc:	fee79ce3          	bne	a5,a4,800042d4 <riscv_trap_vector_init+0x34>
800042e0:	00008067          	ret

800042e4 <riscv_set_trap_int_handler>:
800042e4:	ff010113          	addi	sp,sp,-16
800042e8:	00812423          	sw	s0,8(sp)
800042ec:	00912223          	sw	s1,4(sp)
800042f0:	00112623          	sw	ra,12(sp)
800042f4:	00b00793          	li	a5,11
800042f8:	00050413          	mv	s0,a0
800042fc:	00058493          	mv	s1,a1
80004300:	00a7fe63          	bgeu	a5,a0,8000431c <riscv_set_trap_int_handler+0x38>
80004304:	05500613          	li	a2,85
80004308:	00009597          	auipc	a1,0x9
8000430c:	f8c58593          	addi	a1,a1,-116 # 8000d294 <__FUNCTION__.3181>
80004310:	00009517          	auipc	a0,0x9
80004314:	f2c50513          	addi	a0,a0,-212 # 8000d23c <__FUNCTION__.3128+0x28>
80004318:	ed5fd0ef          	jal	ra,800021ec <rt_assert_handler>
8000431c:	00241413          	slli	s0,s0,0x2
80004320:	02418513          	addi	a0,gp,36 # 80020a84 <riscv_trap_int_handler>
80004324:	00850433          	add	s0,a0,s0
80004328:	00942023          	sw	s1,0(s0)
8000432c:	00c12083          	lw	ra,12(sp)
80004330:	00812403          	lw	s0,8(sp)
80004334:	00412483          	lw	s1,4(sp)
80004338:	01010113          	addi	sp,sp,16
8000433c:	00008067          	ret

80004340 <rt_hw_context_switch_to>:
80004340:	0003c297          	auipc	t0,0x3c
80004344:	cc028293          	addi	t0,t0,-832 # 80040000 <_sp>
80004348:	34029073          	csrw	mscratch,t0
8000434c:	00052103          	lw	sp,0(a0)
80004350:	00012283          	lw	t0,0(sp)
80004354:	34129073          	csrw	mepc,t0
80004358:	07412283          	lw	t0,116(sp)
8000435c:	30029073          	csrw	mstatus,t0
80004360:	00412083          	lw	ra,4(sp)
80004364:	00812283          	lw	t0,8(sp)
80004368:	00c12303          	lw	t1,12(sp)
8000436c:	01012383          	lw	t2,16(sp)
80004370:	01412403          	lw	s0,20(sp)
80004374:	01812483          	lw	s1,24(sp)
80004378:	01c12503          	lw	a0,28(sp)
8000437c:	02012583          	lw	a1,32(sp)
80004380:	02412603          	lw	a2,36(sp)
80004384:	02812683          	lw	a3,40(sp)
80004388:	02c12703          	lw	a4,44(sp)
8000438c:	03012783          	lw	a5,48(sp)
80004390:	03412803          	lw	a6,52(sp)
80004394:	03812883          	lw	a7,56(sp)
80004398:	03c12903          	lw	s2,60(sp)
8000439c:	04012983          	lw	s3,64(sp)
800043a0:	04412a03          	lw	s4,68(sp)
800043a4:	04812a83          	lw	s5,72(sp)
800043a8:	04c12b03          	lw	s6,76(sp)
800043ac:	05012b83          	lw	s7,80(sp)
800043b0:	05412c03          	lw	s8,84(sp)
800043b4:	05812c83          	lw	s9,88(sp)
800043b8:	05c12d03          	lw	s10,92(sp)
800043bc:	06012d83          	lw	s11,96(sp)
800043c0:	06412e03          	lw	t3,100(sp)
800043c4:	06812e83          	lw	t4,104(sp)
800043c8:	06c12f03          	lw	t5,108(sp)
800043cc:	07012f83          	lw	t6,112(sp)
800043d0:	07810113          	addi	sp,sp,120
800043d4:	30200073          	mret

800043d8 <msip_handler>:
800043d8:	f8810113          	addi	sp,sp,-120
800043dc:	00112223          	sw	ra,4(sp)
800043e0:	00512423          	sw	t0,8(sp)
800043e4:	00612623          	sw	t1,12(sp)
800043e8:	00712823          	sw	t2,16(sp)
800043ec:	00812a23          	sw	s0,20(sp)
800043f0:	00912c23          	sw	s1,24(sp)
800043f4:	00a12e23          	sw	a0,28(sp)
800043f8:	02b12023          	sw	a1,32(sp)
800043fc:	02c12223          	sw	a2,36(sp)
80004400:	02d12423          	sw	a3,40(sp)
80004404:	02e12623          	sw	a4,44(sp)
80004408:	02f12823          	sw	a5,48(sp)
8000440c:	03012a23          	sw	a6,52(sp)
80004410:	03112c23          	sw	a7,56(sp)
80004414:	03212e23          	sw	s2,60(sp)
80004418:	05312023          	sw	s3,64(sp)
8000441c:	05412223          	sw	s4,68(sp)
80004420:	05512423          	sw	s5,72(sp)
80004424:	05612623          	sw	s6,76(sp)
80004428:	05712823          	sw	s7,80(sp)
8000442c:	05812a23          	sw	s8,84(sp)
80004430:	05912c23          	sw	s9,88(sp)
80004434:	05a12e23          	sw	s10,92(sp)
80004438:	07b12023          	sw	s11,96(sp)
8000443c:	07c12223          	sw	t3,100(sp)
80004440:	07d12423          	sw	t4,104(sp)
80004444:	07e12623          	sw	t5,108(sp)
80004448:	07f12823          	sw	t6,112(sp)
8000444c:	300022f3          	csrr	t0,mstatus
80004450:	06512a23          	sw	t0,116(sp)
80004454:	8bc1a283          	lw	t0,-1860(gp) # 8002031c <rt_interrupt_from_thread>
80004458:	0022a023          	sw	sp,0(t0)
8000445c:	341022f3          	csrr	t0,mepc
80004460:	00512023          	sw	t0,0(sp)
80004464:	d05ff0ef          	jal	ra,80004168 <rt_hw_taskswitch>
80004468:	8c01a283          	lw	t0,-1856(gp) # 80020320 <rt_interrupt_to_thread>
8000446c:	0002a103          	lw	sp,0(t0)
80004470:	00012283          	lw	t0,0(sp)
80004474:	34129073          	csrw	mepc,t0
80004478:	07412283          	lw	t0,116(sp)
8000447c:	30029073          	csrw	mstatus,t0
80004480:	00412083          	lw	ra,4(sp)
80004484:	00812283          	lw	t0,8(sp)
80004488:	00c12303          	lw	t1,12(sp)
8000448c:	01012383          	lw	t2,16(sp)
80004490:	01412403          	lw	s0,20(sp)
80004494:	01812483          	lw	s1,24(sp)
80004498:	01c12503          	lw	a0,28(sp)
8000449c:	02012583          	lw	a1,32(sp)
800044a0:	02412603          	lw	a2,36(sp)
800044a4:	02812683          	lw	a3,40(sp)
800044a8:	02c12703          	lw	a4,44(sp)
800044ac:	03012783          	lw	a5,48(sp)
800044b0:	03412803          	lw	a6,52(sp)
800044b4:	03812883          	lw	a7,56(sp)
800044b8:	03c12903          	lw	s2,60(sp)
800044bc:	04012983          	lw	s3,64(sp)
800044c0:	04412a03          	lw	s4,68(sp)
800044c4:	04812a83          	lw	s5,72(sp)
800044c8:	04c12b03          	lw	s6,76(sp)
800044cc:	05012b83          	lw	s7,80(sp)
800044d0:	05412c03          	lw	s8,84(sp)
800044d4:	05812c83          	lw	s9,88(sp)
800044d8:	05c12d03          	lw	s10,92(sp)
800044dc:	06012d83          	lw	s11,96(sp)
800044e0:	06412e03          	lw	t3,100(sp)
800044e4:	06812e83          	lw	t4,104(sp)
800044e8:	06c12f03          	lw	t5,108(sp)
800044ec:	07012f83          	lw	t6,112(sp)
800044f0:	07810113          	addi	sp,sp,120
800044f4:	30200073          	mret
	...

80004500 <riscv_trap_handler_entry>:
80004500:	34011173          	csrrw	sp,mscratch,sp
80004504:	fb010113          	addi	sp,sp,-80
80004508:	00112023          	sw	ra,0(sp)
8000450c:	00412223          	sw	tp,4(sp)
80004510:	00512423          	sw	t0,8(sp)
80004514:	00612623          	sw	t1,12(sp)
80004518:	00712823          	sw	t2,16(sp)
8000451c:	00a12a23          	sw	a0,20(sp)
80004520:	00b12c23          	sw	a1,24(sp)
80004524:	00c12e23          	sw	a2,28(sp)
80004528:	02d12023          	sw	a3,32(sp)
8000452c:	02e12223          	sw	a4,36(sp)
80004530:	02f12423          	sw	a5,40(sp)
80004534:	03012c23          	sw	a6,56(sp)
80004538:	03112e23          	sw	a7,60(sp)
8000453c:	05c12023          	sw	t3,64(sp)
80004540:	05d12223          	sw	t4,68(sp)
80004544:	05e12423          	sw	t5,72(sp)
80004548:	05f12623          	sw	t6,76(sp)
8000454c:	342022f3          	csrr	t0,mcause
80004550:	02512623          	sw	t0,44(sp)
80004554:	341022f3          	csrr	t0,mepc
80004558:	02512823          	sw	t0,48(sp)
8000455c:	02012a23          	sw	zero,52(sp)
80004560:	34202573          	csrr	a0,mcause
80004564:	00010593          	mv	a1,sp
80004568:	00100293          	li	t0,1
8000456c:	01f29293          	slli	t0,t0,0x1f
80004570:	0032e293          	ori	t0,t0,3
80004574:	06550463          	beq	a0,t0,800045dc <msip_handler_entry>
80004578:	c95ff0ef          	jal	ra,8000420c <core_exception_handler>
8000457c:	03012283          	lw	t0,48(sp)
80004580:	34129073          	csrw	mepc,t0
80004584:	02c12283          	lw	t0,44(sp)
80004588:	34229073          	csrw	mcause,t0
8000458c:	00012083          	lw	ra,0(sp)
80004590:	00412203          	lw	tp,4(sp)
80004594:	00812283          	lw	t0,8(sp)
80004598:	00c12303          	lw	t1,12(sp)
8000459c:	01012383          	lw	t2,16(sp)
800045a0:	01412503          	lw	a0,20(sp)
800045a4:	01812583          	lw	a1,24(sp)
800045a8:	01c12603          	lw	a2,28(sp)
800045ac:	02012683          	lw	a3,32(sp)
800045b0:	02412703          	lw	a4,36(sp)
800045b4:	02812783          	lw	a5,40(sp)
800045b8:	03812803          	lw	a6,56(sp)
800045bc:	03c12883          	lw	a7,60(sp)
800045c0:	04012e03          	lw	t3,64(sp)
800045c4:	04412e83          	lw	t4,68(sp)
800045c8:	04812f03          	lw	t5,72(sp)
800045cc:	04c12f83          	lw	t6,76(sp)
800045d0:	05010113          	addi	sp,sp,80
800045d4:	34011173          	csrrw	sp,mscratch,sp
800045d8:	30200073          	mret

800045dc <msip_handler_entry>:
800045dc:	03012283          	lw	t0,48(sp)
800045e0:	34129073          	csrw	mepc,t0
800045e4:	02c12283          	lw	t0,44(sp)
800045e8:	34229073          	csrw	mcause,t0
800045ec:	00012083          	lw	ra,0(sp)
800045f0:	00412203          	lw	tp,4(sp)
800045f4:	00812283          	lw	t0,8(sp)
800045f8:	00c12303          	lw	t1,12(sp)
800045fc:	01012383          	lw	t2,16(sp)
80004600:	01412503          	lw	a0,20(sp)
80004604:	01812583          	lw	a1,24(sp)
80004608:	01c12603          	lw	a2,28(sp)
8000460c:	02012683          	lw	a3,32(sp)
80004610:	02412703          	lw	a4,36(sp)
80004614:	02812783          	lw	a5,40(sp)
80004618:	03812803          	lw	a6,56(sp)
8000461c:	03c12883          	lw	a7,60(sp)
80004620:	04012e03          	lw	t3,64(sp)
80004624:	04412e83          	lw	t4,68(sp)
80004628:	04812f03          	lw	t5,72(sp)
8000462c:	04c12f83          	lw	t6,76(sp)
80004630:	05010113          	addi	sp,sp,80
80004634:	34011173          	csrrw	sp,mscratch,sp
80004638:	da1ff06f          	j	800043d8 <msip_handler>
8000463c:	0000                	unimp
	...

80004640 <rt_pin_mode>:
80004640:	05418793          	addi	a5,gp,84 # 80020ab4 <_hw_pin>
80004644:	0507a703          	lw	a4,80(a5)
80004648:	ff010113          	addi	sp,sp,-16
8000464c:	00812423          	sw	s0,8(sp)
80004650:	00912223          	sw	s1,4(sp)
80004654:	01212023          	sw	s2,0(sp)
80004658:	00112623          	sw	ra,12(sp)
8000465c:	00050493          	mv	s1,a0
80004660:	00058913          	mv	s2,a1
80004664:	00078413          	mv	s0,a5
80004668:	00071e63          	bnez	a4,80004684 <rt_pin_mode+0x44>
8000466c:	08800613          	li	a2,136
80004670:	00009597          	auipc	a1,0x9
80004674:	c6858593          	addi	a1,a1,-920 # 8000d2d8 <__FUNCTION__.4923>
80004678:	00009517          	auipc	a0,0x9
8000467c:	c3850513          	addi	a0,a0,-968 # 8000d2b0 <__FUNCTION__.3181+0x1c>
80004680:	b6dfd0ef          	jal	ra,800021ec <rt_assert_handler>
80004684:	05042783          	lw	a5,80(s0)
80004688:	00812403          	lw	s0,8(sp)
8000468c:	00c12083          	lw	ra,12(sp)
80004690:	0007a303          	lw	t1,0(a5)
80004694:	00090613          	mv	a2,s2
80004698:	00048593          	mv	a1,s1
8000469c:	00012903          	lw	s2,0(sp)
800046a0:	00412483          	lw	s1,4(sp)
800046a4:	05418513          	addi	a0,gp,84 # 80020ab4 <_hw_pin>
800046a8:	01010113          	addi	sp,sp,16
800046ac:	00030067          	jr	t1

800046b0 <rt_pin_write>:
800046b0:	05418793          	addi	a5,gp,84 # 80020ab4 <_hw_pin>
800046b4:	0507a703          	lw	a4,80(a5)
800046b8:	ff010113          	addi	sp,sp,-16
800046bc:	00812423          	sw	s0,8(sp)
800046c0:	00912223          	sw	s1,4(sp)
800046c4:	01212023          	sw	s2,0(sp)
800046c8:	00112623          	sw	ra,12(sp)
800046cc:	00050493          	mv	s1,a0
800046d0:	00058913          	mv	s2,a1
800046d4:	00078413          	mv	s0,a5
800046d8:	00071e63          	bnez	a4,800046f4 <rt_pin_write+0x44>
800046dc:	08f00613          	li	a2,143
800046e0:	00009597          	auipc	a1,0x9
800046e4:	c0458593          	addi	a1,a1,-1020 # 8000d2e4 <__FUNCTION__.4931>
800046e8:	00009517          	auipc	a0,0x9
800046ec:	bc850513          	addi	a0,a0,-1080 # 8000d2b0 <__FUNCTION__.3181+0x1c>
800046f0:	afdfd0ef          	jal	ra,800021ec <rt_assert_handler>
800046f4:	05042783          	lw	a5,80(s0)
800046f8:	00812403          	lw	s0,8(sp)
800046fc:	00c12083          	lw	ra,12(sp)
80004700:	0047a303          	lw	t1,4(a5)
80004704:	00090613          	mv	a2,s2
80004708:	00048593          	mv	a1,s1
8000470c:	00012903          	lw	s2,0(sp)
80004710:	00412483          	lw	s1,4(sp)
80004714:	05418513          	addi	a0,gp,84 # 80020ab4 <_hw_pin>
80004718:	01010113          	addi	sp,sp,16
8000471c:	00030067          	jr	t1

80004720 <rt_pin_read>:
80004720:	05418793          	addi	a5,gp,84 # 80020ab4 <_hw_pin>
80004724:	0507a703          	lw	a4,80(a5)
80004728:	ff010113          	addi	sp,sp,-16
8000472c:	00812423          	sw	s0,8(sp)
80004730:	00912223          	sw	s1,4(sp)
80004734:	00112623          	sw	ra,12(sp)
80004738:	00050493          	mv	s1,a0
8000473c:	00078413          	mv	s0,a5
80004740:	00071e63          	bnez	a4,8000475c <rt_pin_read+0x3c>
80004744:	09600613          	li	a2,150
80004748:	00009597          	auipc	a1,0x9
8000474c:	bac58593          	addi	a1,a1,-1108 # 8000d2f4 <__FUNCTION__.4938>
80004750:	00009517          	auipc	a0,0x9
80004754:	b6050513          	addi	a0,a0,-1184 # 8000d2b0 <__FUNCTION__.3181+0x1c>
80004758:	a95fd0ef          	jal	ra,800021ec <rt_assert_handler>
8000475c:	05042783          	lw	a5,80(s0)
80004760:	00812403          	lw	s0,8(sp)
80004764:	00c12083          	lw	ra,12(sp)
80004768:	0087a303          	lw	t1,8(a5)
8000476c:	00048593          	mv	a1,s1
80004770:	00412483          	lw	s1,4(sp)
80004774:	05418513          	addi	a0,gp,84 # 80020ab4 <_hw_pin>
80004778:	01010113          	addi	sp,sp,16
8000477c:	00030067          	jr	t1

80004780 <rt_pin_get>:
80004780:	05418793          	addi	a5,gp,84 # 80020ab4 <_hw_pin>
80004784:	0507a703          	lw	a4,80(a5)
80004788:	ff010113          	addi	sp,sp,-16
8000478c:	00812423          	sw	s0,8(sp)
80004790:	00912223          	sw	s1,4(sp)
80004794:	00112623          	sw	ra,12(sp)
80004798:	00050413          	mv	s0,a0
8000479c:	00078493          	mv	s1,a5
800047a0:	00071e63          	bnez	a4,800047bc <rt_pin_get+0x3c>
800047a4:	09d00613          	li	a2,157
800047a8:	00009597          	auipc	a1,0x9
800047ac:	b5858593          	addi	a1,a1,-1192 # 8000d300 <__FUNCTION__.4945>
800047b0:	00009517          	auipc	a0,0x9
800047b4:	b0050513          	addi	a0,a0,-1280 # 8000d2b0 <__FUNCTION__.3181+0x1c>
800047b8:	a35fd0ef          	jal	ra,800021ec <rt_assert_handler>
800047bc:	00044703          	lbu	a4,0(s0)
800047c0:	05000793          	li	a5,80
800047c4:	00f70e63          	beq	a4,a5,800047e0 <rt_pin_get+0x60>
800047c8:	09e00613          	li	a2,158
800047cc:	00009597          	auipc	a1,0x9
800047d0:	b3458593          	addi	a1,a1,-1228 # 8000d300 <__FUNCTION__.4945>
800047d4:	00009517          	auipc	a0,0x9
800047d8:	af450513          	addi	a0,a0,-1292 # 8000d2c8 <__FUNCTION__.3181+0x34>
800047dc:	a11fd0ef          	jal	ra,800021ec <rt_assert_handler>
800047e0:	0504a783          	lw	a5,80(s1) # 80000050 <_sp+0xfffc0050>
800047e4:	0187a303          	lw	t1,24(a5)
800047e8:	00030e63          	beqz	t1,80004804 <rt_pin_get+0x84>
800047ec:	00040513          	mv	a0,s0
800047f0:	00812403          	lw	s0,8(sp)
800047f4:	00c12083          	lw	ra,12(sp)
800047f8:	00412483          	lw	s1,4(sp)
800047fc:	01010113          	addi	sp,sp,16
80004800:	00030067          	jr	t1
80004804:	00c12083          	lw	ra,12(sp)
80004808:	00812403          	lw	s0,8(sp)
8000480c:	00412483          	lw	s1,4(sp)
80004810:	ffa00513          	li	a0,-6
80004814:	01010113          	addi	sp,sp,16
80004818:	00008067          	ret

8000481c <rt_serial_init>:
8000481c:	ff010113          	addi	sp,sp,-16
80004820:	00812423          	sw	s0,8(sp)
80004824:	00112623          	sw	ra,12(sp)
80004828:	00050413          	mv	s0,a0
8000482c:	00051e63          	bnez	a0,80004848 <rt_serial_init+0x2c>
80004830:	23b00613          	li	a2,571
80004834:	00009597          	auipc	a1,0x9
80004838:	c4858593          	addi	a1,a1,-952 # 8000d47c <__FUNCTION__.3475>
8000483c:	00008517          	auipc	a0,0x8
80004840:	e0c50513          	addi	a0,a0,-500 # 8000c648 <__rti_rti_start_name+0xc>
80004844:	9a9fd0ef          	jal	ra,800021ec <rt_assert_handler>
80004848:	05042783          	lw	a5,80(s0)
8000484c:	04042e23          	sw	zero,92(s0)
80004850:	06042023          	sw	zero,96(s0)
80004854:	0007a303          	lw	t1,0(a5)
80004858:	00030e63          	beqz	t1,80004874 <rt_serial_init+0x58>
8000485c:	05440593          	addi	a1,s0,84
80004860:	00040513          	mv	a0,s0
80004864:	00812403          	lw	s0,8(sp)
80004868:	00c12083          	lw	ra,12(sp)
8000486c:	01010113          	addi	sp,sp,16
80004870:	00030067          	jr	t1
80004874:	00c12083          	lw	ra,12(sp)
80004878:	00812403          	lw	s0,8(sp)
8000487c:	00000513          	li	a0,0
80004880:	01010113          	addi	sp,sp,16
80004884:	00008067          	ret

80004888 <rt_serial_open>:
80004888:	fe010113          	addi	sp,sp,-32
8000488c:	00812c23          	sw	s0,24(sp)
80004890:	00912a23          	sw	s1,20(sp)
80004894:	00112e23          	sw	ra,28(sp)
80004898:	01212823          	sw	s2,16(sp)
8000489c:	01312623          	sw	s3,12(sp)
800048a0:	00050413          	mv	s0,a0
800048a4:	00058493          	mv	s1,a1
800048a8:	00051e63          	bnez	a0,800048c4 <rt_serial_open+0x3c>
800048ac:	24e00613          	li	a2,590
800048b0:	00009597          	auipc	a1,0x9
800048b4:	bdc58593          	addi	a1,a1,-1060 # 8000d48c <__FUNCTION__.3482>
800048b8:	00008517          	auipc	a0,0x8
800048bc:	d9050513          	addi	a0,a0,-624 # 8000c648 <__rti_rti_start_name+0xc>
800048c0:	92dfd0ef          	jal	ra,800021ec <rt_assert_handler>
800048c4:	2004f793          	andi	a5,s1,512
800048c8:	00078a63          	beqz	a5,800048dc <rt_serial_open+0x54>
800048cc:	02445783          	lhu	a5,36(s0)
800048d0:	ff800513          	li	a0,-8
800048d4:	2007f793          	andi	a5,a5,512
800048d8:	18078063          	beqz	a5,80004a58 <rt_serial_open+0x1d0>
800048dc:	000017b7          	lui	a5,0x1
800048e0:	80078793          	addi	a5,a5,-2048 # 800 <__HEAP_SIZE-0x1800>
800048e4:	00f4f733          	and	a4,s1,a5
800048e8:	00070a63          	beqz	a4,800048fc <rt_serial_open+0x74>
800048ec:	02445703          	lhu	a4,36(s0)
800048f0:	ff800513          	li	a0,-8
800048f4:	00e7f7b3          	and	a5,a5,a4
800048f8:	16078063          	beqz	a5,80004a58 <rt_serial_open+0x1d0>
800048fc:	1004f793          	andi	a5,s1,256
80004900:	00078a63          	beqz	a5,80004914 <rt_serial_open+0x8c>
80004904:	02445703          	lhu	a4,36(s0)
80004908:	ff800513          	li	a0,-8
8000490c:	10077713          	andi	a4,a4,256
80004910:	14070463          	beqz	a4,80004a58 <rt_serial_open+0x1d0>
80004914:	4004f993          	andi	s3,s1,1024
80004918:	00098a63          	beqz	s3,8000492c <rt_serial_open+0xa4>
8000491c:	02445703          	lhu	a4,36(s0)
80004920:	ff800513          	li	a0,-8
80004924:	40077713          	andi	a4,a4,1024
80004928:	12070863          	beqz	a4,80004a58 <rt_serial_open+0x1d0>
8000492c:	0404f713          	andi	a4,s1,64
80004930:	04000913          	li	s2,64
80004934:	00071a63          	bnez	a4,80004948 <rt_serial_open+0xc0>
80004938:	02645903          	lhu	s2,38(s0)
8000493c:	04097913          	andi	s2,s2,64
80004940:	00090463          	beqz	s2,80004948 <rt_serial_open+0xc0>
80004944:	04000913          	li	s2,64
80004948:	05c42703          	lw	a4,92(s0)
8000494c:	0ff4f493          	andi	s1,s1,255
80004950:	02941323          	sh	s1,38(s0)
80004954:	12071063          	bnez	a4,80004a74 <rt_serial_open+0x1ec>
80004958:	08078663          	beqz	a5,800049e4 <rt_serial_open+0x15c>
8000495c:	05842503          	lw	a0,88(s0)
80004960:	00a55513          	srli	a0,a0,0xa
80004964:	01051513          	slli	a0,a0,0x10
80004968:	01055513          	srli	a0,a0,0x10
8000496c:	00c50513          	addi	a0,a0,12
80004970:	b69fd0ef          	jal	ra,800024d8 <rt_malloc>
80004974:	00050493          	mv	s1,a0
80004978:	00051e63          	bnez	a0,80004994 <rt_serial_open+0x10c>
8000497c:	26d00613          	li	a2,621
80004980:	00009597          	auipc	a1,0x9
80004984:	b0c58593          	addi	a1,a1,-1268 # 8000d48c <__FUNCTION__.3482>
80004988:	00009517          	auipc	a0,0x9
8000498c:	a2050513          	addi	a0,a0,-1504 # 8000d3a8 <__fsym_pinMode_name+0x8>
80004990:	85dfd0ef          	jal	ra,800021ec <rt_assert_handler>
80004994:	05842603          	lw	a2,88(s0)
80004998:	00c48513          	addi	a0,s1,12
8000499c:	00000593          	li	a1,0
800049a0:	00a65613          	srli	a2,a2,0xa
800049a4:	01061613          	slli	a2,a2,0x10
800049a8:	01065613          	srli	a2,a2,0x10
800049ac:	00a4a023          	sw	a0,0(s1)
800049b0:	f59fc0ef          	jal	ra,80001908 <rt_memset>
800049b4:	0004a223          	sw	zero,4(s1)
800049b8:	02645783          	lhu	a5,38(s0)
800049bc:	0004a423          	sw	zero,8(s1)
800049c0:	04942e23          	sw	s1,92(s0)
800049c4:	1007e793          	ori	a5,a5,256
800049c8:	02f41323          	sh	a5,38(s0)
800049cc:	05042783          	lw	a5,80(s0)
800049d0:	10000613          	li	a2,256
800049d4:	01000593          	li	a1,16
800049d8:	0047a783          	lw	a5,4(a5)
800049dc:	00040513          	mv	a0,s0
800049e0:	000780e7          	jalr	a5
800049e4:	06042783          	lw	a5,96(s0)
800049e8:	08079e63          	bnez	a5,80004a84 <rt_serial_open+0x1fc>
800049ec:	04098e63          	beqz	s3,80004a48 <rt_serial_open+0x1c0>
800049f0:	00c00513          	li	a0,12
800049f4:	ae5fd0ef          	jal	ra,800024d8 <rt_malloc>
800049f8:	00050493          	mv	s1,a0
800049fc:	00051e63          	bnez	a0,80004a18 <rt_serial_open+0x190>
80004a00:	2ac00613          	li	a2,684
80004a04:	00009597          	auipc	a1,0x9
80004a08:	a8858593          	addi	a1,a1,-1400 # 8000d48c <__FUNCTION__.3482>
80004a0c:	00009517          	auipc	a0,0x9
80004a10:	9b050513          	addi	a0,a0,-1616 # 8000d3bc <__fsym_pinMode_name+0x1c>
80004a14:	fd8fd0ef          	jal	ra,800021ec <rt_assert_handler>
80004a18:	00048513          	mv	a0,s1
80004a1c:	061000ef          	jal	ra,8000527c <rt_completion_init>
80004a20:	02645783          	lhu	a5,38(s0)
80004a24:	06942023          	sw	s1,96(s0)
80004a28:	40000613          	li	a2,1024
80004a2c:	4007e793          	ori	a5,a5,1024
80004a30:	02f41323          	sh	a5,38(s0)
80004a34:	05042783          	lw	a5,80(s0)
80004a38:	01000593          	li	a1,16
80004a3c:	00040513          	mv	a0,s0
80004a40:	0047a783          	lw	a5,4(a5)
80004a44:	000780e7          	jalr	a5
80004a48:	02645783          	lhu	a5,38(s0)
80004a4c:	00000513          	li	a0,0
80004a50:	00f96933          	or	s2,s2,a5
80004a54:	03241323          	sh	s2,38(s0)
80004a58:	01c12083          	lw	ra,28(sp)
80004a5c:	01812403          	lw	s0,24(sp)
80004a60:	01412483          	lw	s1,20(sp)
80004a64:	01012903          	lw	s2,16(sp)
80004a68:	00c12983          	lw	s3,12(sp)
80004a6c:	02010113          	addi	sp,sp,32
80004a70:	00008067          	ret
80004a74:	f60788e3          	beqz	a5,800049e4 <rt_serial_open+0x15c>
80004a78:	1004e493          	ori	s1,s1,256
80004a7c:	02941323          	sh	s1,38(s0)
80004a80:	f65ff06f          	j	800049e4 <rt_serial_open+0x15c>
80004a84:	fc0982e3          	beqz	s3,80004a48 <rt_serial_open+0x1c0>
80004a88:	02645783          	lhu	a5,38(s0)
80004a8c:	4007e793          	ori	a5,a5,1024
80004a90:	02f41323          	sh	a5,38(s0)
80004a94:	fb5ff06f          	j	80004a48 <rt_serial_open+0x1c0>

80004a98 <rt_serial_control>:
80004a98:	ff010113          	addi	sp,sp,-16
80004a9c:	00812423          	sw	s0,8(sp)
80004aa0:	00912223          	sw	s1,4(sp)
80004aa4:	01212023          	sw	s2,0(sp)
80004aa8:	00112623          	sw	ra,12(sp)
80004aac:	00050413          	mv	s0,a0
80004ab0:	00058913          	mv	s2,a1
80004ab4:	00060493          	mv	s1,a2
80004ab8:	00051e63          	bnez	a0,80004ad4 <rt_serial_control+0x3c>
80004abc:	3d200613          	li	a2,978
80004ac0:	00009597          	auipc	a1,0x9
80004ac4:	a0c58593          	addi	a1,a1,-1524 # 8000d4cc <__FUNCTION__.3515>
80004ac8:	00008517          	auipc	a0,0x8
80004acc:	b8050513          	addi	a0,a0,-1152 # 8000c648 <__rti_rti_start_name+0xc>
80004ad0:	f1cfd0ef          	jal	ra,800021ec <rt_assert_handler>
80004ad4:	00200793          	li	a5,2
80004ad8:	02f90063          	beq	s2,a5,80004af8 <rt_serial_control+0x60>
80004adc:	00300793          	li	a5,3
80004ae0:	04f90063          	beq	s2,a5,80004b20 <rt_serial_control+0x88>
80004ae4:	00100793          	li	a5,1
80004ae8:	08f91c63          	bne	s2,a5,80004b80 <rt_serial_control+0xe8>
80004aec:	02445783          	lhu	a5,36(s0)
80004af0:	fdf7f793          	andi	a5,a5,-33
80004af4:	00c0006f          	j	80004b00 <rt_serial_control+0x68>
80004af8:	02445783          	lhu	a5,36(s0)
80004afc:	0207e793          	ori	a5,a5,32
80004b00:	02f41223          	sh	a5,36(s0)
80004b04:	00000513          	li	a0,0
80004b08:	00c12083          	lw	ra,12(sp)
80004b0c:	00812403          	lw	s0,8(sp)
80004b10:	00412483          	lw	s1,4(sp)
80004b14:	00012903          	lw	s2,0(sp)
80004b18:	01010113          	addi	sp,sp,16
80004b1c:	00008067          	ret
80004b20:	fe0482e3          	beqz	s1,80004b04 <rt_serial_control+0x6c>
80004b24:	0044a703          	lw	a4,4(s1)
80004b28:	05842783          	lw	a5,88(s0)
80004b2c:	02844683          	lbu	a3,40(s0)
80004b30:	00a75713          	srli	a4,a4,0xa
80004b34:	00a7d793          	srli	a5,a5,0xa
80004b38:	01071713          	slli	a4,a4,0x10
80004b3c:	01079793          	slli	a5,a5,0x10
80004b40:	01075713          	srli	a4,a4,0x10
80004b44:	0107d793          	srli	a5,a5,0x10
80004b48:	00f70663          	beq	a4,a5,80004b54 <rt_serial_control+0xbc>
80004b4c:	00700513          	li	a0,7
80004b50:	fa069ce3          	bnez	a3,80004b08 <rt_serial_control+0x70>
80004b54:	0004a783          	lw	a5,0(s1)
80004b58:	04f42a23          	sw	a5,84(s0)
80004b5c:	0044a783          	lw	a5,4(s1)
80004b60:	04f42c23          	sw	a5,88(s0)
80004b64:	fa0680e3          	beqz	a3,80004b04 <rt_serial_control+0x6c>
80004b68:	05042783          	lw	a5,80(s0)
80004b6c:	00048593          	mv	a1,s1
80004b70:	00040513          	mv	a0,s0
80004b74:	0007a783          	lw	a5,0(a5)
80004b78:	000780e7          	jalr	a5
80004b7c:	f89ff06f          	j	80004b04 <rt_serial_control+0x6c>
80004b80:	05042783          	lw	a5,80(s0)
80004b84:	00040513          	mv	a0,s0
80004b88:	00812403          	lw	s0,8(sp)
80004b8c:	00c12083          	lw	ra,12(sp)
80004b90:	0047a303          	lw	t1,4(a5)
80004b94:	00048613          	mv	a2,s1
80004b98:	00090593          	mv	a1,s2
80004b9c:	00412483          	lw	s1,4(sp)
80004ba0:	00012903          	lw	s2,0(sp)
80004ba4:	01010113          	addi	sp,sp,16
80004ba8:	00030067          	jr	t1

80004bac <rt_serial_write>:
80004bac:	fe010113          	addi	sp,sp,-32
80004bb0:	00812c23          	sw	s0,24(sp)
80004bb4:	00912a23          	sw	s1,20(sp)
80004bb8:	01212823          	sw	s2,16(sp)
80004bbc:	00112e23          	sw	ra,28(sp)
80004bc0:	01312623          	sw	s3,12(sp)
80004bc4:	01412423          	sw	s4,8(sp)
80004bc8:	01512223          	sw	s5,4(sp)
80004bcc:	01612023          	sw	s6,0(sp)
80004bd0:	00050413          	mv	s0,a0
80004bd4:	00060493          	mv	s1,a2
80004bd8:	00068913          	mv	s2,a3
80004bdc:	00051e63          	bnez	a0,80004bf8 <rt_serial_write+0x4c>
80004be0:	35500613          	li	a2,853
80004be4:	00009597          	auipc	a1,0x9
80004be8:	8d858593          	addi	a1,a1,-1832 # 8000d4bc <__FUNCTION__.3507>
80004bec:	00008517          	auipc	a0,0x8
80004bf0:	a5c50513          	addi	a0,a0,-1444 # 8000c648 <__rti_rti_start_name+0xc>
80004bf4:	df8fd0ef          	jal	ra,800021ec <rt_assert_handler>
80004bf8:	08090e63          	beqz	s2,80004c94 <rt_serial_write+0xe8>
80004bfc:	02645783          	lhu	a5,38(s0)
80004c00:	00090993          	mv	s3,s2
80004c04:	4007f793          	andi	a5,a5,1024
80004c08:	0a078c63          	beqz	a5,80004cc0 <rt_serial_write+0x114>
80004c0c:	06042a03          	lw	s4,96(s0)
80004c10:	000a1e63          	bnez	s4,80004c2c <rt_serial_write+0x80>
80004c14:	13c00613          	li	a2,316
80004c18:	00009597          	auipc	a1,0x9
80004c1c:	85458593          	addi	a1,a1,-1964 # 8000d46c <__FUNCTION__.3462>
80004c20:	00008517          	auipc	a0,0x8
80004c24:	7b050513          	addi	a0,a0,1968 # 8000d3d0 <__fsym_pinMode_name+0x30>
80004c28:	dc4fd0ef          	jal	ra,800021ec <rt_assert_handler>
80004c2c:	00a00b13          	li	s6,10
80004c30:	fff00a93          	li	s5,-1
80004c34:	0004c783          	lbu	a5,0(s1)
80004c38:	03679c63          	bne	a5,s6,80004c70 <rt_serial_write+0xc4>
80004c3c:	02645783          	lhu	a5,38(s0)
80004c40:	0407f793          	andi	a5,a5,64
80004c44:	02078663          	beqz	a5,80004c70 <rt_serial_write+0xc4>
80004c48:	05042783          	lw	a5,80(s0)
80004c4c:	00d00593          	li	a1,13
80004c50:	00040513          	mv	a0,s0
80004c54:	0087a783          	lw	a5,8(a5)
80004c58:	000780e7          	jalr	a5
80004c5c:	01551a63          	bne	a0,s5,80004c70 <rt_serial_write+0xc4>
80004c60:	fff00593          	li	a1,-1
80004c64:	000a0513          	mv	a0,s4
80004c68:	664000ef          	jal	ra,800052cc <rt_completion_wait>
80004c6c:	fc9ff06f          	j	80004c34 <rt_serial_write+0x88>
80004c70:	05042783          	lw	a5,80(s0)
80004c74:	0004c583          	lbu	a1,0(s1)
80004c78:	00040513          	mv	a0,s0
80004c7c:	0087a783          	lw	a5,8(a5)
80004c80:	000780e7          	jalr	a5
80004c84:	fd550ee3          	beq	a0,s5,80004c60 <rt_serial_write+0xb4>
80004c88:	fff98993          	addi	s3,s3,-1
80004c8c:	00148493          	addi	s1,s1,1
80004c90:	fa0992e3          	bnez	s3,80004c34 <rt_serial_write+0x88>
80004c94:	01c12083          	lw	ra,28(sp)
80004c98:	01812403          	lw	s0,24(sp)
80004c9c:	01412483          	lw	s1,20(sp)
80004ca0:	00c12983          	lw	s3,12(sp)
80004ca4:	00812a03          	lw	s4,8(sp)
80004ca8:	00412a83          	lw	s5,4(sp)
80004cac:	00012b03          	lw	s6,0(sp)
80004cb0:	00090513          	mv	a0,s2
80004cb4:	01012903          	lw	s2,16(sp)
80004cb8:	02010113          	addi	sp,sp,32
80004cbc:	00008067          	ret
80004cc0:	012489b3          	add	s3,s1,s2
80004cc4:	00a00a13          	li	s4,10
80004cc8:	0004c783          	lbu	a5,0(s1)
80004ccc:	03479263          	bne	a5,s4,80004cf0 <rt_serial_write+0x144>
80004cd0:	02645783          	lhu	a5,38(s0)
80004cd4:	0407f793          	andi	a5,a5,64
80004cd8:	00078c63          	beqz	a5,80004cf0 <rt_serial_write+0x144>
80004cdc:	05042783          	lw	a5,80(s0)
80004ce0:	00d00593          	li	a1,13
80004ce4:	00040513          	mv	a0,s0
80004ce8:	0087a783          	lw	a5,8(a5)
80004cec:	000780e7          	jalr	a5
80004cf0:	05042783          	lw	a5,80(s0)
80004cf4:	0004c583          	lbu	a1,0(s1)
80004cf8:	00040513          	mv	a0,s0
80004cfc:	0087a783          	lw	a5,8(a5)
80004d00:	00148493          	addi	s1,s1,1
80004d04:	000780e7          	jalr	a5
80004d08:	fd3490e3          	bne	s1,s3,80004cc8 <rt_serial_write+0x11c>
80004d0c:	f89ff06f          	j	80004c94 <rt_serial_write+0xe8>

80004d10 <rt_serial_read>:
80004d10:	fe010113          	addi	sp,sp,-32
80004d14:	00812c23          	sw	s0,24(sp)
80004d18:	00912a23          	sw	s1,20(sp)
80004d1c:	01212823          	sw	s2,16(sp)
80004d20:	00112e23          	sw	ra,28(sp)
80004d24:	01312623          	sw	s3,12(sp)
80004d28:	01412423          	sw	s4,8(sp)
80004d2c:	01512223          	sw	s5,4(sp)
80004d30:	01612023          	sw	s6,0(sp)
80004d34:	00050493          	mv	s1,a0
80004d38:	00060913          	mv	s2,a2
80004d3c:	00068413          	mv	s0,a3
80004d40:	00051e63          	bnez	a0,80004d5c <rt_serial_read+0x4c>
80004d44:	33b00613          	li	a2,827
80004d48:	00008597          	auipc	a1,0x8
80004d4c:	76458593          	addi	a1,a1,1892 # 8000d4ac <__FUNCTION__.3499>
80004d50:	00008517          	auipc	a0,0x8
80004d54:	8f850513          	addi	a0,a0,-1800 # 8000c648 <__rti_rti_start_name+0xc>
80004d58:	c94fd0ef          	jal	ra,800021ec <rt_assert_handler>
80004d5c:	08040c63          	beqz	s0,80004df4 <rt_serial_read+0xe4>
80004d60:	0264d783          	lhu	a5,38(s1)
80004d64:	00040993          	mv	s3,s0
80004d68:	1007f793          	andi	a5,a5,256
80004d6c:	02079e63          	bnez	a5,80004da8 <rt_serial_read+0x98>
80004d70:	fff00a13          	li	s4,-1
80004d74:	00a00a93          	li	s5,10
80004d78:	0504a783          	lw	a5,80(s1)
80004d7c:	00048513          	mv	a0,s1
80004d80:	00c7a783          	lw	a5,12(a5)
80004d84:	000780e7          	jalr	a5
80004d88:	01450c63          	beq	a0,s4,80004da0 <rt_serial_read+0x90>
80004d8c:	00a90023          	sb	a0,0(s2)
80004d90:	fff98993          	addi	s3,s3,-1
80004d94:	00190913          	addi	s2,s2,1
80004d98:	01550463          	beq	a0,s5,80004da0 <rt_serial_read+0x90>
80004d9c:	fc099ee3          	bnez	s3,80004d78 <rt_serial_read+0x68>
80004da0:	41340433          	sub	s0,s0,s3
80004da4:	0500006f          	j	80004df4 <rt_serial_read+0xe4>
80004da8:	05c4a983          	lw	s3,92(s1)
80004dac:	00099e63          	bnez	s3,80004dc8 <rt_serial_read+0xb8>
80004db0:	10c00613          	li	a2,268
80004db4:	00008597          	auipc	a1,0x8
80004db8:	6a858593          	addi	a1,a1,1704 # 8000d45c <__FUNCTION__.3449>
80004dbc:	00008517          	auipc	a0,0x8
80004dc0:	5ec50513          	addi	a0,a0,1516 # 8000d3a8 <__fsym_pinMode_name+0x8>
80004dc4:	c28fd0ef          	jal	ra,800021ec <rt_assert_handler>
80004dc8:	00040a13          	mv	s4,s0
80004dcc:	00100a93          	li	s5,1
80004dd0:	bf0ff0ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
80004dd4:	0069d783          	lhu	a5,6(s3)
80004dd8:	0049d703          	lhu	a4,4(s3)
80004ddc:	0089a603          	lw	a2,8(s3)
80004de0:	00050693          	mv	a3,a0
80004de4:	02f71e63          	bne	a4,a5,80004e20 <rt_serial_read+0x110>
80004de8:	02061c63          	bnez	a2,80004e20 <rt_serial_read+0x110>
80004dec:	bdcff0ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
80004df0:	41440433          	sub	s0,s0,s4
80004df4:	01c12083          	lw	ra,28(sp)
80004df8:	00040513          	mv	a0,s0
80004dfc:	01812403          	lw	s0,24(sp)
80004e00:	01412483          	lw	s1,20(sp)
80004e04:	01012903          	lw	s2,16(sp)
80004e08:	00c12983          	lw	s3,12(sp)
80004e0c:	00812a03          	lw	s4,8(sp)
80004e10:	00412a83          	lw	s5,4(sp)
80004e14:	00012b03          	lw	s6,0(sp)
80004e18:	02010113          	addi	sp,sp,32
80004e1c:	00008067          	ret
80004e20:	0009a703          	lw	a4,0(s3)
80004e24:	00f70733          	add	a4,a4,a5
80004e28:	00074b03          	lbu	s6,0(a4)
80004e2c:	0584a703          	lw	a4,88(s1)
80004e30:	00178793          	addi	a5,a5,1
80004e34:	01079793          	slli	a5,a5,0x10
80004e38:	00a75713          	srli	a4,a4,0xa
80004e3c:	0107d793          	srli	a5,a5,0x10
80004e40:	01071713          	slli	a4,a4,0x10
80004e44:	00f99323          	sh	a5,6(s3)
80004e48:	01075713          	srli	a4,a4,0x10
80004e4c:	00e7e463          	bltu	a5,a4,80004e54 <rt_serial_read+0x144>
80004e50:	00099323          	sh	zero,6(s3)
80004e54:	01561463          	bne	a2,s5,80004e5c <rt_serial_read+0x14c>
80004e58:	0009a423          	sw	zero,8(s3)
80004e5c:	00068513          	mv	a0,a3
80004e60:	b68ff0ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
80004e64:	fffa0a13          	addi	s4,s4,-1 # 7fffffff <_sp+0xfffbffff>
80004e68:	01690023          	sb	s6,0(s2)
80004e6c:	00190913          	addi	s2,s2,1
80004e70:	f60a10e3          	bnez	s4,80004dd0 <rt_serial_read+0xc0>
80004e74:	f7dff06f          	j	80004df0 <rt_serial_read+0xe0>

80004e78 <rt_serial_close>:
80004e78:	ff010113          	addi	sp,sp,-16
80004e7c:	00812423          	sw	s0,8(sp)
80004e80:	00112623          	sw	ra,12(sp)
80004e84:	00912223          	sw	s1,4(sp)
80004e88:	00050413          	mv	s0,a0
80004e8c:	00051e63          	bnez	a0,80004ea8 <rt_serial_close+0x30>
80004e90:	2df00613          	li	a2,735
80004e94:	00008597          	auipc	a1,0x8
80004e98:	60858593          	addi	a1,a1,1544 # 8000d49c <__FUNCTION__.3489>
80004e9c:	00007517          	auipc	a0,0x7
80004ea0:	7ac50513          	addi	a0,a0,1964 # 8000c648 <__rti_rti_start_name+0xc>
80004ea4:	b48fd0ef          	jal	ra,800021ec <rt_assert_handler>
80004ea8:	02844703          	lbu	a4,40(s0)
80004eac:	00100793          	li	a5,1
80004eb0:	0ae7ee63          	bltu	a5,a4,80004f6c <rt_serial_close+0xf4>
80004eb4:	02645783          	lhu	a5,38(s0)
80004eb8:	1007f793          	andi	a5,a5,256
80004ebc:	04078a63          	beqz	a5,80004f10 <rt_serial_close+0x98>
80004ec0:	05c42483          	lw	s1,92(s0)
80004ec4:	00049e63          	bnez	s1,80004ee0 <rt_serial_close+0x68>
80004ec8:	2ea00613          	li	a2,746
80004ecc:	00008597          	auipc	a1,0x8
80004ed0:	5d058593          	addi	a1,a1,1488 # 8000d49c <__FUNCTION__.3489>
80004ed4:	00008517          	auipc	a0,0x8
80004ed8:	4d450513          	addi	a0,a0,1236 # 8000d3a8 <__fsym_pinMode_name+0x8>
80004edc:	b10fd0ef          	jal	ra,800021ec <rt_assert_handler>
80004ee0:	00048513          	mv	a0,s1
80004ee4:	8a1fd0ef          	jal	ra,80002784 <rt_free>
80004ee8:	02645783          	lhu	a5,38(s0)
80004eec:	04042e23          	sw	zero,92(s0)
80004ef0:	10000613          	li	a2,256
80004ef4:	eff7f793          	andi	a5,a5,-257
80004ef8:	02f41323          	sh	a5,38(s0)
80004efc:	05042783          	lw	a5,80(s0)
80004f00:	01100593          	li	a1,17
80004f04:	00040513          	mv	a0,s0
80004f08:	0047a783          	lw	a5,4(a5)
80004f0c:	000780e7          	jalr	a5
80004f10:	02645783          	lhu	a5,38(s0)
80004f14:	4007f793          	andi	a5,a5,1024
80004f18:	04078a63          	beqz	a5,80004f6c <rt_serial_close+0xf4>
80004f1c:	06042483          	lw	s1,96(s0)
80004f20:	00049e63          	bnez	s1,80004f3c <rt_serial_close+0xc4>
80004f24:	31200613          	li	a2,786
80004f28:	00008597          	auipc	a1,0x8
80004f2c:	57458593          	addi	a1,a1,1396 # 8000d49c <__FUNCTION__.3489>
80004f30:	00008517          	auipc	a0,0x8
80004f34:	48c50513          	addi	a0,a0,1164 # 8000d3bc <__fsym_pinMode_name+0x1c>
80004f38:	ab4fd0ef          	jal	ra,800021ec <rt_assert_handler>
80004f3c:	00048513          	mv	a0,s1
80004f40:	845fd0ef          	jal	ra,80002784 <rt_free>
80004f44:	02645783          	lhu	a5,38(s0)
80004f48:	06042023          	sw	zero,96(s0)
80004f4c:	40000613          	li	a2,1024
80004f50:	bff7f793          	andi	a5,a5,-1025
80004f54:	02f41323          	sh	a5,38(s0)
80004f58:	05042783          	lw	a5,80(s0)
80004f5c:	01100593          	li	a1,17
80004f60:	00040513          	mv	a0,s0
80004f64:	0047a783          	lw	a5,4(a5)
80004f68:	000780e7          	jalr	a5
80004f6c:	00c12083          	lw	ra,12(sp)
80004f70:	00812403          	lw	s0,8(sp)
80004f74:	00412483          	lw	s1,4(sp)
80004f78:	00000513          	li	a0,0
80004f7c:	01010113          	addi	sp,sp,16
80004f80:	00008067          	ret

80004f84 <rt_hw_serial_register>:
80004f84:	fe010113          	addi	sp,sp,-32
80004f88:	00812c23          	sw	s0,24(sp)
80004f8c:	00912a23          	sw	s1,20(sp)
80004f90:	01212823          	sw	s2,16(sp)
80004f94:	01312623          	sw	s3,12(sp)
80004f98:	00112e23          	sw	ra,28(sp)
80004f9c:	00050413          	mv	s0,a0
80004fa0:	00058493          	mv	s1,a1
80004fa4:	00060913          	mv	s2,a2
80004fa8:	00068993          	mv	s3,a3
80004fac:	00051e63          	bnez	a0,80004fc8 <rt_hw_serial_register+0x44>
80004fb0:	47e00613          	li	a2,1150
80004fb4:	00008597          	auipc	a1,0x8
80004fb8:	52c58593          	addi	a1,a1,1324 # 8000d4e0 <__FUNCTION__.3530>
80004fbc:	00007517          	auipc	a0,0x7
80004fc0:	4b450513          	addi	a0,a0,1204 # 8000c470 <__fsym___cmd_testapp_name+0x14>
80004fc4:	a28fd0ef          	jal	ra,800021ec <rt_assert_handler>
80004fc8:	00000797          	auipc	a5,0x0
80004fcc:	85478793          	addi	a5,a5,-1964 # 8000481c <rt_serial_init>
80004fd0:	02f42a23          	sw	a5,52(s0)
80004fd4:	00000797          	auipc	a5,0x0
80004fd8:	8b478793          	addi	a5,a5,-1868 # 80004888 <rt_serial_open>
80004fdc:	02f42c23          	sw	a5,56(s0)
80004fe0:	00000797          	auipc	a5,0x0
80004fe4:	e9878793          	addi	a5,a5,-360 # 80004e78 <rt_serial_close>
80004fe8:	02f42e23          	sw	a5,60(s0)
80004fec:	00000797          	auipc	a5,0x0
80004ff0:	d2478793          	addi	a5,a5,-732 # 80004d10 <rt_serial_read>
80004ff4:	04f42023          	sw	a5,64(s0)
80004ff8:	00000797          	auipc	a5,0x0
80004ffc:	bb478793          	addi	a5,a5,-1100 # 80004bac <rt_serial_write>
80005000:	04f42223          	sw	a5,68(s0)
80005004:	00000797          	auipc	a5,0x0
80005008:	a9478793          	addi	a5,a5,-1388 # 80004a98 <rt_serial_control>
8000500c:	05342623          	sw	s3,76(s0)
80005010:	02042023          	sw	zero,32(s0)
80005014:	02042623          	sw	zero,44(s0)
80005018:	02042823          	sw	zero,48(s0)
8000501c:	04f42423          	sw	a5,72(s0)
80005020:	00040513          	mv	a0,s0
80005024:	01812403          	lw	s0,24(sp)
80005028:	01c12083          	lw	ra,28(sp)
8000502c:	00c12983          	lw	s3,12(sp)
80005030:	01091613          	slli	a2,s2,0x10
80005034:	00048593          	mv	a1,s1
80005038:	01012903          	lw	s2,16(sp)
8000503c:	01412483          	lw	s1,20(sp)
80005040:	01065613          	srli	a2,a2,0x10
80005044:	02010113          	addi	sp,sp,32
80005048:	b0dfb06f          	j	80000b54 <rt_device_register>

8000504c <rt_hw_serial_isr>:
8000504c:	fc010113          	addi	sp,sp,-64
80005050:	02912a23          	sw	s1,52(sp)
80005054:	02112e23          	sw	ra,60(sp)
80005058:	02812c23          	sw	s0,56(sp)
8000505c:	03212823          	sw	s2,48(sp)
80005060:	03312623          	sw	s3,44(sp)
80005064:	03412423          	sw	s4,40(sp)
80005068:	03512223          	sw	s5,36(sp)
8000506c:	03612023          	sw	s6,32(sp)
80005070:	01712e23          	sw	s7,28(sp)
80005074:	01812c23          	sw	s8,24(sp)
80005078:	01912a23          	sw	s9,20(sp)
8000507c:	0ff5f593          	andi	a1,a1,255
80005080:	00100793          	li	a5,1
80005084:	00050493          	mv	s1,a0
80005088:	04f58063          	beq	a1,a5,800050c8 <rt_hw_serial_isr+0x7c>
8000508c:	00200793          	li	a5,2
80005090:	1af58a63          	beq	a1,a5,80005244 <rt_hw_serial_isr+0x1f8>
80005094:	03c12083          	lw	ra,60(sp)
80005098:	03812403          	lw	s0,56(sp)
8000509c:	03412483          	lw	s1,52(sp)
800050a0:	03012903          	lw	s2,48(sp)
800050a4:	02c12983          	lw	s3,44(sp)
800050a8:	02812a03          	lw	s4,40(sp)
800050ac:	02412a83          	lw	s5,36(sp)
800050b0:	02012b03          	lw	s6,32(sp)
800050b4:	01c12b83          	lw	s7,28(sp)
800050b8:	01812c03          	lw	s8,24(sp)
800050bc:	01412c83          	lw	s9,20(sp)
800050c0:	04010113          	addi	sp,sp,64
800050c4:	00008067          	ret
800050c8:	05c52403          	lw	s0,92(a0)
800050cc:	00041e63          	bnez	s0,800050e8 <rt_hw_serial_isr+0x9c>
800050d0:	4aa00613          	li	a2,1194
800050d4:	00008597          	auipc	a1,0x8
800050d8:	42458593          	addi	a1,a1,1060 # 8000d4f8 <__FUNCTION__.3539>
800050dc:	00008517          	auipc	a0,0x8
800050e0:	2cc50513          	addi	a0,a0,716 # 8000d3a8 <__fsym_pinMode_name+0x8>
800050e4:	908fd0ef          	jal	ra,800021ec <rt_assert_handler>
800050e8:	fff00a13          	li	s4,-1
800050ec:	00100913          	li	s2,1
800050f0:	8c818993          	addi	s3,gp,-1848 # 80020328 <already_output.3469>
800050f4:	00008a97          	auipc	s5,0x8
800050f8:	2eca8a93          	addi	s5,s5,748 # 8000d3e0 <__fsym_pinMode_name+0x40>
800050fc:	00008b17          	auipc	s6,0x8
80005100:	2f4b0b13          	addi	s6,s6,756 # 8000d3f0 <__fsym_pinMode_name+0x50>
80005104:	00008b97          	auipc	s7,0x8
80005108:	350b8b93          	addi	s7,s7,848 # 8000d454 <__fsym_pinMode_name+0xb4>
8000510c:	0504a783          	lw	a5,80(s1)
80005110:	00048513          	mv	a0,s1
80005114:	00c7a783          	lw	a5,12(a5)
80005118:	000780e7          	jalr	a5
8000511c:	00050c13          	mv	s8,a0
80005120:	0b450063          	beq	a0,s4,800051c0 <rt_hw_serial_isr+0x174>
80005124:	89cff0ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
80005128:	00445703          	lhu	a4,4(s0)
8000512c:	00042783          	lw	a5,0(s0)
80005130:	00050c93          	mv	s9,a0
80005134:	00e787b3          	add	a5,a5,a4
80005138:	01878023          	sb	s8,0(a5)
8000513c:	00445783          	lhu	a5,4(s0)
80005140:	0584a703          	lw	a4,88(s1)
80005144:	00178793          	addi	a5,a5,1
80005148:	01079793          	slli	a5,a5,0x10
8000514c:	00a75713          	srli	a4,a4,0xa
80005150:	0107d793          	srli	a5,a5,0x10
80005154:	01071713          	slli	a4,a4,0x10
80005158:	00f41223          	sh	a5,4(s0)
8000515c:	01075713          	srli	a4,a4,0x10
80005160:	00e7e463          	bltu	a5,a4,80005168 <rt_hw_serial_isr+0x11c>
80005164:	00041223          	sh	zero,4(s0)
80005168:	00645683          	lhu	a3,6(s0)
8000516c:	00445783          	lhu	a5,4(s0)
80005170:	04d79263          	bne	a5,a3,800051b4 <rt_hw_serial_isr+0x168>
80005174:	00178793          	addi	a5,a5,1
80005178:	01079793          	slli	a5,a5,0x10
8000517c:	0107d793          	srli	a5,a5,0x10
80005180:	00f41323          	sh	a5,6(s0)
80005184:	01242423          	sw	s2,8(s0)
80005188:	00e7e463          	bltu	a5,a4,80005190 <rt_hw_serial_isr+0x144>
8000518c:	00041323          	sh	zero,6(s0)
80005190:	0009a783          	lw	a5,0(s3)
80005194:	02079063          	bnez	a5,800051b4 <rt_hw_serial_isr+0x168>
80005198:	000a8513          	mv	a0,s5
8000519c:	ed1fc0ef          	jal	ra,8000206c <rt_kprintf>
800051a0:	000b0513          	mv	a0,s6
800051a4:	ec9fc0ef          	jal	ra,8000206c <rt_kprintf>
800051a8:	000b8513          	mv	a0,s7
800051ac:	ec1fc0ef          	jal	ra,8000206c <rt_kprintf>
800051b0:	0129a023          	sw	s2,0(s3)
800051b4:	000c8513          	mv	a0,s9
800051b8:	810ff0ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
800051bc:	f51ff06f          	j	8000510c <rt_hw_serial_isr+0xc0>
800051c0:	02c4a783          	lw	a5,44(s1)
800051c4:	ec0788e3          	beqz	a5,80005094 <rt_hw_serial_isr+0x48>
800051c8:	ff9fe0ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
800051cc:	00445703          	lhu	a4,4(s0)
800051d0:	00645583          	lhu	a1,6(s0)
800051d4:	04b76a63          	bltu	a4,a1,80005228 <rt_hw_serial_isr+0x1dc>
800051d8:	40b705b3          	sub	a1,a4,a1
800051dc:	00b12623          	sw	a1,12(sp)
800051e0:	fe9fe0ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
800051e4:	00c12583          	lw	a1,12(sp)
800051e8:	ea0586e3          	beqz	a1,80005094 <rt_hw_serial_isr+0x48>
800051ec:	03812403          	lw	s0,56(sp)
800051f0:	02c4a303          	lw	t1,44(s1)
800051f4:	03c12083          	lw	ra,60(sp)
800051f8:	03012903          	lw	s2,48(sp)
800051fc:	02c12983          	lw	s3,44(sp)
80005200:	02812a03          	lw	s4,40(sp)
80005204:	02412a83          	lw	s5,36(sp)
80005208:	02012b03          	lw	s6,32(sp)
8000520c:	01c12b83          	lw	s7,28(sp)
80005210:	01812c03          	lw	s8,24(sp)
80005214:	01412c83          	lw	s9,20(sp)
80005218:	00048513          	mv	a0,s1
8000521c:	03412483          	lw	s1,52(sp)
80005220:	04010113          	addi	sp,sp,64
80005224:	00030067          	jr	t1
80005228:	0584a783          	lw	a5,88(s1)
8000522c:	40e585b3          	sub	a1,a1,a4
80005230:	00a7d793          	srli	a5,a5,0xa
80005234:	01079793          	slli	a5,a5,0x10
80005238:	0107d793          	srli	a5,a5,0x10
8000523c:	40b785b3          	sub	a1,a5,a1
80005240:	f9dff06f          	j	800051dc <rt_hw_serial_isr+0x190>
80005244:	03812403          	lw	s0,56(sp)
80005248:	03c12083          	lw	ra,60(sp)
8000524c:	03412483          	lw	s1,52(sp)
80005250:	03012903          	lw	s2,48(sp)
80005254:	02c12983          	lw	s3,44(sp)
80005258:	02812a03          	lw	s4,40(sp)
8000525c:	02412a83          	lw	s5,36(sp)
80005260:	02012b03          	lw	s6,32(sp)
80005264:	01c12b83          	lw	s7,28(sp)
80005268:	01812c03          	lw	s8,24(sp)
8000526c:	01412c83          	lw	s9,20(sp)
80005270:	06052503          	lw	a0,96(a0)
80005274:	04010113          	addi	sp,sp,64
80005278:	1bc0006f          	j	80005434 <rt_completion_done>

8000527c <rt_completion_init>:
8000527c:	ff010113          	addi	sp,sp,-16
80005280:	00812423          	sw	s0,8(sp)
80005284:	00112623          	sw	ra,12(sp)
80005288:	00050413          	mv	s0,a0
8000528c:	00051e63          	bnez	a0,800052a8 <rt_completion_init+0x2c>
80005290:	01500613          	li	a2,21
80005294:	00008597          	auipc	a1,0x8
80005298:	2c058593          	addi	a1,a1,704 # 8000d554 <__FUNCTION__.3425>
8000529c:	00008517          	auipc	a0,0x8
800052a0:	27050513          	addi	a0,a0,624 # 8000d50c <__FUNCTION__.3539+0x14>
800052a4:	f49fc0ef          	jal	ra,800021ec <rt_assert_handler>
800052a8:	f19fe0ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
800052ac:	00440793          	addi	a5,s0,4
800052b0:	00042023          	sw	zero,0(s0)
800052b4:	00f42423          	sw	a5,8(s0)
800052b8:	00f42223          	sw	a5,4(s0)
800052bc:	00812403          	lw	s0,8(sp)
800052c0:	00c12083          	lw	ra,12(sp)
800052c4:	01010113          	addi	sp,sp,16
800052c8:	f01fe06f          	j	800041c8 <rt_hw_interrupt_enable>

800052cc <rt_completion_wait>:
800052cc:	fd010113          	addi	sp,sp,-48
800052d0:	02812423          	sw	s0,40(sp)
800052d4:	02112623          	sw	ra,44(sp)
800052d8:	02912223          	sw	s1,36(sp)
800052dc:	03212023          	sw	s2,32(sp)
800052e0:	01312e23          	sw	s3,28(sp)
800052e4:	01412c23          	sw	s4,24(sp)
800052e8:	00b12623          	sw	a1,12(sp)
800052ec:	00050413          	mv	s0,a0
800052f0:	00051e63          	bnez	a0,8000530c <rt_completion_wait+0x40>
800052f4:	02400613          	li	a2,36
800052f8:	00008597          	auipc	a1,0x8
800052fc:	27058593          	addi	a1,a1,624 # 8000d568 <__FUNCTION__.3433>
80005300:	00008517          	auipc	a0,0x8
80005304:	20c50513          	addi	a0,a0,524 # 8000d50c <__FUNCTION__.3539+0x14>
80005308:	ee5fc0ef          	jal	ra,800021ec <rt_assert_handler>
8000530c:	924fe0ef          	jal	ra,80003430 <rt_thread_self>
80005310:	00050493          	mv	s1,a0
80005314:	eadfe0ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
80005318:	00042703          	lw	a4,0(s0)
8000531c:	00100793          	li	a5,1
80005320:	00050913          	mv	s2,a0
80005324:	10f70463          	beq	a4,a5,8000542c <rt_completion_wait+0x160>
80005328:	00442783          	lw	a5,4(s0)
8000532c:	00440a13          	addi	s4,s0,4
80005330:	00fa0e63          	beq	s4,a5,8000534c <rt_completion_wait+0x80>
80005334:	02d00613          	li	a2,45
80005338:	00008597          	auipc	a1,0x8
8000533c:	23058593          	addi	a1,a1,560 # 8000d568 <__FUNCTION__.3433>
80005340:	00008517          	auipc	a0,0x8
80005344:	1e450513          	addi	a0,a0,484 # 8000d524 <__FUNCTION__.3539+0x2c>
80005348:	ea5fc0ef          	jal	ra,800021ec <rt_assert_handler>
8000534c:	00c12783          	lw	a5,12(sp)
80005350:	ffe00993          	li	s3,-2
80005354:	0a078663          	beqz	a5,80005400 <rt_completion_wait+0x134>
80005358:	0204ae23          	sw	zero,60(s1)
8000535c:	00048513          	mv	a0,s1
80005360:	984fe0ef          	jal	ra,800034e4 <rt_thread_suspend>
80005364:	00842703          	lw	a4,8(s0)
80005368:	02048793          	addi	a5,s1,32
8000536c:	00f72023          	sw	a5,0(a4)
80005370:	02e4a223          	sw	a4,36(s1)
80005374:	00f42423          	sw	a5,8(s0)
80005378:	0344a023          	sw	s4,32(s1)
8000537c:	e45fe0ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
80005380:	00050993          	mv	s3,a0
80005384:	b08fc0ef          	jal	ra,8000168c <rt_interrupt_get_nest>
80005388:	02050863          	beqz	a0,800053b8 <rt_completion_wait+0xec>
8000538c:	00008597          	auipc	a1,0x8
80005390:	1dc58593          	addi	a1,a1,476 # 8000d568 <__FUNCTION__.3433>
80005394:	00007517          	auipc	a0,0x7
80005398:	3f850513          	addi	a0,a0,1016 # 8000c78c <__FUNCTION__.3020+0x1c>
8000539c:	cd1fc0ef          	jal	ra,8000206c <rt_kprintf>
800053a0:	04000613          	li	a2,64
800053a4:	00008597          	auipc	a1,0x8
800053a8:	1c458593          	addi	a1,a1,452 # 8000d568 <__FUNCTION__.3433>
800053ac:	00007517          	auipc	a0,0x7
800053b0:	40850513          	addi	a0,a0,1032 # 8000c7b4 <__FUNCTION__.3020+0x44>
800053b4:	e39fc0ef          	jal	ra,800021ec <rt_assert_handler>
800053b8:	00098513          	mv	a0,s3
800053bc:	e0dfe0ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
800053c0:	00c12783          	lw	a5,12(sp)
800053c4:	02f05063          	blez	a5,800053e4 <rt_completion_wait+0x118>
800053c8:	05848993          	addi	s3,s1,88
800053cc:	00c10613          	addi	a2,sp,12
800053d0:	00000593          	li	a1,0
800053d4:	00098513          	mv	a0,s3
800053d8:	845fe0ef          	jal	ra,80003c1c <rt_timer_control>
800053dc:	00098513          	mv	a0,s3
800053e0:	dfcfe0ef          	jal	ra,800039dc <rt_timer_start>
800053e4:	00090513          	mv	a0,s2
800053e8:	de1fe0ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
800053ec:	afdfd0ef          	jal	ra,80002ee8 <rt_schedule>
800053f0:	03c4a983          	lw	s3,60(s1)
800053f4:	dcdfe0ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
800053f8:	00050913          	mv	s2,a0
800053fc:	00042023          	sw	zero,0(s0)
80005400:	00090513          	mv	a0,s2
80005404:	dc5fe0ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
80005408:	02c12083          	lw	ra,44(sp)
8000540c:	02812403          	lw	s0,40(sp)
80005410:	02412483          	lw	s1,36(sp)
80005414:	02012903          	lw	s2,32(sp)
80005418:	01812a03          	lw	s4,24(sp)
8000541c:	00098513          	mv	a0,s3
80005420:	01c12983          	lw	s3,28(sp)
80005424:	03010113          	addi	sp,sp,48
80005428:	00008067          	ret
8000542c:	00000993          	li	s3,0
80005430:	fcdff06f          	j	800053fc <rt_completion_wait+0x130>

80005434 <rt_completion_done>:
80005434:	ff010113          	addi	sp,sp,-16
80005438:	00812423          	sw	s0,8(sp)
8000543c:	00112623          	sw	ra,12(sp)
80005440:	00912223          	sw	s1,4(sp)
80005444:	01212023          	sw	s2,0(sp)
80005448:	00050413          	mv	s0,a0
8000544c:	00051e63          	bnez	a0,80005468 <rt_completion_done+0x34>
80005450:	06400613          	li	a2,100
80005454:	00008597          	auipc	a1,0x8
80005458:	12858593          	addi	a1,a1,296 # 8000d57c <__FUNCTION__.3440>
8000545c:	00008517          	auipc	a0,0x8
80005460:	0b050513          	addi	a0,a0,176 # 8000d50c <__FUNCTION__.3539+0x14>
80005464:	d89fc0ef          	jal	ra,800021ec <rt_assert_handler>
80005468:	00042783          	lw	a5,0(s0)
8000546c:	00100913          	li	s2,1
80005470:	05278e63          	beq	a5,s2,800054cc <rt_completion_done+0x98>
80005474:	d4dfe0ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
80005478:	00442783          	lw	a5,4(s0)
8000547c:	01242023          	sw	s2,0(s0)
80005480:	00440413          	addi	s0,s0,4
80005484:	00050493          	mv	s1,a0
80005488:	02878663          	beq	a5,s0,800054b4 <rt_completion_done+0x80>
8000548c:	fe078513          	addi	a0,a5,-32
80005490:	a30fe0ef          	jal	ra,800036c0 <rt_thread_resume>
80005494:	00048513          	mv	a0,s1
80005498:	d31fe0ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
8000549c:	00812403          	lw	s0,8(sp)
800054a0:	00c12083          	lw	ra,12(sp)
800054a4:	00412483          	lw	s1,4(sp)
800054a8:	00012903          	lw	s2,0(sp)
800054ac:	01010113          	addi	sp,sp,16
800054b0:	a39fd06f          	j	80002ee8 <rt_schedule>
800054b4:	00812403          	lw	s0,8(sp)
800054b8:	00c12083          	lw	ra,12(sp)
800054bc:	00412483          	lw	s1,4(sp)
800054c0:	00012903          	lw	s2,0(sp)
800054c4:	01010113          	addi	sp,sp,16
800054c8:	d01fe06f          	j	800041c8 <rt_hw_interrupt_enable>
800054cc:	00c12083          	lw	ra,12(sp)
800054d0:	00812403          	lw	s0,8(sp)
800054d4:	00412483          	lw	s1,4(sp)
800054d8:	00012903          	lw	s2,0(sp)
800054dc:	01010113          	addi	sp,sp,16
800054e0:	00008067          	ret

800054e4 <rt_list_remove>:
800054e4:	00052703          	lw	a4,0(a0)
800054e8:	00452783          	lw	a5,4(a0)
800054ec:	00f72223          	sw	a5,4(a4)
800054f0:	00e7a023          	sw	a4,0(a5)
800054f4:	00a52223          	sw	a0,4(a0)
800054f8:	00a52023          	sw	a0,0(a0)
800054fc:	00008067          	ret

80005500 <_workqueue_thread_entry>:
80005500:	fe010113          	addi	sp,sp,-32
80005504:	00812c23          	sw	s0,24(sp)
80005508:	00112e23          	sw	ra,28(sp)
8000550c:	00912a23          	sw	s1,20(sp)
80005510:	01212823          	sw	s2,16(sp)
80005514:	01312623          	sw	s3,12(sp)
80005518:	01412423          	sw	s4,8(sp)
8000551c:	00050413          	mv	s0,a0
80005520:	00051e63          	bnez	a0,8000553c <_workqueue_thread_entry+0x3c>
80005524:	03900613          	li	a2,57
80005528:	00008597          	auipc	a1,0x8
8000552c:	09058593          	addi	a1,a1,144 # 8000d5b8 <__FUNCTION__.3435>
80005530:	00008517          	auipc	a0,0x8
80005534:	06050513          	addi	a0,a0,96 # 8000d590 <__FUNCTION__.3440+0x14>
80005538:	cb5fc0ef          	jal	ra,800021ec <rt_assert_handler>
8000553c:	00c40993          	addi	s3,s0,12
80005540:	ffe00a13          	li	s4,-2
80005544:	00042783          	lw	a5,0(s0)
80005548:	00f41863          	bne	s0,a5,80005558 <_workqueue_thread_entry+0x58>
8000554c:	ee5fd0ef          	jal	ra,80003430 <rt_thread_self>
80005550:	f95fd0ef          	jal	ra,800034e4 <rt_thread_suspend>
80005554:	995fd0ef          	jal	ra,80002ee8 <rt_schedule>
80005558:	c69fe0ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
8000555c:	00042483          	lw	s1,0(s0)
80005560:	00050913          	mv	s2,a0
80005564:	00048513          	mv	a0,s1
80005568:	f7dff0ef          	jal	ra,800054e4 <rt_list_remove>
8000556c:	0104d783          	lhu	a5,16(s1)
80005570:	00942423          	sw	s1,8(s0)
80005574:	00090513          	mv	a0,s2
80005578:	ffe7f793          	andi	a5,a5,-2
8000557c:	00f49823          	sh	a5,16(s1)
80005580:	0404a623          	sw	zero,76(s1)
80005584:	c45fe0ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
80005588:	0084a783          	lw	a5,8(s1)
8000558c:	00c4a583          	lw	a1,12(s1)
80005590:	00048513          	mv	a0,s1
80005594:	000780e7          	jalr	a5
80005598:	c29fe0ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
8000559c:	00042423          	sw	zero,8(s0)
800055a0:	c29fe0ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
800055a4:	ae5fd0ef          	jal	ra,80003088 <rt_enter_critical>
800055a8:	00098513          	mv	a0,s3
800055ac:	f6dfb0ef          	jal	ra,80001518 <rt_sem_trytake>
800055b0:	01451863          	bne	a0,s4,800055c0 <_workqueue_thread_entry+0xc0>
800055b4:	00098513          	mv	a0,s3
800055b8:	f69fb0ef          	jal	ra,80001520 <rt_sem_release>
800055bc:	fedff06f          	j	800055a8 <_workqueue_thread_entry+0xa8>
800055c0:	af1fd0ef          	jal	ra,800030b0 <rt_exit_critical>
800055c4:	f81ff06f          	j	80005544 <_workqueue_thread_entry+0x44>

800055c8 <rt_workqueue_create>:
800055c8:	fe010113          	addi	sp,sp,-32
800055cc:	00912a23          	sw	s1,20(sp)
800055d0:	00050493          	mv	s1,a0
800055d4:	03c00513          	li	a0,60
800055d8:	00812c23          	sw	s0,24(sp)
800055dc:	01212823          	sw	s2,16(sp)
800055e0:	01312623          	sw	s3,12(sp)
800055e4:	00112e23          	sw	ra,28(sp)
800055e8:	00058913          	mv	s2,a1
800055ec:	00060993          	mv	s3,a2
800055f0:	ee9fc0ef          	jal	ra,800024d8 <rt_malloc>
800055f4:	00050413          	mv	s0,a0
800055f8:	04050e63          	beqz	a0,80005654 <rt_workqueue_create+0x8c>
800055fc:	00a42223          	sw	a0,4(s0)
80005600:	00a42023          	sw	a0,0(s0)
80005604:	00052423          	sw	zero,8(a0)
80005608:	00000693          	li	a3,0
8000560c:	00000613          	li	a2,0
80005610:	00008597          	auipc	a1,0x8
80005614:	f9458593          	addi	a1,a1,-108 # 8000d5a4 <__FUNCTION__.3440+0x28>
80005618:	00c50513          	addi	a0,a0,12
8000561c:	c9dfb0ef          	jal	ra,800012b8 <rt_sem_init>
80005620:	00a00793          	li	a5,10
80005624:	00098713          	mv	a4,s3
80005628:	00090693          	mv	a3,s2
8000562c:	00040613          	mv	a2,s0
80005630:	00000597          	auipc	a1,0x0
80005634:	ed058593          	addi	a1,a1,-304 # 80005500 <_workqueue_thread_entry>
80005638:	00048513          	mv	a0,s1
8000563c:	dfdfd0ef          	jal	ra,80003438 <rt_thread_create>
80005640:	02a42c23          	sw	a0,56(s0)
80005644:	02051863          	bnez	a0,80005674 <rt_workqueue_create+0xac>
80005648:	00040513          	mv	a0,s0
8000564c:	938fd0ef          	jal	ra,80002784 <rt_free>
80005650:	00000413          	li	s0,0
80005654:	01c12083          	lw	ra,28(sp)
80005658:	00040513          	mv	a0,s0
8000565c:	01812403          	lw	s0,24(sp)
80005660:	01412483          	lw	s1,20(sp)
80005664:	01012903          	lw	s2,16(sp)
80005668:	00c12983          	lw	s3,12(sp)
8000566c:	02010113          	addi	sp,sp,32
80005670:	00008067          	ret
80005674:	920fe0ef          	jal	ra,80003794 <rt_thread_startup>
80005678:	fddff06f          	j	80005654 <rt_workqueue_create+0x8c>

8000567c <rt_work_sys_workqueue_init>:
8000567c:	ff010113          	addi	sp,sp,-16
80005680:	00812423          	sw	s0,8(sp)
80005684:	8cc18413          	addi	s0,gp,-1844 # 8002032c <sys_workq>
80005688:	00042783          	lw	a5,0(s0)
8000568c:	00112623          	sw	ra,12(sp)
80005690:	02079063          	bnez	a5,800056b0 <rt_work_sys_workqueue_init+0x34>
80005694:	000015b7          	lui	a1,0x1
80005698:	01700613          	li	a2,23
8000569c:	80058593          	addi	a1,a1,-2048 # 800 <__HEAP_SIZE-0x1800>
800056a0:	00008517          	auipc	a0,0x8
800056a4:	f0c50513          	addi	a0,a0,-244 # 8000d5ac <__FUNCTION__.3440+0x30>
800056a8:	f21ff0ef          	jal	ra,800055c8 <rt_workqueue_create>
800056ac:	00a42023          	sw	a0,0(s0)
800056b0:	00c12083          	lw	ra,12(sp)
800056b4:	00812403          	lw	s0,8(sp)
800056b8:	00000513          	li	a0,0
800056bc:	01010113          	addi	sp,sp,16
800056c0:	00008067          	ret

800056c4 <finsh_rx_ind>:
800056c4:	8e418793          	addi	a5,gp,-1820 # 80020344 <shell>
800056c8:	0007a703          	lw	a4,0(a5)
800056cc:	ff010113          	addi	sp,sp,-16
800056d0:	00812423          	sw	s0,8(sp)
800056d4:	00112623          	sw	ra,12(sp)
800056d8:	00078413          	mv	s0,a5
800056dc:	00071e63          	bnez	a4,800056f8 <finsh_rx_ind+0x34>
800056e0:	0bf00613          	li	a2,191
800056e4:	00008597          	auipc	a1,0x8
800056e8:	fec58593          	addi	a1,a1,-20 # 8000d6d0 <__FUNCTION__.4626>
800056ec:	00008517          	auipc	a0,0x8
800056f0:	f0050513          	addi	a0,a0,-256 # 8000d5ec <__rti_rt_work_sys_workqueue_init_name+0x1c>
800056f4:	af9fc0ef          	jal	ra,800021ec <rt_assert_handler>
800056f8:	00042503          	lw	a0,0(s0)
800056fc:	e25fb0ef          	jal	ra,80001520 <rt_sem_release>
80005700:	00c12083          	lw	ra,12(sp)
80005704:	00812403          	lw	s0,8(sp)
80005708:	00000513          	li	a0,0
8000570c:	01010113          	addi	sp,sp,16
80005710:	00008067          	ret

80005714 <finsh_get_prompt>:
80005714:	8e41a783          	lw	a5,-1820(gp) # 80020344 <shell>
80005718:	0307c783          	lbu	a5,48(a5)
8000571c:	0027f793          	andi	a5,a5,2
80005720:	00079863          	bnez	a5,80005730 <finsh_get_prompt+0x1c>
80005724:	0a018423          	sb	zero,168(gp) # 80020b08 <finsh_prompt.4605>
80005728:	0a818513          	addi	a0,gp,168 # 80020b08 <finsh_prompt.4605>
8000572c:	00008067          	ret
80005730:	ff010113          	addi	sp,sp,-16
80005734:	00112623          	sw	ra,12(sp)
80005738:	8e01a583          	lw	a1,-1824(gp) # 80020340 <finsh_prompt_custom>
8000573c:	02058063          	beqz	a1,8000575c <finsh_get_prompt+0x48>
80005740:	08000613          	li	a2,128
80005744:	0a818513          	addi	a0,gp,168 # 80020b08 <finsh_prompt.4605>
80005748:	13d060ef          	jal	ra,8000c084 <strncpy>
8000574c:	00c12083          	lw	ra,12(sp)
80005750:	0a818513          	addi	a0,gp,168 # 80020b08 <finsh_prompt.4605>
80005754:	01010113          	addi	sp,sp,16
80005758:	00008067          	ret
8000575c:	6cd010ef          	jal	ra,80007628 <msh_is_used>
80005760:	00008597          	auipc	a1,0x8
80005764:	ea058593          	addi	a1,a1,-352 # 8000d600 <__rti_rt_work_sys_workqueue_init_name+0x30>
80005768:	00051663          	bnez	a0,80005774 <finsh_get_prompt+0x60>
8000576c:	00008597          	auipc	a1,0x8
80005770:	e9c58593          	addi	a1,a1,-356 # 8000d608 <__rti_rt_work_sys_workqueue_init_name+0x38>
80005774:	0a818513          	addi	a0,gp,168 # 80020b08 <finsh_prompt.4605>
80005778:	099060ef          	jal	ra,8000c010 <strcpy>
8000577c:	00008597          	auipc	a1,0x8
80005780:	e9458593          	addi	a1,a1,-364 # 8000d610 <__rti_rt_work_sys_workqueue_init_name+0x40>
80005784:	0a818513          	addi	a0,gp,168 # 80020b08 <finsh_prompt.4605>
80005788:	6e0060ef          	jal	ra,8000be68 <strcat>
8000578c:	fc1ff06f          	j	8000574c <finsh_get_prompt+0x38>

80005790 <shell_handle_history>:
80005790:	ff010113          	addi	sp,sp,-16
80005794:	00812423          	sw	s0,8(sp)
80005798:	00050413          	mv	s0,a0
8000579c:	00008517          	auipc	a0,0x8
800057a0:	e7850513          	addi	a0,a0,-392 # 8000d614 <__rti_rt_work_sys_workqueue_init_name+0x44>
800057a4:	00112623          	sw	ra,12(sp)
800057a8:	8c5fc0ef          	jal	ra,8000206c <rt_kprintf>
800057ac:	f69ff0ef          	jal	ra,80005714 <finsh_get_prompt>
800057b0:	00050593          	mv	a1,a0
800057b4:	26440613          	addi	a2,s0,612
800057b8:	00008517          	auipc	a0,0x8
800057bc:	e6450513          	addi	a0,a0,-412 # 8000d61c <__rti_rt_work_sys_workqueue_init_name+0x4c>
800057c0:	8adfc0ef          	jal	ra,8000206c <rt_kprintf>
800057c4:	00c12083          	lw	ra,12(sp)
800057c8:	00812403          	lw	s0,8(sp)
800057cc:	00000513          	li	a0,0
800057d0:	01010113          	addi	sp,sp,16
800057d4:	00008067          	ret

800057d8 <finsh_set_prompt_mode>:
800057d8:	8e418793          	addi	a5,gp,-1820 # 80020344 <shell>
800057dc:	0007a703          	lw	a4,0(a5)
800057e0:	ff010113          	addi	sp,sp,-16
800057e4:	00812423          	sw	s0,8(sp)
800057e8:	00912223          	sw	s1,4(sp)
800057ec:	00112623          	sw	ra,12(sp)
800057f0:	00050413          	mv	s0,a0
800057f4:	00078493          	mv	s1,a5
800057f8:	00071e63          	bnez	a4,80005814 <finsh_set_prompt_mode+0x3c>
800057fc:	0a300613          	li	a2,163
80005800:	00008597          	auipc	a1,0x8
80005804:	ea858593          	addi	a1,a1,-344 # 8000d6a8 <__FUNCTION__.4613>
80005808:	00008517          	auipc	a0,0x8
8000580c:	de450513          	addi	a0,a0,-540 # 8000d5ec <__rti_rt_work_sys_workqueue_init_name+0x1c>
80005810:	9ddfc0ef          	jal	ra,800021ec <rt_assert_handler>
80005814:	0004a703          	lw	a4,0(s1)
80005818:	00147413          	andi	s0,s0,1
8000581c:	00141413          	slli	s0,s0,0x1
80005820:	03074783          	lbu	a5,48(a4)
80005824:	00c12083          	lw	ra,12(sp)
80005828:	00412483          	lw	s1,4(sp)
8000582c:	ffd7f793          	andi	a5,a5,-3
80005830:	0087e433          	or	s0,a5,s0
80005834:	02870823          	sb	s0,48(a4)
80005838:	00812403          	lw	s0,8(sp)
8000583c:	01010113          	addi	sp,sp,16
80005840:	00008067          	ret

80005844 <finsh_system_init>:
80005844:	00009797          	auipc	a5,0x9
80005848:	0e478793          	addi	a5,a5,228 # 8000e928 <__fsym___cmd_testapp>
8000584c:	8cf1a823          	sw	a5,-1840(gp) # 80020330 <_syscall_table_begin>
80005850:	00009797          	auipc	a5,0x9
80005854:	27c78793          	addi	a5,a5,636 # 8000eacc <__vsym_dummy>
80005858:	8cf1aa23          	sw	a5,-1836(gp) # 80020334 <_syscall_table_end>
8000585c:	00009797          	auipc	a5,0x9
80005860:	27078793          	addi	a5,a5,624 # 8000eacc <__vsym_dummy>
80005864:	ff010113          	addi	sp,sp,-16
80005868:	8cf1ac23          	sw	a5,-1832(gp) # 80020338 <_sysvar_table_begin>
8000586c:	2c000593          	li	a1,704
80005870:	00009797          	auipc	a5,0x9
80005874:	26c78793          	addi	a5,a5,620 # 8000eadc <__vsymtab_end>
80005878:	00100513          	li	a0,1
8000587c:	00912223          	sw	s1,4(sp)
80005880:	00112623          	sw	ra,12(sp)
80005884:	00812423          	sw	s0,8(sp)
80005888:	8cf1ae23          	sw	a5,-1828(gp) # 8002033c <_sysvar_table_end>
8000588c:	8e418493          	addi	s1,gp,-1820 # 80020344 <shell>
80005890:	eb1fc0ef          	jal	ra,80002740 <rt_calloc>
80005894:	00a4a023          	sw	a0,0(s1)
80005898:	02051663          	bnez	a0,800058c4 <finsh_system_init+0x80>
8000589c:	00008517          	auipc	a0,0x8
800058a0:	d8850513          	addi	a0,a0,-632 # 8000d624 <__rti_rt_work_sys_workqueue_init_name+0x54>
800058a4:	fc8fc0ef          	jal	ra,8000206c <rt_kprintf>
800058a8:	fff00493          	li	s1,-1
800058ac:	00c12083          	lw	ra,12(sp)
800058b0:	00812403          	lw	s0,8(sp)
800058b4:	00048513          	mv	a0,s1
800058b8:	00412483          	lw	s1,4(sp)
800058bc:	01010113          	addi	sp,sp,16
800058c0:	00008067          	ret
800058c4:	000016b7          	lui	a3,0x1
800058c8:	00a00793          	li	a5,10
800058cc:	01400713          	li	a4,20
800058d0:	80068693          	addi	a3,a3,-2048 # 800 <__HEAP_SIZE-0x1800>
800058d4:	00000613          	li	a2,0
800058d8:	00000597          	auipc	a1,0x0
800058dc:	24458593          	addi	a1,a1,580 # 80005b1c <finsh_thread_entry>
800058e0:	00008517          	auipc	a0,0x8
800058e4:	d5c50513          	addi	a0,a0,-676 # 8000d63c <__rti_rt_work_sys_workqueue_init_name+0x6c>
800058e8:	b51fd0ef          	jal	ra,80003438 <rt_thread_create>
800058ec:	00050413          	mv	s0,a0
800058f0:	0004a503          	lw	a0,0(s1)
800058f4:	00000693          	li	a3,0
800058f8:	00000613          	li	a2,0
800058fc:	00008597          	auipc	a1,0x8
80005900:	d4858593          	addi	a1,a1,-696 # 8000d644 <__rti_rt_work_sys_workqueue_init_name+0x74>
80005904:	9b5fb0ef          	jal	ra,800012b8 <rt_sem_init>
80005908:	00100513          	li	a0,1
8000590c:	ecdff0ef          	jal	ra,800057d8 <finsh_set_prompt_mode>
80005910:	00000493          	li	s1,0
80005914:	f8040ce3          	beqz	s0,800058ac <finsh_system_init+0x68>
80005918:	00040513          	mv	a0,s0
8000591c:	e79fd0ef          	jal	ra,80003794 <rt_thread_startup>
80005920:	f8dff06f          	j	800058ac <finsh_system_init+0x68>

80005924 <finsh_set_device>:
80005924:	ff010113          	addi	sp,sp,-16
80005928:	00812423          	sw	s0,8(sp)
8000592c:	8e418413          	addi	s0,gp,-1820 # 80020344 <shell>
80005930:	00042783          	lw	a5,0(s0)
80005934:	01212023          	sw	s2,0(sp)
80005938:	00112623          	sw	ra,12(sp)
8000593c:	00912223          	sw	s1,4(sp)
80005940:	00050913          	mv	s2,a0
80005944:	00079e63          	bnez	a5,80005960 <finsh_set_device+0x3c>
80005948:	0d200613          	li	a2,210
8000594c:	00008597          	auipc	a1,0x8
80005950:	d9458593          	addi	a1,a1,-620 # 8000d6e0 <__FUNCTION__.4631>
80005954:	00008517          	auipc	a0,0x8
80005958:	c9850513          	addi	a0,a0,-872 # 8000d5ec <__rti_rt_work_sys_workqueue_init_name+0x1c>
8000595c:	891fc0ef          	jal	ra,800021ec <rt_assert_handler>
80005960:	00090513          	mv	a0,s2
80005964:	930fb0ef          	jal	ra,80000a94 <rt_device_find>
80005968:	00050493          	mv	s1,a0
8000596c:	02051463          	bnez	a0,80005994 <finsh_set_device+0x70>
80005970:	00812403          	lw	s0,8(sp)
80005974:	00c12083          	lw	ra,12(sp)
80005978:	00412483          	lw	s1,4(sp)
8000597c:	00090593          	mv	a1,s2
80005980:	00012903          	lw	s2,0(sp)
80005984:	00008517          	auipc	a0,0x8
80005988:	cc850513          	addi	a0,a0,-824 # 8000d64c <__rti_rt_work_sys_workqueue_init_name+0x7c>
8000598c:	01010113          	addi	sp,sp,16
80005990:	edcfc06f          	j	8000206c <rt_kprintf>
80005994:	00042783          	lw	a5,0(s0)
80005998:	2bc7a783          	lw	a5,700(a5)
8000599c:	06a78a63          	beq	a5,a0,80005a10 <finsh_set_device+0xec>
800059a0:	14300593          	li	a1,323
800059a4:	a28fb0ef          	jal	ra,80000bcc <rt_device_open>
800059a8:	06051463          	bnez	a0,80005a10 <finsh_set_device+0xec>
800059ac:	00042783          	lw	a5,0(s0)
800059b0:	2bc7a503          	lw	a0,700(a5)
800059b4:	00050c63          	beqz	a0,800059cc <finsh_set_device+0xa8>
800059b8:	b6cfb0ef          	jal	ra,80000d24 <rt_device_close>
800059bc:	00042783          	lw	a5,0(s0)
800059c0:	00000593          	li	a1,0
800059c4:	2bc7a503          	lw	a0,700(a5)
800059c8:	db0fb0ef          	jal	ra,80000f78 <rt_device_set_rx_indicate>
800059cc:	00042403          	lw	s0,0(s0)
800059d0:	00000593          	li	a1,0
800059d4:	05100613          	li	a2,81
800059d8:	26440513          	addi	a0,s0,612
800059dc:	3b0060ef          	jal	ra,8000bd8c <memset>
800059e0:	2a942e23          	sw	s1,700(s0)
800059e4:	2a041b23          	sh	zero,694(s0)
800059e8:	2a041c23          	sh	zero,696(s0)
800059ec:	00812403          	lw	s0,8(sp)
800059f0:	00c12083          	lw	ra,12(sp)
800059f4:	00012903          	lw	s2,0(sp)
800059f8:	00048513          	mv	a0,s1
800059fc:	00412483          	lw	s1,4(sp)
80005a00:	00000597          	auipc	a1,0x0
80005a04:	cc458593          	addi	a1,a1,-828 # 800056c4 <finsh_rx_ind>
80005a08:	01010113          	addi	sp,sp,16
80005a0c:	d6cfb06f          	j	80000f78 <rt_device_set_rx_indicate>
80005a10:	00c12083          	lw	ra,12(sp)
80005a14:	00812403          	lw	s0,8(sp)
80005a18:	00412483          	lw	s1,4(sp)
80005a1c:	00012903          	lw	s2,0(sp)
80005a20:	01010113          	addi	sp,sp,16
80005a24:	00008067          	ret

80005a28 <finsh_run_line>:
80005a28:	8e41a783          	lw	a5,-1820(gp) # 80020344 <shell>
80005a2c:	0307c783          	lbu	a5,48(a5)
80005a30:	fe010113          	addi	sp,sp,-32
80005a34:	00812c23          	sw	s0,24(sp)
80005a38:	00112e23          	sw	ra,28(sp)
80005a3c:	00912a23          	sw	s1,20(sp)
80005a40:	0017f793          	andi	a5,a5,1
80005a44:	00050413          	mv	s0,a0
80005a48:	00078c63          	beqz	a5,80005a60 <finsh_run_line+0x38>
80005a4c:	00008517          	auipc	a0,0x8
80005a50:	ccc50513          	addi	a0,a0,-820 # 8000d718 <__rti_finsh_system_init_name+0x24>
80005a54:	00b12623          	sw	a1,12(sp)
80005a58:	e14fc0ef          	jal	ra,8000206c <rt_kprintf>
80005a5c:	00c12583          	lw	a1,12(sp)
80005a60:	00040513          	mv	a0,s0
80005a64:	490050ef          	jal	ra,8000aef4 <finsh_parser_run>
80005a68:	648030ef          	jal	ra,800090b0 <finsh_errno>
80005a6c:	06051863          	bnez	a0,80005adc <finsh_run_line+0xb4>
80005a70:	09842503          	lw	a0,152(s0)
80005a74:	574030ef          	jal	ra,80008fe8 <finsh_compiler_run>
80005a78:	638030ef          	jal	ra,800090b0 <finsh_errno>
80005a7c:	04051463          	bnez	a0,80005ac4 <finsh_run_line+0x9c>
80005a80:	780050ef          	jal	ra,8000b200 <finsh_vm_run>
80005a84:	159030ef          	jal	ra,800093dc <finsh_stack_bottom>
80005a88:	fdf50513          	addi	a0,a0,-33
80005a8c:	0ff57513          	andi	a0,a0,255
80005a90:	05c00793          	li	a5,92
80005a94:	06a7e263          	bltu	a5,a0,80005af8 <finsh_run_line+0xd0>
80005a98:	145030ef          	jal	ra,800093dc <finsh_stack_bottom>
80005a9c:	00050493          	mv	s1,a0
80005aa0:	13d030ef          	jal	ra,800093dc <finsh_stack_bottom>
80005aa4:	00a12623          	sw	a0,12(sp)
80005aa8:	135030ef          	jal	ra,800093dc <finsh_stack_bottom>
80005aac:	00c12603          	lw	a2,12(sp)
80005ab0:	00050693          	mv	a3,a0
80005ab4:	0ff4f593          	andi	a1,s1,255
80005ab8:	00008517          	auipc	a0,0x8
80005abc:	bb450513          	addi	a0,a0,-1100 # 8000d66c <__rti_rt_work_sys_workqueue_init_name+0x9c>
80005ac0:	dacfc0ef          	jal	ra,8000206c <rt_kprintf>
80005ac4:	00040513          	mv	a0,s0
80005ac8:	01812403          	lw	s0,24(sp)
80005acc:	01c12083          	lw	ra,28(sp)
80005ad0:	01412483          	lw	s1,20(sp)
80005ad4:	02010113          	addi	sp,sp,32
80005ad8:	10d0306f          	j	800093e4 <finsh_flush>
80005adc:	5d4030ef          	jal	ra,800090b0 <finsh_errno>
80005ae0:	5d8030ef          	jal	ra,800090b8 <finsh_error_string>
80005ae4:	00050593          	mv	a1,a0
80005ae8:	00008517          	auipc	a0,0x8
80005aec:	70050513          	addi	a0,a0,1792 # 8000e1e8 <__fsym_hello_name+0x34>
80005af0:	d7cfc0ef          	jal	ra,8000206c <rt_kprintf>
80005af4:	f85ff06f          	j	80005a78 <finsh_run_line+0x50>
80005af8:	0e5030ef          	jal	ra,800093dc <finsh_stack_bottom>
80005afc:	00a12623          	sw	a0,12(sp)
80005b00:	0dd030ef          	jal	ra,800093dc <finsh_stack_bottom>
80005b04:	00c12583          	lw	a1,12(sp)
80005b08:	00050613          	mv	a2,a0
80005b0c:	00008517          	auipc	a0,0x8
80005b10:	b7450513          	addi	a0,a0,-1164 # 8000d680 <__rti_rt_work_sys_workqueue_init_name+0xb0>
80005b14:	d58fc0ef          	jal	ra,8000206c <rt_kprintf>
80005b18:	fadff06f          	j	80005ac4 <finsh_run_line+0x9c>

80005b1c <finsh_thread_entry>:
80005b1c:	fb010113          	addi	sp,sp,-80
80005b20:	04912223          	sw	s1,68(sp)
80005b24:	8e418493          	addi	s1,gp,-1820 # 80020344 <shell>
80005b28:	0004a503          	lw	a0,0(s1)
80005b2c:	04112623          	sw	ra,76(sp)
80005b30:	04812423          	sw	s0,72(sp)
80005b34:	03054783          	lbu	a5,48(a0)
80005b38:	05212023          	sw	s2,64(sp)
80005b3c:	03312e23          	sw	s3,60(sp)
80005b40:	0017e793          	ori	a5,a5,1
80005b44:	03412c23          	sw	s4,56(sp)
80005b48:	03512a23          	sw	s5,52(sp)
80005b4c:	03612823          	sw	s6,48(sp)
80005b50:	03712623          	sw	s7,44(sp)
80005b54:	03812423          	sw	s8,40(sp)
80005b58:	03912223          	sw	s9,36(sp)
80005b5c:	03a12023          	sw	s10,32(sp)
80005b60:	01b12e23          	sw	s11,28(sp)
80005b64:	02f50823          	sb	a5,48(a0)
80005b68:	1c850513          	addi	a0,a0,456
80005b6c:	045030ef          	jal	ra,800093b0 <finsh_init>
80005b70:	0004a783          	lw	a5,0(s1)
80005b74:	2bc7a783          	lw	a5,700(a5)
80005b78:	00079863          	bnez	a5,80005b88 <finsh_thread_entry+0x6c>
80005b7c:	c7cfc0ef          	jal	ra,80001ff8 <rt_console_get_device>
80005b80:	00050463          	beqz	a0,80005b88 <finsh_thread_entry+0x6c>
80005b84:	da1ff0ef          	jal	ra,80005924 <finsh_set_device>
80005b88:	b8dff0ef          	jal	ra,80005714 <finsh_get_prompt>
80005b8c:	ce0fc0ef          	jal	ra,8000206c <rt_kprintf>
80005b90:	00008a97          	auipc	s5,0x8
80005b94:	b30a8a93          	addi	s5,s5,-1232 # 8000d6c0 <__FUNCTION__.4618>
80005b98:	00008b17          	auipc	s6,0x8
80005b9c:	a54b0b13          	addi	s6,s6,-1452 # 8000d5ec <__rti_rt_work_sys_workqueue_init_name+0x1c>
80005ba0:	01b00a13          	li	s4,27
80005ba4:	0fd00b93          	li	s7,253
80005ba8:	00900c13          	li	s8,9
80005bac:	07f00c93          	li	s9,127
80005bb0:	00008997          	auipc	s3,0x8
80005bb4:	ae098993          	addi	s3,s3,-1312 # 8000d690 <__rti_rt_work_sys_workqueue_init_name+0xc0>
80005bb8:	0004a783          	lw	a5,0(s1)
80005bbc:	000107a3          	sb	zero,15(sp)
80005bc0:	00079a63          	bnez	a5,80005bd4 <finsh_thread_entry+0xb8>
80005bc4:	0af00613          	li	a2,175
80005bc8:	000a8593          	mv	a1,s5
80005bcc:	000b0513          	mv	a0,s6
80005bd0:	e1cfc0ef          	jal	ra,800021ec <rt_assert_handler>
80005bd4:	0004a783          	lw	a5,0(s1)
80005bd8:	00100693          	li	a3,1
80005bdc:	00f10613          	addi	a2,sp,15
80005be0:	2bc7a503          	lw	a0,700(a5)
80005be4:	fff00593          	li	a1,-1
80005be8:	9e8fb0ef          	jal	ra,80000dd0 <rt_device_read>
80005bec:	00100793          	li	a5,1
80005bf0:	0004a403          	lw	s0,0(s1)
80005bf4:	00f51a63          	bne	a0,a5,80005c08 <finsh_thread_entry+0xec>
80005bf8:	00f14903          	lbu	s2,15(sp)
80005bfc:	01491e63          	bne	s2,s4,80005c18 <finsh_thread_entry+0xfc>
80005c00:	02a42623          	sw	a0,44(s0)
80005c04:	fb5ff06f          	j	80005bb8 <finsh_thread_entry+0x9c>
80005c08:	fff00593          	li	a1,-1
80005c0c:	00040513          	mv	a0,s0
80005c10:	f50fb0ef          	jal	ra,80001360 <rt_sem_take>
80005c14:	fc1ff06f          	j	80005bd4 <finsh_thread_entry+0xb8>
80005c18:	02c42783          	lw	a5,44(s0)
80005c1c:	02a79a63          	bne	a5,a0,80005c50 <finsh_thread_entry+0x134>
80005c20:	05b00793          	li	a5,91
80005c24:	00f91863          	bne	s2,a5,80005c34 <finsh_thread_entry+0x118>
80005c28:	00200793          	li	a5,2
80005c2c:	02f42623          	sw	a5,44(s0)
80005c30:	f89ff06f          	j	80005bb8 <finsh_thread_entry+0x9c>
80005c34:	02042623          	sw	zero,44(s0)
80005c38:	fff90793          	addi	a5,s2,-1
80005c3c:	0ff7f793          	andi	a5,a5,255
80005c40:	f6fbece3          	bltu	s7,a5,80005bb8 <finsh_thread_entry+0x9c>
80005c44:	19891a63          	bne	s2,s8,80005dd8 <finsh_thread_entry+0x2bc>
80005c48:	00000913          	li	s2,0
80005c4c:	1180006f          	j	80005d64 <finsh_thread_entry+0x248>
80005c50:	00200713          	li	a4,2
80005c54:	fee792e3          	bne	a5,a4,80005c38 <finsh_thread_entry+0x11c>
80005c58:	02042623          	sw	zero,44(s0)
80005c5c:	04100793          	li	a5,65
80005c60:	04f91e63          	bne	s2,a5,80005cbc <finsh_thread_entry+0x1a0>
80005c64:	03245583          	lhu	a1,50(s0)
80005c68:	f40588e3          	beqz	a1,80005bb8 <finsh_thread_entry+0x9c>
80005c6c:	fff58593          	addi	a1,a1,-1
80005c70:	01059593          	slli	a1,a1,0x10
80005c74:	0105d593          	srli	a1,a1,0x10
80005c78:	02b41923          	sh	a1,50(s0)
80005c7c:	26440793          	addi	a5,s0,612
80005c80:	05000713          	li	a4,80
80005c84:	02e585b3          	mul	a1,a1,a4
80005c88:	05000613          	li	a2,80
80005c8c:	00078513          	mv	a0,a5
80005c90:	03658593          	addi	a1,a1,54
80005c94:	00b405b3          	add	a1,s0,a1
80005c98:	7f1050ef          	jal	ra,8000bc88 <memcpy>
80005c9c:	390060ef          	jal	ra,8000c02c <strlen>
80005ca0:	01051513          	slli	a0,a0,0x10
80005ca4:	01055513          	srli	a0,a0,0x10
80005ca8:	2aa41b23          	sh	a0,694(s0)
80005cac:	2aa41c23          	sh	a0,696(s0)
80005cb0:	00040513          	mv	a0,s0
80005cb4:	addff0ef          	jal	ra,80005790 <shell_handle_history>
80005cb8:	f01ff06f          	j	80005bb8 <finsh_thread_entry+0x9c>
80005cbc:	04200793          	li	a5,66
80005cc0:	02f91a63          	bne	s2,a5,80005cf4 <finsh_thread_entry+0x1d8>
80005cc4:	03445683          	lhu	a3,52(s0)
80005cc8:	03245783          	lhu	a5,50(s0)
80005ccc:	fff68713          	addi	a4,a3,-1
80005cd0:	00e7dc63          	bge	a5,a4,80005ce8 <finsh_thread_entry+0x1cc>
80005cd4:	00178793          	addi	a5,a5,1
80005cd8:	02f41923          	sh	a5,50(s0)
80005cdc:	03245583          	lhu	a1,50(s0)
80005ce0:	26440793          	addi	a5,s0,612
80005ce4:	f9dff06f          	j	80005c80 <finsh_thread_entry+0x164>
80005ce8:	ec0688e3          	beqz	a3,80005bb8 <finsh_thread_entry+0x9c>
80005cec:	02e41923          	sh	a4,50(s0)
80005cf0:	fedff06f          	j	80005cdc <finsh_thread_entry+0x1c0>
80005cf4:	04400793          	li	a5,68
80005cf8:	02f91463          	bne	s2,a5,80005d20 <finsh_thread_entry+0x204>
80005cfc:	2b845783          	lhu	a5,696(s0)
80005d00:	ea078ce3          	beqz	a5,80005bb8 <finsh_thread_entry+0x9c>
80005d04:	00098513          	mv	a0,s3
80005d08:	b64fc0ef          	jal	ra,8000206c <rt_kprintf>
80005d0c:	0004a703          	lw	a4,0(s1)
80005d10:	2b875783          	lhu	a5,696(a4)
80005d14:	fff78793          	addi	a5,a5,-1
80005d18:	2af71c23          	sh	a5,696(a4)
80005d1c:	e9dff06f          	j	80005bb8 <finsh_thread_entry+0x9c>
80005d20:	04300793          	li	a5,67
80005d24:	f0f91ae3          	bne	s2,a5,80005c38 <finsh_thread_entry+0x11c>
80005d28:	2b845783          	lhu	a5,696(s0)
80005d2c:	2b645703          	lhu	a4,694(s0)
80005d30:	e8e7f4e3          	bgeu	a5,a4,80005bb8 <finsh_thread_entry+0x9c>
80005d34:	00f40433          	add	s0,s0,a5
80005d38:	26444583          	lbu	a1,612(s0)
80005d3c:	00008517          	auipc	a0,0x8
80005d40:	95850513          	addi	a0,a0,-1704 # 8000d694 <__rti_rt_work_sys_workqueue_init_name+0xc4>
80005d44:	b28fc0ef          	jal	ra,8000206c <rt_kprintf>
80005d48:	0004a703          	lw	a4,0(s1)
80005d4c:	2b875783          	lhu	a5,696(a4)
80005d50:	00178793          	addi	a5,a5,1
80005d54:	fc5ff06f          	j	80005d18 <finsh_thread_entry+0x1fc>
80005d58:	00098513          	mv	a0,s3
80005d5c:	b10fc0ef          	jal	ra,8000206c <rt_kprintf>
80005d60:	00190913          	addi	s2,s2,1
80005d64:	0004a403          	lw	s0,0(s1)
80005d68:	2b845783          	lhu	a5,696(s0)
80005d6c:	fef946e3          	blt	s2,a5,80005d58 <finsh_thread_entry+0x23c>
80005d70:	00008517          	auipc	a0,0x8
80005d74:	9a850513          	addi	a0,a0,-1624 # 8000d718 <__rti_finsh_system_init_name+0x24>
80005d78:	af4fc0ef          	jal	ra,8000206c <rt_kprintf>
80005d7c:	0ad010ef          	jal	ra,80007628 <msh_is_used>
80005d80:	00100793          	li	a5,1
80005d84:	26440413          	addi	s0,s0,612
80005d88:	04f51263          	bne	a0,a5,80005dcc <finsh_thread_entry+0x2b0>
80005d8c:	00040513          	mv	a0,s0
80005d90:	315010ef          	jal	ra,800078a4 <msh_auto_complete>
80005d94:	981ff0ef          	jal	ra,80005714 <finsh_get_prompt>
80005d98:	00050593          	mv	a1,a0
80005d9c:	00040613          	mv	a2,s0
80005da0:	00008517          	auipc	a0,0x8
80005da4:	87c50513          	addi	a0,a0,-1924 # 8000d61c <__rti_rt_work_sys_workqueue_init_name+0x4c>
80005da8:	ac4fc0ef          	jal	ra,8000206c <rt_kprintf>
80005dac:	0004a403          	lw	s0,0(s1)
80005db0:	26440513          	addi	a0,s0,612
80005db4:	278060ef          	jal	ra,8000c02c <strlen>
80005db8:	01051513          	slli	a0,a0,0x10
80005dbc:	01055513          	srli	a0,a0,0x10
80005dc0:	2aa41b23          	sh	a0,694(s0)
80005dc4:	2aa41c23          	sh	a0,696(s0)
80005dc8:	df1ff06f          	j	80005bb8 <finsh_thread_entry+0x9c>
80005dcc:	00040513          	mv	a0,s0
80005dd0:	43c010ef          	jal	ra,8000720c <list_prefix>
80005dd4:	fc1ff06f          	j	80005d94 <finsh_thread_entry+0x278>
80005dd8:	01990663          	beq	s2,s9,80005de4 <finsh_thread_entry+0x2c8>
80005ddc:	00800793          	li	a5,8
80005de0:	0af91c63          	bne	s2,a5,80005e98 <finsh_thread_entry+0x37c>
80005de4:	2b845783          	lhu	a5,696(s0)
80005de8:	dc0788e3          	beqz	a5,80005bb8 <finsh_thread_entry+0x9c>
80005dec:	2b645603          	lhu	a2,694(s0)
80005df0:	fff78793          	addi	a5,a5,-1
80005df4:	01079793          	slli	a5,a5,0x10
80005df8:	fff60613          	addi	a2,a2,-1
80005dfc:	01061613          	slli	a2,a2,0x10
80005e00:	01065613          	srli	a2,a2,0x10
80005e04:	0107d793          	srli	a5,a5,0x10
80005e08:	2ac41b23          	sh	a2,694(s0)
80005e0c:	2af41c23          	sh	a5,696(s0)
80005e10:	06c7f463          	bgeu	a5,a2,80005e78 <finsh_thread_entry+0x35c>
80005e14:	26578593          	addi	a1,a5,613
80005e18:	26478513          	addi	a0,a5,612
80005e1c:	40f60633          	sub	a2,a2,a5
80005e20:	00b405b3          	add	a1,s0,a1
80005e24:	00a40533          	add	a0,s0,a0
80005e28:	ba5fb0ef          	jal	ra,800019cc <rt_memmove>
80005e2c:	0004a783          	lw	a5,0(s1)
80005e30:	00008517          	auipc	a0,0x8
80005e34:	86850513          	addi	a0,a0,-1944 # 8000d698 <__rti_rt_work_sys_workqueue_init_name+0xc8>
80005e38:	2b67d703          	lhu	a4,694(a5)
80005e3c:	00e78733          	add	a4,a5,a4
80005e40:	26070223          	sb	zero,612(a4)
80005e44:	2b87d583          	lhu	a1,696(a5)
80005e48:	26458593          	addi	a1,a1,612
80005e4c:	00b785b3          	add	a1,a5,a1
80005e50:	a1cfc0ef          	jal	ra,8000206c <rt_kprintf>
80005e54:	0004a783          	lw	a5,0(s1)
80005e58:	2b87d403          	lhu	s0,696(a5)
80005e5c:	0004a783          	lw	a5,0(s1)
80005e60:	2b67d783          	lhu	a5,694(a5)
80005e64:	d487cae3          	blt	a5,s0,80005bb8 <finsh_thread_entry+0x9c>
80005e68:	00098513          	mv	a0,s3
80005e6c:	a00fc0ef          	jal	ra,8000206c <rt_kprintf>
80005e70:	00140413          	addi	s0,s0,1
80005e74:	fe9ff06f          	j	80005e5c <finsh_thread_entry+0x340>
80005e78:	00008517          	auipc	a0,0x8
80005e7c:	82850513          	addi	a0,a0,-2008 # 8000d6a0 <__rti_rt_work_sys_workqueue_init_name+0xd0>
80005e80:	9ecfc0ef          	jal	ra,8000206c <rt_kprintf>
80005e84:	0004a783          	lw	a5,0(s1)
80005e88:	2b67d703          	lhu	a4,694(a5)
80005e8c:	00e787b3          	add	a5,a5,a4
80005e90:	26078223          	sb	zero,612(a5)
80005e94:	d25ff06f          	j	80005bb8 <finsh_thread_entry+0x9c>
80005e98:	00d00713          	li	a4,13
80005e9c:	2b645783          	lhu	a5,694(s0)
80005ea0:	00e90663          	beq	s2,a4,80005eac <finsh_thread_entry+0x390>
80005ea4:	00a00713          	li	a4,10
80005ea8:	18e91663          	bne	s2,a4,80006034 <finsh_thread_entry+0x518>
80005eac:	06078863          	beqz	a5,80005f1c <finsh_thread_entry+0x400>
80005eb0:	03445903          	lhu	s2,52(s0)
80005eb4:	00400793          	li	a5,4
80005eb8:	26440d13          	addi	s10,s0,612
80005ebc:	0d27f463          	bgeu	a5,s2,80005f84 <finsh_thread_entry+0x468>
80005ec0:	17640d93          	addi	s11,s0,374
80005ec4:	05000613          	li	a2,80
80005ec8:	000d0593          	mv	a1,s10
80005ecc:	000d8513          	mv	a0,s11
80005ed0:	589050ef          	jal	ra,8000bc58 <memcmp>
80005ed4:	04050463          	beqz	a0,80005f1c <finsh_thread_entry+0x400>
80005ed8:	03640913          	addi	s2,s0,54
80005edc:	00090513          	mv	a0,s2
80005ee0:	05090913          	addi	s2,s2,80
80005ee4:	05000613          	li	a2,80
80005ee8:	00090593          	mv	a1,s2
80005eec:	59d050ef          	jal	ra,8000bc88 <memcpy>
80005ef0:	ff2d96e3          	bne	s11,s2,80005edc <finsh_thread_entry+0x3c0>
80005ef4:	05000613          	li	a2,80
80005ef8:	00000593          	li	a1,0
80005efc:	000d8513          	mv	a0,s11
80005f00:	68d050ef          	jal	ra,8000bd8c <memset>
80005f04:	2b645603          	lhu	a2,694(s0)
80005f08:	000d0593          	mv	a1,s10
80005f0c:	000d8513          	mv	a0,s11
80005f10:	579050ef          	jal	ra,8000bc88 <memcpy>
80005f14:	00500793          	li	a5,5
80005f18:	02f41a23          	sh	a5,52(s0)
80005f1c:	03445783          	lhu	a5,52(s0)
80005f20:	02f41923          	sh	a5,50(s0)
80005f24:	704010ef          	jal	ra,80007628 <msh_is_used>
80005f28:	00100793          	li	a5,1
80005f2c:	0cf51263          	bne	a0,a5,80005ff0 <finsh_thread_entry+0x4d4>
80005f30:	0004a783          	lw	a5,0(s1)
80005f34:	0307c783          	lbu	a5,48(a5)
80005f38:	0017f793          	andi	a5,a5,1
80005f3c:	00078863          	beqz	a5,80005f4c <finsh_thread_entry+0x430>
80005f40:	00007517          	auipc	a0,0x7
80005f44:	7d850513          	addi	a0,a0,2008 # 8000d718 <__rti_finsh_system_init_name+0x24>
80005f48:	924fc0ef          	jal	ra,8000206c <rt_kprintf>
80005f4c:	0004a503          	lw	a0,0(s1)
80005f50:	2b655583          	lhu	a1,694(a0)
80005f54:	26450513          	addi	a0,a0,612
80005f58:	6d8010ef          	jal	ra,80007630 <msh_exec>
80005f5c:	fb8ff0ef          	jal	ra,80005714 <finsh_get_prompt>
80005f60:	90cfc0ef          	jal	ra,8000206c <rt_kprintf>
80005f64:	0004a403          	lw	s0,0(s1)
80005f68:	05100613          	li	a2,81
80005f6c:	00000593          	li	a1,0
80005f70:	26440513          	addi	a0,s0,612
80005f74:	619050ef          	jal	ra,8000bd8c <memset>
80005f78:	2a041b23          	sh	zero,694(s0)
80005f7c:	2a041c23          	sh	zero,696(s0)
80005f80:	c39ff06f          	j	80005bb8 <finsh_thread_entry+0x9c>
80005f84:	02090463          	beqz	s2,80005fac <finsh_thread_entry+0x490>
80005f88:	fff90513          	addi	a0,s2,-1
80005f8c:	05000793          	li	a5,80
80005f90:	02f50533          	mul	a0,a0,a5
80005f94:	05000613          	li	a2,80
80005f98:	000d0593          	mv	a1,s10
80005f9c:	03650513          	addi	a0,a0,54
80005fa0:	00a40533          	add	a0,s0,a0
80005fa4:	4b5050ef          	jal	ra,8000bc58 <memcmp>
80005fa8:	f6050ae3          	beqz	a0,80005f1c <finsh_thread_entry+0x400>
80005fac:	05000d93          	li	s11,80
80005fb0:	03b90533          	mul	a0,s2,s11
80005fb4:	05000613          	li	a2,80
80005fb8:	00000593          	li	a1,0
80005fbc:	03650513          	addi	a0,a0,54
80005fc0:	00a40533          	add	a0,s0,a0
80005fc4:	5c9050ef          	jal	ra,8000bd8c <memset>
80005fc8:	03445503          	lhu	a0,52(s0)
80005fcc:	2b645603          	lhu	a2,694(s0)
80005fd0:	000d0593          	mv	a1,s10
80005fd4:	03b50533          	mul	a0,a0,s11
80005fd8:	03650513          	addi	a0,a0,54
80005fdc:	00a40533          	add	a0,s0,a0
80005fe0:	4a9050ef          	jal	ra,8000bc88 <memcpy>
80005fe4:	03445783          	lhu	a5,52(s0)
80005fe8:	00178793          	addi	a5,a5,1
80005fec:	f2dff06f          	j	80005f18 <finsh_thread_entry+0x3fc>
80005ff0:	0004a503          	lw	a0,0(s1)
80005ff4:	03b00693          	li	a3,59
80005ff8:	2b655783          	lhu	a5,694(a0)
80005ffc:	00f50733          	add	a4,a0,a5
80006000:	26d70223          	sb	a3,612(a4)
80006004:	00078a63          	beqz	a5,80006018 <finsh_thread_entry+0x4fc>
80006008:	26450593          	addi	a1,a0,612
8000600c:	1c850513          	addi	a0,a0,456
80006010:	a19ff0ef          	jal	ra,80005a28 <finsh_run_line>
80006014:	f49ff06f          	j	80005f5c <finsh_thread_entry+0x440>
80006018:	03054783          	lbu	a5,48(a0)
8000601c:	0017f793          	andi	a5,a5,1
80006020:	f2078ee3          	beqz	a5,80005f5c <finsh_thread_entry+0x440>
80006024:	00007517          	auipc	a0,0x7
80006028:	6f450513          	addi	a0,a0,1780 # 8000d718 <__rti_finsh_system_init_name+0x24>
8000602c:	840fc0ef          	jal	ra,8000206c <rt_kprintf>
80006030:	f2dff06f          	j	80005f5c <finsh_thread_entry+0x440>
80006034:	04f00713          	li	a4,79
80006038:	00f77463          	bgeu	a4,a5,80006040 <finsh_thread_entry+0x524>
8000603c:	2a041b23          	sh	zero,694(s0)
80006040:	2b845603          	lhu	a2,696(s0)
80006044:	2b645783          	lhu	a5,694(s0)
80006048:	0af67463          	bgeu	a2,a5,800060f0 <finsh_thread_entry+0x5d4>
8000604c:	26460593          	addi	a1,a2,612
80006050:	26560513          	addi	a0,a2,613
80006054:	00b405b3          	add	a1,s0,a1
80006058:	40c78633          	sub	a2,a5,a2
8000605c:	00a40533          	add	a0,s0,a0
80006060:	96dfb0ef          	jal	ra,800019cc <rt_memmove>
80006064:	0004a583          	lw	a1,0(s1)
80006068:	2b85d783          	lhu	a5,696(a1)
8000606c:	00f58733          	add	a4,a1,a5
80006070:	27270223          	sb	s2,612(a4)
80006074:	0305c703          	lbu	a4,48(a1)
80006078:	00177713          	andi	a4,a4,1
8000607c:	00070c63          	beqz	a4,80006094 <finsh_thread_entry+0x578>
80006080:	26478793          	addi	a5,a5,612
80006084:	00f585b3          	add	a1,a1,a5
80006088:	00007517          	auipc	a0,0x7
8000608c:	61c50513          	addi	a0,a0,1564 # 8000d6a4 <__rti_rt_work_sys_workqueue_init_name+0xd4>
80006090:	fddfb0ef          	jal	ra,8000206c <rt_kprintf>
80006094:	0004a783          	lw	a5,0(s1)
80006098:	2b87d403          	lhu	s0,696(a5)
8000609c:	0004a783          	lw	a5,0(s1)
800060a0:	2b67d783          	lhu	a5,694(a5)
800060a4:	02f44e63          	blt	s0,a5,800060e0 <finsh_thread_entry+0x5c4>
800060a8:	0004a783          	lw	a5,0(s1)
800060ac:	2b67d703          	lhu	a4,694(a5)
800060b0:	2b87d683          	lhu	a3,696(a5)
800060b4:	00170713          	addi	a4,a4,1
800060b8:	01071713          	slli	a4,a4,0x10
800060bc:	00168693          	addi	a3,a3,1
800060c0:	01075713          	srli	a4,a4,0x10
800060c4:	2ad79c23          	sh	a3,696(a5)
800060c8:	2ae79b23          	sh	a4,694(a5)
800060cc:	04f00693          	li	a3,79
800060d0:	aee6f4e3          	bgeu	a3,a4,80005bb8 <finsh_thread_entry+0x9c>
800060d4:	2a079b23          	sh	zero,694(a5)
800060d8:	2a079c23          	sh	zero,696(a5)
800060dc:	addff06f          	j	80005bb8 <finsh_thread_entry+0x9c>
800060e0:	00098513          	mv	a0,s3
800060e4:	f89fb0ef          	jal	ra,8000206c <rt_kprintf>
800060e8:	00140413          	addi	s0,s0,1
800060ec:	fb1ff06f          	j	8000609c <finsh_thread_entry+0x580>
800060f0:	00f407b3          	add	a5,s0,a5
800060f4:	27278223          	sb	s2,612(a5)
800060f8:	03044783          	lbu	a5,48(s0)
800060fc:	0017f793          	andi	a5,a5,1
80006100:	fa0784e3          	beqz	a5,800060a8 <finsh_thread_entry+0x58c>
80006104:	00090593          	mv	a1,s2
80006108:	00007517          	auipc	a0,0x7
8000610c:	58c50513          	addi	a0,a0,1420 # 8000d694 <__rti_rt_work_sys_workqueue_init_name+0xc4>
80006110:	f5dfb0ef          	jal	ra,8000206c <rt_kprintf>
80006114:	f95ff06f          	j	800060a8 <finsh_thread_entry+0x58c>

80006118 <rt_list_len>:
80006118:	00050793          	mv	a5,a0
8000611c:	00050713          	mv	a4,a0
80006120:	00000513          	li	a0,0
80006124:	00072703          	lw	a4,0(a4)
80006128:	00f71463          	bne	a4,a5,80006130 <rt_list_len+0x18>
8000612c:	00008067          	ret
80006130:	00150513          	addi	a0,a0,1
80006134:	ff1ff06f          	j	80006124 <rt_list_len+0xc>

80006138 <str_is_prefix>:
80006138:	00054783          	lbu	a5,0(a0)
8000613c:	02078063          	beqz	a5,8000615c <str_is_prefix+0x24>
80006140:	0005c703          	lbu	a4,0(a1)
80006144:	00f70663          	beq	a4,a5,80006150 <str_is_prefix+0x18>
80006148:	fff00513          	li	a0,-1
8000614c:	00008067          	ret
80006150:	00150513          	addi	a0,a0,1
80006154:	00158593          	addi	a1,a1,1
80006158:	fe1ff06f          	j	80006138 <str_is_prefix>
8000615c:	00000513          	li	a0,0
80006160:	00008067          	ret

80006164 <str_common>:
80006164:	00050793          	mv	a5,a0
80006168:	0007c683          	lbu	a3,0(a5)
8000616c:	00069663          	bnez	a3,80006178 <str_common+0x14>
80006170:	40a78533          	sub	a0,a5,a0
80006174:	00008067          	ret
80006178:	0005c703          	lbu	a4,0(a1)
8000617c:	fe070ae3          	beqz	a4,80006170 <str_common+0xc>
80006180:	fee698e3          	bne	a3,a4,80006170 <str_common+0xc>
80006184:	00178793          	addi	a5,a5,1
80006188:	00158593          	addi	a1,a1,1
8000618c:	fddff06f          	j	80006168 <str_common+0x4>

80006190 <hello>:
80006190:	ff010113          	addi	sp,sp,-16
80006194:	00007517          	auipc	a0,0x7
80006198:	57450513          	addi	a0,a0,1396 # 8000d708 <__rti_finsh_system_init_name+0x14>
8000619c:	00112623          	sw	ra,12(sp)
800061a0:	ecdfb0ef          	jal	ra,8000206c <rt_kprintf>
800061a4:	00c12083          	lw	ra,12(sp)
800061a8:	00000513          	li	a0,0
800061ac:	01010113          	addi	sp,sp,16
800061b0:	00008067          	ret

800061b4 <clear>:
800061b4:	ff010113          	addi	sp,sp,-16
800061b8:	00007517          	auipc	a0,0x7
800061bc:	56450513          	addi	a0,a0,1380 # 8000d71c <__rti_finsh_system_init_name+0x28>
800061c0:	00112623          	sw	ra,12(sp)
800061c4:	ea9fb0ef          	jal	ra,8000206c <rt_kprintf>
800061c8:	00c12083          	lw	ra,12(sp)
800061cc:	00000513          	li	a0,0
800061d0:	01010113          	addi	sp,sp,16
800061d4:	00008067          	ret

800061d8 <show_wait_queue>:
800061d8:	fe010113          	addi	sp,sp,-32
800061dc:	00912a23          	sw	s1,20(sp)
800061e0:	00052483          	lw	s1,0(a0)
800061e4:	00812c23          	sw	s0,24(sp)
800061e8:	01212823          	sw	s2,16(sp)
800061ec:	01312623          	sw	s3,12(sp)
800061f0:	00112e23          	sw	ra,28(sp)
800061f4:	00050413          	mv	s0,a0
800061f8:	00007917          	auipc	s2,0x7
800061fc:	4ac90913          	addi	s2,s2,1196 # 8000d6a4 <__rti_rt_work_sys_workqueue_init_name+0xd4>
80006200:	00007997          	auipc	s3,0x7
80006204:	52498993          	addi	s3,s3,1316 # 8000d724 <__rti_finsh_system_init_name+0x30>
80006208:	02849063          	bne	s1,s0,80006228 <show_wait_queue+0x50>
8000620c:	01c12083          	lw	ra,28(sp)
80006210:	01812403          	lw	s0,24(sp)
80006214:	01412483          	lw	s1,20(sp)
80006218:	01012903          	lw	s2,16(sp)
8000621c:	00c12983          	lw	s3,12(sp)
80006220:	02010113          	addi	sp,sp,32
80006224:	00008067          	ret
80006228:	fe048593          	addi	a1,s1,-32
8000622c:	00090513          	mv	a0,s2
80006230:	e3dfb0ef          	jal	ra,8000206c <rt_kprintf>
80006234:	0004a783          	lw	a5,0(s1)
80006238:	00878663          	beq	a5,s0,80006244 <show_wait_queue+0x6c>
8000623c:	00098513          	mv	a0,s3
80006240:	e2dfb0ef          	jal	ra,8000206c <rt_kprintf>
80006244:	0004a483          	lw	s1,0(s1)
80006248:	fc1ff06f          	j	80006208 <show_wait_queue+0x30>

8000624c <version>:
8000624c:	ff010113          	addi	sp,sp,-16
80006250:	00112623          	sw	ra,12(sp)
80006254:	ec1fb0ef          	jal	ra,80002114 <rt_show_version>
80006258:	00c12083          	lw	ra,12(sp)
8000625c:	00000513          	li	a0,0
80006260:	01010113          	addi	sp,sp,16
80006264:	00008067          	ret

80006268 <list>:
80006268:	fe010113          	addi	sp,sp,-32
8000626c:	00007517          	auipc	a0,0x7
80006270:	4bc50513          	addi	a0,a0,1212 # 8000d728 <__rti_finsh_system_init_name+0x34>
80006274:	00812c23          	sw	s0,24(sp)
80006278:	01212823          	sw	s2,16(sp)
8000627c:	01312623          	sw	s3,12(sp)
80006280:	01412423          	sw	s4,8(sp)
80006284:	00112e23          	sw	ra,28(sp)
80006288:	00912a23          	sw	s1,20(sp)
8000628c:	8d418913          	addi	s2,gp,-1836 # 80020334 <_syscall_table_end>
80006290:	dddfb0ef          	jal	ra,8000206c <rt_kprintf>
80006294:	00007997          	auipc	s3,0x7
80006298:	4a898993          	addi	s3,s3,1192 # 8000d73c <__rti_finsh_system_init_name+0x48>
8000629c:	8d01a403          	lw	s0,-1840(gp) # 80020330 <_syscall_table_begin>
800062a0:	00007a17          	auipc	s4,0x7
800062a4:	4a0a0a13          	addi	s4,s4,1184 # 8000d740 <__rti_finsh_system_init_name+0x4c>
800062a8:	00092783          	lw	a5,0(s2)
800062ac:	06f46663          	bltu	s0,a5,80006318 <list+0xb0>
800062b0:	90c1a403          	lw	s0,-1780(gp) # 8002036c <global_syscall_list>
800062b4:	00007497          	auipc	s1,0x7
800062b8:	49c48493          	addi	s1,s1,1180 # 8000d750 <__rti_finsh_system_init_name+0x5c>
800062bc:	08041663          	bnez	s0,80006348 <list+0xe0>
800062c0:	00007517          	auipc	a0,0x7
800062c4:	49850513          	addi	a0,a0,1176 # 8000d758 <__rti_finsh_system_init_name+0x64>
800062c8:	da5fb0ef          	jal	ra,8000206c <rt_kprintf>
800062cc:	8dc18493          	addi	s1,gp,-1828 # 8002033c <_sysvar_table_end>
800062d0:	8d81a403          	lw	s0,-1832(gp) # 80020338 <_sysvar_table_begin>
800062d4:	00007917          	auipc	s2,0x7
800062d8:	46c90913          	addi	s2,s2,1132 # 8000d740 <__rti_finsh_system_init_name+0x4c>
800062dc:	0004a783          	lw	a5,0(s1)
800062e0:	06f46e63          	bltu	s0,a5,8000635c <list+0xf4>
800062e4:	9001a403          	lw	s0,-1792(gp) # 80020360 <global_sysvar_list>
800062e8:	00007497          	auipc	s1,0x7
800062ec:	46848493          	addi	s1,s1,1128 # 8000d750 <__rti_finsh_system_init_name+0x5c>
800062f0:	08041263          	bnez	s0,80006374 <list+0x10c>
800062f4:	01c12083          	lw	ra,28(sp)
800062f8:	01812403          	lw	s0,24(sp)
800062fc:	01412483          	lw	s1,20(sp)
80006300:	01012903          	lw	s2,16(sp)
80006304:	00c12983          	lw	s3,12(sp)
80006308:	00812a03          	lw	s4,8(sp)
8000630c:	00000513          	li	a0,0
80006310:	02010113          	addi	sp,sp,32
80006314:	00008067          	ret
80006318:	00042483          	lw	s1,0(s0)
8000631c:	00200613          	li	a2,2
80006320:	00098593          	mv	a1,s3
80006324:	00048513          	mv	a0,s1
80006328:	521050ef          	jal	ra,8000c048 <strncmp>
8000632c:	00050a63          	beqz	a0,80006340 <list+0xd8>
80006330:	00442603          	lw	a2,4(s0)
80006334:	00048593          	mv	a1,s1
80006338:	000a0513          	mv	a0,s4
8000633c:	d31fb0ef          	jal	ra,8000206c <rt_kprintf>
80006340:	00c40413          	addi	s0,s0,12
80006344:	f65ff06f          	j	800062a8 <list+0x40>
80006348:	00442583          	lw	a1,4(s0)
8000634c:	00048513          	mv	a0,s1
80006350:	d1dfb0ef          	jal	ra,8000206c <rt_kprintf>
80006354:	00042403          	lw	s0,0(s0)
80006358:	f65ff06f          	j	800062bc <list+0x54>
8000635c:	00442603          	lw	a2,4(s0)
80006360:	00042583          	lw	a1,0(s0)
80006364:	00090513          	mv	a0,s2
80006368:	01040413          	addi	s0,s0,16
8000636c:	d01fb0ef          	jal	ra,8000206c <rt_kprintf>
80006370:	f6dff06f          	j	800062dc <list+0x74>
80006374:	00442583          	lw	a1,4(s0)
80006378:	00048513          	mv	a0,s1
8000637c:	cf1fb0ef          	jal	ra,8000206c <rt_kprintf>
80006380:	00042403          	lw	s0,0(s0)
80006384:	f6dff06f          	j	800062f0 <list+0x88>

80006388 <list_get_next>:
80006388:	00c5a783          	lw	a5,12(a1)
8000638c:	0005a823          	sw	zero,16(a1)
80006390:	0c078663          	beqz	a5,8000645c <list_get_next+0xd4>
80006394:	0085c783          	lbu	a5,8(a1)
80006398:	fe010113          	addi	sp,sp,-32
8000639c:	00812c23          	sw	s0,24(sp)
800063a0:	00912a23          	sw	s1,20(sp)
800063a4:	00112e23          	sw	ra,28(sp)
800063a8:	01212823          	sw	s2,16(sp)
800063ac:	01312623          	sw	s3,12(sp)
800063b0:	00050413          	mv	s0,a0
800063b4:	00058493          	mv	s1,a1
800063b8:	00000513          	li	a0,0
800063bc:	02078e63          	beqz	a5,800063f8 <list_get_next+0x70>
800063c0:	0005a983          	lw	s3,0(a1)
800063c4:	00000913          	li	s2,0
800063c8:	00041663          	bnez	s0,800063d4 <list_get_next+0x4c>
800063cc:	00098413          	mv	s0,s3
800063d0:	00100913          	li	s2,1
800063d4:	dedfd0ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
800063d8:	00050713          	mv	a4,a0
800063dc:	02091c63          	bnez	s2,80006414 <list_get_next+0x8c>
800063e0:	ffc44783          	lbu	a5,-4(s0)
800063e4:	0084c683          	lbu	a3,8(s1)
800063e8:	f7f7f793          	andi	a5,a5,-129
800063ec:	02d78463          	beq	a5,a3,80006414 <list_get_next+0x8c>
800063f0:	dd9fd0ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
800063f4:	00000513          	li	a0,0
800063f8:	01c12083          	lw	ra,28(sp)
800063fc:	01812403          	lw	s0,24(sp)
80006400:	01412483          	lw	s1,20(sp)
80006404:	01012903          	lw	s2,16(sp)
80006408:	00c12983          	lw	s3,12(sp)
8000640c:	02010113          	addi	sp,sp,32
80006410:	00008067          	ret
80006414:	0044a603          	lw	a2,4(s1)
80006418:	00000793          	li	a5,0
8000641c:	00042403          	lw	s0,0(s0)
80006420:	00078913          	mv	s2,a5
80006424:	02898863          	beq	s3,s0,80006454 <list_get_next+0xcc>
80006428:	00279693          	slli	a3,a5,0x2
8000642c:	00c4a903          	lw	s2,12(s1)
80006430:	00d606b3          	add	a3,a2,a3
80006434:	0086a023          	sw	s0,0(a3)
80006438:	00178793          	addi	a5,a5,1
8000643c:	ff2790e3          	bne	a5,s2,8000641c <list_get_next+0x94>
80006440:	00070513          	mv	a0,a4
80006444:	d85fd0ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
80006448:	00040513          	mv	a0,s0
8000644c:	0124a823          	sw	s2,16(s1)
80006450:	fa9ff06f          	j	800063f8 <list_get_next+0x70>
80006454:	00000413          	li	s0,0
80006458:	fe9ff06f          	j	80006440 <list_get_next+0xb8>
8000645c:	00000513          	li	a0,0
80006460:	00008067          	ret

80006464 <object_split.constprop.0>:
80006464:	ff010113          	addi	sp,sp,-16
80006468:	00812423          	sw	s0,8(sp)
8000646c:	00912223          	sw	s1,4(sp)
80006470:	00112623          	sw	ra,12(sp)
80006474:	01500413          	li	s0,21
80006478:	00007497          	auipc	s1,0x7
8000647c:	2f448493          	addi	s1,s1,756 # 8000d76c <__rti_finsh_system_init_name+0x78>
80006480:	fff40413          	addi	s0,s0,-1
80006484:	00041c63          	bnez	s0,8000649c <object_split.constprop.0+0x38>
80006488:	00c12083          	lw	ra,12(sp)
8000648c:	00812403          	lw	s0,8(sp)
80006490:	00412483          	lw	s1,4(sp)
80006494:	01010113          	addi	sp,sp,16
80006498:	00008067          	ret
8000649c:	00048513          	mv	a0,s1
800064a0:	bcdfb0ef          	jal	ra,8000206c <rt_kprintf>
800064a4:	fddff06f          	j	80006480 <object_split.constprop.0+0x1c>

800064a8 <list_thread>:
800064a8:	f8010113          	addi	sp,sp,-128
800064ac:	00100513          	li	a0,1
800064b0:	06112e23          	sw	ra,124(sp)
800064b4:	06912a23          	sw	s1,116(sp)
800064b8:	07312623          	sw	s3,108(sp)
800064bc:	07412423          	sw	s4,104(sp)
800064c0:	07512223          	sw	s5,100(sp)
800064c4:	07612023          	sw	s6,96(sp)
800064c8:	05712e23          	sw	s7,92(sp)
800064cc:	05812c23          	sw	s8,88(sp)
800064d0:	06812c23          	sw	s0,120(sp)
800064d4:	07212823          	sw	s2,112(sp)
800064d8:	05912a23          	sw	s9,84(sp)
800064dc:	05a12823          	sw	s10,80(sp)
800064e0:	05b12623          	sw	s11,76(sp)
800064e4:	c68fc0ef          	jal	ra,8000294c <rt_object_get_information>
800064e8:	00450513          	addi	a0,a0,4
800064ec:	00100793          	li	a5,1
800064f0:	00007617          	auipc	a2,0x7
800064f4:	28060613          	addi	a2,a2,640 # 8000d770 <__rti_finsh_system_init_name+0x7c>
800064f8:	01400593          	li	a1,20
800064fc:	00a12623          	sw	a0,12(sp)
80006500:	00f10a23          	sb	a5,20(sp)
80006504:	00007517          	auipc	a0,0x7
80006508:	27450513          	addi	a0,a0,628 # 8000d778 <__rti_finsh_system_init_name+0x84>
8000650c:	00800793          	li	a5,8
80006510:	02010993          	addi	s3,sp,32
80006514:	00f12c23          	sw	a5,24(sp)
80006518:	01312823          	sw	s3,16(sp)
8000651c:	00012e23          	sw	zero,28(sp)
80006520:	b4dfb0ef          	jal	ra,8000206c <rt_kprintf>
80006524:	f41ff0ef          	jal	ra,80006464 <object_split.constprop.0>
80006528:	00007517          	auipc	a0,0x7
8000652c:	29450513          	addi	a0,a0,660 # 8000d7bc <__rti_finsh_system_init_name+0xc8>
80006530:	b3dfb0ef          	jal	ra,8000206c <rt_kprintf>
80006534:	00000493          	li	s1,0
80006538:	00007a17          	auipc	s4,0x7
8000653c:	2c4a0a13          	addi	s4,s4,708 # 8000d7fc <__rti_finsh_system_init_name+0x108>
80006540:	00100a93          	li	s5,1
80006544:	02300b13          	li	s6,35
80006548:	06400b93          	li	s7,100
8000654c:	00007c17          	auipc	s8,0x7
80006550:	2f8c0c13          	addi	s8,s8,760 # 8000d844 <__rti_finsh_system_init_name+0x150>
80006554:	00048513          	mv	a0,s1
80006558:	00c10593          	addi	a1,sp,12
8000655c:	e2dff0ef          	jal	ra,80006388 <list_get_next>
80006560:	00050493          	mv	s1,a0
80006564:	00000913          	li	s2,0
80006568:	00200c93          	li	s9,2
8000656c:	00400d13          	li	s10,4
80006570:	00300d93          	li	s11,3
80006574:	01c12783          	lw	a5,28(sp)
80006578:	04f94463          	blt	s2,a5,800065c0 <list_thread+0x118>
8000657c:	fc049ce3          	bnez	s1,80006554 <list_thread+0xac>
80006580:	07c12083          	lw	ra,124(sp)
80006584:	07812403          	lw	s0,120(sp)
80006588:	07412483          	lw	s1,116(sp)
8000658c:	07012903          	lw	s2,112(sp)
80006590:	06c12983          	lw	s3,108(sp)
80006594:	06812a03          	lw	s4,104(sp)
80006598:	06412a83          	lw	s5,100(sp)
8000659c:	06012b03          	lw	s6,96(sp)
800065a0:	05c12b83          	lw	s7,92(sp)
800065a4:	05812c03          	lw	s8,88(sp)
800065a8:	05412c83          	lw	s9,84(sp)
800065ac:	05012d03          	lw	s10,80(sp)
800065b0:	04c12d83          	lw	s11,76(sp)
800065b4:	00000513          	li	a0,0
800065b8:	08010113          	addi	sp,sp,128
800065bc:	00008067          	ret
800065c0:	00291793          	slli	a5,s2,0x2
800065c4:	00f987b3          	add	a5,s3,a5
800065c8:	0007a403          	lw	s0,0(a5)
800065cc:	bf5fd0ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
800065d0:	01414703          	lbu	a4,20(sp)
800065d4:	ffc44783          	lbu	a5,-4(s0)
800065d8:	f7f7f793          	andi	a5,a5,-129
800065dc:	00e78863          	beq	a5,a4,800065ec <list_thread+0x144>
800065e0:	be9fd0ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
800065e4:	00190913          	addi	s2,s2,1
800065e8:	f8dff06f          	j	80006574 <list_thread+0xcc>
800065ec:	bddfd0ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
800065f0:	02944703          	lbu	a4,41(s0)
800065f4:	000a0513          	mv	a0,s4
800065f8:	fe840693          	addi	a3,s0,-24
800065fc:	01400613          	li	a2,20
80006600:	01400593          	li	a1,20
80006604:	a69fb0ef          	jal	ra,8000206c <rt_kprintf>
80006608:	02844783          	lbu	a5,40(s0)
8000660c:	00007517          	auipc	a0,0x7
80006610:	1fc50513          	addi	a0,a0,508 # 8000d808 <__rti_finsh_system_init_name+0x114>
80006614:	0077f793          	andi	a5,a5,7
80006618:	03578a63          	beq	a5,s5,8000664c <list_thread+0x1a4>
8000661c:	00007517          	auipc	a0,0x7
80006620:	1f850513          	addi	a0,a0,504 # 8000d814 <__rti_finsh_system_init_name+0x120>
80006624:	03978463          	beq	a5,s9,8000664c <list_thread+0x1a4>
80006628:	00007517          	auipc	a0,0x7
8000662c:	1f850513          	addi	a0,a0,504 # 8000d820 <__rti_finsh_system_init_name+0x12c>
80006630:	00078e63          	beqz	a5,8000664c <list_thread+0x1a4>
80006634:	00007517          	auipc	a0,0x7
80006638:	1f850513          	addi	a0,a0,504 # 8000d82c <__rti_finsh_system_init_name+0x138>
8000663c:	01a78863          	beq	a5,s10,8000664c <list_thread+0x1a4>
80006640:	01b79863          	bne	a5,s11,80006650 <list_thread+0x1a8>
80006644:	00007517          	auipc	a0,0x7
80006648:	1f450513          	addi	a0,a0,500 # 8000d838 <__rti_finsh_system_init_name+0x144>
8000664c:	a21fb0ef          	jal	ra,8000206c <rt_kprintf>
80006650:	01c42583          	lw	a1,28(s0)
80006654:	00058693          	mv	a3,a1
80006658:	0006c783          	lbu	a5,0(a3)
8000665c:	03678a63          	beq	a5,s6,80006690 <list_thread+0x1e8>
80006660:	02042603          	lw	a2,32(s0)
80006664:	01042503          	lw	a0,16(s0)
80006668:	02442783          	lw	a5,36(s0)
8000666c:	00c585b3          	add	a1,a1,a2
80006670:	40d586b3          	sub	a3,a1,a3
80006674:	037686b3          	mul	a3,a3,s7
80006678:	03c42703          	lw	a4,60(s0)
8000667c:	40a585b3          	sub	a1,a1,a0
80006680:	000c0513          	mv	a0,s8
80006684:	02c6d6b3          	divu	a3,a3,a2
80006688:	9e5fb0ef          	jal	ra,8000206c <rt_kprintf>
8000668c:	f59ff06f          	j	800065e4 <list_thread+0x13c>
80006690:	00168693          	addi	a3,a3,1
80006694:	fc5ff06f          	j	80006658 <list_thread+0x1b0>

80006698 <list_device>:
80006698:	f9010113          	addi	sp,sp,-112
8000669c:	00900513          	li	a0,9
800066a0:	06112623          	sw	ra,108(sp)
800066a4:	06812423          	sw	s0,104(sp)
800066a8:	05312e23          	sw	s3,92(sp)
800066ac:	05412c23          	sw	s4,88(sp)
800066b0:	05512a23          	sw	s5,84(sp)
800066b4:	05612823          	sw	s6,80(sp)
800066b8:	05712623          	sw	s7,76(sp)
800066bc:	06912223          	sw	s1,100(sp)
800066c0:	07212023          	sw	s2,96(sp)
800066c4:	a88fc0ef          	jal	ra,8000294c <rt_object_get_information>
800066c8:	00450513          	addi	a0,a0,4
800066cc:	00900793          	li	a5,9
800066d0:	00007617          	auipc	a2,0x7
800066d4:	1a460613          	addi	a2,a2,420 # 8000d874 <__rti_finsh_system_init_name+0x180>
800066d8:	01400593          	li	a1,20
800066dc:	00a12623          	sw	a0,12(sp)
800066e0:	00f10a23          	sb	a5,20(sp)
800066e4:	00007517          	auipc	a0,0x7
800066e8:	19850513          	addi	a0,a0,408 # 8000d87c <__rti_finsh_system_init_name+0x188>
800066ec:	00800793          	li	a5,8
800066f0:	02010993          	addi	s3,sp,32
800066f4:	00f12c23          	sw	a5,24(sp)
800066f8:	01312823          	sw	s3,16(sp)
800066fc:	00012e23          	sw	zero,28(sp)
80006700:	96dfb0ef          	jal	ra,8000206c <rt_kprintf>
80006704:	d61ff0ef          	jal	ra,80006464 <object_split.constprop.0>
80006708:	00007517          	auipc	a0,0x7
8000670c:	19c50513          	addi	a0,a0,412 # 8000d8a4 <__rti_finsh_system_init_name+0x1b0>
80006710:	95dfb0ef          	jal	ra,8000206c <rt_kprintf>
80006714:	00000413          	li	s0,0
80006718:	01500a13          	li	s4,21
8000671c:	00007a97          	auipc	s5,0x7
80006720:	150a8a93          	addi	s5,s5,336 # 8000d86c <__rti_finsh_system_init_name+0x178>
80006724:	00007b17          	auipc	s6,0x7
80006728:	1a4b0b13          	addi	s6,s6,420 # 8000d8c8 <__rti_finsh_system_init_name+0x1d4>
8000672c:	00007b97          	auipc	s7,0x7
80006730:	64cb8b93          	addi	s7,s7,1612 # 8000dd78 <device_type_str>
80006734:	00040513          	mv	a0,s0
80006738:	00c10593          	addi	a1,sp,12
8000673c:	c4dff0ef          	jal	ra,80006388 <list_get_next>
80006740:	00050413          	mv	s0,a0
80006744:	00000493          	li	s1,0
80006748:	01c12783          	lw	a5,28(sp)
8000674c:	02f4cc63          	blt	s1,a5,80006784 <list_device+0xec>
80006750:	fe0412e3          	bnez	s0,80006734 <list_device+0x9c>
80006754:	06c12083          	lw	ra,108(sp)
80006758:	06812403          	lw	s0,104(sp)
8000675c:	06412483          	lw	s1,100(sp)
80006760:	06012903          	lw	s2,96(sp)
80006764:	05c12983          	lw	s3,92(sp)
80006768:	05812a03          	lw	s4,88(sp)
8000676c:	05412a83          	lw	s5,84(sp)
80006770:	05012b03          	lw	s6,80(sp)
80006774:	04c12b83          	lw	s7,76(sp)
80006778:	00000513          	li	a0,0
8000677c:	07010113          	addi	sp,sp,112
80006780:	00008067          	ret
80006784:	00249793          	slli	a5,s1,0x2
80006788:	00f987b3          	add	a5,s3,a5
8000678c:	0007a903          	lw	s2,0(a5)
80006790:	a31fd0ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
80006794:	01414703          	lbu	a4,20(sp)
80006798:	ffc94783          	lbu	a5,-4(s2)
8000679c:	f7f7f793          	andi	a5,a5,-129
800067a0:	00e78863          	beq	a5,a4,800067b0 <list_device+0x118>
800067a4:	a25fd0ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
800067a8:	00148493          	addi	s1,s1,1
800067ac:	f9dff06f          	j	80006748 <list_device+0xb0>
800067b0:	a19fd0ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
800067b4:	00892783          	lw	a5,8(s2)
800067b8:	fe890693          	addi	a3,s2,-24
800067bc:	000a8713          	mv	a4,s5
800067c0:	00fa6863          	bltu	s4,a5,800067d0 <list_device+0x138>
800067c4:	00279793          	slli	a5,a5,0x2
800067c8:	00fb87b3          	add	a5,s7,a5
800067cc:	0007a703          	lw	a4,0(a5)
800067d0:	01094783          	lbu	a5,16(s2)
800067d4:	01400613          	li	a2,20
800067d8:	01400593          	li	a1,20
800067dc:	000b0513          	mv	a0,s6
800067e0:	88dfb0ef          	jal	ra,8000206c <rt_kprintf>
800067e4:	fc5ff06f          	j	800067a8 <list_device+0x110>

800067e8 <list_mutex>:
800067e8:	f9010113          	addi	sp,sp,-112
800067ec:	00300513          	li	a0,3
800067f0:	06112623          	sw	ra,108(sp)
800067f4:	06812423          	sw	s0,104(sp)
800067f8:	05312e23          	sw	s3,92(sp)
800067fc:	05412c23          	sw	s4,88(sp)
80006800:	06912223          	sw	s1,100(sp)
80006804:	07212023          	sw	s2,96(sp)
80006808:	944fc0ef          	jal	ra,8000294c <rt_object_get_information>
8000680c:	00450513          	addi	a0,a0,4
80006810:	00300793          	li	a5,3
80006814:	00007617          	auipc	a2,0x7
80006818:	0c860613          	addi	a2,a2,200 # 8000d8dc <__rti_finsh_system_init_name+0x1e8>
8000681c:	01400593          	li	a1,20
80006820:	00a12e23          	sw	a0,28(sp)
80006824:	02f10223          	sb	a5,36(sp)
80006828:	00007517          	auipc	a0,0x7
8000682c:	0bc50513          	addi	a0,a0,188 # 8000d8e4 <__rti_finsh_system_init_name+0x1f0>
80006830:	00800793          	li	a5,8
80006834:	03010993          	addi	s3,sp,48
80006838:	02f12423          	sw	a5,40(sp)
8000683c:	03312023          	sw	s3,32(sp)
80006840:	02012623          	sw	zero,44(sp)
80006844:	829fb0ef          	jal	ra,8000206c <rt_kprintf>
80006848:	c1dff0ef          	jal	ra,80006464 <object_split.constprop.0>
8000684c:	00007517          	auipc	a0,0x7
80006850:	0bc50513          	addi	a0,a0,188 # 8000d908 <__rti_finsh_system_init_name+0x214>
80006854:	819fb0ef          	jal	ra,8000206c <rt_kprintf>
80006858:	00000413          	li	s0,0
8000685c:	00007a17          	auipc	s4,0x7
80006860:	0cca0a13          	addi	s4,s4,204 # 8000d928 <__rti_finsh_system_init_name+0x234>
80006864:	00040513          	mv	a0,s0
80006868:	01c10593          	addi	a1,sp,28
8000686c:	b1dff0ef          	jal	ra,80006388 <list_get_next>
80006870:	00050413          	mv	s0,a0
80006874:	00000913          	li	s2,0
80006878:	02c12783          	lw	a5,44(sp)
8000687c:	02f94663          	blt	s2,a5,800068a8 <list_mutex+0xc0>
80006880:	fe0412e3          	bnez	s0,80006864 <list_mutex+0x7c>
80006884:	06c12083          	lw	ra,108(sp)
80006888:	06812403          	lw	s0,104(sp)
8000688c:	06412483          	lw	s1,100(sp)
80006890:	06012903          	lw	s2,96(sp)
80006894:	05c12983          	lw	s3,92(sp)
80006898:	05812a03          	lw	s4,88(sp)
8000689c:	00000513          	li	a0,0
800068a0:	07010113          	addi	sp,sp,112
800068a4:	00008067          	ret
800068a8:	00291793          	slli	a5,s2,0x2
800068ac:	00f987b3          	add	a5,s3,a5
800068b0:	0007a483          	lw	s1,0(a5)
800068b4:	90dfd0ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
800068b8:	02414703          	lbu	a4,36(sp)
800068bc:	ffc4c783          	lbu	a5,-4(s1)
800068c0:	f7f7f793          	andi	a5,a5,-129
800068c4:	00e78863          	beq	a5,a4,800068d4 <list_mutex+0xec>
800068c8:	901fd0ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
800068cc:	00190913          	addi	s2,s2,1
800068d0:	fa9ff06f          	j	80006878 <list_mutex+0x90>
800068d4:	8f5fd0ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
800068d8:	fe848693          	addi	a3,s1,-24
800068dc:	00848513          	addi	a0,s1,8
800068e0:	00d12623          	sw	a3,12(sp)
800068e4:	835ff0ef          	jal	ra,80006118 <rt_list_len>
800068e8:	0134c803          	lbu	a6,19(s1)
800068ec:	0144a783          	lw	a5,20(s1)
800068f0:	00c12683          	lw	a3,12(sp)
800068f4:	00050893          	mv	a7,a0
800068f8:	01400713          	li	a4,20
800068fc:	01400613          	li	a2,20
80006900:	01400593          	li	a1,20
80006904:	000a0513          	mv	a0,s4
80006908:	f64fb0ef          	jal	ra,8000206c <rt_kprintf>
8000690c:	fc1ff06f          	j	800068cc <list_mutex+0xe4>

80006910 <list_timer>:
80006910:	fa010113          	addi	sp,sp,-96
80006914:	00a00513          	li	a0,10
80006918:	04112e23          	sw	ra,92(sp)
8000691c:	04812c23          	sw	s0,88(sp)
80006920:	05312623          	sw	s3,76(sp)
80006924:	05412423          	sw	s4,72(sp)
80006928:	05512223          	sw	s5,68(sp)
8000692c:	05612023          	sw	s6,64(sp)
80006930:	04912a23          	sw	s1,84(sp)
80006934:	05212823          	sw	s2,80(sp)
80006938:	814fc0ef          	jal	ra,8000294c <rt_object_get_information>
8000693c:	00450513          	addi	a0,a0,4
80006940:	00a00793          	li	a5,10
80006944:	00007617          	auipc	a2,0x7
80006948:	88860613          	addi	a2,a2,-1912 # 8000d1cc <__FUNCTION__.3150+0xc8>
8000694c:	01400593          	li	a1,20
80006950:	00a12623          	sw	a0,12(sp)
80006954:	00f10a23          	sb	a5,20(sp)
80006958:	00007517          	auipc	a0,0x7
8000695c:	fe850513          	addi	a0,a0,-24 # 8000d940 <__rti_finsh_system_init_name+0x24c>
80006960:	00800793          	li	a5,8
80006964:	02010993          	addi	s3,sp,32
80006968:	00f12c23          	sw	a5,24(sp)
8000696c:	01312823          	sw	s3,16(sp)
80006970:	00012e23          	sw	zero,28(sp)
80006974:	ef8fb0ef          	jal	ra,8000206c <rt_kprintf>
80006978:	aedff0ef          	jal	ra,80006464 <object_split.constprop.0>
8000697c:	00007517          	auipc	a0,0x7
80006980:	fec50513          	addi	a0,a0,-20 # 8000d968 <__rti_finsh_system_init_name+0x274>
80006984:	ee8fb0ef          	jal	ra,8000206c <rt_kprintf>
80006988:	00000413          	li	s0,0
8000698c:	00007a17          	auipc	s4,0x7
80006990:	000a0a13          	mv	s4,s4
80006994:	00007a97          	auipc	s5,0x7
80006998:	01ca8a93          	addi	s5,s5,28 # 8000d9b0 <__rti_finsh_system_init_name+0x2bc>
8000699c:	00007b17          	auipc	s6,0x7
800069a0:	008b0b13          	addi	s6,s6,8 # 8000d9a4 <__rti_finsh_system_init_name+0x2b0>
800069a4:	00040513          	mv	a0,s0
800069a8:	00c10593          	addi	a1,sp,12
800069ac:	9ddff0ef          	jal	ra,80006388 <list_get_next>
800069b0:	00050413          	mv	s0,a0
800069b4:	00000913          	li	s2,0
800069b8:	01c12783          	lw	a5,28(sp)
800069bc:	04f94463          	blt	s2,a5,80006a04 <list_timer+0xf4>
800069c0:	fe0412e3          	bnez	s0,800069a4 <list_timer+0x94>
800069c4:	e3df90ef          	jal	ra,80000800 <rt_tick_get>
800069c8:	00050593          	mv	a1,a0
800069cc:	00007517          	auipc	a0,0x7
800069d0:	ff450513          	addi	a0,a0,-12 # 8000d9c0 <__rti_finsh_system_init_name+0x2cc>
800069d4:	e98fb0ef          	jal	ra,8000206c <rt_kprintf>
800069d8:	05c12083          	lw	ra,92(sp)
800069dc:	05812403          	lw	s0,88(sp)
800069e0:	05412483          	lw	s1,84(sp)
800069e4:	05012903          	lw	s2,80(sp)
800069e8:	04c12983          	lw	s3,76(sp)
800069ec:	04812a03          	lw	s4,72(sp)
800069f0:	04412a83          	lw	s5,68(sp)
800069f4:	04012b03          	lw	s6,64(sp)
800069f8:	00000513          	li	a0,0
800069fc:	06010113          	addi	sp,sp,96
80006a00:	00008067          	ret
80006a04:	00291793          	slli	a5,s2,0x2
80006a08:	00f987b3          	add	a5,s3,a5
80006a0c:	0007a483          	lw	s1,0(a5)
80006a10:	fb0fd0ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
80006a14:	01414703          	lbu	a4,20(sp)
80006a18:	ffc4c783          	lbu	a5,-4(s1)
80006a1c:	f7f7f793          	andi	a5,a5,-129
80006a20:	00e78863          	beq	a5,a4,80006a30 <list_timer+0x120>
80006a24:	fa4fd0ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
80006a28:	00190913          	addi	s2,s2,1
80006a2c:	f8dff06f          	j	800069b8 <list_timer+0xa8>
80006a30:	f98fd0ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
80006a34:	01c4a783          	lw	a5,28(s1)
80006a38:	0184a703          	lw	a4,24(s1)
80006a3c:	000a0513          	mv	a0,s4
80006a40:	fe848693          	addi	a3,s1,-24
80006a44:	01400613          	li	a2,20
80006a48:	01400593          	li	a1,20
80006a4c:	e20fb0ef          	jal	ra,8000206c <rt_kprintf>
80006a50:	ffd4c783          	lbu	a5,-3(s1)
80006a54:	000b0513          	mv	a0,s6
80006a58:	0017f793          	andi	a5,a5,1
80006a5c:	00079463          	bnez	a5,80006a64 <list_timer+0x154>
80006a60:	000a8513          	mv	a0,s5
80006a64:	e08fb0ef          	jal	ra,8000206c <rt_kprintf>
80006a68:	fc1ff06f          	j	80006a28 <list_timer+0x118>

80006a6c <list_event>:
80006a6c:	f8010113          	addi	sp,sp,-128
80006a70:	00400513          	li	a0,4
80006a74:	06112e23          	sw	ra,124(sp)
80006a78:	06912a23          	sw	s1,116(sp)
80006a7c:	07412423          	sw	s4,104(sp)
80006a80:	07512223          	sw	s5,100(sp)
80006a84:	07612023          	sw	s6,96(sp)
80006a88:	05712e23          	sw	s7,92(sp)
80006a8c:	06812c23          	sw	s0,120(sp)
80006a90:	07212823          	sw	s2,112(sp)
80006a94:	07312623          	sw	s3,108(sp)
80006a98:	eb5fb0ef          	jal	ra,8000294c <rt_object_get_information>
80006a9c:	00450513          	addi	a0,a0,4
80006aa0:	00400793          	li	a5,4
80006aa4:	00007617          	auipc	a2,0x7
80006aa8:	f3460613          	addi	a2,a2,-204 # 8000d9d8 <__rti_finsh_system_init_name+0x2e4>
80006aac:	01400593          	li	a1,20
80006ab0:	00a12e23          	sw	a0,28(sp)
80006ab4:	02f10223          	sb	a5,36(sp)
80006ab8:	00007517          	auipc	a0,0x7
80006abc:	f2850513          	addi	a0,a0,-216 # 8000d9e0 <__rti_finsh_system_init_name+0x2ec>
80006ac0:	00800793          	li	a5,8
80006ac4:	03010a13          	addi	s4,sp,48
80006ac8:	02f12423          	sw	a5,40(sp)
80006acc:	03412023          	sw	s4,32(sp)
80006ad0:	02012623          	sw	zero,44(sp)
80006ad4:	d98fb0ef          	jal	ra,8000206c <rt_kprintf>
80006ad8:	98dff0ef          	jal	ra,80006464 <object_split.constprop.0>
80006adc:	00007517          	auipc	a0,0x7
80006ae0:	f2850513          	addi	a0,a0,-216 # 8000da04 <__rti_finsh_system_init_name+0x310>
80006ae4:	d88fb0ef          	jal	ra,8000206c <rt_kprintf>
80006ae8:	00000493          	li	s1,0
80006aec:	00007a97          	auipc	s5,0x7
80006af0:	f50a8a93          	addi	s5,s5,-176 # 8000da3c <__rti_finsh_system_init_name+0x348>
80006af4:	00007b17          	auipc	s6,0x7
80006af8:	f30b0b13          	addi	s6,s6,-208 # 8000da24 <__rti_finsh_system_init_name+0x330>
80006afc:	00007b97          	auipc	s7,0x7
80006b00:	c1cb8b93          	addi	s7,s7,-996 # 8000d718 <__rti_finsh_system_init_name+0x24>
80006b04:	00048513          	mv	a0,s1
80006b08:	01c10593          	addi	a1,sp,28
80006b0c:	87dff0ef          	jal	ra,80006388 <list_get_next>
80006b10:	00050493          	mv	s1,a0
80006b14:	00000913          	li	s2,0
80006b18:	02c12783          	lw	a5,44(sp)
80006b1c:	02f94c63          	blt	s2,a5,80006b54 <list_event+0xe8>
80006b20:	fe0492e3          	bnez	s1,80006b04 <list_event+0x98>
80006b24:	07c12083          	lw	ra,124(sp)
80006b28:	07812403          	lw	s0,120(sp)
80006b2c:	07412483          	lw	s1,116(sp)
80006b30:	07012903          	lw	s2,112(sp)
80006b34:	06c12983          	lw	s3,108(sp)
80006b38:	06812a03          	lw	s4,104(sp)
80006b3c:	06412a83          	lw	s5,100(sp)
80006b40:	06012b03          	lw	s6,96(sp)
80006b44:	05c12b83          	lw	s7,92(sp)
80006b48:	00000513          	li	a0,0
80006b4c:	08010113          	addi	sp,sp,128
80006b50:	00008067          	ret
80006b54:	00291793          	slli	a5,s2,0x2
80006b58:	00fa07b3          	add	a5,s4,a5
80006b5c:	0007a403          	lw	s0,0(a5)
80006b60:	e60fd0ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
80006b64:	02414703          	lbu	a4,36(sp)
80006b68:	ffc44783          	lbu	a5,-4(s0)
80006b6c:	f7f7f793          	andi	a5,a5,-129
80006b70:	00e78863          	beq	a5,a4,80006b80 <list_event+0x114>
80006b74:	e54fd0ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
80006b78:	00190913          	addi	s2,s2,1
80006b7c:	f9dff06f          	j	80006b18 <list_event+0xac>
80006b80:	e48fd0ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
80006b84:	00842783          	lw	a5,8(s0)
80006b88:	00840993          	addi	s3,s0,8
80006b8c:	fe840693          	addi	a3,s0,-24
80006b90:	04f98063          	beq	s3,a5,80006bd0 <list_event+0x164>
80006b94:	00098513          	mv	a0,s3
80006b98:	00d12623          	sw	a3,12(sp)
80006b9c:	d7cff0ef          	jal	ra,80006118 <rt_list_len>
80006ba0:	01042703          	lw	a4,16(s0)
80006ba4:	00c12683          	lw	a3,12(sp)
80006ba8:	00050793          	mv	a5,a0
80006bac:	01400613          	li	a2,20
80006bb0:	01400593          	li	a1,20
80006bb4:	000b0513          	mv	a0,s6
80006bb8:	cb4fb0ef          	jal	ra,8000206c <rt_kprintf>
80006bbc:	00098513          	mv	a0,s3
80006bc0:	e18ff0ef          	jal	ra,800061d8 <show_wait_queue>
80006bc4:	000b8513          	mv	a0,s7
80006bc8:	ca4fb0ef          	jal	ra,8000206c <rt_kprintf>
80006bcc:	fadff06f          	j	80006b78 <list_event+0x10c>
80006bd0:	01042703          	lw	a4,16(s0)
80006bd4:	01400613          	li	a2,20
80006bd8:	01400593          	li	a1,20
80006bdc:	000a8513          	mv	a0,s5
80006be0:	c8cfb0ef          	jal	ra,8000206c <rt_kprintf>
80006be4:	f95ff06f          	j	80006b78 <list_event+0x10c>

80006be8 <list_msgqueue>:
80006be8:	f8010113          	addi	sp,sp,-128
80006bec:	00600513          	li	a0,6
80006bf0:	06112e23          	sw	ra,124(sp)
80006bf4:	06912a23          	sw	s1,116(sp)
80006bf8:	07412423          	sw	s4,104(sp)
80006bfc:	07512223          	sw	s5,100(sp)
80006c00:	07612023          	sw	s6,96(sp)
80006c04:	05712e23          	sw	s7,92(sp)
80006c08:	06812c23          	sw	s0,120(sp)
80006c0c:	07212823          	sw	s2,112(sp)
80006c10:	07312623          	sw	s3,108(sp)
80006c14:	d39fb0ef          	jal	ra,8000294c <rt_object_get_information>
80006c18:	00450513          	addi	a0,a0,4
80006c1c:	00600793          	li	a5,6
80006c20:	00007617          	auipc	a2,0x7
80006c24:	e3060613          	addi	a2,a2,-464 # 8000da50 <__rti_finsh_system_init_name+0x35c>
80006c28:	01400593          	li	a1,20
80006c2c:	00a12e23          	sw	a0,28(sp)
80006c30:	02f10223          	sb	a5,36(sp)
80006c34:	00007517          	auipc	a0,0x7
80006c38:	e2850513          	addi	a0,a0,-472 # 8000da5c <__rti_finsh_system_init_name+0x368>
80006c3c:	00800793          	li	a5,8
80006c40:	03010a13          	addi	s4,sp,48
80006c44:	02f12423          	sw	a5,40(sp)
80006c48:	03412023          	sw	s4,32(sp)
80006c4c:	02012623          	sw	zero,44(sp)
80006c50:	c1cfb0ef          	jal	ra,8000206c <rt_kprintf>
80006c54:	811ff0ef          	jal	ra,80006464 <object_split.constprop.0>
80006c58:	00007517          	auipc	a0,0x7
80006c5c:	e2050513          	addi	a0,a0,-480 # 8000da78 <__rti_finsh_system_init_name+0x384>
80006c60:	c0cfb0ef          	jal	ra,8000206c <rt_kprintf>
80006c64:	00000493          	li	s1,0
80006c68:	00007a97          	auipc	s5,0x7
80006c6c:	e3ca8a93          	addi	s5,s5,-452 # 8000daa4 <__rti_finsh_system_init_name+0x3b0>
80006c70:	00007b17          	auipc	s6,0x7
80006c74:	e20b0b13          	addi	s6,s6,-480 # 8000da90 <__rti_finsh_system_init_name+0x39c>
80006c78:	00007b97          	auipc	s7,0x7
80006c7c:	aa0b8b93          	addi	s7,s7,-1376 # 8000d718 <__rti_finsh_system_init_name+0x24>
80006c80:	00048513          	mv	a0,s1
80006c84:	01c10593          	addi	a1,sp,28
80006c88:	f00ff0ef          	jal	ra,80006388 <list_get_next>
80006c8c:	00050493          	mv	s1,a0
80006c90:	00000913          	li	s2,0
80006c94:	02c12783          	lw	a5,44(sp)
80006c98:	02f94c63          	blt	s2,a5,80006cd0 <list_msgqueue+0xe8>
80006c9c:	fe0492e3          	bnez	s1,80006c80 <list_msgqueue+0x98>
80006ca0:	07c12083          	lw	ra,124(sp)
80006ca4:	07812403          	lw	s0,120(sp)
80006ca8:	07412483          	lw	s1,116(sp)
80006cac:	07012903          	lw	s2,112(sp)
80006cb0:	06c12983          	lw	s3,108(sp)
80006cb4:	06812a03          	lw	s4,104(sp)
80006cb8:	06412a83          	lw	s5,100(sp)
80006cbc:	06012b03          	lw	s6,96(sp)
80006cc0:	05c12b83          	lw	s7,92(sp)
80006cc4:	00000513          	li	a0,0
80006cc8:	08010113          	addi	sp,sp,128
80006ccc:	00008067          	ret
80006cd0:	00291793          	slli	a5,s2,0x2
80006cd4:	00fa07b3          	add	a5,s4,a5
80006cd8:	0007a403          	lw	s0,0(a5)
80006cdc:	ce4fd0ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
80006ce0:	02414703          	lbu	a4,36(sp)
80006ce4:	ffc44783          	lbu	a5,-4(s0)
80006ce8:	f7f7f793          	andi	a5,a5,-129
80006cec:	00e78863          	beq	a5,a4,80006cfc <list_msgqueue+0x114>
80006cf0:	cd8fd0ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
80006cf4:	00190913          	addi	s2,s2,1
80006cf8:	f9dff06f          	j	80006c94 <list_msgqueue+0xac>
80006cfc:	cccfd0ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
80006d00:	00842783          	lw	a5,8(s0)
80006d04:	fe840693          	addi	a3,s0,-24
80006d08:	00840993          	addi	s3,s0,8
80006d0c:	00d12623          	sw	a3,12(sp)
80006d10:	00098513          	mv	a0,s3
80006d14:	02f98c63          	beq	s3,a5,80006d4c <list_msgqueue+0x164>
80006d18:	c00ff0ef          	jal	ra,80006118 <rt_list_len>
80006d1c:	01845703          	lhu	a4,24(s0)
80006d20:	00c12683          	lw	a3,12(sp)
80006d24:	00050793          	mv	a5,a0
80006d28:	01400613          	li	a2,20
80006d2c:	01400593          	li	a1,20
80006d30:	000b0513          	mv	a0,s6
80006d34:	b38fb0ef          	jal	ra,8000206c <rt_kprintf>
80006d38:	00098513          	mv	a0,s3
80006d3c:	c9cff0ef          	jal	ra,800061d8 <show_wait_queue>
80006d40:	000b8513          	mv	a0,s7
80006d44:	b28fb0ef          	jal	ra,8000206c <rt_kprintf>
80006d48:	fadff06f          	j	80006cf4 <list_msgqueue+0x10c>
80006d4c:	bccff0ef          	jal	ra,80006118 <rt_list_len>
80006d50:	01845703          	lhu	a4,24(s0)
80006d54:	00c12683          	lw	a3,12(sp)
80006d58:	00050793          	mv	a5,a0
80006d5c:	01400613          	li	a2,20
80006d60:	01400593          	li	a1,20
80006d64:	000a8513          	mv	a0,s5
80006d68:	b04fb0ef          	jal	ra,8000206c <rt_kprintf>
80006d6c:	f89ff06f          	j	80006cf4 <list_msgqueue+0x10c>

80006d70 <list_sem>:
80006d70:	f8010113          	addi	sp,sp,-128
80006d74:	00200513          	li	a0,2
80006d78:	06112e23          	sw	ra,124(sp)
80006d7c:	06912a23          	sw	s1,116(sp)
80006d80:	07412423          	sw	s4,104(sp)
80006d84:	07512223          	sw	s5,100(sp)
80006d88:	07612023          	sw	s6,96(sp)
80006d8c:	05712e23          	sw	s7,92(sp)
80006d90:	06812c23          	sw	s0,120(sp)
80006d94:	07212823          	sw	s2,112(sp)
80006d98:	07312623          	sw	s3,108(sp)
80006d9c:	bb1fb0ef          	jal	ra,8000294c <rt_object_get_information>
80006da0:	00450513          	addi	a0,a0,4
80006da4:	00200793          	li	a5,2
80006da8:	00007617          	auipc	a2,0x7
80006dac:	d1060613          	addi	a2,a2,-752 # 8000dab8 <__rti_finsh_system_init_name+0x3c4>
80006db0:	01400593          	li	a1,20
80006db4:	00a12e23          	sw	a0,28(sp)
80006db8:	02f10223          	sb	a5,36(sp)
80006dbc:	00007517          	auipc	a0,0x7
80006dc0:	d0850513          	addi	a0,a0,-760 # 8000dac4 <__rti_finsh_system_init_name+0x3d0>
80006dc4:	00800793          	li	a5,8
80006dc8:	03010a13          	addi	s4,sp,48
80006dcc:	02f12423          	sw	a5,40(sp)
80006dd0:	03412023          	sw	s4,32(sp)
80006dd4:	02012623          	sw	zero,44(sp)
80006dd8:	a94fb0ef          	jal	ra,8000206c <rt_kprintf>
80006ddc:	e88ff0ef          	jal	ra,80006464 <object_split.constprop.0>
80006de0:	00007517          	auipc	a0,0x7
80006de4:	d0050513          	addi	a0,a0,-768 # 8000dae0 <__rti_finsh_system_init_name+0x3ec>
80006de8:	a84fb0ef          	jal	ra,8000206c <rt_kprintf>
80006dec:	00000493          	li	s1,0
80006df0:	00007a97          	auipc	s5,0x7
80006df4:	d18a8a93          	addi	s5,s5,-744 # 8000db08 <__rti_finsh_system_init_name+0x414>
80006df8:	00007b17          	auipc	s6,0x7
80006dfc:	d00b0b13          	addi	s6,s6,-768 # 8000daf8 <__rti_finsh_system_init_name+0x404>
80006e00:	00007b97          	auipc	s7,0x7
80006e04:	918b8b93          	addi	s7,s7,-1768 # 8000d718 <__rti_finsh_system_init_name+0x24>
80006e08:	00048513          	mv	a0,s1
80006e0c:	01c10593          	addi	a1,sp,28
80006e10:	d78ff0ef          	jal	ra,80006388 <list_get_next>
80006e14:	00050493          	mv	s1,a0
80006e18:	00000913          	li	s2,0
80006e1c:	02c12783          	lw	a5,44(sp)
80006e20:	02f94c63          	blt	s2,a5,80006e58 <list_sem+0xe8>
80006e24:	fe0492e3          	bnez	s1,80006e08 <list_sem+0x98>
80006e28:	07c12083          	lw	ra,124(sp)
80006e2c:	07812403          	lw	s0,120(sp)
80006e30:	07412483          	lw	s1,116(sp)
80006e34:	07012903          	lw	s2,112(sp)
80006e38:	06c12983          	lw	s3,108(sp)
80006e3c:	06812a03          	lw	s4,104(sp)
80006e40:	06412a83          	lw	s5,100(sp)
80006e44:	06012b03          	lw	s6,96(sp)
80006e48:	05c12b83          	lw	s7,92(sp)
80006e4c:	00000513          	li	a0,0
80006e50:	08010113          	addi	sp,sp,128
80006e54:	00008067          	ret
80006e58:	00291793          	slli	a5,s2,0x2
80006e5c:	00fa07b3          	add	a5,s4,a5
80006e60:	0007a403          	lw	s0,0(a5)
80006e64:	b5cfd0ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
80006e68:	02414703          	lbu	a4,36(sp)
80006e6c:	ffc44783          	lbu	a5,-4(s0)
80006e70:	f7f7f793          	andi	a5,a5,-129
80006e74:	00e78863          	beq	a5,a4,80006e84 <list_sem+0x114>
80006e78:	b50fd0ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
80006e7c:	00190913          	addi	s2,s2,1
80006e80:	f9dff06f          	j	80006e1c <list_sem+0xac>
80006e84:	b44fd0ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
80006e88:	00842783          	lw	a5,8(s0)
80006e8c:	fe840693          	addi	a3,s0,-24
80006e90:	00840993          	addi	s3,s0,8
80006e94:	00d12623          	sw	a3,12(sp)
80006e98:	00098513          	mv	a0,s3
80006e9c:	02f98c63          	beq	s3,a5,80006ed4 <list_sem+0x164>
80006ea0:	a78ff0ef          	jal	ra,80006118 <rt_list_len>
80006ea4:	01045703          	lhu	a4,16(s0)
80006ea8:	00c12683          	lw	a3,12(sp)
80006eac:	00050793          	mv	a5,a0
80006eb0:	01400613          	li	a2,20
80006eb4:	01400593          	li	a1,20
80006eb8:	000b0513          	mv	a0,s6
80006ebc:	9b0fb0ef          	jal	ra,8000206c <rt_kprintf>
80006ec0:	00098513          	mv	a0,s3
80006ec4:	b14ff0ef          	jal	ra,800061d8 <show_wait_queue>
80006ec8:	000b8513          	mv	a0,s7
80006ecc:	9a0fb0ef          	jal	ra,8000206c <rt_kprintf>
80006ed0:	fadff06f          	j	80006e7c <list_sem+0x10c>
80006ed4:	a44ff0ef          	jal	ra,80006118 <rt_list_len>
80006ed8:	01045703          	lhu	a4,16(s0)
80006edc:	00c12683          	lw	a3,12(sp)
80006ee0:	00050793          	mv	a5,a0
80006ee4:	01400613          	li	a2,20
80006ee8:	01400593          	li	a1,20
80006eec:	000a8513          	mv	a0,s5
80006ef0:	97cfb0ef          	jal	ra,8000206c <rt_kprintf>
80006ef4:	f89ff06f          	j	80006e7c <list_sem+0x10c>

80006ef8 <list_mailbox>:
80006ef8:	f8010113          	addi	sp,sp,-128
80006efc:	00500513          	li	a0,5
80006f00:	06112e23          	sw	ra,124(sp)
80006f04:	06912a23          	sw	s1,116(sp)
80006f08:	07412423          	sw	s4,104(sp)
80006f0c:	07512223          	sw	s5,100(sp)
80006f10:	07612023          	sw	s6,96(sp)
80006f14:	05712e23          	sw	s7,92(sp)
80006f18:	06812c23          	sw	s0,120(sp)
80006f1c:	07212823          	sw	s2,112(sp)
80006f20:	07312623          	sw	s3,108(sp)
80006f24:	a29fb0ef          	jal	ra,8000294c <rt_object_get_information>
80006f28:	00450513          	addi	a0,a0,4
80006f2c:	00500793          	li	a5,5
80006f30:	00007617          	auipc	a2,0x7
80006f34:	be860613          	addi	a2,a2,-1048 # 8000db18 <__rti_finsh_system_init_name+0x424>
80006f38:	01400593          	li	a1,20
80006f3c:	00a12e23          	sw	a0,28(sp)
80006f40:	02f10223          	sb	a5,36(sp)
80006f44:	00007517          	auipc	a0,0x7
80006f48:	bdc50513          	addi	a0,a0,-1060 # 8000db20 <__rti_finsh_system_init_name+0x42c>
80006f4c:	00800793          	li	a5,8
80006f50:	03010a13          	addi	s4,sp,48
80006f54:	02f12423          	sw	a5,40(sp)
80006f58:	03412023          	sw	s4,32(sp)
80006f5c:	02012623          	sw	zero,44(sp)
80006f60:	90cfb0ef          	jal	ra,8000206c <rt_kprintf>
80006f64:	d00ff0ef          	jal	ra,80006464 <object_split.constprop.0>
80006f68:	00007517          	auipc	a0,0x7
80006f6c:	bdc50513          	addi	a0,a0,-1060 # 8000db44 <__rti_finsh_system_init_name+0x450>
80006f70:	8fcfb0ef          	jal	ra,8000206c <rt_kprintf>
80006f74:	00000493          	li	s1,0
80006f78:	00007a97          	auipc	s5,0x7
80006f7c:	c00a8a93          	addi	s5,s5,-1024 # 8000db78 <__rti_finsh_system_init_name+0x484>
80006f80:	00007b17          	auipc	s6,0x7
80006f84:	be0b0b13          	addi	s6,s6,-1056 # 8000db60 <__rti_finsh_system_init_name+0x46c>
80006f88:	00006b97          	auipc	s7,0x6
80006f8c:	790b8b93          	addi	s7,s7,1936 # 8000d718 <__rti_finsh_system_init_name+0x24>
80006f90:	00048513          	mv	a0,s1
80006f94:	01c10593          	addi	a1,sp,28
80006f98:	bf0ff0ef          	jal	ra,80006388 <list_get_next>
80006f9c:	00050493          	mv	s1,a0
80006fa0:	00000913          	li	s2,0
80006fa4:	02c12783          	lw	a5,44(sp)
80006fa8:	02f94c63          	blt	s2,a5,80006fe0 <list_mailbox+0xe8>
80006fac:	fe0492e3          	bnez	s1,80006f90 <list_mailbox+0x98>
80006fb0:	07c12083          	lw	ra,124(sp)
80006fb4:	07812403          	lw	s0,120(sp)
80006fb8:	07412483          	lw	s1,116(sp)
80006fbc:	07012903          	lw	s2,112(sp)
80006fc0:	06c12983          	lw	s3,108(sp)
80006fc4:	06812a03          	lw	s4,104(sp)
80006fc8:	06412a83          	lw	s5,100(sp)
80006fcc:	06012b03          	lw	s6,96(sp)
80006fd0:	05c12b83          	lw	s7,92(sp)
80006fd4:	00000513          	li	a0,0
80006fd8:	08010113          	addi	sp,sp,128
80006fdc:	00008067          	ret
80006fe0:	00291793          	slli	a5,s2,0x2
80006fe4:	00fa07b3          	add	a5,s4,a5
80006fe8:	0007a403          	lw	s0,0(a5)
80006fec:	9d4fd0ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
80006ff0:	02414703          	lbu	a4,36(sp)
80006ff4:	ffc44783          	lbu	a5,-4(s0)
80006ff8:	f7f7f793          	andi	a5,a5,-129
80006ffc:	00e78863          	beq	a5,a4,8000700c <list_mailbox+0x114>
80007000:	9c8fd0ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
80007004:	00190913          	addi	s2,s2,1
80007008:	f9dff06f          	j	80006fa4 <list_mailbox+0xac>
8000700c:	9bcfd0ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
80007010:	00842783          	lw	a5,8(s0)
80007014:	fe840693          	addi	a3,s0,-24
80007018:	00840993          	addi	s3,s0,8
8000701c:	00d12623          	sw	a3,12(sp)
80007020:	00098513          	mv	a0,s3
80007024:	02f98e63          	beq	s3,a5,80007060 <list_mailbox+0x168>
80007028:	8f0ff0ef          	jal	ra,80006118 <rt_list_len>
8000702c:	01445783          	lhu	a5,20(s0)
80007030:	01645703          	lhu	a4,22(s0)
80007034:	00c12683          	lw	a3,12(sp)
80007038:	00050813          	mv	a6,a0
8000703c:	01400613          	li	a2,20
80007040:	01400593          	li	a1,20
80007044:	000b0513          	mv	a0,s6
80007048:	824fb0ef          	jal	ra,8000206c <rt_kprintf>
8000704c:	00098513          	mv	a0,s3
80007050:	988ff0ef          	jal	ra,800061d8 <show_wait_queue>
80007054:	000b8513          	mv	a0,s7
80007058:	814fb0ef          	jal	ra,8000206c <rt_kprintf>
8000705c:	fa9ff06f          	j	80007004 <list_mailbox+0x10c>
80007060:	8b8ff0ef          	jal	ra,80006118 <rt_list_len>
80007064:	01445783          	lhu	a5,20(s0)
80007068:	01645703          	lhu	a4,22(s0)
8000706c:	00c12683          	lw	a3,12(sp)
80007070:	00050813          	mv	a6,a0
80007074:	01400613          	li	a2,20
80007078:	01400593          	li	a1,20
8000707c:	000a8513          	mv	a0,s5
80007080:	fedfa0ef          	jal	ra,8000206c <rt_kprintf>
80007084:	f81ff06f          	j	80007004 <list_mailbox+0x10c>

80007088 <list_mempool>:
80007088:	f9010113          	addi	sp,sp,-112
8000708c:	00800513          	li	a0,8
80007090:	06112623          	sw	ra,108(sp)
80007094:	06912223          	sw	s1,100(sp)
80007098:	05412c23          	sw	s4,88(sp)
8000709c:	05512a23          	sw	s5,84(sp)
800070a0:	05612823          	sw	s6,80(sp)
800070a4:	05712623          	sw	s7,76(sp)
800070a8:	06812423          	sw	s0,104(sp)
800070ac:	07212023          	sw	s2,96(sp)
800070b0:	05312e23          	sw	s3,92(sp)
800070b4:	899fb0ef          	jal	ra,8000294c <rt_object_get_information>
800070b8:	00450513          	addi	a0,a0,4
800070bc:	00800793          	li	a5,8
800070c0:	00007617          	auipc	a2,0x7
800070c4:	ad060613          	addi	a2,a2,-1328 # 8000db90 <__rti_finsh_system_init_name+0x49c>
800070c8:	01400593          	li	a1,20
800070cc:	00a12623          	sw	a0,12(sp)
800070d0:	00f10a23          	sb	a5,20(sp)
800070d4:	00007517          	auipc	a0,0x7
800070d8:	ac450513          	addi	a0,a0,-1340 # 8000db98 <__rti_finsh_system_init_name+0x4a4>
800070dc:	00800793          	li	a5,8
800070e0:	02010a13          	addi	s4,sp,32
800070e4:	00f12c23          	sw	a5,24(sp)
800070e8:	01412823          	sw	s4,16(sp)
800070ec:	00012e23          	sw	zero,28(sp)
800070f0:	f7dfa0ef          	jal	ra,8000206c <rt_kprintf>
800070f4:	b70ff0ef          	jal	ra,80006464 <object_split.constprop.0>
800070f8:	00007517          	auipc	a0,0x7
800070fc:	ac850513          	addi	a0,a0,-1336 # 8000dbc0 <__rti_finsh_system_init_name+0x4cc>
80007100:	f6dfa0ef          	jal	ra,8000206c <rt_kprintf>
80007104:	00000493          	li	s1,0
80007108:	00007a97          	auipc	s5,0x7
8000710c:	af8a8a93          	addi	s5,s5,-1288 # 8000dc00 <__rti_finsh_system_init_name+0x50c>
80007110:	00007b17          	auipc	s6,0x7
80007114:	ad4b0b13          	addi	s6,s6,-1324 # 8000dbe4 <__rti_finsh_system_init_name+0x4f0>
80007118:	00006b97          	auipc	s7,0x6
8000711c:	600b8b93          	addi	s7,s7,1536 # 8000d718 <__rti_finsh_system_init_name+0x24>
80007120:	00048513          	mv	a0,s1
80007124:	00c10593          	addi	a1,sp,12
80007128:	a60ff0ef          	jal	ra,80006388 <list_get_next>
8000712c:	00050493          	mv	s1,a0
80007130:	00000913          	li	s2,0
80007134:	01c12783          	lw	a5,28(sp)
80007138:	02f94c63          	blt	s2,a5,80007170 <list_mempool+0xe8>
8000713c:	fe0492e3          	bnez	s1,80007120 <list_mempool+0x98>
80007140:	06c12083          	lw	ra,108(sp)
80007144:	06812403          	lw	s0,104(sp)
80007148:	06412483          	lw	s1,100(sp)
8000714c:	06012903          	lw	s2,96(sp)
80007150:	05c12983          	lw	s3,92(sp)
80007154:	05812a03          	lw	s4,88(sp)
80007158:	05412a83          	lw	s5,84(sp)
8000715c:	05012b03          	lw	s6,80(sp)
80007160:	04c12b83          	lw	s7,76(sp)
80007164:	00000513          	li	a0,0
80007168:	07010113          	addi	sp,sp,112
8000716c:	00008067          	ret
80007170:	00291793          	slli	a5,s2,0x2
80007174:	00fa07b3          	add	a5,s4,a5
80007178:	0007a403          	lw	s0,0(a5)
8000717c:	844fd0ef          	jal	ra,800041c0 <rt_hw_interrupt_disable>
80007180:	01414703          	lbu	a4,20(sp)
80007184:	ffc44783          	lbu	a5,-4(s0)
80007188:	f7f7f793          	andi	a5,a5,-129
8000718c:	00e78863          	beq	a5,a4,8000719c <list_mempool+0x114>
80007190:	838fd0ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
80007194:	00190913          	addi	s2,s2,1
80007198:	f9dff06f          	j	80007134 <list_mempool+0xac>
8000719c:	82cfd0ef          	jal	ra,800041c8 <rt_hw_interrupt_enable>
800071a0:	02042983          	lw	s3,32(s0)
800071a4:	00000893          	li	a7,0
800071a8:	fe840693          	addi	a3,s0,-24
800071ac:	02040793          	addi	a5,s0,32
800071b0:	02f99c63          	bne	s3,a5,800071e8 <list_mempool+0x160>
800071b4:	01042703          	lw	a4,16(s0)
800071b8:	01842783          	lw	a5,24(s0)
800071bc:	01c42803          	lw	a6,28(s0)
800071c0:	02088a63          	beqz	a7,800071f4 <list_mempool+0x16c>
800071c4:	01400613          	li	a2,20
800071c8:	01400593          	li	a1,20
800071cc:	000b0513          	mv	a0,s6
800071d0:	e9dfa0ef          	jal	ra,8000206c <rt_kprintf>
800071d4:	00098513          	mv	a0,s3
800071d8:	800ff0ef          	jal	ra,800061d8 <show_wait_queue>
800071dc:	000b8513          	mv	a0,s7
800071e0:	e8dfa0ef          	jal	ra,8000206c <rt_kprintf>
800071e4:	fb1ff06f          	j	80007194 <list_mempool+0x10c>
800071e8:	0009a983          	lw	s3,0(s3)
800071ec:	00188893          	addi	a7,a7,1
800071f0:	fc1ff06f          	j	800071b0 <list_mempool+0x128>
800071f4:	00000893          	li	a7,0
800071f8:	01400613          	li	a2,20
800071fc:	01400593          	li	a1,20
80007200:	000a8513          	mv	a0,s5
80007204:	e69fa0ef          	jal	ra,8000206c <rt_kprintf>
80007208:	f8dff06f          	j	80007194 <list_mempool+0x10c>

8000720c <list_prefix>:
8000720c:	fc010113          	addi	sp,sp,-64
80007210:	02812c23          	sw	s0,56(sp)
80007214:	02912a23          	sw	s1,52(sp)
80007218:	03212823          	sw	s2,48(sp)
8000721c:	03312623          	sw	s3,44(sp)
80007220:	03412423          	sw	s4,40(sp)
80007224:	03512223          	sw	s5,36(sp)
80007228:	03612023          	sw	s6,32(sp)
8000722c:	01712e23          	sw	s7,28(sp)
80007230:	01812c23          	sw	s8,24(sp)
80007234:	02112e23          	sw	ra,60(sp)
80007238:	00050913          	mv	s2,a0
8000723c:	8d01aa03          	lw	s4,-1840(gp) # 80020330 <_syscall_table_begin>
80007240:	00000493          	li	s1,0
80007244:	00000413          	li	s0,0
80007248:	00000993          	li	s3,0
8000724c:	8d418a93          	addi	s5,gp,-1836 # 80020334 <_syscall_table_end>
80007250:	00006b17          	auipc	s6,0x6
80007254:	4ecb0b13          	addi	s6,s6,1260 # 8000d73c <__rti_finsh_system_init_name+0x48>
80007258:	00006b97          	auipc	s7,0x6
8000725c:	4e8b8b93          	addi	s7,s7,1256 # 8000d740 <__rti_finsh_system_init_name+0x4c>
80007260:	00007c17          	auipc	s8,0x7
80007264:	9bcc0c13          	addi	s8,s8,-1604 # 8000dc1c <__rti_finsh_system_init_name+0x528>
80007268:	000aa783          	lw	a5,0(s5)
8000726c:	08fa6c63          	bltu	s4,a5,80007304 <list_prefix+0xf8>
80007270:	90c1aa03          	lw	s4,-1780(gp) # 8002036c <global_syscall_list>
80007274:	00006a97          	auipc	s5,0x6
80007278:	4dca8a93          	addi	s5,s5,1244 # 8000d750 <__rti_finsh_system_init_name+0x5c>
8000727c:	00007b17          	auipc	s6,0x7
80007280:	9a0b0b13          	addi	s6,s6,-1632 # 8000dc1c <__rti_finsh_system_init_name+0x528>
80007284:	100a1663          	bnez	s4,80007390 <list_prefix+0x184>
80007288:	8d81aa03          	lw	s4,-1832(gp) # 80020338 <_sysvar_table_begin>
8000728c:	00000993          	li	s3,0
80007290:	8dc18a93          	addi	s5,gp,-1828 # 8002033c <_sysvar_table_end>
80007294:	00006b17          	auipc	s6,0x6
80007298:	4acb0b13          	addi	s6,s6,1196 # 8000d740 <__rti_finsh_system_init_name+0x4c>
8000729c:	00007b97          	auipc	s7,0x7
800072a0:	990b8b93          	addi	s7,s7,-1648 # 8000dc2c <__rti_finsh_system_init_name+0x538>
800072a4:	000aa783          	lw	a5,0(s5)
800072a8:	16fa6063          	bltu	s4,a5,80007408 <list_prefix+0x1fc>
800072ac:	9001aa03          	lw	s4,-1792(gp) # 80020360 <global_sysvar_list>
800072b0:	00007a97          	auipc	s5,0x7
800072b4:	98ca8a93          	addi	s5,s5,-1652 # 8000dc3c <__rti_finsh_system_init_name+0x548>
800072b8:	00007b17          	auipc	s6,0x7
800072bc:	974b0b13          	addi	s6,s6,-1676 # 8000dc2c <__rti_finsh_system_init_name+0x538>
800072c0:	1c0a1263          	bnez	s4,80007484 <list_prefix+0x278>
800072c4:	22048c63          	beqz	s1,800074fc <list_prefix+0x2f0>
800072c8:	00040613          	mv	a2,s0
800072cc:	03812403          	lw	s0,56(sp)
800072d0:	03c12083          	lw	ra,60(sp)
800072d4:	02c12983          	lw	s3,44(sp)
800072d8:	02812a03          	lw	s4,40(sp)
800072dc:	02412a83          	lw	s5,36(sp)
800072e0:	02012b03          	lw	s6,32(sp)
800072e4:	01c12b83          	lw	s7,28(sp)
800072e8:	01812c03          	lw	s8,24(sp)
800072ec:	00048593          	mv	a1,s1
800072f0:	00090513          	mv	a0,s2
800072f4:	03412483          	lw	s1,52(sp)
800072f8:	03012903          	lw	s2,48(sp)
800072fc:	04010113          	addi	sp,sp,64
80007300:	f28fa06f          	j	80001a28 <rt_strncpy>
80007304:	000a2583          	lw	a1,0(s4) # 8000d98c <__rti_finsh_system_init_name+0x298>
80007308:	000b0513          	mv	a0,s6
8000730c:	00b12623          	sw	a1,12(sp)
80007310:	e29fe0ef          	jal	ra,80006138 <str_is_prefix>
80007314:	06050a63          	beqz	a0,80007388 <list_prefix+0x17c>
80007318:	00c12583          	lw	a1,12(sp)
8000731c:	00090513          	mv	a0,s2
80007320:	e19fe0ef          	jal	ra,80006138 <str_is_prefix>
80007324:	06051263          	bnez	a0,80007388 <list_prefix+0x17c>
80007328:	02099263          	bnez	s3,8000734c <list_prefix+0x140>
8000732c:	000c0513          	mv	a0,s8
80007330:	d3dfa0ef          	jal	ra,8000206c <rt_kprintf>
80007334:	00094783          	lbu	a5,0(s2)
80007338:	00078a63          	beqz	a5,8000734c <list_prefix+0x140>
8000733c:	000a2483          	lw	s1,0(s4)
80007340:	00048513          	mv	a0,s1
80007344:	4e9040ef          	jal	ra,8000c02c <strlen>
80007348:	00050413          	mv	s0,a0
8000734c:	00094783          	lbu	a5,0(s2)
80007350:	00198993          	addi	s3,s3,1
80007354:	01099993          	slli	s3,s3,0x10
80007358:	000a2583          	lw	a1,0(s4)
8000735c:	0109d993          	srli	s3,s3,0x10
80007360:	00078e63          	beqz	a5,8000737c <list_prefix+0x170>
80007364:	00048513          	mv	a0,s1
80007368:	00b12623          	sw	a1,12(sp)
8000736c:	df9fe0ef          	jal	ra,80006164 <str_common>
80007370:	00c12583          	lw	a1,12(sp)
80007374:	00855463          	bge	a0,s0,8000737c <list_prefix+0x170>
80007378:	00050413          	mv	s0,a0
8000737c:	004a2603          	lw	a2,4(s4)
80007380:	000b8513          	mv	a0,s7
80007384:	ce9fa0ef          	jal	ra,8000206c <rt_kprintf>
80007388:	00ca0a13          	addi	s4,s4,12
8000738c:	eddff06f          	j	80007268 <list_prefix+0x5c>
80007390:	004a2583          	lw	a1,4(s4)
80007394:	00090513          	mv	a0,s2
80007398:	da1fe0ef          	jal	ra,80006138 <str_is_prefix>
8000739c:	06051263          	bnez	a0,80007400 <list_prefix+0x1f4>
800073a0:	02099463          	bnez	s3,800073c8 <list_prefix+0x1bc>
800073a4:	000b0513          	mv	a0,s6
800073a8:	cc5fa0ef          	jal	ra,8000206c <rt_kprintf>
800073ac:	00094783          	lbu	a5,0(s2)
800073b0:	00078c63          	beqz	a5,800073c8 <list_prefix+0x1bc>
800073b4:	00049a63          	bnez	s1,800073c8 <list_prefix+0x1bc>
800073b8:	004a2483          	lw	s1,4(s4)
800073bc:	00048513          	mv	a0,s1
800073c0:	46d040ef          	jal	ra,8000c02c <strlen>
800073c4:	00050413          	mv	s0,a0
800073c8:	00094783          	lbu	a5,0(s2)
800073cc:	00198993          	addi	s3,s3,1
800073d0:	01099993          	slli	s3,s3,0x10
800073d4:	004a2583          	lw	a1,4(s4)
800073d8:	0109d993          	srli	s3,s3,0x10
800073dc:	00078e63          	beqz	a5,800073f8 <list_prefix+0x1ec>
800073e0:	00048513          	mv	a0,s1
800073e4:	00b12623          	sw	a1,12(sp)
800073e8:	d7dfe0ef          	jal	ra,80006164 <str_common>
800073ec:	00c12583          	lw	a1,12(sp)
800073f0:	00855463          	bge	a0,s0,800073f8 <list_prefix+0x1ec>
800073f4:	00050413          	mv	s0,a0
800073f8:	000a8513          	mv	a0,s5
800073fc:	c71fa0ef          	jal	ra,8000206c <rt_kprintf>
80007400:	000a2a03          	lw	s4,0(s4)
80007404:	e81ff06f          	j	80007284 <list_prefix+0x78>
80007408:	000a2583          	lw	a1,0(s4)
8000740c:	00090513          	mv	a0,s2
80007410:	d29fe0ef          	jal	ra,80006138 <str_is_prefix>
80007414:	06051463          	bnez	a0,8000747c <list_prefix+0x270>
80007418:	02099463          	bnez	s3,80007440 <list_prefix+0x234>
8000741c:	000b8513          	mv	a0,s7
80007420:	c4dfa0ef          	jal	ra,8000206c <rt_kprintf>
80007424:	00094783          	lbu	a5,0(s2)
80007428:	00078c63          	beqz	a5,80007440 <list_prefix+0x234>
8000742c:	00049a63          	bnez	s1,80007440 <list_prefix+0x234>
80007430:	000a2483          	lw	s1,0(s4)
80007434:	00048513          	mv	a0,s1
80007438:	3f5040ef          	jal	ra,8000c02c <strlen>
8000743c:	00050413          	mv	s0,a0
80007440:	00094783          	lbu	a5,0(s2)
80007444:	00198993          	addi	s3,s3,1
80007448:	01099993          	slli	s3,s3,0x10
8000744c:	000a2583          	lw	a1,0(s4)
80007450:	0109d993          	srli	s3,s3,0x10
80007454:	00078e63          	beqz	a5,80007470 <list_prefix+0x264>
80007458:	00048513          	mv	a0,s1
8000745c:	00b12623          	sw	a1,12(sp)
80007460:	d05fe0ef          	jal	ra,80006164 <str_common>
80007464:	00c12583          	lw	a1,12(sp)
80007468:	00855463          	bge	a0,s0,80007470 <list_prefix+0x264>
8000746c:	00050413          	mv	s0,a0
80007470:	004a2603          	lw	a2,4(s4)
80007474:	000b0513          	mv	a0,s6
80007478:	bf5fa0ef          	jal	ra,8000206c <rt_kprintf>
8000747c:	010a0a13          	addi	s4,s4,16
80007480:	e25ff06f          	j	800072a4 <list_prefix+0x98>
80007484:	004a2583          	lw	a1,4(s4)
80007488:	00090513          	mv	a0,s2
8000748c:	cadfe0ef          	jal	ra,80006138 <str_is_prefix>
80007490:	06051263          	bnez	a0,800074f4 <list_prefix+0x2e8>
80007494:	02099463          	bnez	s3,800074bc <list_prefix+0x2b0>
80007498:	000b0513          	mv	a0,s6
8000749c:	bd1fa0ef          	jal	ra,8000206c <rt_kprintf>
800074a0:	00094783          	lbu	a5,0(s2)
800074a4:	00078c63          	beqz	a5,800074bc <list_prefix+0x2b0>
800074a8:	00049a63          	bnez	s1,800074bc <list_prefix+0x2b0>
800074ac:	004a2483          	lw	s1,4(s4)
800074b0:	00048513          	mv	a0,s1
800074b4:	379040ef          	jal	ra,8000c02c <strlen>
800074b8:	00050413          	mv	s0,a0
800074bc:	00094783          	lbu	a5,0(s2)
800074c0:	00198993          	addi	s3,s3,1
800074c4:	01099993          	slli	s3,s3,0x10
800074c8:	004a2583          	lw	a1,4(s4)
800074cc:	0109d993          	srli	s3,s3,0x10
800074d0:	00078e63          	beqz	a5,800074ec <list_prefix+0x2e0>
800074d4:	00048513          	mv	a0,s1
800074d8:	00b12623          	sw	a1,12(sp)
800074dc:	c89fe0ef          	jal	ra,80006164 <str_common>
800074e0:	00c12583          	lw	a1,12(sp)
800074e4:	00855463          	bge	a0,s0,800074ec <list_prefix+0x2e0>
800074e8:	00050413          	mv	s0,a0
800074ec:	000a8513          	mv	a0,s5
800074f0:	b7dfa0ef          	jal	ra,8000206c <rt_kprintf>
800074f4:	000a2a03          	lw	s4,0(s4)
800074f8:	dc9ff06f          	j	800072c0 <list_prefix+0xb4>
800074fc:	03c12083          	lw	ra,60(sp)
80007500:	03812403          	lw	s0,56(sp)
80007504:	03412483          	lw	s1,52(sp)
80007508:	03012903          	lw	s2,48(sp)
8000750c:	02c12983          	lw	s3,44(sp)
80007510:	02812a03          	lw	s4,40(sp)
80007514:	02412a83          	lw	s5,36(sp)
80007518:	02012b03          	lw	s6,32(sp)
8000751c:	01c12b83          	lw	s7,28(sp)
80007520:	01812c03          	lw	s8,24(sp)
80007524:	04010113          	addi	sp,sp,64
80007528:	00008067          	ret

8000752c <msh_exit>:
8000752c:	8001aa23          	sw	zero,-2028(gp) # 80020274 <__msh_state>
80007530:	00000513          	li	a0,0
80007534:	00008067          	ret

80007538 <msh_enter>:
80007538:	00100793          	li	a5,1
8000753c:	80f1aa23          	sw	a5,-2028(gp) # 80020274 <__msh_state>
80007540:	00000513          	li	a0,0
80007544:	00008067          	ret

80007548 <msh_help>:
80007548:	fe010113          	addi	sp,sp,-32
8000754c:	00007517          	auipc	a0,0x7
80007550:	c7050513          	addi	a0,a0,-912 # 8000e1bc <__fsym_hello_name+0x8>
80007554:	00812c23          	sw	s0,24(sp)
80007558:	01212823          	sw	s2,16(sp)
8000755c:	01312623          	sw	s3,12(sp)
80007560:	01412423          	sw	s4,8(sp)
80007564:	00112e23          	sw	ra,28(sp)
80007568:	00912a23          	sw	s1,20(sp)
8000756c:	8d418913          	addi	s2,gp,-1836 # 80020334 <_syscall_table_end>
80007570:	afdfa0ef          	jal	ra,8000206c <rt_kprintf>
80007574:	00007997          	auipc	s3,0x7
80007578:	c6498993          	addi	s3,s3,-924 # 8000e1d8 <__fsym_hello_name+0x24>
8000757c:	8d01a403          	lw	s0,-1840(gp) # 80020330 <_syscall_table_begin>
80007580:	00007a17          	auipc	s4,0x7
80007584:	c60a0a13          	addi	s4,s4,-928 # 8000e1e0 <__fsym_hello_name+0x2c>
80007588:	00092783          	lw	a5,0(s2)
8000758c:	02f46a63          	bltu	s0,a5,800075c0 <msh_help+0x78>
80007590:	00006517          	auipc	a0,0x6
80007594:	18850513          	addi	a0,a0,392 # 8000d718 <__rti_finsh_system_init_name+0x24>
80007598:	ad5fa0ef          	jal	ra,8000206c <rt_kprintf>
8000759c:	01c12083          	lw	ra,28(sp)
800075a0:	01812403          	lw	s0,24(sp)
800075a4:	01412483          	lw	s1,20(sp)
800075a8:	01012903          	lw	s2,16(sp)
800075ac:	00c12983          	lw	s3,12(sp)
800075b0:	00812a03          	lw	s4,8(sp)
800075b4:	00000513          	li	a0,0
800075b8:	02010113          	addi	sp,sp,32
800075bc:	00008067          	ret
800075c0:	00042483          	lw	s1,0(s0)
800075c4:	00600613          	li	a2,6
800075c8:	00098593          	mv	a1,s3
800075cc:	00048513          	mv	a0,s1
800075d0:	279040ef          	jal	ra,8000c048 <strncmp>
800075d4:	00051a63          	bnez	a0,800075e8 <msh_help+0xa0>
800075d8:	00442603          	lw	a2,4(s0)
800075dc:	00648593          	addi	a1,s1,6
800075e0:	000a0513          	mv	a0,s4
800075e4:	a89fa0ef          	jal	ra,8000206c <rt_kprintf>
800075e8:	00c40413          	addi	s0,s0,12
800075ec:	f9dff06f          	j	80007588 <msh_help+0x40>

800075f0 <cmd_ps>:
800075f0:	ff010113          	addi	sp,sp,-16
800075f4:	00112623          	sw	ra,12(sp)
800075f8:	eb1fe0ef          	jal	ra,800064a8 <list_thread>
800075fc:	00c12083          	lw	ra,12(sp)
80007600:	00000513          	li	a0,0
80007604:	01010113          	addi	sp,sp,16
80007608:	00008067          	ret

8000760c <cmd_free>:
8000760c:	ff010113          	addi	sp,sp,-16
80007610:	00112623          	sw	ra,12(sp)
80007614:	c29fa0ef          	jal	ra,8000223c <list_mem>
80007618:	00c12083          	lw	ra,12(sp)
8000761c:	00000513          	li	a0,0
80007620:	01010113          	addi	sp,sp,16
80007624:	00008067          	ret

80007628 <msh_is_used>:
80007628:	8141a503          	lw	a0,-2028(gp) # 80020274 <__msh_state>
8000762c:	00008067          	ret

80007630 <msh_exec>:
80007630:	fb010113          	addi	sp,sp,-80
80007634:	04812423          	sw	s0,72(sp)
80007638:	04112623          	sw	ra,76(sp)
8000763c:	04912223          	sw	s1,68(sp)
80007640:	05212023          	sw	s2,64(sp)
80007644:	03312e23          	sw	s3,60(sp)
80007648:	03412c23          	sw	s4,56(sp)
8000764c:	03512a23          	sw	s5,52(sp)
80007650:	03612823          	sw	s6,48(sp)
80007654:	00050413          	mv	s0,a0
80007658:	00b505b3          	add	a1,a0,a1
8000765c:	02000693          	li	a3,32
80007660:	00900713          	li	a4,9
80007664:	00044783          	lbu	a5,0(s0)
80007668:	408584b3          	sub	s1,a1,s0
8000766c:	0cd78c63          	beq	a5,a3,80007744 <msh_exec+0x114>
80007670:	0ce78a63          	beq	a5,a4,80007744 <msh_exec+0x114>
80007674:	00000513          	li	a0,0
80007678:	16048663          	beqz	s1,800077e4 <msh_exec+0x1b4>
8000767c:	00000913          	li	s2,0
80007680:	02000713          	li	a4,32
80007684:	00900693          	li	a3,9
80007688:	012407b3          	add	a5,s0,s2
8000768c:	0007c783          	lbu	a5,0(a5)
80007690:	0ce78263          	beq	a5,a4,80007754 <msh_exec+0x124>
80007694:	0cd78063          	beq	a5,a3,80007754 <msh_exec+0x124>
80007698:	0a991a63          	bne	s2,s1,8000774c <msh_exec+0x11c>
8000769c:	8d01a983          	lw	s3,-1840(gp) # 80020330 <_syscall_table_begin>
800076a0:	8d41aa83          	lw	s5,-1836(gp) # 80020334 <_syscall_table_end>
800076a4:	00007b17          	auipc	s6,0x7
800076a8:	b34b0b13          	addi	s6,s6,-1228 # 8000e1d8 <__fsym_hello_name+0x24>
800076ac:	0b59f663          	bgeu	s3,s5,80007758 <msh_exec+0x128>
800076b0:	0009aa03          	lw	s4,0(s3)
800076b4:	00600613          	li	a2,6
800076b8:	000b0593          	mv	a1,s6
800076bc:	000a0513          	mv	a0,s4
800076c0:	189040ef          	jal	ra,8000c048 <strncmp>
800076c4:	0c051063          	bnez	a0,80007784 <msh_exec+0x154>
800076c8:	00090613          	mv	a2,s2
800076cc:	00040593          	mv	a1,s0
800076d0:	006a0513          	addi	a0,s4,6
800076d4:	175040ef          	jal	ra,8000c048 <strncmp>
800076d8:	0a051663          	bnez	a0,80007784 <msh_exec+0x154>
800076dc:	012a0a33          	add	s4,s4,s2
800076e0:	006a4783          	lbu	a5,6(s4)
800076e4:	0a079063          	bnez	a5,80007784 <msh_exec+0x154>
800076e8:	0089a983          	lw	s3,8(s3)
800076ec:	06098663          	beqz	s3,80007758 <msh_exec+0x128>
800076f0:	02800613          	li	a2,40
800076f4:	00000593          	li	a1,0
800076f8:	00810513          	addi	a0,sp,8
800076fc:	690040ef          	jal	ra,8000bd8c <memset>
80007700:	00810913          	addi	s2,sp,8
80007704:	00090693          	mv	a3,s2
80007708:	00040793          	mv	a5,s0
8000770c:	00000513          	li	a0,0
80007710:	00000713          	li	a4,0
80007714:	02000813          	li	a6,32
80007718:	00900893          	li	a7,9
8000771c:	00a00313          	li	t1,10
80007720:	02200613          	li	a2,34
80007724:	05c00e13          	li	t3,92
80007728:	0007c583          	lbu	a1,0(a5)
8000772c:	01058463          	beq	a1,a6,80007734 <msh_exec+0x104>
80007730:	07159663          	bne	a1,a7,8000779c <msh_exec+0x16c>
80007734:	04971c63          	bne	a4,s1,8000778c <msh_exec+0x15c>
80007738:	00a00793          	li	a5,10
8000773c:	06f50263          	beq	a0,a5,800077a0 <msh_exec+0x170>
80007740:	0f00006f          	j	80007830 <msh_exec+0x200>
80007744:	00140413          	addi	s0,s0,1
80007748:	f1dff06f          	j	80007664 <msh_exec+0x34>
8000774c:	00190913          	addi	s2,s2,1
80007750:	f39ff06f          	j	80007688 <msh_exec+0x58>
80007754:	f40914e3          	bnez	s2,8000769c <msh_exec+0x6c>
80007758:	00040793          	mv	a5,s0
8000775c:	0007c703          	lbu	a4,0(a5)
80007760:	0df77713          	andi	a4,a4,223
80007764:	12071c63          	bnez	a4,8000789c <msh_exec+0x26c>
80007768:	00007517          	auipc	a0,0x7
8000776c:	aa850513          	addi	a0,a0,-1368 # 8000e210 <__fsym_hello_name+0x5c>
80007770:	00078023          	sb	zero,0(a5)
80007774:	00040593          	mv	a1,s0
80007778:	8f5fa0ef          	jal	ra,8000206c <rt_kprintf>
8000777c:	fff00513          	li	a0,-1
80007780:	0640006f          	j	800077e4 <msh_exec+0x1b4>
80007784:	00c98993          	addi	s3,s3,12
80007788:	f25ff06f          	j	800076ac <msh_exec+0x7c>
8000778c:	00078023          	sb	zero,0(a5)
80007790:	00170713          	addi	a4,a4,1
80007794:	00178793          	addi	a5,a5,1
80007798:	f91ff06f          	j	80007728 <msh_exec+0xf8>
8000779c:	06651863          	bne	a0,t1,8000780c <msh_exec+0x1dc>
800077a0:	00007517          	auipc	a0,0x7
800077a4:	a4c50513          	addi	a0,a0,-1460 # 8000e1ec <__fsym_hello_name+0x38>
800077a8:	8c5fa0ef          	jal	ra,8000206c <rt_kprintf>
800077ac:	03010413          	addi	s0,sp,48
800077b0:	00007497          	auipc	s1,0x7
800077b4:	a5c48493          	addi	s1,s1,-1444 # 8000e20c <__fsym_hello_name+0x58>
800077b8:	00092583          	lw	a1,0(s2)
800077bc:	00048513          	mv	a0,s1
800077c0:	00490913          	addi	s2,s2,4
800077c4:	8a9fa0ef          	jal	ra,8000206c <rt_kprintf>
800077c8:	ff2418e3          	bne	s0,s2,800077b8 <msh_exec+0x188>
800077cc:	00006517          	auipc	a0,0x6
800077d0:	f4c50513          	addi	a0,a0,-180 # 8000d718 <__rti_finsh_system_init_name+0x24>
800077d4:	899fa0ef          	jal	ra,8000206c <rt_kprintf>
800077d8:	00a00513          	li	a0,10
800077dc:	00810593          	addi	a1,sp,8
800077e0:	000980e7          	jalr	s3
800077e4:	04c12083          	lw	ra,76(sp)
800077e8:	04812403          	lw	s0,72(sp)
800077ec:	04412483          	lw	s1,68(sp)
800077f0:	04012903          	lw	s2,64(sp)
800077f4:	03c12983          	lw	s3,60(sp)
800077f8:	03812a03          	lw	s4,56(sp)
800077fc:	03412a83          	lw	s5,52(sp)
80007800:	03012b03          	lw	s6,48(sp)
80007804:	05010113          	addi	sp,sp,80
80007808:	00008067          	ret
8000780c:	02977263          	bgeu	a4,s1,80007830 <msh_exec+0x200>
80007810:	00150513          	addi	a0,a0,1
80007814:	06c59063          	bne	a1,a2,80007874 <msh_exec+0x244>
80007818:	00178793          	addi	a5,a5,1
8000781c:	00170713          	addi	a4,a4,1
80007820:	00f6a023          	sw	a5,0(a3)
80007824:	0007c583          	lbu	a1,0(a5)
80007828:	02c58863          	beq	a1,a2,80007858 <msh_exec+0x228>
8000782c:	00976663          	bltu	a4,s1,80007838 <msh_exec+0x208>
80007830:	fa0516e3          	bnez	a0,800077dc <msh_exec+0x1ac>
80007834:	f25ff06f          	j	80007758 <msh_exec+0x128>
80007838:	0017ce83          	lbu	t4,1(a5)
8000783c:	01c59863          	bne	a1,t3,8000784c <msh_exec+0x21c>
80007840:	00ce9663          	bne	t4,a2,8000784c <msh_exec+0x21c>
80007844:	00178793          	addi	a5,a5,1
80007848:	00170713          	addi	a4,a4,1
8000784c:	00178793          	addi	a5,a5,1
80007850:	00170713          	addi	a4,a4,1
80007854:	fd1ff06f          	j	80007824 <msh_exec+0x1f4>
80007858:	fc977ce3          	bgeu	a4,s1,80007830 <msh_exec+0x200>
8000785c:	00078023          	sb	zero,0(a5)
80007860:	00170713          	addi	a4,a4,1
80007864:	00178793          	addi	a5,a5,1
80007868:	00468693          	addi	a3,a3,4
8000786c:	ea976ee3          	bltu	a4,s1,80007728 <msh_exec+0xf8>
80007870:	fc1ff06f          	j	80007830 <msh_exec+0x200>
80007874:	00f6a023          	sw	a5,0(a3)
80007878:	0007c583          	lbu	a1,0(a5)
8000787c:	01058c63          	beq	a1,a6,80007894 <msh_exec+0x264>
80007880:	01158a63          	beq	a1,a7,80007894 <msh_exec+0x264>
80007884:	fa9706e3          	beq	a4,s1,80007830 <msh_exec+0x200>
80007888:	00178793          	addi	a5,a5,1
8000788c:	00170713          	addi	a4,a4,1
80007890:	fe9ff06f          	j	80007878 <msh_exec+0x248>
80007894:	fc976ae3          	bltu	a4,s1,80007868 <msh_exec+0x238>
80007898:	f99ff06f          	j	80007830 <msh_exec+0x200>
8000789c:	00178793          	addi	a5,a5,1
800078a0:	ebdff06f          	j	8000775c <msh_exec+0x12c>

800078a4 <msh_auto_complete>:
800078a4:	00054783          	lbu	a5,0(a0)
800078a8:	00079863          	bnez	a5,800078b8 <msh_auto_complete+0x14>
800078ac:	00000593          	li	a1,0
800078b0:	00000513          	li	a0,0
800078b4:	c95ff06f          	j	80007548 <msh_help>
800078b8:	fd010113          	addi	sp,sp,-48
800078bc:	02912223          	sw	s1,36(sp)
800078c0:	03212023          	sw	s2,32(sp)
800078c4:	01312e23          	sw	s3,28(sp)
800078c8:	01412c23          	sw	s4,24(sp)
800078cc:	01512a23          	sw	s5,20(sp)
800078d0:	01612823          	sw	s6,16(sp)
800078d4:	01712623          	sw	s7,12(sp)
800078d8:	02112623          	sw	ra,44(sp)
800078dc:	02812423          	sw	s0,40(sp)
800078e0:	00050913          	mv	s2,a0
800078e4:	8d01aa03          	lw	s4,-1840(gp) # 80020330 <_syscall_table_begin>
800078e8:	00000993          	li	s3,0
800078ec:	00000493          	li	s1,0
800078f0:	8d418a93          	addi	s5,gp,-1836 # 80020334 <_syscall_table_end>
800078f4:	00007b17          	auipc	s6,0x7
800078f8:	8e4b0b13          	addi	s6,s6,-1820 # 8000e1d8 <__fsym_hello_name+0x24>
800078fc:	00007b97          	auipc	s7,0x7
80007900:	8ecb8b93          	addi	s7,s7,-1812 # 8000e1e8 <__fsym_hello_name+0x34>
80007904:	000aa783          	lw	a5,0(s5)
80007908:	04fa6063          	bltu	s4,a5,80007948 <msh_auto_complete+0xa4>
8000790c:	0c098863          	beqz	s3,800079dc <msh_auto_complete+0x138>
80007910:	02812403          	lw	s0,40(sp)
80007914:	02c12083          	lw	ra,44(sp)
80007918:	01812a03          	lw	s4,24(sp)
8000791c:	01412a83          	lw	s5,20(sp)
80007920:	01012b03          	lw	s6,16(sp)
80007924:	00c12b83          	lw	s7,12(sp)
80007928:	00048613          	mv	a2,s1
8000792c:	00098593          	mv	a1,s3
80007930:	02412483          	lw	s1,36(sp)
80007934:	01c12983          	lw	s3,28(sp)
80007938:	00090513          	mv	a0,s2
8000793c:	02012903          	lw	s2,32(sp)
80007940:	03010113          	addi	sp,sp,48
80007944:	8e4fa06f          	j	80001a28 <rt_strncpy>
80007948:	000a2403          	lw	s0,0(s4)
8000794c:	00600613          	li	a2,6
80007950:	000b0593          	mv	a1,s6
80007954:	00040513          	mv	a0,s0
80007958:	6f0040ef          	jal	ra,8000c048 <strncmp>
8000795c:	06051063          	bnez	a0,800079bc <msh_auto_complete+0x118>
80007960:	00090513          	mv	a0,s2
80007964:	6c8040ef          	jal	ra,8000c02c <strlen>
80007968:	00640413          	addi	s0,s0,6
8000796c:	00050613          	mv	a2,a0
80007970:	00040593          	mv	a1,s0
80007974:	00090513          	mv	a0,s2
80007978:	6d0040ef          	jal	ra,8000c048 <strncmp>
8000797c:	04051063          	bnez	a0,800079bc <msh_auto_complete+0x118>
80007980:	00049a63          	bnez	s1,80007994 <msh_auto_complete+0xf0>
80007984:	00040513          	mv	a0,s0
80007988:	6a4040ef          	jal	ra,8000c02c <strlen>
8000798c:	00050493          	mv	s1,a0
80007990:	00040993          	mv	s3,s0
80007994:	00098793          	mv	a5,s3
80007998:	00040713          	mv	a4,s0
8000799c:	0007c603          	lbu	a2,0(a5)
800079a0:	02061263          	bnez	a2,800079c4 <msh_auto_complete+0x120>
800079a4:	413787b3          	sub	a5,a5,s3
800079a8:	0097d463          	bge	a5,s1,800079b0 <msh_auto_complete+0x10c>
800079ac:	00078493          	mv	s1,a5
800079b0:	00040593          	mv	a1,s0
800079b4:	000b8513          	mv	a0,s7
800079b8:	eb4fa0ef          	jal	ra,8000206c <rt_kprintf>
800079bc:	00ca0a13          	addi	s4,s4,12
800079c0:	f45ff06f          	j	80007904 <msh_auto_complete+0x60>
800079c4:	00074683          	lbu	a3,0(a4)
800079c8:	fc068ee3          	beqz	a3,800079a4 <msh_auto_complete+0x100>
800079cc:	fcd61ce3          	bne	a2,a3,800079a4 <msh_auto_complete+0x100>
800079d0:	00178793          	addi	a5,a5,1
800079d4:	00170713          	addi	a4,a4,1
800079d8:	fc5ff06f          	j	8000799c <msh_auto_complete+0xf8>
800079dc:	02c12083          	lw	ra,44(sp)
800079e0:	02812403          	lw	s0,40(sp)
800079e4:	02412483          	lw	s1,36(sp)
800079e8:	02012903          	lw	s2,32(sp)
800079ec:	01c12983          	lw	s3,28(sp)
800079f0:	01812a03          	lw	s4,24(sp)
800079f4:	01412a83          	lw	s5,20(sp)
800079f8:	01012b03          	lw	s6,16(sp)
800079fc:	00c12b83          	lw	s7,12(sp)
80007a00:	03010113          	addi	sp,sp,48
80007a04:	00008067          	ret

80007a08 <finsh_type_check>:
80007a08:	16050263          	beqz	a0,80007b6c <finsh_type_check+0x164>
80007a0c:	ff010113          	addi	sp,sp,-16
80007a10:	00812423          	sw	s0,8(sp)
80007a14:	00912223          	sw	s1,4(sp)
80007a18:	00112623          	sw	ra,12(sp)
80007a1c:	00054683          	lbu	a3,0(a0)
80007a20:	00050413          	mv	s0,a0
80007a24:	00058493          	mv	s1,a1
80007a28:	fed68793          	addi	a5,a3,-19
80007a2c:	0ff7f713          	andi	a4,a5,255
80007a30:	00700793          	li	a5,7
80007a34:	01052503          	lw	a0,16(a0)
80007a38:	02e7e063          	bltu	a5,a4,80007a58 <finsh_type_check+0x50>
80007a3c:	08d00793          	li	a5,141
80007a40:	00e7d7b3          	srl	a5,a5,a4
80007a44:	0017f793          	andi	a5,a5,1
80007a48:	00800593          	li	a1,8
80007a4c:	00079e63          	bnez	a5,80007a68 <finsh_type_check+0x60>
80007a50:	01900793          	li	a5,25
80007a54:	00f68663          	beq	a3,a5,80007a60 <finsh_type_check+0x58>
80007a58:	00048593          	mv	a1,s1
80007a5c:	00c0006f          	j	80007a68 <finsh_type_check+0x60>
80007a60:	00000593          	li	a1,0
80007a64:	fe048ae3          	beqz	s1,80007a58 <finsh_type_check+0x50>
80007a68:	fa1ff0ef          	jal	ra,80007a08 <finsh_type_check>
80007a6c:	00c42503          	lw	a0,12(s0)
80007a70:	00000593          	li	a1,0
80007a74:	f95ff0ef          	jal	ra,80007a08 <finsh_type_check>
80007a78:	00244583          	lbu	a1,2(s0)
80007a7c:	00400793          	li	a5,4
80007a80:	00f58663          	beq	a1,a5,80007a8c <finsh_type_check+0x84>
80007a84:	0095e5b3          	or	a1,a1,s1
80007a88:	00b40123          	sb	a1,2(s0)
80007a8c:	01042783          	lw	a5,16(s0)
80007a90:	00078863          	beqz	a5,80007aa0 <finsh_type_check+0x98>
80007a94:	0017c783          	lbu	a5,1(a5)
80007a98:	00f400a3          	sb	a5,1(s0)
80007a9c:	0580006f          	j	80007af4 <finsh_type_check+0xec>
80007aa0:	00044783          	lbu	a5,0(s0)
80007aa4:	00100713          	li	a4,1
80007aa8:	0ae79063          	bne	a5,a4,80007b48 <finsh_type_check+0x140>
80007aac:	00244783          	lbu	a5,2(s0)
80007ab0:	0017f713          	andi	a4,a5,1
80007ab4:	06070e63          	beqz	a4,80007b30 <finsh_type_check+0x128>
80007ab8:	00842783          	lw	a5,8(s0)
80007abc:	02078c63          	beqz	a5,80007af4 <finsh_type_check+0xec>
80007ac0:	0117c783          	lbu	a5,17(a5)
80007ac4:	fff78793          	addi	a5,a5,-1
80007ac8:	0ff7f793          	andi	a5,a5,255
80007acc:	00d00713          	li	a4,13
80007ad0:	04f76a63          	bltu	a4,a5,80007b24 <finsh_type_check+0x11c>
80007ad4:	00007717          	auipc	a4,0x7
80007ad8:	81870713          	addi	a4,a4,-2024 # 8000e2ec <__fsym___cmd_exit_name+0xc>
80007adc:	00279793          	slli	a5,a5,0x2
80007ae0:	00e787b3          	add	a5,a5,a4
80007ae4:	0007a783          	lw	a5,0(a5)
80007ae8:	00e787b3          	add	a5,a5,a4
80007aec:	00078067          	jr	a5
80007af0:	000400a3          	sb	zero,1(s0)
80007af4:	00c12083          	lw	ra,12(sp)
80007af8:	00812403          	lw	s0,8(sp)
80007afc:	00412483          	lw	s1,4(sp)
80007b00:	00000513          	li	a0,0
80007b04:	01010113          	addi	sp,sp,16
80007b08:	00008067          	ret
80007b0c:	00100793          	li	a5,1
80007b10:	f89ff06f          	j	80007a98 <finsh_type_check+0x90>
80007b14:	00200793          	li	a5,2
80007b18:	f81ff06f          	j	80007a98 <finsh_type_check+0x90>
80007b1c:	00300793          	li	a5,3
80007b20:	f79ff06f          	j	80007a98 <finsh_type_check+0x90>
80007b24:	00300513          	li	a0,3
80007b28:	57c010ef          	jal	ra,800090a4 <finsh_error_set>
80007b2c:	fc9ff06f          	j	80007af4 <finsh_type_check+0xec>
80007b30:	0027f793          	andi	a5,a5,2
80007b34:	fc0780e3          	beqz	a5,80007af4 <finsh_type_check+0xec>
80007b38:	00842783          	lw	a5,8(s0)
80007b3c:	fa078ce3          	beqz	a5,80007af4 <finsh_type_check+0xec>
80007b40:	0087c783          	lbu	a5,8(a5)
80007b44:	f81ff06f          	j	80007ac4 <finsh_type_check+0xbc>
80007b48:	00200693          	li	a3,2
80007b4c:	00d79663          	bne	a5,a3,80007b58 <finsh_type_check+0x150>
80007b50:	00e400a3          	sb	a4,1(s0)
80007b54:	fa1ff06f          	j	80007af4 <finsh_type_check+0xec>
80007b58:	ffd78793          	addi	a5,a5,-3
80007b5c:	0ff7f793          	andi	a5,a5,255
80007b60:	00300713          	li	a4,3
80007b64:	f8f768e3          	bltu	a4,a5,80007af4 <finsh_type_check+0xec>
80007b68:	fe9ff06f          	j	80007b50 <finsh_type_check+0x148>
80007b6c:	00000513          	li	a0,0
80007b70:	00008067          	ret

80007b74 <finsh_compile>:
80007b74:	00051463          	bnez	a0,80007b7c <finsh_compile+0x8>
80007b78:	4680106f          	j	80008fe0 <finsh_compile+0x146c>
80007b7c:	ff010113          	addi	sp,sp,-16
80007b80:	00812423          	sw	s0,8(sp)
80007b84:	00050413          	mv	s0,a0
80007b88:	01052503          	lw	a0,16(a0)
80007b8c:	00112623          	sw	ra,12(sp)
80007b90:	00050463          	beqz	a0,80007b98 <finsh_compile+0x24>
80007b94:	fe1ff0ef          	jal	ra,80007b74 <finsh_compile>
80007b98:	00044783          	lbu	a5,0(s0)
80007b9c:	01a00713          	li	a4,26
80007ba0:	fff78793          	addi	a5,a5,-1
80007ba4:	0ff7f793          	andi	a5,a5,255
80007ba8:	00f77463          	bgeu	a4,a5,80007bb0 <finsh_compile+0x3c>
80007bac:	4280106f          	j	80008fd4 <finsh_compile+0x1460>
80007bb0:	00006717          	auipc	a4,0x6
80007bb4:	77470713          	addi	a4,a4,1908 # 8000e324 <__fsym___cmd_exit_name+0x44>
80007bb8:	00279793          	slli	a5,a5,0x2
80007bbc:	00e787b3          	add	a5,a5,a4
80007bc0:	0007a783          	lw	a5,0(a5)
80007bc4:	00e787b3          	add	a5,a5,a4
80007bc8:	00078067          	jr	a5
80007bcc:	00244703          	lbu	a4,2(s0)
80007bd0:	00477793          	andi	a5,a4,4
80007bd4:	08078663          	beqz	a5,80007c60 <finsh_compile+0xec>
80007bd8:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
80007bdc:	0007a703          	lw	a4,0(a5)
80007be0:	02400693          	li	a3,36
80007be4:	00d70023          	sb	a3,0(a4)
80007be8:	0007a703          	lw	a4,0(a5)
80007bec:	00170693          	addi	a3,a4,1
80007bf0:	00d7a023          	sw	a3,0(a5)
80007bf4:	00842683          	lw	a3,8(s0)
80007bf8:	0086a683          	lw	a3,8(a3)
80007bfc:	00d700a3          	sb	a3,1(a4)
80007c00:	00842703          	lw	a4,8(s0)
80007c04:	0007a683          	lw	a3,0(a5)
80007c08:	00872703          	lw	a4,8(a4)
80007c0c:	00875713          	srli	a4,a4,0x8
80007c10:	00e680a3          	sb	a4,1(a3)
80007c14:	00842683          	lw	a3,8(s0)
80007c18:	0007a703          	lw	a4,0(a5)
80007c1c:	00a6d683          	lhu	a3,10(a3)
80007c20:	00d70123          	sb	a3,2(a4)
80007c24:	00842683          	lw	a3,8(s0)
80007c28:	0007a703          	lw	a4,0(a5)
80007c2c:	00b6c683          	lbu	a3,11(a3)
80007c30:	00d701a3          	sb	a3,3(a4)
80007c34:	0007a703          	lw	a4,0(a5)
80007c38:	00470713          	addi	a4,a4,4
80007c3c:	00e7a023          	sw	a4,0(a5)
80007c40:	00c42503          	lw	a0,12(s0)
80007c44:	00050463          	beqz	a0,80007c4c <finsh_compile+0xd8>
80007c48:	f2dff0ef          	jal	ra,80007b74 <finsh_compile>
80007c4c:	00c12083          	lw	ra,12(sp)
80007c50:	00812403          	lw	s0,8(sp)
80007c54:	00000513          	li	a0,0
80007c58:	01010113          	addi	sp,sp,16
80007c5c:	00008067          	ret
80007c60:	00277693          	andi	a3,a4,2
80007c64:	00842783          	lw	a5,8(s0)
80007c68:	18068463          	beqz	a3,80007df0 <finsh_compile+0x27c>
80007c6c:	fc078ae3          	beqz	a5,80007c40 <finsh_compile+0xcc>
80007c70:	0087c683          	lbu	a3,8(a5)
80007c74:	00700613          	li	a2,7
80007c78:	08d66063          	bltu	a2,a3,80007cf8 <finsh_compile+0x184>
80007c7c:	00500613          	li	a2,5
80007c80:	0ed66c63          	bltu	a2,a3,80007d78 <finsh_compile+0x204>
80007c84:	08c68263          	beq	a3,a2,80007d08 <finsh_compile+0x194>
80007c88:	00200613          	li	a2,2
80007c8c:	fad67ae3          	bgeu	a2,a3,80007c40 <finsh_compile+0xcc>
80007c90:	8ec18693          	addi	a3,gp,-1812 # 8002034c <finsh_compile_pc>
80007c94:	00877713          	andi	a4,a4,8
80007c98:	0006a603          	lw	a2,0(a3)
80007c9c:	0c070a63          	beqz	a4,80007d70 <finsh_compile+0x1fc>
80007ca0:	02400713          	li	a4,36
80007ca4:	00e60023          	sb	a4,0(a2)
80007ca8:	0006a703          	lw	a4,0(a3)
80007cac:	00c7a603          	lw	a2,12(a5)
80007cb0:	00170713          	addi	a4,a4,1
80007cb4:	00e6a023          	sw	a4,0(a3)
80007cb8:	0006a703          	lw	a4,0(a3)
80007cbc:	00c70023          	sb	a2,0(a4)
80007cc0:	00c7a703          	lw	a4,12(a5)
80007cc4:	0006a603          	lw	a2,0(a3)
80007cc8:	00875713          	srli	a4,a4,0x8
80007ccc:	00e600a3          	sb	a4,1(a2)
80007cd0:	0006a703          	lw	a4,0(a3)
80007cd4:	00e7d603          	lhu	a2,14(a5)
80007cd8:	00c70123          	sb	a2,2(a4)
80007cdc:	0006a703          	lw	a4,0(a3)
80007ce0:	00f7c783          	lbu	a5,15(a5)
80007ce4:	00f701a3          	sb	a5,3(a4)
80007ce8:	0006a783          	lw	a5,0(a3)
80007cec:	00478793          	addi	a5,a5,4
80007cf0:	00f6a023          	sw	a5,0(a3)
80007cf4:	f4dff06f          	j	80007c40 <finsh_compile+0xcc>
80007cf8:	ff868693          	addi	a3,a3,-8
80007cfc:	0ff6f693          	andi	a3,a3,255
80007d00:	00600613          	li	a2,6
80007d04:	f2d66ee3          	bltu	a2,a3,80007c40 <finsh_compile+0xcc>
80007d08:	8ec18693          	addi	a3,gp,-1812 # 8002034c <finsh_compile_pc>
80007d0c:	00877713          	andi	a4,a4,8
80007d10:	0006a603          	lw	a2,0(a3)
80007d14:	0c070a63          	beqz	a4,80007de8 <finsh_compile+0x274>
80007d18:	02400713          	li	a4,36
80007d1c:	00e60023          	sb	a4,0(a2)
80007d20:	0006a703          	lw	a4,0(a3)
80007d24:	00c7a603          	lw	a2,12(a5)
80007d28:	00170713          	addi	a4,a4,1
80007d2c:	00e6a023          	sw	a4,0(a3)
80007d30:	0006a703          	lw	a4,0(a3)
80007d34:	00c70023          	sb	a2,0(a4)
80007d38:	00c7a703          	lw	a4,12(a5)
80007d3c:	0006a603          	lw	a2,0(a3)
80007d40:	00875713          	srli	a4,a4,0x8
80007d44:	00e600a3          	sb	a4,1(a2)
80007d48:	0006a703          	lw	a4,0(a3)
80007d4c:	00e7d603          	lhu	a2,14(a5)
80007d50:	00c70123          	sb	a2,2(a4)
80007d54:	0006a703          	lw	a4,0(a3)
80007d58:	00f7c783          	lbu	a5,15(a5)
80007d5c:	00f701a3          	sb	a5,3(a4)
80007d60:	0006a783          	lw	a5,0(a3)
80007d64:	00478793          	addi	a5,a5,4
80007d68:	00f6a023          	sw	a5,0(a3)
80007d6c:	ed5ff06f          	j	80007c40 <finsh_compile+0xcc>
80007d70:	02500713          	li	a4,37
80007d74:	f31ff06f          	j	80007ca4 <finsh_compile+0x130>
80007d78:	8ec18693          	addi	a3,gp,-1812 # 8002034c <finsh_compile_pc>
80007d7c:	00877713          	andi	a4,a4,8
80007d80:	0006a603          	lw	a2,0(a3)
80007d84:	04070e63          	beqz	a4,80007de0 <finsh_compile+0x26c>
80007d88:	02400713          	li	a4,36
80007d8c:	00e60023          	sb	a4,0(a2)
80007d90:	0006a703          	lw	a4,0(a3)
80007d94:	00c7a603          	lw	a2,12(a5)
80007d98:	00170713          	addi	a4,a4,1
80007d9c:	00e6a023          	sw	a4,0(a3)
80007da0:	0006a703          	lw	a4,0(a3)
80007da4:	00c70023          	sb	a2,0(a4)
80007da8:	00c7a703          	lw	a4,12(a5)
80007dac:	0006a603          	lw	a2,0(a3)
80007db0:	00875713          	srli	a4,a4,0x8
80007db4:	00e600a3          	sb	a4,1(a2)
80007db8:	0006a703          	lw	a4,0(a3)
80007dbc:	00e7d603          	lhu	a2,14(a5)
80007dc0:	00c70123          	sb	a2,2(a4)
80007dc4:	0006a703          	lw	a4,0(a3)
80007dc8:	00f7c783          	lbu	a5,15(a5)
80007dcc:	00f701a3          	sb	a5,3(a4)
80007dd0:	0006a783          	lw	a5,0(a3)
80007dd4:	00478793          	addi	a5,a5,4
80007dd8:	00f6a023          	sw	a5,0(a3)
80007ddc:	e65ff06f          	j	80007c40 <finsh_compile+0xcc>
80007de0:	02600713          	li	a4,38
80007de4:	fa9ff06f          	j	80007d8c <finsh_compile+0x218>
80007de8:	02700713          	li	a4,39
80007dec:	f31ff06f          	j	80007d1c <finsh_compile+0x1a8>
80007df0:	e40788e3          	beqz	a5,80007c40 <finsh_compile+0xcc>
80007df4:	0117c683          	lbu	a3,17(a5)
80007df8:	00700613          	li	a2,7
80007dfc:	06d66e63          	bltu	a2,a3,80007e78 <finsh_compile+0x304>
80007e00:	00500613          	li	a2,5
80007e04:	0ed66863          	bltu	a2,a3,80007ef4 <finsh_compile+0x380>
80007e08:	08c68063          	beq	a3,a2,80007e88 <finsh_compile+0x314>
80007e0c:	00200613          	li	a2,2
80007e10:	e2d678e3          	bgeu	a2,a3,80007c40 <finsh_compile+0xcc>
80007e14:	8ec18693          	addi	a3,gp,-1812 # 8002034c <finsh_compile_pc>
80007e18:	00877713          	andi	a4,a4,8
80007e1c:	0006a603          	lw	a2,0(a3)
80007e20:	0c070663          	beqz	a4,80007eec <finsh_compile+0x378>
80007e24:	02400713          	li	a4,36
80007e28:	00e60023          	sb	a4,0(a2)
80007e2c:	0006a703          	lw	a4,0(a3)
80007e30:	01478793          	addi	a5,a5,20
80007e34:	0087d613          	srli	a2,a5,0x8
80007e38:	00170713          	addi	a4,a4,1
80007e3c:	00e6a023          	sw	a4,0(a3)
80007e40:	0006a703          	lw	a4,0(a3)
80007e44:	00f70023          	sb	a5,0(a4)
80007e48:	0006a703          	lw	a4,0(a3)
80007e4c:	00c700a3          	sb	a2,1(a4)
80007e50:	0006a703          	lw	a4,0(a3)
80007e54:	0107d613          	srli	a2,a5,0x10
80007e58:	0187d793          	srli	a5,a5,0x18
80007e5c:	00c70123          	sb	a2,2(a4)
80007e60:	0006a703          	lw	a4,0(a3)
80007e64:	00f701a3          	sb	a5,3(a4)
80007e68:	0006a783          	lw	a5,0(a3)
80007e6c:	00478793          	addi	a5,a5,4
80007e70:	00f6a023          	sw	a5,0(a3)
80007e74:	dcdff06f          	j	80007c40 <finsh_compile+0xcc>
80007e78:	ff868693          	addi	a3,a3,-8
80007e7c:	0ff6f693          	andi	a3,a3,255
80007e80:	00600613          	li	a2,6
80007e84:	dad66ee3          	bltu	a2,a3,80007c40 <finsh_compile+0xcc>
80007e88:	8ec18693          	addi	a3,gp,-1812 # 8002034c <finsh_compile_pc>
80007e8c:	00877713          	andi	a4,a4,8
80007e90:	0006a603          	lw	a2,0(a3)
80007e94:	0c070663          	beqz	a4,80007f60 <finsh_compile+0x3ec>
80007e98:	02400713          	li	a4,36
80007e9c:	00e60023          	sb	a4,0(a2)
80007ea0:	0006a703          	lw	a4,0(a3)
80007ea4:	01478793          	addi	a5,a5,20
80007ea8:	0087d613          	srli	a2,a5,0x8
80007eac:	00170713          	addi	a4,a4,1
80007eb0:	00e6a023          	sw	a4,0(a3)
80007eb4:	0006a703          	lw	a4,0(a3)
80007eb8:	00f70023          	sb	a5,0(a4)
80007ebc:	0006a703          	lw	a4,0(a3)
80007ec0:	00c700a3          	sb	a2,1(a4)
80007ec4:	0006a703          	lw	a4,0(a3)
80007ec8:	0107d613          	srli	a2,a5,0x10
80007ecc:	0187d793          	srli	a5,a5,0x18
80007ed0:	00c70123          	sb	a2,2(a4)
80007ed4:	0006a703          	lw	a4,0(a3)
80007ed8:	00f701a3          	sb	a5,3(a4)
80007edc:	0006a783          	lw	a5,0(a3)
80007ee0:	00478793          	addi	a5,a5,4
80007ee4:	00f6a023          	sw	a5,0(a3)
80007ee8:	d59ff06f          	j	80007c40 <finsh_compile+0xcc>
80007eec:	02500713          	li	a4,37
80007ef0:	f39ff06f          	j	80007e28 <finsh_compile+0x2b4>
80007ef4:	8ec18693          	addi	a3,gp,-1812 # 8002034c <finsh_compile_pc>
80007ef8:	00877713          	andi	a4,a4,8
80007efc:	0006a603          	lw	a2,0(a3)
80007f00:	04070c63          	beqz	a4,80007f58 <finsh_compile+0x3e4>
80007f04:	02400713          	li	a4,36
80007f08:	00e60023          	sb	a4,0(a2)
80007f0c:	0006a703          	lw	a4,0(a3)
80007f10:	01478793          	addi	a5,a5,20
80007f14:	0087d613          	srli	a2,a5,0x8
80007f18:	00170713          	addi	a4,a4,1
80007f1c:	00e6a023          	sw	a4,0(a3)
80007f20:	0006a703          	lw	a4,0(a3)
80007f24:	00f70023          	sb	a5,0(a4)
80007f28:	0006a703          	lw	a4,0(a3)
80007f2c:	00c700a3          	sb	a2,1(a4)
80007f30:	0006a703          	lw	a4,0(a3)
80007f34:	0107d613          	srli	a2,a5,0x10
80007f38:	0187d793          	srli	a5,a5,0x18
80007f3c:	00c70123          	sb	a2,2(a4)
80007f40:	0006a703          	lw	a4,0(a3)
80007f44:	00f701a3          	sb	a5,3(a4)
80007f48:	0006a783          	lw	a5,0(a3)
80007f4c:	00478793          	addi	a5,a5,4
80007f50:	00f6a023          	sw	a5,0(a3)
80007f54:	cedff06f          	j	80007c40 <finsh_compile+0xcc>
80007f58:	02600713          	li	a4,38
80007f5c:	fadff06f          	j	80007f08 <finsh_compile+0x394>
80007f60:	02700713          	li	a4,39
80007f64:	f39ff06f          	j	80007e9c <finsh_compile+0x328>
80007f68:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
80007f6c:	0007a703          	lw	a4,0(a5)
80007f70:	02200693          	li	a3,34
80007f74:	00d70023          	sb	a3,0(a4)
80007f78:	0007a703          	lw	a4,0(a5)
80007f7c:	00170693          	addi	a3,a4,1
80007f80:	00d7a023          	sw	a3,0(a5)
80007f84:	00444683          	lbu	a3,4(s0)
80007f88:	00d700a3          	sb	a3,1(a4)
80007f8c:	0007a703          	lw	a4,0(a5)
80007f90:	00170713          	addi	a4,a4,1
80007f94:	00e7a023          	sw	a4,0(a5)
80007f98:	ca9ff06f          	j	80007c40 <finsh_compile+0xcc>
80007f9c:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
80007fa0:	0007a703          	lw	a4,0(a5)
80007fa4:	02400693          	li	a3,36
80007fa8:	00d70023          	sb	a3,0(a4)
80007fac:	0007a703          	lw	a4,0(a5)
80007fb0:	00170693          	addi	a3,a4,1
80007fb4:	00d7a023          	sw	a3,0(a5)
80007fb8:	00442683          	lw	a3,4(s0)
80007fbc:	00d700a3          	sb	a3,1(a4)
80007fc0:	00442703          	lw	a4,4(s0)
80007fc4:	0007a683          	lw	a3,0(a5)
80007fc8:	00875713          	srli	a4,a4,0x8
80007fcc:	00e680a3          	sb	a4,1(a3)
80007fd0:	0007a703          	lw	a4,0(a5)
80007fd4:	00645683          	lhu	a3,6(s0)
80007fd8:	00d70123          	sb	a3,2(a4)
80007fdc:	0007a703          	lw	a4,0(a5)
80007fe0:	00744683          	lbu	a3,7(s0)
80007fe4:	00d701a3          	sb	a3,3(a4)
80007fe8:	0007a703          	lw	a4,0(a5)
80007fec:	00470713          	addi	a4,a4,4
80007ff0:	00e7a023          	sw	a4,0(a5)
80007ff4:	c4dff06f          	j	80007c40 <finsh_compile+0xcc>
80007ff8:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
80007ffc:	0007a703          	lw	a4,0(a5)
80008000:	02400693          	li	a3,36
80008004:	00d70023          	sb	a3,0(a4)
80008008:	0007a703          	lw	a4,0(a5)
8000800c:	00170693          	addi	a3,a4,1
80008010:	00d7a023          	sw	a3,0(a5)
80008014:	00442683          	lw	a3,4(s0)
80008018:	00d700a3          	sb	a3,1(a4)
8000801c:	00442703          	lw	a4,4(s0)
80008020:	0007a683          	lw	a3,0(a5)
80008024:	00875713          	srli	a4,a4,0x8
80008028:	00e680a3          	sb	a4,1(a3)
8000802c:	0007a703          	lw	a4,0(a5)
80008030:	00645683          	lhu	a3,6(s0)
80008034:	00d70123          	sb	a3,2(a4)
80008038:	0007a703          	lw	a4,0(a5)
8000803c:	00744683          	lbu	a3,7(s0)
80008040:	00d701a3          	sb	a3,3(a4)
80008044:	0007a703          	lw	a4,0(a5)
80008048:	00470713          	addi	a4,a4,4
8000804c:	00e7a023          	sw	a4,0(a5)
80008050:	bf1ff06f          	j	80007c40 <finsh_compile+0xcc>
80008054:	00144783          	lbu	a5,1(s0)
80008058:	00100713          	li	a4,1
8000805c:	02e79063          	bne	a5,a4,8000807c <finsh_compile+0x508>
80008060:	8ec18713          	addi	a4,gp,-1812 # 8002034c <finsh_compile_pc>
80008064:	00072683          	lw	a3,0(a4)
80008068:	00f68023          	sb	a5,0(a3)
8000806c:	00072783          	lw	a5,0(a4)
80008070:	00178793          	addi	a5,a5,1
80008074:	00f72023          	sw	a5,0(a4)
80008078:	bc9ff06f          	j	80007c40 <finsh_compile+0xcc>
8000807c:	00200713          	li	a4,2
80008080:	02e79063          	bne	a5,a4,800080a0 <finsh_compile+0x52c>
80008084:	8ec18713          	addi	a4,gp,-1812 # 8002034c <finsh_compile_pc>
80008088:	00072683          	lw	a3,0(a4)
8000808c:	00f68023          	sb	a5,0(a3)
80008090:	00072783          	lw	a5,0(a4)
80008094:	00178793          	addi	a5,a5,1
80008098:	00f72023          	sw	a5,0(a4)
8000809c:	ba5ff06f          	j	80007c40 <finsh_compile+0xcc>
800080a0:	00300713          	li	a4,3
800080a4:	b8e79ee3          	bne	a5,a4,80007c40 <finsh_compile+0xcc>
800080a8:	8ec18713          	addi	a4,gp,-1812 # 8002034c <finsh_compile_pc>
800080ac:	00072683          	lw	a3,0(a4)
800080b0:	00f68023          	sb	a5,0(a3)
800080b4:	00072783          	lw	a5,0(a4)
800080b8:	00178793          	addi	a5,a5,1
800080bc:	00f72023          	sw	a5,0(a4)
800080c0:	b81ff06f          	j	80007c40 <finsh_compile+0xcc>
800080c4:	00144783          	lbu	a5,1(s0)
800080c8:	00100713          	li	a4,1
800080cc:	02e79263          	bne	a5,a4,800080f0 <finsh_compile+0x57c>
800080d0:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
800080d4:	0007a703          	lw	a4,0(a5)
800080d8:	00400693          	li	a3,4
800080dc:	00d70023          	sb	a3,0(a4)
800080e0:	0007a703          	lw	a4,0(a5)
800080e4:	00170713          	addi	a4,a4,1
800080e8:	00e7a023          	sw	a4,0(a5)
800080ec:	b55ff06f          	j	80007c40 <finsh_compile+0xcc>
800080f0:	00200713          	li	a4,2
800080f4:	02e79263          	bne	a5,a4,80008118 <finsh_compile+0x5a4>
800080f8:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
800080fc:	0007a703          	lw	a4,0(a5)
80008100:	00500693          	li	a3,5
80008104:	00d70023          	sb	a3,0(a4)
80008108:	0007a703          	lw	a4,0(a5)
8000810c:	00170713          	addi	a4,a4,1
80008110:	00e7a023          	sw	a4,0(a5)
80008114:	b2dff06f          	j	80007c40 <finsh_compile+0xcc>
80008118:	00300713          	li	a4,3
8000811c:	b2e792e3          	bne	a5,a4,80007c40 <finsh_compile+0xcc>
80008120:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
80008124:	0007a703          	lw	a4,0(a5)
80008128:	00600693          	li	a3,6
8000812c:	00d70023          	sb	a3,0(a4)
80008130:	0007a703          	lw	a4,0(a5)
80008134:	00170713          	addi	a4,a4,1
80008138:	00e7a023          	sw	a4,0(a5)
8000813c:	b05ff06f          	j	80007c40 <finsh_compile+0xcc>
80008140:	00144783          	lbu	a5,1(s0)
80008144:	00100713          	li	a4,1
80008148:	02e79263          	bne	a5,a4,8000816c <finsh_compile+0x5f8>
8000814c:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
80008150:	0007a703          	lw	a4,0(a5)
80008154:	00d00693          	li	a3,13
80008158:	00d70023          	sb	a3,0(a4)
8000815c:	0007a703          	lw	a4,0(a5)
80008160:	00170713          	addi	a4,a4,1
80008164:	00e7a023          	sw	a4,0(a5)
80008168:	ad9ff06f          	j	80007c40 <finsh_compile+0xcc>
8000816c:	00200713          	li	a4,2
80008170:	02e79263          	bne	a5,a4,80008194 <finsh_compile+0x620>
80008174:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
80008178:	0007a703          	lw	a4,0(a5)
8000817c:	00e00693          	li	a3,14
80008180:	00d70023          	sb	a3,0(a4)
80008184:	0007a703          	lw	a4,0(a5)
80008188:	00170713          	addi	a4,a4,1
8000818c:	00e7a023          	sw	a4,0(a5)
80008190:	ab1ff06f          	j	80007c40 <finsh_compile+0xcc>
80008194:	00300713          	li	a4,3
80008198:	aae794e3          	bne	a5,a4,80007c40 <finsh_compile+0xcc>
8000819c:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
800081a0:	0007a703          	lw	a4,0(a5)
800081a4:	00f00693          	li	a3,15
800081a8:	00d70023          	sb	a3,0(a4)
800081ac:	0007a703          	lw	a4,0(a5)
800081b0:	00170713          	addi	a4,a4,1
800081b4:	00e7a023          	sw	a4,0(a5)
800081b8:	a89ff06f          	j	80007c40 <finsh_compile+0xcc>
800081bc:	00144783          	lbu	a5,1(s0)
800081c0:	00100713          	li	a4,1
800081c4:	02e79263          	bne	a5,a4,800081e8 <finsh_compile+0x674>
800081c8:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
800081cc:	0007a703          	lw	a4,0(a5)
800081d0:	00700693          	li	a3,7
800081d4:	00d70023          	sb	a3,0(a4)
800081d8:	0007a703          	lw	a4,0(a5)
800081dc:	00170713          	addi	a4,a4,1
800081e0:	00e7a023          	sw	a4,0(a5)
800081e4:	a5dff06f          	j	80007c40 <finsh_compile+0xcc>
800081e8:	00200713          	li	a4,2
800081ec:	02e79263          	bne	a5,a4,80008210 <finsh_compile+0x69c>
800081f0:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
800081f4:	0007a703          	lw	a4,0(a5)
800081f8:	00800693          	li	a3,8
800081fc:	00d70023          	sb	a3,0(a4)
80008200:	0007a703          	lw	a4,0(a5)
80008204:	00170713          	addi	a4,a4,1
80008208:	00e7a023          	sw	a4,0(a5)
8000820c:	a35ff06f          	j	80007c40 <finsh_compile+0xcc>
80008210:	00300713          	li	a4,3
80008214:	a2e796e3          	bne	a5,a4,80007c40 <finsh_compile+0xcc>
80008218:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
8000821c:	0007a703          	lw	a4,0(a5)
80008220:	00900693          	li	a3,9
80008224:	00d70023          	sb	a3,0(a4)
80008228:	0007a703          	lw	a4,0(a5)
8000822c:	00170713          	addi	a4,a4,1
80008230:	00e7a023          	sw	a4,0(a5)
80008234:	a0dff06f          	j	80007c40 <finsh_compile+0xcc>
80008238:	00144783          	lbu	a5,1(s0)
8000823c:	00100713          	li	a4,1
80008240:	02e79263          	bne	a5,a4,80008264 <finsh_compile+0x6f0>
80008244:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
80008248:	0007a703          	lw	a4,0(a5)
8000824c:	00a00693          	li	a3,10
80008250:	00d70023          	sb	a3,0(a4)
80008254:	0007a703          	lw	a4,0(a5)
80008258:	00170713          	addi	a4,a4,1
8000825c:	00e7a023          	sw	a4,0(a5)
80008260:	9e1ff06f          	j	80007c40 <finsh_compile+0xcc>
80008264:	00200713          	li	a4,2
80008268:	02e79263          	bne	a5,a4,8000828c <finsh_compile+0x718>
8000826c:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
80008270:	0007a703          	lw	a4,0(a5)
80008274:	00b00693          	li	a3,11
80008278:	00d70023          	sb	a3,0(a4)
8000827c:	0007a703          	lw	a4,0(a5)
80008280:	00170713          	addi	a4,a4,1
80008284:	00e7a023          	sw	a4,0(a5)
80008288:	9b9ff06f          	j	80007c40 <finsh_compile+0xcc>
8000828c:	00300713          	li	a4,3
80008290:	9ae798e3          	bne	a5,a4,80007c40 <finsh_compile+0xcc>
80008294:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
80008298:	0007a703          	lw	a4,0(a5)
8000829c:	00c00693          	li	a3,12
800082a0:	00d70023          	sb	a3,0(a4)
800082a4:	0007a703          	lw	a4,0(a5)
800082a8:	00170713          	addi	a4,a4,1
800082ac:	00e7a023          	sw	a4,0(a5)
800082b0:	991ff06f          	j	80007c40 <finsh_compile+0xcc>
800082b4:	00144783          	lbu	a5,1(s0)
800082b8:	00100713          	li	a4,1
800082bc:	02e79263          	bne	a5,a4,800082e0 <finsh_compile+0x76c>
800082c0:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
800082c4:	0007a703          	lw	a4,0(a5)
800082c8:	01000693          	li	a3,16
800082cc:	00d70023          	sb	a3,0(a4)
800082d0:	0007a703          	lw	a4,0(a5)
800082d4:	00170713          	addi	a4,a4,1
800082d8:	00e7a023          	sw	a4,0(a5)
800082dc:	965ff06f          	j	80007c40 <finsh_compile+0xcc>
800082e0:	00200713          	li	a4,2
800082e4:	02e79263          	bne	a5,a4,80008308 <finsh_compile+0x794>
800082e8:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
800082ec:	0007a703          	lw	a4,0(a5)
800082f0:	01100693          	li	a3,17
800082f4:	00d70023          	sb	a3,0(a4)
800082f8:	0007a703          	lw	a4,0(a5)
800082fc:	00170713          	addi	a4,a4,1
80008300:	00e7a023          	sw	a4,0(a5)
80008304:	93dff06f          	j	80007c40 <finsh_compile+0xcc>
80008308:	00300713          	li	a4,3
8000830c:	92e79ae3          	bne	a5,a4,80007c40 <finsh_compile+0xcc>
80008310:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
80008314:	0007a703          	lw	a4,0(a5)
80008318:	01200693          	li	a3,18
8000831c:	00d70023          	sb	a3,0(a4)
80008320:	0007a703          	lw	a4,0(a5)
80008324:	00170713          	addi	a4,a4,1
80008328:	00e7a023          	sw	a4,0(a5)
8000832c:	915ff06f          	j	80007c40 <finsh_compile+0xcc>
80008330:	00144783          	lbu	a5,1(s0)
80008334:	00100713          	li	a4,1
80008338:	02e79263          	bne	a5,a4,8000835c <finsh_compile+0x7e8>
8000833c:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
80008340:	0007a703          	lw	a4,0(a5)
80008344:	01300693          	li	a3,19
80008348:	00d70023          	sb	a3,0(a4)
8000834c:	0007a703          	lw	a4,0(a5)
80008350:	00170713          	addi	a4,a4,1
80008354:	00e7a023          	sw	a4,0(a5)
80008358:	8e9ff06f          	j	80007c40 <finsh_compile+0xcc>
8000835c:	00200713          	li	a4,2
80008360:	02e79263          	bne	a5,a4,80008384 <finsh_compile+0x810>
80008364:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
80008368:	0007a703          	lw	a4,0(a5)
8000836c:	01400693          	li	a3,20
80008370:	00d70023          	sb	a3,0(a4)
80008374:	0007a703          	lw	a4,0(a5)
80008378:	00170713          	addi	a4,a4,1
8000837c:	00e7a023          	sw	a4,0(a5)
80008380:	8c1ff06f          	j	80007c40 <finsh_compile+0xcc>
80008384:	00300713          	li	a4,3
80008388:	8ae79ce3          	bne	a5,a4,80007c40 <finsh_compile+0xcc>
8000838c:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
80008390:	0007a703          	lw	a4,0(a5)
80008394:	01500693          	li	a3,21
80008398:	00d70023          	sb	a3,0(a4)
8000839c:	0007a703          	lw	a4,0(a5)
800083a0:	00170713          	addi	a4,a4,1
800083a4:	00e7a023          	sw	a4,0(a5)
800083a8:	899ff06f          	j	80007c40 <finsh_compile+0xcc>
800083ac:	00144783          	lbu	a5,1(s0)
800083b0:	00100713          	li	a4,1
800083b4:	02e79263          	bne	a5,a4,800083d8 <finsh_compile+0x864>
800083b8:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
800083bc:	0007a703          	lw	a4,0(a5)
800083c0:	01600693          	li	a3,22
800083c4:	00d70023          	sb	a3,0(a4)
800083c8:	0007a703          	lw	a4,0(a5)
800083cc:	00170713          	addi	a4,a4,1
800083d0:	00e7a023          	sw	a4,0(a5)
800083d4:	86dff06f          	j	80007c40 <finsh_compile+0xcc>
800083d8:	00200713          	li	a4,2
800083dc:	02e79263          	bne	a5,a4,80008400 <finsh_compile+0x88c>
800083e0:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
800083e4:	0007a703          	lw	a4,0(a5)
800083e8:	01700693          	li	a3,23
800083ec:	00d70023          	sb	a3,0(a4)
800083f0:	0007a703          	lw	a4,0(a5)
800083f4:	00170713          	addi	a4,a4,1
800083f8:	00e7a023          	sw	a4,0(a5)
800083fc:	845ff06f          	j	80007c40 <finsh_compile+0xcc>
80008400:	00300713          	li	a4,3
80008404:	82e79ee3          	bne	a5,a4,80007c40 <finsh_compile+0xcc>
80008408:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
8000840c:	0007a703          	lw	a4,0(a5)
80008410:	01800693          	li	a3,24
80008414:	00d70023          	sb	a3,0(a4)
80008418:	0007a703          	lw	a4,0(a5)
8000841c:	00170713          	addi	a4,a4,1
80008420:	00e7a023          	sw	a4,0(a5)
80008424:	81dff06f          	j	80007c40 <finsh_compile+0xcc>
80008428:	00144783          	lbu	a5,1(s0)
8000842c:	00100713          	li	a4,1
80008430:	02e79263          	bne	a5,a4,80008454 <finsh_compile+0x8e0>
80008434:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
80008438:	0007a703          	lw	a4,0(a5)
8000843c:	01900693          	li	a3,25
80008440:	00d70023          	sb	a3,0(a4)
80008444:	0007a703          	lw	a4,0(a5)
80008448:	00170713          	addi	a4,a4,1
8000844c:	00e7a023          	sw	a4,0(a5)
80008450:	ff0ff06f          	j	80007c40 <finsh_compile+0xcc>
80008454:	00200713          	li	a4,2
80008458:	02e79263          	bne	a5,a4,8000847c <finsh_compile+0x908>
8000845c:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
80008460:	0007a703          	lw	a4,0(a5)
80008464:	01a00693          	li	a3,26
80008468:	00d70023          	sb	a3,0(a4)
8000846c:	0007a703          	lw	a4,0(a5)
80008470:	00170713          	addi	a4,a4,1
80008474:	00e7a023          	sw	a4,0(a5)
80008478:	fc8ff06f          	j	80007c40 <finsh_compile+0xcc>
8000847c:	00300713          	li	a4,3
80008480:	fce79063          	bne	a5,a4,80007c40 <finsh_compile+0xcc>
80008484:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
80008488:	0007a703          	lw	a4,0(a5)
8000848c:	01b00693          	li	a3,27
80008490:	00d70023          	sb	a3,0(a4)
80008494:	0007a703          	lw	a4,0(a5)
80008498:	00170713          	addi	a4,a4,1
8000849c:	00e7a023          	sw	a4,0(a5)
800084a0:	fa0ff06f          	j	80007c40 <finsh_compile+0xcc>
800084a4:	00144783          	lbu	a5,1(s0)
800084a8:	00100713          	li	a4,1
800084ac:	02e79263          	bne	a5,a4,800084d0 <finsh_compile+0x95c>
800084b0:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
800084b4:	0007a703          	lw	a4,0(a5)
800084b8:	01c00693          	li	a3,28
800084bc:	00d70023          	sb	a3,0(a4)
800084c0:	0007a703          	lw	a4,0(a5)
800084c4:	00170713          	addi	a4,a4,1
800084c8:	00e7a023          	sw	a4,0(a5)
800084cc:	f74ff06f          	j	80007c40 <finsh_compile+0xcc>
800084d0:	00200713          	li	a4,2
800084d4:	02e79263          	bne	a5,a4,800084f8 <finsh_compile+0x984>
800084d8:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
800084dc:	0007a703          	lw	a4,0(a5)
800084e0:	01d00693          	li	a3,29
800084e4:	00d70023          	sb	a3,0(a4)
800084e8:	0007a703          	lw	a4,0(a5)
800084ec:	00170713          	addi	a4,a4,1
800084f0:	00e7a023          	sw	a4,0(a5)
800084f4:	f4cff06f          	j	80007c40 <finsh_compile+0xcc>
800084f8:	00300713          	li	a4,3
800084fc:	f4e79263          	bne	a5,a4,80007c40 <finsh_compile+0xcc>
80008500:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
80008504:	0007a703          	lw	a4,0(a5)
80008508:	01e00693          	li	a3,30
8000850c:	00d70023          	sb	a3,0(a4)
80008510:	0007a703          	lw	a4,0(a5)
80008514:	00170713          	addi	a4,a4,1
80008518:	00e7a023          	sw	a4,0(a5)
8000851c:	f24ff06f          	j	80007c40 <finsh_compile+0xcc>
80008520:	00144783          	lbu	a5,1(s0)
80008524:	00100713          	li	a4,1
80008528:	02e79263          	bne	a5,a4,8000854c <finsh_compile+0x9d8>
8000852c:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
80008530:	0007a703          	lw	a4,0(a5)
80008534:	01f00693          	li	a3,31
80008538:	00d70023          	sb	a3,0(a4)
8000853c:	0007a703          	lw	a4,0(a5)
80008540:	00170713          	addi	a4,a4,1
80008544:	00e7a023          	sw	a4,0(a5)
80008548:	ef8ff06f          	j	80007c40 <finsh_compile+0xcc>
8000854c:	00200713          	li	a4,2
80008550:	02e79263          	bne	a5,a4,80008574 <finsh_compile+0xa00>
80008554:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
80008558:	0007a703          	lw	a4,0(a5)
8000855c:	02000693          	li	a3,32
80008560:	00d70023          	sb	a3,0(a4)
80008564:	0007a703          	lw	a4,0(a5)
80008568:	00170713          	addi	a4,a4,1
8000856c:	00e7a023          	sw	a4,0(a5)
80008570:	ed0ff06f          	j	80007c40 <finsh_compile+0xcc>
80008574:	00300713          	li	a4,3
80008578:	ece79463          	bne	a5,a4,80007c40 <finsh_compile+0xcc>
8000857c:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
80008580:	0007a703          	lw	a4,0(a5)
80008584:	02100693          	li	a3,33
80008588:	00d70023          	sb	a3,0(a4)
8000858c:	0007a703          	lw	a4,0(a5)
80008590:	00170713          	addi	a4,a4,1
80008594:	00e7a023          	sw	a4,0(a5)
80008598:	ea8ff06f          	j	80007c40 <finsh_compile+0xcc>
8000859c:	01042783          	lw	a5,16(s0)
800085a0:	ea078063          	beqz	a5,80007c40 <finsh_compile+0xcc>
800085a4:	00c7a783          	lw	a5,12(a5)
800085a8:	00000713          	li	a4,0
800085ac:	02079a63          	bnez	a5,800085e0 <finsh_compile+0xa6c>
800085b0:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
800085b4:	0007a683          	lw	a3,0(a5)
800085b8:	02c00613          	li	a2,44
800085bc:	00c68023          	sb	a2,0(a3)
800085c0:	0007a683          	lw	a3,0(a5)
800085c4:	00168613          	addi	a2,a3,1
800085c8:	00c7a023          	sw	a2,0(a5)
800085cc:	00e680a3          	sb	a4,1(a3)
800085d0:	0007a703          	lw	a4,0(a5)
800085d4:	00170713          	addi	a4,a4,1
800085d8:	00e7a023          	sw	a4,0(a5)
800085dc:	e64ff06f          	j	80007c40 <finsh_compile+0xcc>
800085e0:	00c7a783          	lw	a5,12(a5)
800085e4:	00170713          	addi	a4,a4,1
800085e8:	fc5ff06f          	j	800085ac <finsh_compile+0xa38>
800085ec:	01042783          	lw	a5,16(s0)
800085f0:	00100693          	li	a3,1
800085f4:	0007c703          	lbu	a4,0(a5)
800085f8:	0cd71263          	bne	a4,a3,800086bc <finsh_compile+0xb48>
800085fc:	0017c783          	lbu	a5,1(a5)
80008600:	00200693          	li	a3,2
80008604:	04d78263          	beq	a5,a3,80008648 <finsh_compile+0xad4>
80008608:	00300693          	li	a3,3
8000860c:	06d78863          	beq	a5,a3,8000867c <finsh_compile+0xb08>
80008610:	0ae79063          	bne	a5,a4,800086b0 <finsh_compile+0xb3c>
80008614:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
80008618:	0007a703          	lw	a4,0(a5)
8000861c:	02800693          	li	a3,40
80008620:	00d70023          	sb	a3,0(a4)
80008624:	0007a703          	lw	a4,0(a5)
80008628:	00170693          	addi	a3,a4,1
8000862c:	00d7a023          	sw	a3,0(a5)
80008630:	02d00693          	li	a3,45
80008634:	00d700a3          	sb	a3,1(a4)
80008638:	0007a703          	lw	a4,0(a5)
8000863c:	00170713          	addi	a4,a4,1
80008640:	00e7a023          	sw	a4,0(a5)
80008644:	dfcff06f          	j	80007c40 <finsh_compile+0xcc>
80008648:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
8000864c:	0007a703          	lw	a4,0(a5)
80008650:	02900693          	li	a3,41
80008654:	00d70023          	sb	a3,0(a4)
80008658:	0007a703          	lw	a4,0(a5)
8000865c:	00170693          	addi	a3,a4,1
80008660:	00d7a023          	sw	a3,0(a5)
80008664:	02e00693          	li	a3,46
80008668:	00d700a3          	sb	a3,1(a4)
8000866c:	0007a703          	lw	a4,0(a5)
80008670:	00170713          	addi	a4,a4,1
80008674:	00e7a023          	sw	a4,0(a5)
80008678:	dc8ff06f          	j	80007c40 <finsh_compile+0xcc>
8000867c:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
80008680:	0007a703          	lw	a4,0(a5)
80008684:	02a00693          	li	a3,42
80008688:	00d70023          	sb	a3,0(a4)
8000868c:	0007a703          	lw	a4,0(a5)
80008690:	00170693          	addi	a3,a4,1
80008694:	00d7a023          	sw	a3,0(a5)
80008698:	02f00693          	li	a3,47
8000869c:	00d700a3          	sb	a3,1(a4)
800086a0:	0007a703          	lw	a4,0(a5)
800086a4:	00170713          	addi	a4,a4,1
800086a8:	00e7a023          	sw	a4,0(a5)
800086ac:	d94ff06f          	j	80007c40 <finsh_compile+0xcc>
800086b0:	00300513          	li	a0,3
800086b4:	1f1000ef          	jal	ra,800090a4 <finsh_error_set>
800086b8:	d88ff06f          	j	80007c40 <finsh_compile+0xcc>
800086bc:	01900613          	li	a2,25
800086c0:	d8c71063          	bne	a4,a2,80007c40 <finsh_compile+0xcc>
800086c4:	0017c783          	lbu	a5,1(a5)
800086c8:	00200713          	li	a4,2
800086cc:	00f7f793          	andi	a5,a5,15
800086d0:	04e78263          	beq	a5,a4,80008714 <finsh_compile+0xba0>
800086d4:	00300713          	li	a4,3
800086d8:	06e78863          	beq	a5,a4,80008748 <finsh_compile+0xbd4>
800086dc:	fcd79ae3          	bne	a5,a3,800086b0 <finsh_compile+0xb3c>
800086e0:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
800086e4:	0007a703          	lw	a4,0(a5)
800086e8:	02800693          	li	a3,40
800086ec:	00d70023          	sb	a3,0(a4)
800086f0:	0007a703          	lw	a4,0(a5)
800086f4:	00170693          	addi	a3,a4,1
800086f8:	00d7a023          	sw	a3,0(a5)
800086fc:	02d00693          	li	a3,45
80008700:	00d700a3          	sb	a3,1(a4)
80008704:	0007a703          	lw	a4,0(a5)
80008708:	00170713          	addi	a4,a4,1
8000870c:	00e7a023          	sw	a4,0(a5)
80008710:	d30ff06f          	j	80007c40 <finsh_compile+0xcc>
80008714:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
80008718:	0007a703          	lw	a4,0(a5)
8000871c:	02900693          	li	a3,41
80008720:	00d70023          	sb	a3,0(a4)
80008724:	0007a703          	lw	a4,0(a5)
80008728:	00170693          	addi	a3,a4,1
8000872c:	00d7a023          	sw	a3,0(a5)
80008730:	02e00693          	li	a3,46
80008734:	00d700a3          	sb	a3,1(a4)
80008738:	0007a703          	lw	a4,0(a5)
8000873c:	00170713          	addi	a4,a4,1
80008740:	00e7a023          	sw	a4,0(a5)
80008744:	cfcff06f          	j	80007c40 <finsh_compile+0xcc>
80008748:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
8000874c:	0007a703          	lw	a4,0(a5)
80008750:	02a00693          	li	a3,42
80008754:	00d70023          	sb	a3,0(a4)
80008758:	0007a703          	lw	a4,0(a5)
8000875c:	00170693          	addi	a3,a4,1
80008760:	00d7a023          	sw	a3,0(a5)
80008764:	02f00693          	li	a3,47
80008768:	00d700a3          	sb	a3,1(a4)
8000876c:	0007a703          	lw	a4,0(a5)
80008770:	00170713          	addi	a4,a4,1
80008774:	00e7a023          	sw	a4,0(a5)
80008778:	cc8ff06f          	j	80007c40 <finsh_compile+0xcc>
8000877c:	01042783          	lw	a5,16(s0)
80008780:	cc078063          	beqz	a5,80007c40 <finsh_compile+0xcc>
80008784:	0007c603          	lbu	a2,0(a5)
80008788:	00100713          	li	a4,1
8000878c:	cae61a63          	bne	a2,a4,80007c40 <finsh_compile+0xcc>
80008790:	00144683          	lbu	a3,1(s0)
80008794:	00200713          	li	a4,2
80008798:	0087a783          	lw	a5,8(a5)
8000879c:	08e68463          	beq	a3,a4,80008824 <finsh_compile+0xcb0>
800087a0:	00300713          	li	a4,3
800087a4:	0ee68e63          	beq	a3,a4,800088a0 <finsh_compile+0xd2c>
800087a8:	c8c69c63          	bne	a3,a2,80007c40 <finsh_compile+0xcc>
800087ac:	8ec18713          	addi	a4,gp,-1812 # 8002034c <finsh_compile_pc>
800087b0:	00072603          	lw	a2,0(a4)
800087b4:	02500593          	li	a1,37
800087b8:	01478793          	addi	a5,a5,20
800087bc:	00b60023          	sb	a1,0(a2)
800087c0:	00072603          	lw	a2,0(a4)
800087c4:	00160593          	addi	a1,a2,1
800087c8:	00b72023          	sw	a1,0(a4)
800087cc:	00f600a3          	sb	a5,1(a2)
800087d0:	00072603          	lw	a2,0(a4)
800087d4:	0087d593          	srli	a1,a5,0x8
800087d8:	00b600a3          	sb	a1,1(a2)
800087dc:	00072603          	lw	a2,0(a4)
800087e0:	0107d593          	srli	a1,a5,0x10
800087e4:	0187d793          	srli	a5,a5,0x18
800087e8:	00b60123          	sb	a1,2(a2)
800087ec:	00072603          	lw	a2,0(a4)
800087f0:	00f601a3          	sb	a5,3(a2)
800087f4:	00072783          	lw	a5,0(a4)
800087f8:	02200613          	li	a2,34
800087fc:	00d782a3          	sb	a3,5(a5)
80008800:	00d78323          	sb	a3,6(a5)
80008804:	02800693          	li	a3,40
80008808:	00d783a3          	sb	a3,7(a5)
8000880c:	02f00693          	li	a3,47
80008810:	00c78223          	sb	a2,4(a5)
80008814:	00d78423          	sb	a3,8(a5)
80008818:	00978793          	addi	a5,a5,9
8000881c:	00f72023          	sw	a5,0(a4)
80008820:	c20ff06f          	j	80007c40 <finsh_compile+0xcc>
80008824:	8ec18713          	addi	a4,gp,-1812 # 8002034c <finsh_compile_pc>
80008828:	00072583          	lw	a1,0(a4)
8000882c:	02600513          	li	a0,38
80008830:	01478793          	addi	a5,a5,20
80008834:	00a58023          	sb	a0,0(a1)
80008838:	00072583          	lw	a1,0(a4)
8000883c:	00158513          	addi	a0,a1,1
80008840:	00a72023          	sw	a0,0(a4)
80008844:	00f580a3          	sb	a5,1(a1)
80008848:	00072583          	lw	a1,0(a4)
8000884c:	0087d513          	srli	a0,a5,0x8
80008850:	00a580a3          	sb	a0,1(a1)
80008854:	00072583          	lw	a1,0(a4)
80008858:	0107d513          	srli	a0,a5,0x10
8000885c:	0187d793          	srli	a5,a5,0x18
80008860:	00a58123          	sb	a0,2(a1)
80008864:	00072583          	lw	a1,0(a4)
80008868:	00f581a3          	sb	a5,3(a1)
8000886c:	00072783          	lw	a5,0(a4)
80008870:	02300593          	li	a1,35
80008874:	00d783a3          	sb	a3,7(a5)
80008878:	02900693          	li	a3,41
8000887c:	00d78423          	sb	a3,8(a5)
80008880:	02f00693          	li	a3,47
80008884:	00b78223          	sb	a1,4(a5)
80008888:	00c782a3          	sb	a2,5(a5)
8000888c:	00078323          	sb	zero,6(a5)
80008890:	00d784a3          	sb	a3,9(a5)
80008894:	00a78793          	addi	a5,a5,10
80008898:	00f72023          	sw	a5,0(a4)
8000889c:	ba4ff06f          	j	80007c40 <finsh_compile+0xcc>
800088a0:	8ec18713          	addi	a4,gp,-1812 # 8002034c <finsh_compile_pc>
800088a4:	00072583          	lw	a1,0(a4)
800088a8:	02700513          	li	a0,39
800088ac:	01478793          	addi	a5,a5,20
800088b0:	00a58023          	sb	a0,0(a1)
800088b4:	00072583          	lw	a1,0(a4)
800088b8:	00158513          	addi	a0,a1,1
800088bc:	00a72023          	sw	a0,0(a4)
800088c0:	00f580a3          	sb	a5,1(a1)
800088c4:	00072583          	lw	a1,0(a4)
800088c8:	0087d513          	srli	a0,a5,0x8
800088cc:	00a580a3          	sb	a0,1(a1)
800088d0:	00072583          	lw	a1,0(a4)
800088d4:	0107d513          	srli	a0,a5,0x10
800088d8:	0187d793          	srli	a5,a5,0x18
800088dc:	00a58123          	sb	a0,2(a1)
800088e0:	00072583          	lw	a1,0(a4)
800088e4:	00f581a3          	sb	a5,3(a1)
800088e8:	00072783          	lw	a5,0(a4)
800088ec:	02400593          	li	a1,36
800088f0:	00d784a3          	sb	a3,9(a5)
800088f4:	02a00693          	li	a3,42
800088f8:	00d78523          	sb	a3,10(a5)
800088fc:	02f00693          	li	a3,47
80008900:	00b78223          	sb	a1,4(a5)
80008904:	00c782a3          	sb	a2,5(a5)
80008908:	00078323          	sb	zero,6(a5)
8000890c:	000783a3          	sb	zero,7(a5)
80008910:	00078423          	sb	zero,8(a5)
80008914:	00d785a3          	sb	a3,11(a5)
80008918:	00c78793          	addi	a5,a5,12
8000891c:	00f72023          	sw	a5,0(a4)
80008920:	b20ff06f          	j	80007c40 <finsh_compile+0xcc>
80008924:	01042783          	lw	a5,16(s0)
80008928:	b0078c63          	beqz	a5,80007c40 <finsh_compile+0xcc>
8000892c:	0007c683          	lbu	a3,0(a5)
80008930:	00100713          	li	a4,1
80008934:	b0e69663          	bne	a3,a4,80007c40 <finsh_compile+0xcc>
80008938:	00144603          	lbu	a2,1(s0)
8000893c:	00200713          	li	a4,2
80008940:	0087a783          	lw	a5,8(a5)
80008944:	08e60663          	beq	a2,a4,800089d0 <finsh_compile+0xe5c>
80008948:	00300713          	li	a4,3
8000894c:	10e60263          	beq	a2,a4,80008a50 <finsh_compile+0xedc>
80008950:	aed61863          	bne	a2,a3,80007c40 <finsh_compile+0xcc>
80008954:	8ec18713          	addi	a4,gp,-1812 # 8002034c <finsh_compile_pc>
80008958:	00072683          	lw	a3,0(a4)
8000895c:	02500593          	li	a1,37
80008960:	01478793          	addi	a5,a5,20
80008964:	00b68023          	sb	a1,0(a3)
80008968:	00072683          	lw	a3,0(a4)
8000896c:	00168593          	addi	a1,a3,1
80008970:	00b72023          	sw	a1,0(a4)
80008974:	00f680a3          	sb	a5,1(a3)
80008978:	00072683          	lw	a3,0(a4)
8000897c:	0087d593          	srli	a1,a5,0x8
80008980:	00b680a3          	sb	a1,1(a3)
80008984:	00072683          	lw	a3,0(a4)
80008988:	0107d593          	srli	a1,a5,0x10
8000898c:	0187d793          	srli	a5,a5,0x18
80008990:	00b68123          	sb	a1,2(a3)
80008994:	00072683          	lw	a3,0(a4)
80008998:	00f681a3          	sb	a5,3(a3)
8000899c:	00072783          	lw	a5,0(a4)
800089a0:	02200693          	li	a3,34
800089a4:	00d78223          	sb	a3,4(a5)
800089a8:	00400693          	li	a3,4
800089ac:	00d78323          	sb	a3,6(a5)
800089b0:	02800693          	li	a3,40
800089b4:	00d783a3          	sb	a3,7(a5)
800089b8:	02f00693          	li	a3,47
800089bc:	00c782a3          	sb	a2,5(a5)
800089c0:	00d78423          	sb	a3,8(a5)
800089c4:	00978793          	addi	a5,a5,9
800089c8:	00f72023          	sw	a5,0(a4)
800089cc:	a74ff06f          	j	80007c40 <finsh_compile+0xcc>
800089d0:	8ec18713          	addi	a4,gp,-1812 # 8002034c <finsh_compile_pc>
800089d4:	00072603          	lw	a2,0(a4)
800089d8:	02600593          	li	a1,38
800089dc:	01478793          	addi	a5,a5,20
800089e0:	00b60023          	sb	a1,0(a2)
800089e4:	00072603          	lw	a2,0(a4)
800089e8:	00160593          	addi	a1,a2,1
800089ec:	00b72023          	sw	a1,0(a4)
800089f0:	00f600a3          	sb	a5,1(a2)
800089f4:	00072603          	lw	a2,0(a4)
800089f8:	0087d593          	srli	a1,a5,0x8
800089fc:	00b600a3          	sb	a1,1(a2)
80008a00:	00072603          	lw	a2,0(a4)
80008a04:	0107d593          	srli	a1,a5,0x10
80008a08:	0187d793          	srli	a5,a5,0x18
80008a0c:	00b60123          	sb	a1,2(a2)
80008a10:	00072603          	lw	a2,0(a4)
80008a14:	00f601a3          	sb	a5,3(a2)
80008a18:	00072783          	lw	a5,0(a4)
80008a1c:	02300613          	li	a2,35
80008a20:	00d782a3          	sb	a3,5(a5)
80008a24:	00500693          	li	a3,5
80008a28:	00d783a3          	sb	a3,7(a5)
80008a2c:	02900693          	li	a3,41
80008a30:	00d78423          	sb	a3,8(a5)
80008a34:	02f00693          	li	a3,47
80008a38:	00c78223          	sb	a2,4(a5)
80008a3c:	00078323          	sb	zero,6(a5)
80008a40:	00d784a3          	sb	a3,9(a5)
80008a44:	00a78793          	addi	a5,a5,10
80008a48:	00f72023          	sw	a5,0(a4)
80008a4c:	9f4ff06f          	j	80007c40 <finsh_compile+0xcc>
80008a50:	8ec18713          	addi	a4,gp,-1812 # 8002034c <finsh_compile_pc>
80008a54:	00072603          	lw	a2,0(a4)
80008a58:	02700593          	li	a1,39
80008a5c:	01478793          	addi	a5,a5,20
80008a60:	00b60023          	sb	a1,0(a2)
80008a64:	00072603          	lw	a2,0(a4)
80008a68:	00160593          	addi	a1,a2,1
80008a6c:	00b72023          	sw	a1,0(a4)
80008a70:	00f600a3          	sb	a5,1(a2)
80008a74:	00072603          	lw	a2,0(a4)
80008a78:	0087d593          	srli	a1,a5,0x8
80008a7c:	00b600a3          	sb	a1,1(a2)
80008a80:	00072603          	lw	a2,0(a4)
80008a84:	0107d593          	srli	a1,a5,0x10
80008a88:	0187d793          	srli	a5,a5,0x18
80008a8c:	00b60123          	sb	a1,2(a2)
80008a90:	00072603          	lw	a2,0(a4)
80008a94:	00f601a3          	sb	a5,3(a2)
80008a98:	00072783          	lw	a5,0(a4)
80008a9c:	02400613          	li	a2,36
80008aa0:	00d782a3          	sb	a3,5(a5)
80008aa4:	00600693          	li	a3,6
80008aa8:	00d784a3          	sb	a3,9(a5)
80008aac:	02a00693          	li	a3,42
80008ab0:	00d78523          	sb	a3,10(a5)
80008ab4:	02f00693          	li	a3,47
80008ab8:	00c78223          	sb	a2,4(a5)
80008abc:	00078323          	sb	zero,6(a5)
80008ac0:	000783a3          	sb	zero,7(a5)
80008ac4:	00078423          	sb	zero,8(a5)
80008ac8:	00d785a3          	sb	a3,11(a5)
80008acc:	00c78793          	addi	a5,a5,12
80008ad0:	00f72023          	sw	a5,0(a4)
80008ad4:	96cff06f          	j	80007c40 <finsh_compile+0xcc>
80008ad8:	01042783          	lw	a5,16(s0)
80008adc:	96078263          	beqz	a5,80007c40 <finsh_compile+0xcc>
80008ae0:	0007c583          	lbu	a1,0(a5)
80008ae4:	00100713          	li	a4,1
80008ae8:	94e59c63          	bne	a1,a4,80007c40 <finsh_compile+0xcc>
80008aec:	00144603          	lbu	a2,1(s0)
80008af0:	00200713          	li	a4,2
80008af4:	0087a783          	lw	a5,8(a5)
80008af8:	0ae60663          	beq	a2,a4,80008ba4 <finsh_compile+0x1030>
80008afc:	00300713          	li	a4,3
80008b00:	14e60263          	beq	a2,a4,80008c44 <finsh_compile+0x10d0>
80008b04:	92b61e63          	bne	a2,a1,80007c40 <finsh_compile+0xcc>
80008b08:	8ec18693          	addi	a3,gp,-1812 # 8002034c <finsh_compile_pc>
80008b0c:	0006a703          	lw	a4,0(a3)
80008b10:	02400593          	li	a1,36
80008b14:	01478793          	addi	a5,a5,20
80008b18:	00b70023          	sb	a1,0(a4)
80008b1c:	0006a703          	lw	a4,0(a3)
80008b20:	0ff7f813          	andi	a6,a5,255
80008b24:	0087d513          	srli	a0,a5,0x8
80008b28:	00170593          	addi	a1,a4,1
80008b2c:	00b6a023          	sw	a1,0(a3)
80008b30:	010700a3          	sb	a6,1(a4)
80008b34:	0006a703          	lw	a4,0(a3)
80008b38:	0ff57513          	andi	a0,a0,255
80008b3c:	0107d593          	srli	a1,a5,0x10
80008b40:	00a700a3          	sb	a0,1(a4)
80008b44:	0006a703          	lw	a4,0(a3)
80008b48:	0ff5f593          	andi	a1,a1,255
80008b4c:	0187d793          	srli	a5,a5,0x18
80008b50:	00b70123          	sb	a1,2(a4)
80008b54:	0006a703          	lw	a4,0(a3)
80008b58:	02500893          	li	a7,37
80008b5c:	00f701a3          	sb	a5,3(a4)
80008b60:	0006a703          	lw	a4,0(a3)
80008b64:	00f70423          	sb	a5,8(a4)
80008b68:	02200793          	li	a5,34
80008b6c:	00f704a3          	sb	a5,9(a4)
80008b70:	02800793          	li	a5,40
80008b74:	00f70623          	sb	a5,12(a4)
80008b78:	02b00793          	li	a5,43
80008b7c:	01170223          	sb	a7,4(a4)
80008b80:	010702a3          	sb	a6,5(a4)
80008b84:	00a70323          	sb	a0,6(a4)
80008b88:	00b703a3          	sb	a1,7(a4)
80008b8c:	00c70523          	sb	a2,10(a4)
80008b90:	00c705a3          	sb	a2,11(a4)
80008b94:	00f706a3          	sb	a5,13(a4)
80008b98:	00e70713          	addi	a4,a4,14
80008b9c:	00e6a023          	sw	a4,0(a3)
80008ba0:	8a0ff06f          	j	80007c40 <finsh_compile+0xcc>
80008ba4:	8ec18693          	addi	a3,gp,-1812 # 8002034c <finsh_compile_pc>
80008ba8:	0006a703          	lw	a4,0(a3)
80008bac:	02400513          	li	a0,36
80008bb0:	01478793          	addi	a5,a5,20
80008bb4:	00a70023          	sb	a0,0(a4)
80008bb8:	0006a703          	lw	a4,0(a3)
80008bbc:	0ff7f893          	andi	a7,a5,255
80008bc0:	0087d813          	srli	a6,a5,0x8
80008bc4:	00170513          	addi	a0,a4,1
80008bc8:	00a6a023          	sw	a0,0(a3)
80008bcc:	011700a3          	sb	a7,1(a4)
80008bd0:	0006a703          	lw	a4,0(a3)
80008bd4:	0ff87813          	andi	a6,a6,255
80008bd8:	0107d513          	srli	a0,a5,0x10
80008bdc:	010700a3          	sb	a6,1(a4)
80008be0:	0006a703          	lw	a4,0(a3)
80008be4:	0ff57513          	andi	a0,a0,255
80008be8:	0187d793          	srli	a5,a5,0x18
80008bec:	00a70123          	sb	a0,2(a4)
80008bf0:	0006a703          	lw	a4,0(a3)
80008bf4:	02600313          	li	t1,38
80008bf8:	00f701a3          	sb	a5,3(a4)
80008bfc:	0006a703          	lw	a4,0(a3)
80008c00:	00f70423          	sb	a5,8(a4)
80008c04:	02300793          	li	a5,35
80008c08:	00f704a3          	sb	a5,9(a4)
80008c0c:	02900793          	li	a5,41
80008c10:	00f706a3          	sb	a5,13(a4)
80008c14:	02b00793          	li	a5,43
80008c18:	00670223          	sb	t1,4(a4)
80008c1c:	011702a3          	sb	a7,5(a4)
80008c20:	01070323          	sb	a6,6(a4)
80008c24:	00a703a3          	sb	a0,7(a4)
80008c28:	00b70523          	sb	a1,10(a4)
80008c2c:	000705a3          	sb	zero,11(a4)
80008c30:	00c70623          	sb	a2,12(a4)
80008c34:	00f70723          	sb	a5,14(a4)
80008c38:	00f70713          	addi	a4,a4,15
80008c3c:	00e6a023          	sw	a4,0(a3)
80008c40:	800ff06f          	j	80007c40 <finsh_compile+0xcc>
80008c44:	8ec18693          	addi	a3,gp,-1812 # 8002034c <finsh_compile_pc>
80008c48:	0006a703          	lw	a4,0(a3)
80008c4c:	02400893          	li	a7,36
80008c50:	01478793          	addi	a5,a5,20
80008c54:	01170023          	sb	a7,0(a4)
80008c58:	0006a703          	lw	a4,0(a3)
80008c5c:	0ff7f313          	andi	t1,a5,255
80008c60:	0087d813          	srli	a6,a5,0x8
80008c64:	00170513          	addi	a0,a4,1
80008c68:	00a6a023          	sw	a0,0(a3)
80008c6c:	006700a3          	sb	t1,1(a4)
80008c70:	0006a703          	lw	a4,0(a3)
80008c74:	0ff87813          	andi	a6,a6,255
80008c78:	0107d513          	srli	a0,a5,0x10
80008c7c:	010700a3          	sb	a6,1(a4)
80008c80:	0006a703          	lw	a4,0(a3)
80008c84:	0ff57513          	andi	a0,a0,255
80008c88:	0187d793          	srli	a5,a5,0x18
80008c8c:	00a70123          	sb	a0,2(a4)
80008c90:	0006a703          	lw	a4,0(a3)
80008c94:	02700e13          	li	t3,39
80008c98:	00f701a3          	sb	a5,3(a4)
80008c9c:	0006a703          	lw	a4,0(a3)
80008ca0:	00f70423          	sb	a5,8(a4)
80008ca4:	02a00793          	li	a5,42
80008ca8:	00f707a3          	sb	a5,15(a4)
80008cac:	02b00793          	li	a5,43
80008cb0:	01c70223          	sb	t3,4(a4)
80008cb4:	006702a3          	sb	t1,5(a4)
80008cb8:	01070323          	sb	a6,6(a4)
80008cbc:	00a703a3          	sb	a0,7(a4)
80008cc0:	011704a3          	sb	a7,9(a4)
80008cc4:	00b70523          	sb	a1,10(a4)
80008cc8:	000705a3          	sb	zero,11(a4)
80008ccc:	00070623          	sb	zero,12(a4)
80008cd0:	000706a3          	sb	zero,13(a4)
80008cd4:	00c70723          	sb	a2,14(a4)
80008cd8:	00f70823          	sb	a5,16(a4)
80008cdc:	01170713          	addi	a4,a4,17
80008ce0:	00e6a023          	sw	a4,0(a3)
80008ce4:	f5dfe06f          	j	80007c40 <finsh_compile+0xcc>
80008ce8:	01042783          	lw	a5,16(s0)
80008cec:	00079463          	bnez	a5,80008cf4 <finsh_compile+0x1180>
80008cf0:	f51fe06f          	j	80007c40 <finsh_compile+0xcc>
80008cf4:	0007c603          	lbu	a2,0(a5)
80008cf8:	00100713          	li	a4,1
80008cfc:	00e60463          	beq	a2,a4,80008d04 <finsh_compile+0x1190>
80008d00:	f41fe06f          	j	80007c40 <finsh_compile+0xcc>
80008d04:	00144583          	lbu	a1,1(s0)
80008d08:	00200713          	li	a4,2
80008d0c:	0087a783          	lw	a5,8(a5)
80008d10:	0ae58a63          	beq	a1,a4,80008dc4 <finsh_compile+0x1250>
80008d14:	00300713          	li	a4,3
80008d18:	14e58863          	beq	a1,a4,80008e68 <finsh_compile+0x12f4>
80008d1c:	00c58463          	beq	a1,a2,80008d24 <finsh_compile+0x11b0>
80008d20:	f21fe06f          	j	80007c40 <finsh_compile+0xcc>
80008d24:	8ec18693          	addi	a3,gp,-1812 # 8002034c <finsh_compile_pc>
80008d28:	0006a703          	lw	a4,0(a3)
80008d2c:	02400613          	li	a2,36
80008d30:	01478793          	addi	a5,a5,20
80008d34:	00c70023          	sb	a2,0(a4)
80008d38:	0006a703          	lw	a4,0(a3)
80008d3c:	0ff7f813          	andi	a6,a5,255
80008d40:	0087d513          	srli	a0,a5,0x8
80008d44:	00170613          	addi	a2,a4,1
80008d48:	00c6a023          	sw	a2,0(a3)
80008d4c:	010700a3          	sb	a6,1(a4)
80008d50:	0006a703          	lw	a4,0(a3)
80008d54:	0ff57513          	andi	a0,a0,255
80008d58:	0107d613          	srli	a2,a5,0x10
80008d5c:	00a700a3          	sb	a0,1(a4)
80008d60:	0006a703          	lw	a4,0(a3)
80008d64:	0ff67613          	andi	a2,a2,255
80008d68:	0187d793          	srli	a5,a5,0x18
80008d6c:	00c70123          	sb	a2,2(a4)
80008d70:	0006a703          	lw	a4,0(a3)
80008d74:	02500893          	li	a7,37
80008d78:	00f701a3          	sb	a5,3(a4)
80008d7c:	0006a703          	lw	a4,0(a3)
80008d80:	00f70423          	sb	a5,8(a4)
80008d84:	02200793          	li	a5,34
80008d88:	00f704a3          	sb	a5,9(a4)
80008d8c:	00400793          	li	a5,4
80008d90:	00f705a3          	sb	a5,11(a4)
80008d94:	02800793          	li	a5,40
80008d98:	00f70623          	sb	a5,12(a4)
80008d9c:	02b00793          	li	a5,43
80008da0:	01170223          	sb	a7,4(a4)
80008da4:	010702a3          	sb	a6,5(a4)
80008da8:	00a70323          	sb	a0,6(a4)
80008dac:	00c703a3          	sb	a2,7(a4)
80008db0:	00b70523          	sb	a1,10(a4)
80008db4:	00f706a3          	sb	a5,13(a4)
80008db8:	00e70713          	addi	a4,a4,14
80008dbc:	00e6a023          	sw	a4,0(a3)
80008dc0:	e81fe06f          	j	80007c40 <finsh_compile+0xcc>
80008dc4:	8ec18693          	addi	a3,gp,-1812 # 8002034c <finsh_compile_pc>
80008dc8:	0006a703          	lw	a4,0(a3)
80008dcc:	02400593          	li	a1,36
80008dd0:	01478793          	addi	a5,a5,20
80008dd4:	00b70023          	sb	a1,0(a4)
80008dd8:	0006a703          	lw	a4,0(a3)
80008ddc:	0ff7f813          	andi	a6,a5,255
80008de0:	0087d513          	srli	a0,a5,0x8
80008de4:	00170593          	addi	a1,a4,1
80008de8:	00b6a023          	sw	a1,0(a3)
80008dec:	010700a3          	sb	a6,1(a4)
80008df0:	0006a703          	lw	a4,0(a3)
80008df4:	0ff57513          	andi	a0,a0,255
80008df8:	0107d593          	srli	a1,a5,0x10
80008dfc:	00a700a3          	sb	a0,1(a4)
80008e00:	0006a703          	lw	a4,0(a3)
80008e04:	0ff5f593          	andi	a1,a1,255
80008e08:	0187d793          	srli	a5,a5,0x18
80008e0c:	00b70123          	sb	a1,2(a4)
80008e10:	0006a703          	lw	a4,0(a3)
80008e14:	02600893          	li	a7,38
80008e18:	00f701a3          	sb	a5,3(a4)
80008e1c:	0006a703          	lw	a4,0(a3)
80008e20:	00f70423          	sb	a5,8(a4)
80008e24:	02300793          	li	a5,35
80008e28:	00f704a3          	sb	a5,9(a4)
80008e2c:	00500793          	li	a5,5
80008e30:	00f70623          	sb	a5,12(a4)
80008e34:	02900793          	li	a5,41
80008e38:	00f706a3          	sb	a5,13(a4)
80008e3c:	02b00793          	li	a5,43
80008e40:	01170223          	sb	a7,4(a4)
80008e44:	010702a3          	sb	a6,5(a4)
80008e48:	00a70323          	sb	a0,6(a4)
80008e4c:	00b703a3          	sb	a1,7(a4)
80008e50:	00c70523          	sb	a2,10(a4)
80008e54:	000705a3          	sb	zero,11(a4)
80008e58:	00f70723          	sb	a5,14(a4)
80008e5c:	00f70713          	addi	a4,a4,15
80008e60:	00e6a023          	sw	a4,0(a3)
80008e64:	dddfe06f          	j	80007c40 <finsh_compile+0xcc>
80008e68:	8ec18693          	addi	a3,gp,-1812 # 8002034c <finsh_compile_pc>
80008e6c:	0006a703          	lw	a4,0(a3)
80008e70:	02400813          	li	a6,36
80008e74:	01478793          	addi	a5,a5,20
80008e78:	01070023          	sb	a6,0(a4)
80008e7c:	0006a703          	lw	a4,0(a3)
80008e80:	0ff7f893          	andi	a7,a5,255
80008e84:	0087d513          	srli	a0,a5,0x8
80008e88:	00170593          	addi	a1,a4,1
80008e8c:	00b6a023          	sw	a1,0(a3)
80008e90:	011700a3          	sb	a7,1(a4)
80008e94:	0006a703          	lw	a4,0(a3)
80008e98:	0ff57513          	andi	a0,a0,255
80008e9c:	0107d593          	srli	a1,a5,0x10
80008ea0:	00a700a3          	sb	a0,1(a4)
80008ea4:	0006a703          	lw	a4,0(a3)
80008ea8:	0ff5f593          	andi	a1,a1,255
80008eac:	0187d793          	srli	a5,a5,0x18
80008eb0:	00b70123          	sb	a1,2(a4)
80008eb4:	0006a703          	lw	a4,0(a3)
80008eb8:	02700313          	li	t1,39
80008ebc:	00f701a3          	sb	a5,3(a4)
80008ec0:	0006a703          	lw	a4,0(a3)
80008ec4:	00f70423          	sb	a5,8(a4)
80008ec8:	00600793          	li	a5,6
80008ecc:	00f70723          	sb	a5,14(a4)
80008ed0:	02a00793          	li	a5,42
80008ed4:	00f707a3          	sb	a5,15(a4)
80008ed8:	02b00793          	li	a5,43
80008edc:	00670223          	sb	t1,4(a4)
80008ee0:	011702a3          	sb	a7,5(a4)
80008ee4:	00a70323          	sb	a0,6(a4)
80008ee8:	00b703a3          	sb	a1,7(a4)
80008eec:	010704a3          	sb	a6,9(a4)
80008ef0:	00c70523          	sb	a2,10(a4)
80008ef4:	000705a3          	sb	zero,11(a4)
80008ef8:	00070623          	sb	zero,12(a4)
80008efc:	000706a3          	sb	zero,13(a4)
80008f00:	00f70823          	sb	a5,16(a4)
80008f04:	01170713          	addi	a4,a4,17
80008f08:	00e6a023          	sw	a4,0(a3)
80008f0c:	d35fe06f          	j	80007c40 <finsh_compile+0xcc>
80008f10:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
80008f14:	0007a703          	lw	a4,0(a5)
80008f18:	00070023          	sb	zero,0(a4)
80008f1c:	0007a703          	lw	a4,0(a5)
80008f20:	000700a3          	sb	zero,1(a4)
80008f24:	0007a703          	lw	a4,0(a5)
80008f28:	00070123          	sb	zero,2(a4)
80008f2c:	0007a703          	lw	a4,0(a5)
80008f30:	000701a3          	sb	zero,3(a4)
80008f34:	0007a703          	lw	a4,0(a5)
80008f38:	00470713          	addi	a4,a4,4
80008f3c:	00e7a023          	sw	a4,0(a5)
80008f40:	d01fe06f          	j	80007c40 <finsh_compile+0xcc>
80008f44:	00244783          	lbu	a5,2(s0)
80008f48:	0087f793          	andi	a5,a5,8
80008f4c:	00078463          	beqz	a5,80008f54 <finsh_compile+0x13e0>
80008f50:	cf1fe06f          	j	80007c40 <finsh_compile+0xcc>
80008f54:	00144783          	lbu	a5,1(s0)
80008f58:	00200713          	li	a4,2
80008f5c:	02e78c63          	beq	a5,a4,80008f94 <finsh_compile+0x1420>
80008f60:	00300713          	li	a4,3
80008f64:	04e78863          	beq	a5,a4,80008fb4 <finsh_compile+0x1440>
80008f68:	00100713          	li	a4,1
80008f6c:	00e78463          	beq	a5,a4,80008f74 <finsh_compile+0x1400>
80008f70:	cd1fe06f          	j	80007c40 <finsh_compile+0xcc>
80008f74:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
80008f78:	0007a703          	lw	a4,0(a5)
80008f7c:	02d00693          	li	a3,45
80008f80:	00d70023          	sb	a3,0(a4)
80008f84:	0007a703          	lw	a4,0(a5)
80008f88:	00170713          	addi	a4,a4,1
80008f8c:	00e7a023          	sw	a4,0(a5)
80008f90:	cb1fe06f          	j	80007c40 <finsh_compile+0xcc>
80008f94:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
80008f98:	0007a703          	lw	a4,0(a5)
80008f9c:	02e00693          	li	a3,46
80008fa0:	00d70023          	sb	a3,0(a4)
80008fa4:	0007a703          	lw	a4,0(a5)
80008fa8:	00170713          	addi	a4,a4,1
80008fac:	00e7a023          	sw	a4,0(a5)
80008fb0:	c91fe06f          	j	80007c40 <finsh_compile+0xcc>
80008fb4:	8ec18793          	addi	a5,gp,-1812 # 8002034c <finsh_compile_pc>
80008fb8:	0007a703          	lw	a4,0(a5)
80008fbc:	02f00693          	li	a3,47
80008fc0:	00d70023          	sb	a3,0(a4)
80008fc4:	0007a703          	lw	a4,0(a5)
80008fc8:	00170713          	addi	a4,a4,1
80008fcc:	00e7a023          	sw	a4,0(a5)
80008fd0:	c71fe06f          	j	80007c40 <finsh_compile+0xcc>
80008fd4:	00800513          	li	a0,8
80008fd8:	0cc000ef          	jal	ra,800090a4 <finsh_error_set>
80008fdc:	c65fe06f          	j	80007c40 <finsh_compile+0xcc>
80008fe0:	00000513          	li	a0,0
80008fe4:	00008067          	ret

80008fe8 <finsh_compiler_run>:
80008fe8:	fe010113          	addi	sp,sp,-32
80008fec:	00000593          	li	a1,0
80008ff0:	00112e23          	sw	ra,28(sp)
80008ff4:	00812c23          	sw	s0,24(sp)
80008ff8:	00912a23          	sw	s1,20(sp)
80008ffc:	01212823          	sw	s2,16(sp)
80009000:	01312623          	sw	s3,12(sp)
80009004:	4ac18913          	addi	s2,gp,1196 # 80020f0c <text_segment>
80009008:	00050413          	mv	s0,a0
8000900c:	9fdfe0ef          	jal	ra,80007a08 <finsh_type_check>
80009010:	08000613          	li	a2,128
80009014:	00000593          	li	a1,0
80009018:	00090513          	mv	a0,s2
8000901c:	571020ef          	jal	ra,8000bd8c <memset>
80009020:	3ac18793          	addi	a5,gp,940 # 80020e0c <finsh_vm_stack>
80009024:	10000613          	li	a2,256
80009028:	00000593          	li	a1,0
8000902c:	00078513          	mv	a0,a5
80009030:	55d020ef          	jal	ra,8000bd8c <memset>
80009034:	8ec18493          	addi	s1,gp,-1812 # 8002034c <finsh_compile_pc>
80009038:	8ea1a823          	sw	a0,-1808(gp) # 80020350 <finsh_compile_sp>
8000903c:	0124a023          	sw	s2,0(s1)
80009040:	02b00993          	li	s3,43
80009044:	02041263          	bnez	s0,80009068 <finsh_compiler_run+0x80>
80009048:	01c12083          	lw	ra,28(sp)
8000904c:	01812403          	lw	s0,24(sp)
80009050:	01412483          	lw	s1,20(sp)
80009054:	01012903          	lw	s2,16(sp)
80009058:	00c12983          	lw	s3,12(sp)
8000905c:	00000513          	li	a0,0
80009060:	02010113          	addi	sp,sp,32
80009064:	00008067          	ret
80009068:	00c42903          	lw	s2,12(s0)
8000906c:	00040513          	mv	a0,s0
80009070:	00042623          	sw	zero,12(s0)
80009074:	b01fe0ef          	jal	ra,80007b74 <finsh_compile>
80009078:	00090c63          	beqz	s2,80009090 <finsh_compiler_run+0xa8>
8000907c:	0004a783          	lw	a5,0(s1)
80009080:	01378023          	sb	s3,0(a5)
80009084:	0004a783          	lw	a5,0(s1)
80009088:	00178793          	addi	a5,a5,1
8000908c:	00f4a023          	sw	a5,0(s1)
80009090:	00090413          	mv	s0,s2
80009094:	fb1ff06f          	j	80009044 <finsh_compiler_run+0x5c>

80009098 <finsh_error_init>:
80009098:	8e018a23          	sb	zero,-1804(gp) # 80020354 <global_errno>
8000909c:	00000513          	li	a0,0
800090a0:	00008067          	ret

800090a4 <finsh_error_set>:
800090a4:	8ea18a23          	sb	a0,-1804(gp) # 80020354 <global_errno>
800090a8:	00000513          	li	a0,0
800090ac:	00008067          	ret

800090b0 <finsh_errno>:
800090b0:	8f41c503          	lbu	a0,-1804(gp) # 80020354 <global_errno>
800090b4:	00008067          	ret

800090b8 <finsh_error_string>:
800090b8:	00251793          	slli	a5,a0,0x2
800090bc:	00005517          	auipc	a0,0x5
800090c0:	3c850513          	addi	a0,a0,968 # 8000e484 <finsh_error_string_table>
800090c4:	00f50533          	add	a0,a0,a5
800090c8:	00052503          	lw	a0,0(a0)
800090cc:	00008067          	ret

800090d0 <finsh_block_insert>:
800090d0:	00052783          	lw	a5,0(a0)
800090d4:	00079663          	bnez	a5,800090e0 <finsh_block_insert+0x10>
800090d8:	00b52023          	sw	a1,0(a0)
800090dc:	00008067          	ret
800090e0:	00f5f663          	bgeu	a1,a5,800090ec <finsh_block_insert+0x1c>
800090e4:	00f5a223          	sw	a5,4(a1)
800090e8:	ff1ff06f          	j	800090d8 <finsh_block_insert+0x8>
800090ec:	00078713          	mv	a4,a5
800090f0:	0047a783          	lw	a5,4(a5)
800090f4:	00f5e863          	bltu	a1,a5,80009104 <finsh_block_insert+0x34>
800090f8:	fe079ae3          	bnez	a5,800090ec <finsh_block_insert+0x1c>
800090fc:	00b72223          	sw	a1,4(a4)
80009100:	00008067          	ret
80009104:	fe078ce3          	beqz	a5,800090fc <finsh_block_insert+0x2c>
80009108:	00f5a223          	sw	a5,4(a1)
8000910c:	ff1ff06f          	j	800090fc <finsh_block_insert+0x2c>

80009110 <finsh_heap_init>:
80009110:	ff010113          	addi	sp,sp,-16
80009114:	00812423          	sw	s0,8(sp)
80009118:	07c00613          	li	a2,124
8000911c:	12c18413          	addi	s0,gp,300 # 80020b8c <finsh_heap>
80009120:	00000593          	li	a1,0
80009124:	13018513          	addi	a0,gp,304 # 80020b90 <finsh_heap+0x4>
80009128:	00112623          	sw	ra,12(sp)
8000912c:	461020ef          	jal	ra,8000bd8c <memset>
80009130:	8e81ae23          	sw	s0,-1796(gp) # 8002035c <free_list>
80009134:	07800793          	li	a5,120
80009138:	00f42023          	sw	a5,0(s0)
8000913c:	00c12083          	lw	ra,12(sp)
80009140:	00812403          	lw	s0,8(sp)
80009144:	8e01ac23          	sw	zero,-1800(gp) # 80020358 <allocate_list>
80009148:	00000513          	li	a0,0
8000914c:	01010113          	addi	sp,sp,16
80009150:	00008067          	ret

80009154 <finsh_heap_free>:
80009154:	8f818713          	addi	a4,gp,-1800 # 80020358 <allocate_list>
80009158:	00072783          	lw	a5,0(a4)
8000915c:	ff010113          	addi	sp,sp,-16
80009160:	00812423          	sw	s0,8(sp)
80009164:	00912223          	sw	s1,4(sp)
80009168:	00112623          	sw	ra,12(sp)
8000916c:	01212023          	sw	s2,0(sp)
80009170:	ff850493          	addi	s1,a0,-8
80009174:	00050413          	mv	s0,a0
80009178:	04f49e63          	bne	s1,a5,800091d4 <finsh_heap_free+0x80>
8000917c:	ffc52783          	lw	a5,-4(a0)
80009180:	00f72023          	sw	a5,0(a4)
80009184:	fe052e23          	sw	zero,-4(a0)
80009188:	8fc18913          	addi	s2,gp,-1796 # 8002035c <free_list>
8000918c:	00048593          	mv	a1,s1
80009190:	00090513          	mv	a0,s2
80009194:	f3dff0ef          	jal	ra,800090d0 <finsh_block_insert>
80009198:	00092703          	lw	a4,0(s2)
8000919c:	ffc42683          	lw	a3,-4(s0)
800091a0:	04e49c63          	bne	s1,a4,800091f8 <finsh_heap_free+0xa4>
800091a4:	0a068663          	beqz	a3,80009250 <finsh_heap_free+0xfc>
800091a8:	ff842783          	lw	a5,-8(s0)
800091ac:	00f40733          	add	a4,s0,a5
800091b0:	0ae69063          	bne	a3,a4,80009250 <finsh_heap_free+0xfc>
800091b4:	0006a703          	lw	a4,0(a3)
800091b8:	00878793          	addi	a5,a5,8
800091bc:	00e787b3          	add	a5,a5,a4
800091c0:	fef42c23          	sw	a5,-8(s0)
800091c4:	0046a783          	lw	a5,4(a3)
800091c8:	fef42e23          	sw	a5,-4(s0)
800091cc:	0840006f          	j	80009250 <finsh_heap_free+0xfc>
800091d0:	00070793          	mv	a5,a4
800091d4:	fa078ae3          	beqz	a5,80009188 <finsh_heap_free+0x34>
800091d8:	0047a703          	lw	a4,4(a5)
800091dc:	fee49ae3          	bne	s1,a4,800091d0 <finsh_heap_free+0x7c>
800091e0:	ffc42703          	lw	a4,-4(s0)
800091e4:	00e7a223          	sw	a4,4(a5)
800091e8:	fa1ff06f          	j	80009188 <finsh_heap_free+0x34>
800091ec:	00472783          	lw	a5,4(a4)
800091f0:	02f48263          	beq	s1,a5,80009214 <finsh_heap_free+0xc0>
800091f4:	00078713          	mv	a4,a5
800091f8:	fe071ae3          	bnez	a4,800091ec <finsh_heap_free+0x98>
800091fc:	fa9ff06f          	j	800091a4 <finsh_heap_free+0x50>
80009200:	00878793          	addi	a5,a5,8
80009204:	00c787b3          	add	a5,a5,a2
80009208:	00f72023          	sw	a5,0(a4)
8000920c:	00d72223          	sw	a3,4(a4)
80009210:	0400006f          	j	80009250 <finsh_heap_free+0xfc>
80009214:	00072603          	lw	a2,0(a4)
80009218:	00860793          	addi	a5,a2,8
8000921c:	00f707b3          	add	a5,a4,a5
80009220:	f8f492e3          	bne	s1,a5,800091a4 <finsh_heap_free+0x50>
80009224:	ff842783          	lw	a5,-8(s0)
80009228:	fc068ce3          	beqz	a3,80009200 <finsh_heap_free+0xac>
8000922c:	00f40433          	add	s0,s0,a5
80009230:	fc8698e3          	bne	a3,s0,80009200 <finsh_heap_free+0xac>
80009234:	0006a583          	lw	a1,0(a3)
80009238:	01078793          	addi	a5,a5,16
8000923c:	00b787b3          	add	a5,a5,a1
80009240:	00c787b3          	add	a5,a5,a2
80009244:	00f72023          	sw	a5,0(a4)
80009248:	0046a783          	lw	a5,4(a3)
8000924c:	00f72223          	sw	a5,4(a4)
80009250:	00c12083          	lw	ra,12(sp)
80009254:	00812403          	lw	s0,8(sp)
80009258:	00412483          	lw	s1,4(sp)
8000925c:	00012903          	lw	s2,0(sp)
80009260:	01010113          	addi	sp,sp,16
80009264:	00008067          	ret

80009268 <finsh_heap_allocate>:
80009268:	fe010113          	addi	sp,sp,-32
8000926c:	01212823          	sw	s2,16(sp)
80009270:	8fc18913          	addi	s2,gp,-1796 # 8002035c <free_list>
80009274:	00812c23          	sw	s0,24(sp)
80009278:	00912a23          	sw	s1,20(sp)
8000927c:	00092403          	lw	s0,0(s2)
80009280:	00350493          	addi	s1,a0,3
80009284:	ffc4f493          	andi	s1,s1,-4
80009288:	00112e23          	sw	ra,28(sp)
8000928c:	01312623          	sw	s3,12(sp)
80009290:	00848793          	addi	a5,s1,8
80009294:	10040863          	beqz	s0,800093a4 <finsh_heap_allocate+0x13c>
80009298:	00042703          	lw	a4,0(s0)
8000929c:	00442683          	lw	a3,4(s0)
800092a0:	08e7f263          	bgeu	a5,a4,80009324 <finsh_heap_allocate+0xbc>
800092a4:	ff800713          	li	a4,-8
800092a8:	409706b3          	sub	a3,a4,s1
800092ac:	00042703          	lw	a4,0(s0)
800092b0:	00848793          	addi	a5,s1,8
800092b4:	00f407b3          	add	a5,s0,a5
800092b8:	00d70733          	add	a4,a4,a3
800092bc:	00e7a023          	sw	a4,0(a5)
800092c0:	00442703          	lw	a4,4(s0)
800092c4:	00942023          	sw	s1,0(s0)
800092c8:	00e7a223          	sw	a4,4(a5)
800092cc:	00092703          	lw	a4,0(s2)
800092d0:	00f42223          	sw	a5,4(s0)
800092d4:	0ae41e63          	bne	s0,a4,80009390 <finsh_heap_allocate+0x128>
800092d8:	00f92023          	sw	a5,0(s2)
800092dc:	00042223          	sw	zero,4(s0)
800092e0:	00042223          	sw	zero,4(s0)
800092e4:	00040593          	mv	a1,s0
800092e8:	8f818513          	addi	a0,gp,-1800 # 80020358 <allocate_list>
800092ec:	de5ff0ef          	jal	ra,800090d0 <finsh_block_insert>
800092f0:	00840413          	addi	s0,s0,8
800092f4:	00048613          	mv	a2,s1
800092f8:	00000593          	li	a1,0
800092fc:	00040513          	mv	a0,s0
80009300:	28d020ef          	jal	ra,8000bd8c <memset>
80009304:	01c12083          	lw	ra,28(sp)
80009308:	00040513          	mv	a0,s0
8000930c:	01812403          	lw	s0,24(sp)
80009310:	01412483          	lw	s1,20(sp)
80009314:	01012903          	lw	s2,16(sp)
80009318:	00c12983          	lw	s3,12(sp)
8000931c:	02010113          	addi	sp,sp,32
80009320:	00008067          	ret
80009324:	00068413          	mv	s0,a3
80009328:	f6dff06f          	j	80009294 <finsh_heap_allocate+0x2c>
8000932c:	2ec18713          	addi	a4,gp,748 # 80020d4c <global_variable>
80009330:	00000793          	li	a5,0
80009334:	00850693          	addi	a3,a0,8
80009338:	01174603          	lbu	a2,17(a4)
8000933c:	00060663          	beqz	a2,80009348 <finsh_heap_allocate+0xe0>
80009340:	01472603          	lw	a2,20(a4)
80009344:	00d60863          	beq	a2,a3,80009354 <finsh_heap_allocate+0xec>
80009348:	00178793          	addi	a5,a5,1
8000934c:	01870713          	addi	a4,a4,24
80009350:	fe8794e3          	bne	a5,s0,80009338 <finsh_heap_allocate+0xd0>
80009354:	00452983          	lw	s3,4(a0)
80009358:	00879663          	bne	a5,s0,80009364 <finsh_heap_allocate+0xfc>
8000935c:	00850513          	addi	a0,a0,8
80009360:	df5ff0ef          	jal	ra,80009154 <finsh_heap_free>
80009364:	00098513          	mv	a0,s3
80009368:	fc0512e3          	bnez	a0,8000932c <finsh_heap_allocate+0xc4>
8000936c:	00092403          	lw	s0,0(s2)
80009370:	00848793          	addi	a5,s1,8
80009374:	f80408e3          	beqz	s0,80009304 <finsh_heap_allocate+0x9c>
80009378:	00042703          	lw	a4,0(s0)
8000937c:	00442683          	lw	a3,4(s0)
80009380:	f2f772e3          	bgeu	a4,a5,800092a4 <finsh_heap_allocate+0x3c>
80009384:	00068413          	mv	s0,a3
80009388:	fedff06f          	j	80009374 <finsh_heap_allocate+0x10c>
8000938c:	00068713          	mv	a4,a3
80009390:	f40708e3          	beqz	a4,800092e0 <finsh_heap_allocate+0x78>
80009394:	00472683          	lw	a3,4(a4)
80009398:	fed41ae3          	bne	s0,a3,8000938c <finsh_heap_allocate+0x124>
8000939c:	00f72223          	sw	a5,4(a4)
800093a0:	f41ff06f          	j	800092e0 <finsh_heap_allocate+0x78>
800093a4:	8f81a503          	lw	a0,-1800(gp) # 80020358 <allocate_list>
800093a8:	00800413          	li	s0,8
800093ac:	fbdff06f          	j	80009368 <finsh_heap_allocate+0x100>

800093b0 <finsh_init>:
800093b0:	ff010113          	addi	sp,sp,-16
800093b4:	00112623          	sw	ra,12(sp)
800093b8:	441010ef          	jal	ra,8000aff8 <finsh_parser_init>
800093bc:	04c000ef          	jal	ra,80009408 <finsh_node_init>
800093c0:	45d010ef          	jal	ra,8000b01c <finsh_var_init>
800093c4:	cd5ff0ef          	jal	ra,80009098 <finsh_error_init>
800093c8:	d49ff0ef          	jal	ra,80009110 <finsh_heap_init>
800093cc:	00c12083          	lw	ra,12(sp)
800093d0:	00000513          	li	a0,0
800093d4:	01010113          	addi	sp,sp,16
800093d8:	00008067          	ret

800093dc <finsh_stack_bottom>:
800093dc:	3ac1a503          	lw	a0,940(gp) # 80020e0c <finsh_vm_stack>
800093e0:	00008067          	ret

800093e4 <finsh_flush>:
800093e4:	ff010113          	addi	sp,sp,-16
800093e8:	00112623          	sw	ra,12(sp)
800093ec:	40d010ef          	jal	ra,8000aff8 <finsh_parser_init>
800093f0:	018000ef          	jal	ra,80009408 <finsh_node_init>
800093f4:	ca5ff0ef          	jal	ra,80009098 <finsh_error_init>
800093f8:	00c12083          	lw	ra,12(sp)
800093fc:	00000513          	li	a0,0
80009400:	01010113          	addi	sp,sp,16
80009404:	00008067          	ret

80009408 <finsh_node_init>:
80009408:	ff010113          	addi	sp,sp,-16
8000940c:	14000613          	li	a2,320
80009410:	00000593          	li	a1,0
80009414:	1ac18513          	addi	a0,gp,428 # 80020c0c <global_node_table>
80009418:	00112623          	sw	ra,12(sp)
8000941c:	171020ef          	jal	ra,8000bd8c <memset>
80009420:	00c12083          	lw	ra,12(sp)
80009424:	00000513          	li	a0,0
80009428:	01010113          	addi	sp,sp,16
8000942c:	00008067          	ret

80009430 <finsh_node_allocate>:
80009430:	1ac18693          	addi	a3,gp,428 # 80020c0c <global_node_table>
80009434:	00050613          	mv	a2,a0
80009438:	00000713          	li	a4,0
8000943c:	00068793          	mv	a5,a3
80009440:	01000593          	li	a1,16
80009444:	0006c503          	lbu	a0,0(a3)
80009448:	00050c63          	beqz	a0,80009460 <finsh_node_allocate+0x30>
8000944c:	00170713          	addi	a4,a4,1
80009450:	01468693          	addi	a3,a3,20
80009454:	feb718e3          	bne	a4,a1,80009444 <finsh_node_allocate+0x14>
80009458:	00000513          	li	a0,0
8000945c:	00008067          	ret
80009460:	01400513          	li	a0,20
80009464:	02a70733          	mul	a4,a4,a0
80009468:	00e78533          	add	a0,a5,a4
8000946c:	00c50023          	sb	a2,0(a0)
80009470:	00008067          	ret

80009474 <finsh_node_new_id>:
80009474:	ff010113          	addi	sp,sp,-16
80009478:	00812423          	sw	s0,8(sp)
8000947c:	00912223          	sw	s1,4(sp)
80009480:	01212023          	sw	s2,0(sp)
80009484:	00112623          	sw	ra,12(sp)
80009488:	00050493          	mv	s1,a0
8000948c:	491010ef          	jal	ra,8000b11c <finsh_var_lookup>
80009490:	00050413          	mv	s0,a0
80009494:	00100913          	li	s2,1
80009498:	06051063          	bnez	a0,800094f8 <finsh_node_new_id+0x84>
8000949c:	00048513          	mv	a0,s1
800094a0:	4d9010ef          	jal	ra,8000b178 <finsh_sysvar_lookup>
800094a4:	00050413          	mv	s0,a0
800094a8:	00200913          	li	s2,2
800094ac:	04051663          	bnez	a0,800094f8 <finsh_node_new_id+0x84>
800094b0:	00048513          	mv	a0,s1
800094b4:	5d1010ef          	jal	ra,8000b284 <finsh_syscall_lookup>
800094b8:	00050413          	mv	s0,a0
800094bc:	00400913          	li	s2,4
800094c0:	02051c63          	bnez	a0,800094f8 <finsh_node_new_id+0x84>
800094c4:	00d00513          	li	a0,13
800094c8:	bddff0ef          	jal	ra,800090a4 <finsh_error_set>
800094cc:	00000493          	li	s1,0
800094d0:	0400006f          	j	80009510 <finsh_node_new_id+0x9c>
800094d4:	00200793          	li	a5,2
800094d8:	00f90a63          	beq	s2,a5,800094ec <finsh_node_new_id+0x78>
800094dc:	00400793          	li	a5,4
800094e0:	00f90663          	beq	s2,a5,800094ec <finsh_node_new_id+0x78>
800094e4:	00100793          	li	a5,1
800094e8:	00f91463          	bne	s2,a5,800094f0 <finsh_node_new_id+0x7c>
800094ec:	0084a423          	sw	s0,8(s1)
800094f0:	01248123          	sb	s2,2(s1)
800094f4:	01c0006f          	j	80009510 <finsh_node_new_id+0x9c>
800094f8:	00100513          	li	a0,1
800094fc:	f35ff0ef          	jal	ra,80009430 <finsh_node_allocate>
80009500:	00050493          	mv	s1,a0
80009504:	fc0518e3          	bnez	a0,800094d4 <finsh_node_new_id+0x60>
80009508:	00600513          	li	a0,6
8000950c:	b99ff0ef          	jal	ra,800090a4 <finsh_error_set>
80009510:	00c12083          	lw	ra,12(sp)
80009514:	00812403          	lw	s0,8(sp)
80009518:	00012903          	lw	s2,0(sp)
8000951c:	00048513          	mv	a0,s1
80009520:	00412483          	lw	s1,4(sp)
80009524:	01010113          	addi	sp,sp,16
80009528:	00008067          	ret

8000952c <finsh_node_new_char>:
8000952c:	ff010113          	addi	sp,sp,-16
80009530:	00912223          	sw	s1,4(sp)
80009534:	00050493          	mv	s1,a0
80009538:	00200513          	li	a0,2
8000953c:	00812423          	sw	s0,8(sp)
80009540:	00112623          	sw	ra,12(sp)
80009544:	eedff0ef          	jal	ra,80009430 <finsh_node_allocate>
80009548:	00050413          	mv	s0,a0
8000954c:	02051263          	bnez	a0,80009570 <finsh_node_new_char+0x44>
80009550:	00600513          	li	a0,6
80009554:	b51ff0ef          	jal	ra,800090a4 <finsh_error_set>
80009558:	00c12083          	lw	ra,12(sp)
8000955c:	00040513          	mv	a0,s0
80009560:	00812403          	lw	s0,8(sp)
80009564:	00412483          	lw	s1,4(sp)
80009568:	01010113          	addi	sp,sp,16
8000956c:	00008067          	ret
80009570:	00950223          	sb	s1,4(a0)
80009574:	fe5ff06f          	j	80009558 <finsh_node_new_char+0x2c>

80009578 <finsh_node_new_int>:
80009578:	ff010113          	addi	sp,sp,-16
8000957c:	00912223          	sw	s1,4(sp)
80009580:	00050493          	mv	s1,a0
80009584:	00300513          	li	a0,3
80009588:	00812423          	sw	s0,8(sp)
8000958c:	00112623          	sw	ra,12(sp)
80009590:	ea1ff0ef          	jal	ra,80009430 <finsh_node_allocate>
80009594:	00050413          	mv	s0,a0
80009598:	02051263          	bnez	a0,800095bc <finsh_node_new_int+0x44>
8000959c:	00600513          	li	a0,6
800095a0:	b05ff0ef          	jal	ra,800090a4 <finsh_error_set>
800095a4:	00c12083          	lw	ra,12(sp)
800095a8:	00040513          	mv	a0,s0
800095ac:	00812403          	lw	s0,8(sp)
800095b0:	00412483          	lw	s1,4(sp)
800095b4:	01010113          	addi	sp,sp,16
800095b8:	00008067          	ret
800095bc:	00952223          	sw	s1,4(a0)
800095c0:	fe5ff06f          	j	800095a4 <finsh_node_new_int+0x2c>

800095c4 <finsh_node_new_long>:
800095c4:	ff010113          	addi	sp,sp,-16
800095c8:	00912223          	sw	s1,4(sp)
800095cc:	00050493          	mv	s1,a0
800095d0:	00400513          	li	a0,4
800095d4:	00812423          	sw	s0,8(sp)
800095d8:	00112623          	sw	ra,12(sp)
800095dc:	e55ff0ef          	jal	ra,80009430 <finsh_node_allocate>
800095e0:	00050413          	mv	s0,a0
800095e4:	02051263          	bnez	a0,80009608 <finsh_node_new_long+0x44>
800095e8:	00600513          	li	a0,6
800095ec:	ab9ff0ef          	jal	ra,800090a4 <finsh_error_set>
800095f0:	00c12083          	lw	ra,12(sp)
800095f4:	00040513          	mv	a0,s0
800095f8:	00812403          	lw	s0,8(sp)
800095fc:	00412483          	lw	s1,4(sp)
80009600:	01010113          	addi	sp,sp,16
80009604:	00008067          	ret
80009608:	00952223          	sw	s1,4(a0)
8000960c:	fe5ff06f          	j	800095f0 <finsh_node_new_long+0x2c>

80009610 <finsh_node_new_string>:
80009610:	ff010113          	addi	sp,sp,-16
80009614:	00912223          	sw	s1,4(sp)
80009618:	00050493          	mv	s1,a0
8000961c:	00500513          	li	a0,5
80009620:	00812423          	sw	s0,8(sp)
80009624:	00112623          	sw	ra,12(sp)
80009628:	01212023          	sw	s2,0(sp)
8000962c:	e05ff0ef          	jal	ra,80009430 <finsh_node_allocate>
80009630:	00050413          	mv	s0,a0
80009634:	02051463          	bnez	a0,8000965c <finsh_node_new_string+0x4c>
80009638:	00600513          	li	a0,6
8000963c:	a69ff0ef          	jal	ra,800090a4 <finsh_error_set>
80009640:	00c12083          	lw	ra,12(sp)
80009644:	00040513          	mv	a0,s0
80009648:	00812403          	lw	s0,8(sp)
8000964c:	00412483          	lw	s1,4(sp)
80009650:	00012903          	lw	s2,0(sp)
80009654:	01010113          	addi	sp,sp,16
80009658:	00008067          	ret
8000965c:	00048513          	mv	a0,s1
80009660:	1cd020ef          	jal	ra,8000c02c <strlen>
80009664:	00150513          	addi	a0,a0,1
80009668:	c01ff0ef          	jal	ra,80009268 <finsh_heap_allocate>
8000966c:	00050913          	mv	s2,a0
80009670:	00a42223          	sw	a0,4(s0)
80009674:	00048513          	mv	a0,s1
80009678:	1b5020ef          	jal	ra,8000c02c <strlen>
8000967c:	00050613          	mv	a2,a0
80009680:	00048593          	mv	a1,s1
80009684:	00090513          	mv	a0,s2
80009688:	1fd020ef          	jal	ra,8000c084 <strncpy>
8000968c:	00048513          	mv	a0,s1
80009690:	19d020ef          	jal	ra,8000c02c <strlen>
80009694:	00442783          	lw	a5,4(s0)
80009698:	00a787b3          	add	a5,a5,a0
8000969c:	00078023          	sb	zero,0(a5)
800096a0:	fa1ff06f          	j	80009640 <finsh_node_new_string+0x30>

800096a4 <finsh_node_new_ptr>:
800096a4:	ff010113          	addi	sp,sp,-16
800096a8:	00912223          	sw	s1,4(sp)
800096ac:	00050493          	mv	s1,a0
800096b0:	00600513          	li	a0,6
800096b4:	00812423          	sw	s0,8(sp)
800096b8:	00112623          	sw	ra,12(sp)
800096bc:	d75ff0ef          	jal	ra,80009430 <finsh_node_allocate>
800096c0:	00050413          	mv	s0,a0
800096c4:	02051263          	bnez	a0,800096e8 <finsh_node_new_ptr+0x44>
800096c8:	00600513          	li	a0,6
800096cc:	9d9ff0ef          	jal	ra,800090a4 <finsh_error_set>
800096d0:	00c12083          	lw	ra,12(sp)
800096d4:	00040513          	mv	a0,s0
800096d8:	00812403          	lw	s0,8(sp)
800096dc:	00412483          	lw	s1,4(sp)
800096e0:	01010113          	addi	sp,sp,16
800096e4:	00008067          	ret
800096e8:	00952223          	sw	s1,4(a0)
800096ec:	fe5ff06f          	j	800096d0 <finsh_node_new_ptr+0x2c>

800096f0 <OP_no_op>:
800096f0:	00008067          	ret

800096f4 <OP_add_byte>:
800096f4:	90818693          	addi	a3,gp,-1784 # 80020368 <finsh_sp>
800096f8:	0006a783          	lw	a5,0(a3)
800096fc:	ff87c703          	lbu	a4,-8(a5)
80009700:	ffc7c603          	lbu	a2,-4(a5)
80009704:	ffc78793          	addi	a5,a5,-4
80009708:	00c70733          	add	a4,a4,a2
8000970c:	fee78e23          	sb	a4,-4(a5)
80009710:	00f6a023          	sw	a5,0(a3)
80009714:	00008067          	ret

80009718 <OP_add_word>:
80009718:	90818693          	addi	a3,gp,-1784 # 80020368 <finsh_sp>
8000971c:	0006a783          	lw	a5,0(a3)
80009720:	ff87d703          	lhu	a4,-8(a5)
80009724:	ffc7d603          	lhu	a2,-4(a5)
80009728:	ffc78793          	addi	a5,a5,-4
8000972c:	00c70733          	add	a4,a4,a2
80009730:	fee79e23          	sh	a4,-4(a5)
80009734:	00f6a023          	sw	a5,0(a3)
80009738:	00008067          	ret

8000973c <OP_add_dword>:
8000973c:	90818693          	addi	a3,gp,-1784 # 80020368 <finsh_sp>
80009740:	0006a783          	lw	a5,0(a3)
80009744:	ff87a703          	lw	a4,-8(a5)
80009748:	ffc7a603          	lw	a2,-4(a5)
8000974c:	ffc78793          	addi	a5,a5,-4
80009750:	00c70733          	add	a4,a4,a2
80009754:	fee7ae23          	sw	a4,-4(a5)
80009758:	00f6a023          	sw	a5,0(a3)
8000975c:	00008067          	ret

80009760 <OP_sub_byte>:
80009760:	90818693          	addi	a3,gp,-1784 # 80020368 <finsh_sp>
80009764:	0006a783          	lw	a5,0(a3)
80009768:	ff87c703          	lbu	a4,-8(a5)
8000976c:	ffc7c603          	lbu	a2,-4(a5)
80009770:	ffc78793          	addi	a5,a5,-4
80009774:	40c70733          	sub	a4,a4,a2
80009778:	fee78e23          	sb	a4,-4(a5)
8000977c:	00f6a023          	sw	a5,0(a3)
80009780:	00008067          	ret

80009784 <OP_sub_word>:
80009784:	90818693          	addi	a3,gp,-1784 # 80020368 <finsh_sp>
80009788:	0006a783          	lw	a5,0(a3)
8000978c:	ff87d703          	lhu	a4,-8(a5)
80009790:	ffc7d603          	lhu	a2,-4(a5)
80009794:	ffc78793          	addi	a5,a5,-4
80009798:	40c70733          	sub	a4,a4,a2
8000979c:	fee79e23          	sh	a4,-4(a5)
800097a0:	00f6a023          	sw	a5,0(a3)
800097a4:	00008067          	ret

800097a8 <OP_sub_dword>:
800097a8:	90818693          	addi	a3,gp,-1784 # 80020368 <finsh_sp>
800097ac:	0006a783          	lw	a5,0(a3)
800097b0:	ff87a703          	lw	a4,-8(a5)
800097b4:	ffc7a603          	lw	a2,-4(a5)
800097b8:	ffc78793          	addi	a5,a5,-4
800097bc:	40c70733          	sub	a4,a4,a2
800097c0:	fee7ae23          	sw	a4,-4(a5)
800097c4:	00f6a023          	sw	a5,0(a3)
800097c8:	00008067          	ret

800097cc <OP_div_byte>:
800097cc:	90818693          	addi	a3,gp,-1784 # 80020368 <finsh_sp>
800097d0:	0006a783          	lw	a5,0(a3)
800097d4:	ff87c703          	lbu	a4,-8(a5)
800097d8:	ffc7c603          	lbu	a2,-4(a5)
800097dc:	ffc78793          	addi	a5,a5,-4
800097e0:	02c75733          	divu	a4,a4,a2
800097e4:	fee78e23          	sb	a4,-4(a5)
800097e8:	00f6a023          	sw	a5,0(a3)
800097ec:	00008067          	ret

800097f0 <OP_div_word>:
800097f0:	90818693          	addi	a3,gp,-1784 # 80020368 <finsh_sp>
800097f4:	0006a783          	lw	a5,0(a3)
800097f8:	ff879703          	lh	a4,-8(a5)
800097fc:	ffc79603          	lh	a2,-4(a5)
80009800:	ffc78793          	addi	a5,a5,-4
80009804:	02c74733          	div	a4,a4,a2
80009808:	fee79e23          	sh	a4,-4(a5)
8000980c:	00f6a023          	sw	a5,0(a3)
80009810:	00008067          	ret

80009814 <OP_div_dword>:
80009814:	90818693          	addi	a3,gp,-1784 # 80020368 <finsh_sp>
80009818:	0006a783          	lw	a5,0(a3)
8000981c:	ff87a703          	lw	a4,-8(a5)
80009820:	ffc7a603          	lw	a2,-4(a5)
80009824:	ffc78793          	addi	a5,a5,-4
80009828:	02c74733          	div	a4,a4,a2
8000982c:	fee7ae23          	sw	a4,-4(a5)
80009830:	00f6a023          	sw	a5,0(a3)
80009834:	00008067          	ret

80009838 <OP_mod_byte>:
80009838:	90818693          	addi	a3,gp,-1784 # 80020368 <finsh_sp>
8000983c:	0006a783          	lw	a5,0(a3)
80009840:	ff87c703          	lbu	a4,-8(a5)
80009844:	ffc7c603          	lbu	a2,-4(a5)
80009848:	ffc78793          	addi	a5,a5,-4
8000984c:	02c77733          	remu	a4,a4,a2
80009850:	fee78e23          	sb	a4,-4(a5)
80009854:	00f6a023          	sw	a5,0(a3)
80009858:	00008067          	ret

8000985c <OP_mod_word>:
8000985c:	90818693          	addi	a3,gp,-1784 # 80020368 <finsh_sp>
80009860:	0006a783          	lw	a5,0(a3)
80009864:	ff879703          	lh	a4,-8(a5)
80009868:	ffc79603          	lh	a2,-4(a5)
8000986c:	ffc78793          	addi	a5,a5,-4
80009870:	02c76733          	rem	a4,a4,a2
80009874:	fee79e23          	sh	a4,-4(a5)
80009878:	00f6a023          	sw	a5,0(a3)
8000987c:	00008067          	ret

80009880 <OP_mod_dword>:
80009880:	90818693          	addi	a3,gp,-1784 # 80020368 <finsh_sp>
80009884:	0006a783          	lw	a5,0(a3)
80009888:	ff87a703          	lw	a4,-8(a5)
8000988c:	ffc7a603          	lw	a2,-4(a5)
80009890:	ffc78793          	addi	a5,a5,-4
80009894:	02c76733          	rem	a4,a4,a2
80009898:	fee7ae23          	sw	a4,-4(a5)
8000989c:	00f6a023          	sw	a5,0(a3)
800098a0:	00008067          	ret

800098a4 <OP_mul_byte>:
800098a4:	90818693          	addi	a3,gp,-1784 # 80020368 <finsh_sp>
800098a8:	0006a783          	lw	a5,0(a3)
800098ac:	ff87c703          	lbu	a4,-8(a5)
800098b0:	ffc7c603          	lbu	a2,-4(a5)
800098b4:	ffc78793          	addi	a5,a5,-4
800098b8:	02c70733          	mul	a4,a4,a2
800098bc:	fee78e23          	sb	a4,-4(a5)
800098c0:	00f6a023          	sw	a5,0(a3)
800098c4:	00008067          	ret

800098c8 <OP_mul_word>:
800098c8:	90818693          	addi	a3,gp,-1784 # 80020368 <finsh_sp>
800098cc:	0006a783          	lw	a5,0(a3)
800098d0:	ff87d703          	lhu	a4,-8(a5)
800098d4:	ffc7d603          	lhu	a2,-4(a5)
800098d8:	ffc78793          	addi	a5,a5,-4
800098dc:	02c70733          	mul	a4,a4,a2
800098e0:	fee79e23          	sh	a4,-4(a5)
800098e4:	00f6a023          	sw	a5,0(a3)
800098e8:	00008067          	ret

800098ec <OP_mul_dword>:
800098ec:	90818693          	addi	a3,gp,-1784 # 80020368 <finsh_sp>
800098f0:	0006a783          	lw	a5,0(a3)
800098f4:	ff87a703          	lw	a4,-8(a5)
800098f8:	ffc7a603          	lw	a2,-4(a5)
800098fc:	ffc78793          	addi	a5,a5,-4
80009900:	02c70733          	mul	a4,a4,a2
80009904:	fee7ae23          	sw	a4,-4(a5)
80009908:	00f6a023          	sw	a5,0(a3)
8000990c:	00008067          	ret

80009910 <OP_and_byte>:
80009910:	90818693          	addi	a3,gp,-1784 # 80020368 <finsh_sp>
80009914:	0006a783          	lw	a5,0(a3)
80009918:	ff87c703          	lbu	a4,-8(a5)
8000991c:	ffc7c603          	lbu	a2,-4(a5)
80009920:	ffc78793          	addi	a5,a5,-4
80009924:	00c77733          	and	a4,a4,a2
80009928:	fee78e23          	sb	a4,-4(a5)
8000992c:	00f6a023          	sw	a5,0(a3)
80009930:	00008067          	ret

80009934 <OP_and_word>:
80009934:	90818693          	addi	a3,gp,-1784 # 80020368 <finsh_sp>
80009938:	0006a783          	lw	a5,0(a3)
8000993c:	ff87d703          	lhu	a4,-8(a5)
80009940:	ffc7d603          	lhu	a2,-4(a5)
80009944:	ffc78793          	addi	a5,a5,-4
80009948:	00c77733          	and	a4,a4,a2
8000994c:	fee79e23          	sh	a4,-4(a5)
80009950:	00f6a023          	sw	a5,0(a3)
80009954:	00008067          	ret

80009958 <OP_and_dword>:
80009958:	90818693          	addi	a3,gp,-1784 # 80020368 <finsh_sp>
8000995c:	0006a783          	lw	a5,0(a3)
80009960:	ff87a703          	lw	a4,-8(a5)
80009964:	ffc7a603          	lw	a2,-4(a5)
80009968:	ffc78793          	addi	a5,a5,-4
8000996c:	00c77733          	and	a4,a4,a2
80009970:	fee7ae23          	sw	a4,-4(a5)
80009974:	00f6a023          	sw	a5,0(a3)
80009978:	00008067          	ret

8000997c <OP_or_byte>:
8000997c:	90818693          	addi	a3,gp,-1784 # 80020368 <finsh_sp>
80009980:	0006a783          	lw	a5,0(a3)
80009984:	ff87c703          	lbu	a4,-8(a5)
80009988:	ffc7c603          	lbu	a2,-4(a5)
8000998c:	ffc78793          	addi	a5,a5,-4
80009990:	00c76733          	or	a4,a4,a2
80009994:	fee78e23          	sb	a4,-4(a5)
80009998:	00f6a023          	sw	a5,0(a3)
8000999c:	00008067          	ret

800099a0 <OP_or_word>:
800099a0:	90818693          	addi	a3,gp,-1784 # 80020368 <finsh_sp>
800099a4:	0006a783          	lw	a5,0(a3)
800099a8:	ff87d703          	lhu	a4,-8(a5)
800099ac:	ffc7d603          	lhu	a2,-4(a5)
800099b0:	ffc78793          	addi	a5,a5,-4
800099b4:	00c76733          	or	a4,a4,a2
800099b8:	fee79e23          	sh	a4,-4(a5)
800099bc:	00f6a023          	sw	a5,0(a3)
800099c0:	00008067          	ret

800099c4 <OP_or_dword>:
800099c4:	90818693          	addi	a3,gp,-1784 # 80020368 <finsh_sp>
800099c8:	0006a783          	lw	a5,0(a3)
800099cc:	ff87a703          	lw	a4,-8(a5)
800099d0:	ffc7a603          	lw	a2,-4(a5)
800099d4:	ffc78793          	addi	a5,a5,-4
800099d8:	00c76733          	or	a4,a4,a2
800099dc:	fee7ae23          	sw	a4,-4(a5)
800099e0:	00f6a023          	sw	a5,0(a3)
800099e4:	00008067          	ret

800099e8 <OP_xor_byte>:
800099e8:	90818693          	addi	a3,gp,-1784 # 80020368 <finsh_sp>
800099ec:	0006a783          	lw	a5,0(a3)
800099f0:	ff87c703          	lbu	a4,-8(a5)
800099f4:	ffc7c603          	lbu	a2,-4(a5)
800099f8:	ffc78793          	addi	a5,a5,-4
800099fc:	00c74733          	xor	a4,a4,a2
80009a00:	fee78e23          	sb	a4,-4(a5)
80009a04:	00f6a023          	sw	a5,0(a3)
80009a08:	00008067          	ret

80009a0c <OP_xor_word>:
80009a0c:	90818693          	addi	a3,gp,-1784 # 80020368 <finsh_sp>
80009a10:	0006a783          	lw	a5,0(a3)
80009a14:	ff87d703          	lhu	a4,-8(a5)
80009a18:	ffc7d603          	lhu	a2,-4(a5)
80009a1c:	ffc78793          	addi	a5,a5,-4
80009a20:	00c74733          	xor	a4,a4,a2
80009a24:	fee79e23          	sh	a4,-4(a5)
80009a28:	00f6a023          	sw	a5,0(a3)
80009a2c:	00008067          	ret

80009a30 <OP_xor_dword>:
80009a30:	90818693          	addi	a3,gp,-1784 # 80020368 <finsh_sp>
80009a34:	0006a783          	lw	a5,0(a3)
80009a38:	ff87a703          	lw	a4,-8(a5)
80009a3c:	ffc7a603          	lw	a2,-4(a5)
80009a40:	ffc78793          	addi	a5,a5,-4
80009a44:	00c74733          	xor	a4,a4,a2
80009a48:	fee7ae23          	sw	a4,-4(a5)
80009a4c:	00f6a023          	sw	a5,0(a3)
80009a50:	00008067          	ret

80009a54 <OP_bw_byte>:
80009a54:	9081a703          	lw	a4,-1784(gp) # 80020368 <finsh_sp>
80009a58:	ffc74783          	lbu	a5,-4(a4)
80009a5c:	fff7c793          	not	a5,a5
80009a60:	fef70e23          	sb	a5,-4(a4)
80009a64:	00008067          	ret

80009a68 <OP_bw_word>:
80009a68:	9081a703          	lw	a4,-1784(gp) # 80020368 <finsh_sp>
80009a6c:	ffc75783          	lhu	a5,-4(a4)
80009a70:	fff7c793          	not	a5,a5
80009a74:	fef71e23          	sh	a5,-4(a4)
80009a78:	00008067          	ret

80009a7c <OP_bw_dword>:
80009a7c:	9081a703          	lw	a4,-1784(gp) # 80020368 <finsh_sp>
80009a80:	ffc72783          	lw	a5,-4(a4)
80009a84:	fff7c793          	not	a5,a5
80009a88:	fef72e23          	sw	a5,-4(a4)
80009a8c:	00008067          	ret

80009a90 <OP_shl_byte>:
80009a90:	90818693          	addi	a3,gp,-1784 # 80020368 <finsh_sp>
80009a94:	0006a783          	lw	a5,0(a3)
80009a98:	ff87c703          	lbu	a4,-8(a5)
80009a9c:	ffc7c603          	lbu	a2,-4(a5)
80009aa0:	ffc78793          	addi	a5,a5,-4
80009aa4:	00c71733          	sll	a4,a4,a2
80009aa8:	fee78e23          	sb	a4,-4(a5)
80009aac:	00f6a023          	sw	a5,0(a3)
80009ab0:	00008067          	ret

80009ab4 <OP_shl_word>:
80009ab4:	90818693          	addi	a3,gp,-1784 # 80020368 <finsh_sp>
80009ab8:	0006a783          	lw	a5,0(a3)
80009abc:	ff879703          	lh	a4,-8(a5)
80009ac0:	ffc79603          	lh	a2,-4(a5)
80009ac4:	ffc78793          	addi	a5,a5,-4
80009ac8:	00c71733          	sll	a4,a4,a2
80009acc:	fee79e23          	sh	a4,-4(a5)
80009ad0:	00f6a023          	sw	a5,0(a3)
80009ad4:	00008067          	ret

80009ad8 <OP_shl_dword>:
80009ad8:	90818693          	addi	a3,gp,-1784 # 80020368 <finsh_sp>
80009adc:	0006a783          	lw	a5,0(a3)
80009ae0:	ff87a703          	lw	a4,-8(a5)
80009ae4:	ffc7a603          	lw	a2,-4(a5)
80009ae8:	ffc78793          	addi	a5,a5,-4
80009aec:	00c71733          	sll	a4,a4,a2
80009af0:	fee7ae23          	sw	a4,-4(a5)
80009af4:	00f6a023          	sw	a5,0(a3)
80009af8:	00008067          	ret

80009afc <OP_shr_byte>:
80009afc:	90818693          	addi	a3,gp,-1784 # 80020368 <finsh_sp>
80009b00:	0006a783          	lw	a5,0(a3)
80009b04:	ff87c703          	lbu	a4,-8(a5)
80009b08:	ffc7c603          	lbu	a2,-4(a5)
80009b0c:	ffc78793          	addi	a5,a5,-4
80009b10:	40c75733          	sra	a4,a4,a2
80009b14:	fee78e23          	sb	a4,-4(a5)
80009b18:	00f6a023          	sw	a5,0(a3)
80009b1c:	00008067          	ret

80009b20 <OP_shr_word>:
80009b20:	90818693          	addi	a3,gp,-1784 # 80020368 <finsh_sp>
80009b24:	0006a783          	lw	a5,0(a3)
80009b28:	ff879703          	lh	a4,-8(a5)
80009b2c:	ffc79603          	lh	a2,-4(a5)
80009b30:	ffc78793          	addi	a5,a5,-4
80009b34:	40c75733          	sra	a4,a4,a2
80009b38:	fee79e23          	sh	a4,-4(a5)
80009b3c:	00f6a023          	sw	a5,0(a3)
80009b40:	00008067          	ret

80009b44 <OP_shr_dword>:
80009b44:	90818693          	addi	a3,gp,-1784 # 80020368 <finsh_sp>
80009b48:	0006a783          	lw	a5,0(a3)
80009b4c:	ff87a703          	lw	a4,-8(a5)
80009b50:	ffc7a603          	lw	a2,-4(a5)
80009b54:	ffc78793          	addi	a5,a5,-4
80009b58:	40c75733          	sra	a4,a4,a2
80009b5c:	fee7ae23          	sw	a4,-4(a5)
80009b60:	00f6a023          	sw	a5,0(a3)
80009b64:	00008067          	ret

80009b68 <OP_ld_byte>:
80009b68:	90418693          	addi	a3,gp,-1788 # 80020364 <finsh_pc>
80009b6c:	0006a783          	lw	a5,0(a3)
80009b70:	90818613          	addi	a2,gp,-1784 # 80020368 <finsh_sp>
80009b74:	00062703          	lw	a4,0(a2)
80009b78:	0007c583          	lbu	a1,0(a5)
80009b7c:	00178793          	addi	a5,a5,1
80009b80:	00470713          	addi	a4,a4,4
80009b84:	feb70e23          	sb	a1,-4(a4)
80009b88:	00e62023          	sw	a4,0(a2)
80009b8c:	00f6a023          	sw	a5,0(a3)
80009b90:	00008067          	ret

80009b94 <OP_ld_word>:
80009b94:	90418613          	addi	a2,gp,-1788 # 80020364 <finsh_pc>
80009b98:	00062783          	lw	a5,0(a2)
80009b9c:	90818593          	addi	a1,gp,-1784 # 80020368 <finsh_sp>
80009ba0:	0005a683          	lw	a3,0(a1)
80009ba4:	0017c703          	lbu	a4,1(a5)
80009ba8:	0007c503          	lbu	a0,0(a5)
80009bac:	00468693          	addi	a3,a3,4
80009bb0:	00871713          	slli	a4,a4,0x8
80009bb4:	00a76733          	or	a4,a4,a0
80009bb8:	fee69e23          	sh	a4,-4(a3)
80009bbc:	00278793          	addi	a5,a5,2
80009bc0:	00d5a023          	sw	a3,0(a1)
80009bc4:	00f62023          	sw	a5,0(a2)
80009bc8:	00008067          	ret

80009bcc <OP_ld_dword>:
80009bcc:	90418593          	addi	a1,gp,-1788 # 80020364 <finsh_pc>
80009bd0:	0005a783          	lw	a5,0(a1)
80009bd4:	90818513          	addi	a0,gp,-1784 # 80020368 <finsh_sp>
80009bd8:	00052603          	lw	a2,0(a0)
80009bdc:	0017c683          	lbu	a3,1(a5)
80009be0:	0007c703          	lbu	a4,0(a5)
80009be4:	00460613          	addi	a2,a2,4
80009be8:	00869693          	slli	a3,a3,0x8
80009bec:	00e6e6b3          	or	a3,a3,a4
80009bf0:	0027c703          	lbu	a4,2(a5)
80009bf4:	00478793          	addi	a5,a5,4
80009bf8:	01071713          	slli	a4,a4,0x10
80009bfc:	00d766b3          	or	a3,a4,a3
80009c00:	fff7c703          	lbu	a4,-1(a5)
80009c04:	01871713          	slli	a4,a4,0x18
80009c08:	00d76733          	or	a4,a4,a3
80009c0c:	fee62e23          	sw	a4,-4(a2)
80009c10:	00c52023          	sw	a2,0(a0)
80009c14:	00f5a023          	sw	a5,0(a1)
80009c18:	00008067          	ret

80009c1c <OP_ld_value_byte>:
80009c1c:	90418593          	addi	a1,gp,-1788 # 80020364 <finsh_pc>
80009c20:	0005a783          	lw	a5,0(a1)
80009c24:	90818513          	addi	a0,gp,-1784 # 80020368 <finsh_sp>
80009c28:	00052603          	lw	a2,0(a0)
80009c2c:	0017c683          	lbu	a3,1(a5)
80009c30:	0007c703          	lbu	a4,0(a5)
80009c34:	00460613          	addi	a2,a2,4
80009c38:	00869693          	slli	a3,a3,0x8
80009c3c:	00e6e6b3          	or	a3,a3,a4
80009c40:	0027c703          	lbu	a4,2(a5)
80009c44:	00478793          	addi	a5,a5,4
80009c48:	01071713          	slli	a4,a4,0x10
80009c4c:	00d766b3          	or	a3,a4,a3
80009c50:	fff7c703          	lbu	a4,-1(a5)
80009c54:	01871713          	slli	a4,a4,0x18
80009c58:	00d76733          	or	a4,a4,a3
80009c5c:	00074703          	lbu	a4,0(a4)
80009c60:	fee60e23          	sb	a4,-4(a2)
80009c64:	00c52023          	sw	a2,0(a0)
80009c68:	00f5a023          	sw	a5,0(a1)
80009c6c:	00008067          	ret

80009c70 <OP_ld_value_byte_stack>:
80009c70:	9081a783          	lw	a5,-1784(gp) # 80020368 <finsh_sp>
80009c74:	ffc7a703          	lw	a4,-4(a5)
80009c78:	00074703          	lbu	a4,0(a4)
80009c7c:	fee78e23          	sb	a4,-4(a5)
80009c80:	00008067          	ret

80009c84 <OP_ld_value_word>:
80009c84:	90418593          	addi	a1,gp,-1788 # 80020364 <finsh_pc>
80009c88:	0005a783          	lw	a5,0(a1)
80009c8c:	90818513          	addi	a0,gp,-1784 # 80020368 <finsh_sp>
80009c90:	00052603          	lw	a2,0(a0)
80009c94:	0017c683          	lbu	a3,1(a5)
80009c98:	0007c703          	lbu	a4,0(a5)
80009c9c:	00460613          	addi	a2,a2,4
80009ca0:	00869693          	slli	a3,a3,0x8
80009ca4:	00e6e6b3          	or	a3,a3,a4
80009ca8:	0027c703          	lbu	a4,2(a5)
80009cac:	00478793          	addi	a5,a5,4
80009cb0:	01071713          	slli	a4,a4,0x10
80009cb4:	00d766b3          	or	a3,a4,a3
80009cb8:	fff7c703          	lbu	a4,-1(a5)
80009cbc:	01871713          	slli	a4,a4,0x18
80009cc0:	00d76733          	or	a4,a4,a3
80009cc4:	00071703          	lh	a4,0(a4)
80009cc8:	fee61e23          	sh	a4,-4(a2)
80009ccc:	00c52023          	sw	a2,0(a0)
80009cd0:	00f5a023          	sw	a5,0(a1)
80009cd4:	00008067          	ret

80009cd8 <OP_ld_value_word_stack>:
80009cd8:	9081a783          	lw	a5,-1784(gp) # 80020368 <finsh_sp>
80009cdc:	ffc7a703          	lw	a4,-4(a5)
80009ce0:	00071703          	lh	a4,0(a4)
80009ce4:	fee79e23          	sh	a4,-4(a5)
80009ce8:	00008067          	ret

80009cec <OP_ld_value_dword>:
80009cec:	90418593          	addi	a1,gp,-1788 # 80020364 <finsh_pc>
80009cf0:	0005a783          	lw	a5,0(a1)
80009cf4:	90818513          	addi	a0,gp,-1784 # 80020368 <finsh_sp>
80009cf8:	00052603          	lw	a2,0(a0)
80009cfc:	0017c683          	lbu	a3,1(a5)
80009d00:	0007c703          	lbu	a4,0(a5)
80009d04:	00460613          	addi	a2,a2,4
80009d08:	00869693          	slli	a3,a3,0x8
80009d0c:	00e6e6b3          	or	a3,a3,a4
80009d10:	0027c703          	lbu	a4,2(a5)
80009d14:	00478793          	addi	a5,a5,4
80009d18:	01071713          	slli	a4,a4,0x10
80009d1c:	00d766b3          	or	a3,a4,a3
80009d20:	fff7c703          	lbu	a4,-1(a5)
80009d24:	01871713          	slli	a4,a4,0x18
80009d28:	00d76733          	or	a4,a4,a3
80009d2c:	00072703          	lw	a4,0(a4)
80009d30:	fee62e23          	sw	a4,-4(a2)
80009d34:	00c52023          	sw	a2,0(a0)
80009d38:	00f5a023          	sw	a5,0(a1)
80009d3c:	00008067          	ret

80009d40 <OP_ld_value_dword_stack>:
80009d40:	9081a783          	lw	a5,-1784(gp) # 80020368 <finsh_sp>
80009d44:	ffc7a703          	lw	a4,-4(a5)
80009d48:	00072703          	lw	a4,0(a4)
80009d4c:	fee7ae23          	sw	a4,-4(a5)
80009d50:	00008067          	ret

80009d54 <OP_st_byte>:
80009d54:	90818793          	addi	a5,gp,-1784 # 80020368 <finsh_sp>
80009d58:	0007a703          	lw	a4,0(a5)
80009d5c:	ffc74683          	lbu	a3,-4(a4)
80009d60:	ff872703          	lw	a4,-8(a4)
80009d64:	00d70023          	sb	a3,0(a4)
80009d68:	0007a703          	lw	a4,0(a5)
80009d6c:	ffc70713          	addi	a4,a4,-4
80009d70:	00e7a023          	sw	a4,0(a5)
80009d74:	00008067          	ret

80009d78 <OP_st_word>:
80009d78:	90818713          	addi	a4,gp,-1784 # 80020368 <finsh_sp>
80009d7c:	00072783          	lw	a5,0(a4)
80009d80:	ffc79603          	lh	a2,-4(a5)
80009d84:	ff87a683          	lw	a3,-8(a5)
80009d88:	ffc78793          	addi	a5,a5,-4
80009d8c:	00c69023          	sh	a2,0(a3)
80009d90:	00f72023          	sw	a5,0(a4)
80009d94:	00008067          	ret

80009d98 <OP_st_dword>:
80009d98:	90818713          	addi	a4,gp,-1784 # 80020368 <finsh_sp>
80009d9c:	00072783          	lw	a5,0(a4)
80009da0:	ffc7a603          	lw	a2,-4(a5)
80009da4:	ff87a683          	lw	a3,-8(a5)
80009da8:	ffc78793          	addi	a5,a5,-4
80009dac:	00c6a023          	sw	a2,0(a3)
80009db0:	00f72023          	sw	a5,0(a4)
80009db4:	00008067          	ret

80009db8 <OP_pop>:
80009db8:	90818713          	addi	a4,gp,-1784 # 80020368 <finsh_sp>
80009dbc:	00072783          	lw	a5,0(a4)
80009dc0:	ffc78793          	addi	a5,a5,-4
80009dc4:	00f72023          	sw	a5,0(a4)
80009dc8:	00008067          	ret

80009dcc <OP_call>:
80009dcc:	90418713          	addi	a4,gp,-1788 # 80020364 <finsh_pc>
80009dd0:	00072783          	lw	a5,0(a4)
80009dd4:	f9010113          	addi	sp,sp,-112
80009dd8:	06812423          	sw	s0,104(sp)
80009ddc:	00178693          	addi	a3,a5,1
80009de0:	06112623          	sw	ra,108(sp)
80009de4:	00d72023          	sw	a3,0(a4)
80009de8:	90818413          	addi	s0,gp,-1784 # 80020368 <finsh_sp>
80009dec:	0007c603          	lbu	a2,0(a5)
80009df0:	00042783          	lw	a5,0(s0)
80009df4:	02010813          	addi	a6,sp,32
80009df8:	00261713          	slli	a4,a2,0x2
80009dfc:	ffc78793          	addi	a5,a5,-4
80009e00:	00f42023          	sw	a5,0(s0)
80009e04:	00078593          	mv	a1,a5
80009e08:	00e806b3          	add	a3,a6,a4
80009e0c:	00000513          	li	a0,0
80009e10:	04d81263          	bne	a6,a3,80009e54 <OP_call+0x88>
80009e14:	ffc00693          	li	a3,-4
80009e18:	02d606b3          	mul	a3,a2,a3
80009e1c:	00d787b3          	add	a5,a5,a3
80009e20:	00050463          	beqz	a0,80009e28 <OP_call+0x5c>
80009e24:	00f42023          	sw	a5,0(s0)
80009e28:	00042783          	lw	a5,0(s0)
80009e2c:	00000513          	li	a0,0
80009e30:	0007a303          	lw	t1,0(a5)
80009e34:	01000793          	li	a5,16
80009e38:	02c7ee63          	bltu	a5,a2,80009e74 <OP_call+0xa8>
80009e3c:	00004697          	auipc	a3,0x4
80009e40:	68468693          	addi	a3,a3,1668 # 8000e4c0 <finsh_error_string_table+0x3c>
80009e44:	00e68733          	add	a4,a3,a4
80009e48:	00072783          	lw	a5,0(a4)
80009e4c:	00d787b3          	add	a5,a5,a3
80009e50:	00078067          	jr	a5
80009e54:	0005a503          	lw	a0,0(a1)
80009e58:	ffc68693          	addi	a3,a3,-4
80009e5c:	ffc58593          	addi	a1,a1,-4
80009e60:	00a6a023          	sw	a0,0(a3)
80009e64:	00100513          	li	a0,1
80009e68:	fa9ff06f          	j	80009e10 <OP_call+0x44>
80009e6c:	00000513          	li	a0,0
80009e70:	000300e7          	jalr	t1
80009e74:	00042783          	lw	a5,0(s0)
80009e78:	06c12083          	lw	ra,108(sp)
80009e7c:	00a7a023          	sw	a0,0(a5)
80009e80:	00478793          	addi	a5,a5,4
80009e84:	00f42023          	sw	a5,0(s0)
80009e88:	06812403          	lw	s0,104(sp)
80009e8c:	07010113          	addi	sp,sp,112
80009e90:	00008067          	ret
80009e94:	02012503          	lw	a0,32(sp)
80009e98:	fd9ff06f          	j	80009e70 <OP_call+0xa4>
80009e9c:	02412583          	lw	a1,36(sp)
80009ea0:	02012503          	lw	a0,32(sp)
80009ea4:	000300e7          	jalr	t1
80009ea8:	fcdff06f          	j	80009e74 <OP_call+0xa8>
80009eac:	02812603          	lw	a2,40(sp)
80009eb0:	02412583          	lw	a1,36(sp)
80009eb4:	02012503          	lw	a0,32(sp)
80009eb8:	000300e7          	jalr	t1
80009ebc:	fb9ff06f          	j	80009e74 <OP_call+0xa8>
80009ec0:	02c12683          	lw	a3,44(sp)
80009ec4:	02812603          	lw	a2,40(sp)
80009ec8:	02412583          	lw	a1,36(sp)
80009ecc:	02012503          	lw	a0,32(sp)
80009ed0:	000300e7          	jalr	t1
80009ed4:	fa1ff06f          	j	80009e74 <OP_call+0xa8>
80009ed8:	03012703          	lw	a4,48(sp)
80009edc:	02c12683          	lw	a3,44(sp)
80009ee0:	02812603          	lw	a2,40(sp)
80009ee4:	02412583          	lw	a1,36(sp)
80009ee8:	02012503          	lw	a0,32(sp)
80009eec:	000300e7          	jalr	t1
80009ef0:	f85ff06f          	j	80009e74 <OP_call+0xa8>
80009ef4:	03412783          	lw	a5,52(sp)
80009ef8:	03012703          	lw	a4,48(sp)
80009efc:	02c12683          	lw	a3,44(sp)
80009f00:	02812603          	lw	a2,40(sp)
80009f04:	02412583          	lw	a1,36(sp)
80009f08:	02012503          	lw	a0,32(sp)
80009f0c:	000300e7          	jalr	t1
80009f10:	f65ff06f          	j	80009e74 <OP_call+0xa8>
80009f14:	03812803          	lw	a6,56(sp)
80009f18:	03412783          	lw	a5,52(sp)
80009f1c:	03012703          	lw	a4,48(sp)
80009f20:	02c12683          	lw	a3,44(sp)
80009f24:	02812603          	lw	a2,40(sp)
80009f28:	02412583          	lw	a1,36(sp)
80009f2c:	02012503          	lw	a0,32(sp)
80009f30:	000300e7          	jalr	t1
80009f34:	f41ff06f          	j	80009e74 <OP_call+0xa8>
80009f38:	03c12883          	lw	a7,60(sp)
80009f3c:	03812803          	lw	a6,56(sp)
80009f40:	03412783          	lw	a5,52(sp)
80009f44:	03012703          	lw	a4,48(sp)
80009f48:	02c12683          	lw	a3,44(sp)
80009f4c:	02812603          	lw	a2,40(sp)
80009f50:	02412583          	lw	a1,36(sp)
80009f54:	02012503          	lw	a0,32(sp)
80009f58:	000300e7          	jalr	t1
80009f5c:	f19ff06f          	j	80009e74 <OP_call+0xa8>
80009f60:	04012783          	lw	a5,64(sp)
80009f64:	03c12883          	lw	a7,60(sp)
80009f68:	03812803          	lw	a6,56(sp)
80009f6c:	00f12023          	sw	a5,0(sp)
80009f70:	03012703          	lw	a4,48(sp)
80009f74:	03412783          	lw	a5,52(sp)
80009f78:	02c12683          	lw	a3,44(sp)
80009f7c:	02812603          	lw	a2,40(sp)
80009f80:	02412583          	lw	a1,36(sp)
80009f84:	02012503          	lw	a0,32(sp)
80009f88:	000300e7          	jalr	t1
80009f8c:	ee9ff06f          	j	80009e74 <OP_call+0xa8>
80009f90:	04412783          	lw	a5,68(sp)
80009f94:	03c12883          	lw	a7,60(sp)
80009f98:	03812803          	lw	a6,56(sp)
80009f9c:	00f12223          	sw	a5,4(sp)
80009fa0:	04012783          	lw	a5,64(sp)
80009fa4:	03012703          	lw	a4,48(sp)
80009fa8:	02c12683          	lw	a3,44(sp)
80009fac:	00f12023          	sw	a5,0(sp)
80009fb0:	02812603          	lw	a2,40(sp)
80009fb4:	03412783          	lw	a5,52(sp)
80009fb8:	02412583          	lw	a1,36(sp)
80009fbc:	02012503          	lw	a0,32(sp)
80009fc0:	000300e7          	jalr	t1
80009fc4:	eb1ff06f          	j	80009e74 <OP_call+0xa8>
80009fc8:	04812783          	lw	a5,72(sp)
80009fcc:	03c12883          	lw	a7,60(sp)
80009fd0:	03812803          	lw	a6,56(sp)
80009fd4:	00f12423          	sw	a5,8(sp)
80009fd8:	04412783          	lw	a5,68(sp)
80009fdc:	03012703          	lw	a4,48(sp)
80009fe0:	02c12683          	lw	a3,44(sp)
80009fe4:	00f12223          	sw	a5,4(sp)
80009fe8:	04012783          	lw	a5,64(sp)
80009fec:	02812603          	lw	a2,40(sp)
80009ff0:	02412583          	lw	a1,36(sp)
80009ff4:	00f12023          	sw	a5,0(sp)
80009ff8:	02012503          	lw	a0,32(sp)
80009ffc:	03412783          	lw	a5,52(sp)
8000a000:	000300e7          	jalr	t1
8000a004:	e71ff06f          	j	80009e74 <OP_call+0xa8>
8000a008:	04c12783          	lw	a5,76(sp)
8000a00c:	03c12883          	lw	a7,60(sp)
8000a010:	03812803          	lw	a6,56(sp)
8000a014:	00f12623          	sw	a5,12(sp)
8000a018:	04812783          	lw	a5,72(sp)
8000a01c:	03012703          	lw	a4,48(sp)
8000a020:	02c12683          	lw	a3,44(sp)
8000a024:	00f12423          	sw	a5,8(sp)
8000a028:	04412783          	lw	a5,68(sp)
8000a02c:	02812603          	lw	a2,40(sp)
8000a030:	02412583          	lw	a1,36(sp)
8000a034:	00f12223          	sw	a5,4(sp)
8000a038:	04012783          	lw	a5,64(sp)
8000a03c:	02012503          	lw	a0,32(sp)
8000a040:	00f12023          	sw	a5,0(sp)
8000a044:	03412783          	lw	a5,52(sp)
8000a048:	000300e7          	jalr	t1
8000a04c:	e29ff06f          	j	80009e74 <OP_call+0xa8>
8000a050:	05012783          	lw	a5,80(sp)
8000a054:	03c12883          	lw	a7,60(sp)
8000a058:	03812803          	lw	a6,56(sp)
8000a05c:	00f12823          	sw	a5,16(sp)
8000a060:	04c12783          	lw	a5,76(sp)
8000a064:	03012703          	lw	a4,48(sp)
8000a068:	02c12683          	lw	a3,44(sp)
8000a06c:	00f12623          	sw	a5,12(sp)
8000a070:	04812783          	lw	a5,72(sp)
8000a074:	02812603          	lw	a2,40(sp)
8000a078:	02412583          	lw	a1,36(sp)
8000a07c:	00f12423          	sw	a5,8(sp)
8000a080:	04412783          	lw	a5,68(sp)
8000a084:	02012503          	lw	a0,32(sp)
8000a088:	00f12223          	sw	a5,4(sp)
8000a08c:	04012783          	lw	a5,64(sp)
8000a090:	00f12023          	sw	a5,0(sp)
8000a094:	03412783          	lw	a5,52(sp)
8000a098:	000300e7          	jalr	t1
8000a09c:	dd9ff06f          	j	80009e74 <OP_call+0xa8>
8000a0a0:	05412783          	lw	a5,84(sp)
8000a0a4:	03c12883          	lw	a7,60(sp)
8000a0a8:	03812803          	lw	a6,56(sp)
8000a0ac:	00f12a23          	sw	a5,20(sp)
8000a0b0:	05012783          	lw	a5,80(sp)
8000a0b4:	03012703          	lw	a4,48(sp)
8000a0b8:	02c12683          	lw	a3,44(sp)
8000a0bc:	00f12823          	sw	a5,16(sp)
8000a0c0:	04c12783          	lw	a5,76(sp)
8000a0c4:	02812603          	lw	a2,40(sp)
8000a0c8:	02412583          	lw	a1,36(sp)
8000a0cc:	00f12623          	sw	a5,12(sp)
8000a0d0:	04812783          	lw	a5,72(sp)
8000a0d4:	02012503          	lw	a0,32(sp)
8000a0d8:	00f12423          	sw	a5,8(sp)
8000a0dc:	04412783          	lw	a5,68(sp)
8000a0e0:	00f12223          	sw	a5,4(sp)
8000a0e4:	04012783          	lw	a5,64(sp)
8000a0e8:	00f12023          	sw	a5,0(sp)
8000a0ec:	03412783          	lw	a5,52(sp)
8000a0f0:	000300e7          	jalr	t1
8000a0f4:	d81ff06f          	j	80009e74 <OP_call+0xa8>
8000a0f8:	05812783          	lw	a5,88(sp)
8000a0fc:	03c12883          	lw	a7,60(sp)
8000a100:	03812803          	lw	a6,56(sp)
8000a104:	00f12c23          	sw	a5,24(sp)
8000a108:	05412783          	lw	a5,84(sp)
8000a10c:	03012703          	lw	a4,48(sp)
8000a110:	02c12683          	lw	a3,44(sp)
8000a114:	00f12a23          	sw	a5,20(sp)
8000a118:	05012783          	lw	a5,80(sp)
8000a11c:	02812603          	lw	a2,40(sp)
8000a120:	02412583          	lw	a1,36(sp)
8000a124:	00f12823          	sw	a5,16(sp)
8000a128:	04c12783          	lw	a5,76(sp)
8000a12c:	02012503          	lw	a0,32(sp)
8000a130:	00f12623          	sw	a5,12(sp)
8000a134:	04812783          	lw	a5,72(sp)
8000a138:	00f12423          	sw	a5,8(sp)
8000a13c:	04412783          	lw	a5,68(sp)
8000a140:	00f12223          	sw	a5,4(sp)
8000a144:	04012783          	lw	a5,64(sp)
8000a148:	00f12023          	sw	a5,0(sp)
8000a14c:	03412783          	lw	a5,52(sp)
8000a150:	000300e7          	jalr	t1
8000a154:	d21ff06f          	j	80009e74 <OP_call+0xa8>
8000a158:	05c12783          	lw	a5,92(sp)
8000a15c:	03c12883          	lw	a7,60(sp)
8000a160:	03812803          	lw	a6,56(sp)
8000a164:	00f12e23          	sw	a5,28(sp)
8000a168:	05812783          	lw	a5,88(sp)
8000a16c:	03012703          	lw	a4,48(sp)
8000a170:	02c12683          	lw	a3,44(sp)
8000a174:	00f12c23          	sw	a5,24(sp)
8000a178:	05412783          	lw	a5,84(sp)
8000a17c:	02812603          	lw	a2,40(sp)
8000a180:	02412583          	lw	a1,36(sp)
8000a184:	00f12a23          	sw	a5,20(sp)
8000a188:	05012783          	lw	a5,80(sp)
8000a18c:	02012503          	lw	a0,32(sp)
8000a190:	00f12823          	sw	a5,16(sp)
8000a194:	04c12783          	lw	a5,76(sp)
8000a198:	00f12623          	sw	a5,12(sp)
8000a19c:	04812783          	lw	a5,72(sp)
8000a1a0:	00f12423          	sw	a5,8(sp)
8000a1a4:	04412783          	lw	a5,68(sp)
8000a1a8:	00f12223          	sw	a5,4(sp)
8000a1ac:	04012783          	lw	a5,64(sp)
8000a1b0:	00f12023          	sw	a5,0(sp)
8000a1b4:	03412783          	lw	a5,52(sp)
8000a1b8:	000300e7          	jalr	t1
8000a1bc:	cb9ff06f          	j	80009e74 <OP_call+0xa8>

8000a1c0 <proc_type>:
8000a1c0:	ff010113          	addi	sp,sp,-16
8000a1c4:	01212023          	sw	s2,0(sp)
8000a1c8:	00450913          	addi	s2,a0,4
8000a1cc:	00912223          	sw	s1,4(sp)
8000a1d0:	00050493          	mv	s1,a0
8000a1d4:	00090513          	mv	a0,s2
8000a1d8:	00812423          	sw	s0,8(sp)
8000a1dc:	00112623          	sw	ra,12(sp)
8000a1e0:	2ec010ef          	jal	ra,8000b4cc <finsh_token_token>
8000a1e4:	fec50793          	addi	a5,a0,-20
8000a1e8:	00400413          	li	s0,4
8000a1ec:	06f46463          	bltu	s0,a5,8000a254 <proc_type+0x94>
8000a1f0:	feb50793          	addi	a5,a0,-21
8000a1f4:	00300713          	li	a4,3
8000a1f8:	00100413          	li	s0,1
8000a1fc:	00f76663          	bltu	a4,a5,8000a208 <proc_type+0x48>
8000a200:	02e50433          	mul	s0,a0,a4
8000a204:	fc440413          	addi	s0,s0,-60
8000a208:	00090513          	mv	a0,s2
8000a20c:	2c0010ef          	jal	ra,8000b4cc <finsh_token_token>
8000a210:	00500793          	li	a5,5
8000a214:	08f51463          	bne	a0,a5,8000a29c <proc_type+0xdc>
8000a218:	ffd40713          	addi	a4,s0,-3
8000a21c:	00a00793          	li	a5,10
8000a220:	00200413          	li	s0,2
8000a224:	00e7ea63          	bltu	a5,a4,8000a238 <proc_type+0x78>
8000a228:	00004797          	auipc	a5,0x4
8000a22c:	3e878793          	addi	a5,a5,1000 # 8000e610 <CSWTCH.5>
8000a230:	00e787b3          	add	a5,a5,a4
8000a234:	0007c403          	lbu	s0,0(a5)
8000a238:	00c12083          	lw	ra,12(sp)
8000a23c:	00040513          	mv	a0,s0
8000a240:	00812403          	lw	s0,8(sp)
8000a244:	00412483          	lw	s1,4(sp)
8000a248:	00012903          	lw	s2,0(sp)
8000a24c:	01010113          	addi	sp,sp,16
8000a250:	00008067          	ret
8000a254:	01900793          	li	a5,25
8000a258:	04f51863          	bne	a0,a5,8000a2a8 <proc_type+0xe8>
8000a25c:	00090513          	mv	a0,s2
8000a260:	26c010ef          	jal	ra,8000b4cc <finsh_token_token>
8000a264:	fec50793          	addi	a5,a0,-20
8000a268:	00f46e63          	bltu	s0,a5,8000a284 <proc_type+0xc4>
8000a26c:	feb50793          	addi	a5,a0,-21
8000a270:	00300413          	li	s0,3
8000a274:	02f46a63          	bltu	s0,a5,8000a2a8 <proc_type+0xe8>
8000a278:	02850433          	mul	s0,a0,s0
8000a27c:	fc540413          	addi	s0,s0,-59
8000a280:	f89ff06f          	j	8000a208 <proc_type+0x48>
8000a284:	00100793          	li	a5,1
8000a288:	00f482a3          	sb	a5,5(s1)
8000a28c:	00200513          	li	a0,2
8000a290:	e15fe0ef          	jal	ra,800090a4 <finsh_error_set>
8000a294:	00000413          	li	s0,0
8000a298:	f71ff06f          	j	8000a208 <proc_type+0x48>
8000a29c:	00100793          	li	a5,1
8000a2a0:	00f482a3          	sb	a5,5(s1)
8000a2a4:	f95ff06f          	j	8000a238 <proc_type+0x78>
8000a2a8:	00100793          	li	a5,1
8000a2ac:	00f482a3          	sb	a5,5(s1)
8000a2b0:	00300513          	li	a0,3
8000a2b4:	df1fe0ef          	jal	ra,800090a4 <finsh_error_set>
8000a2b8:	00000413          	li	s0,0
8000a2bc:	f7dff06f          	j	8000a238 <proc_type+0x78>

8000a2c0 <proc_identifier>:
8000a2c0:	ff010113          	addi	sp,sp,-16
8000a2c4:	00812423          	sw	s0,8(sp)
8000a2c8:	00050413          	mv	s0,a0
8000a2cc:	00450513          	addi	a0,a0,4
8000a2d0:	00912223          	sw	s1,4(sp)
8000a2d4:	00112623          	sw	ra,12(sp)
8000a2d8:	00058493          	mv	s1,a1
8000a2dc:	1f0010ef          	jal	ra,8000b4cc <finsh_token_token>
8000a2e0:	01f00793          	li	a5,31
8000a2e4:	00f50a63          	beq	a0,a5,8000a2f8 <proc_identifier+0x38>
8000a2e8:	00100513          	li	a0,1
8000a2ec:	db9fe0ef          	jal	ra,800090a4 <finsh_error_set>
8000a2f0:	00100793          	li	a5,1
8000a2f4:	00f402a3          	sb	a5,5(s0)
8000a2f8:	01440593          	addi	a1,s0,20
8000a2fc:	00048513          	mv	a0,s1
8000a300:	01000613          	li	a2,16
8000a304:	581010ef          	jal	ra,8000c084 <strncpy>
8000a308:	00c12083          	lw	ra,12(sp)
8000a30c:	00812403          	lw	s0,8(sp)
8000a310:	00412483          	lw	s1,4(sp)
8000a314:	00000513          	li	a0,0
8000a318:	01010113          	addi	sp,sp,16
8000a31c:	00008067          	ret

8000a320 <make_sys_node>:
8000a320:	ff010113          	addi	sp,sp,-16
8000a324:	00812423          	sw	s0,8(sp)
8000a328:	00912223          	sw	s1,4(sp)
8000a32c:	01212023          	sw	s2,0(sp)
8000a330:	00112623          	sw	ra,12(sp)
8000a334:	00058493          	mv	s1,a1
8000a338:	00060913          	mv	s2,a2
8000a33c:	8f4ff0ef          	jal	ra,80009430 <finsh_node_allocate>
8000a340:	00050413          	mv	s0,a0
8000a344:	02048663          	beqz	s1,8000a370 <make_sys_node+0x50>
8000a348:	02050463          	beqz	a0,8000a370 <make_sys_node+0x50>
8000a34c:	00952823          	sw	s1,16(a0)
8000a350:	0124a623          	sw	s2,12(s1)
8000a354:	00c12083          	lw	ra,12(sp)
8000a358:	00040513          	mv	a0,s0
8000a35c:	00812403          	lw	s0,8(sp)
8000a360:	00412483          	lw	s1,4(sp)
8000a364:	00012903          	lw	s2,0(sp)
8000a368:	01010113          	addi	sp,sp,16
8000a36c:	00008067          	ret
8000a370:	00e00513          	li	a0,14
8000a374:	d31fe0ef          	jal	ra,800090a4 <finsh_error_set>
8000a378:	fddff06f          	j	8000a354 <make_sys_node+0x34>

8000a37c <proc_assign_expr>:
8000a37c:	fe010113          	addi	sp,sp,-32
8000a380:	00912a23          	sw	s1,20(sp)
8000a384:	00050493          	mv	s1,a0
8000a388:	00112e23          	sw	ra,28(sp)
8000a38c:	00812c23          	sw	s0,24(sp)
8000a390:	01212823          	sw	s2,16(sp)
8000a394:	01312623          	sw	s3,12(sp)
8000a398:	00448913          	addi	s2,s1,4
8000a39c:	7e4000ef          	jal	ra,8000ab80 <proc_exclusive_or_expr>
8000a3a0:	00050413          	mv	s0,a0
8000a3a4:	00090513          	mv	a0,s2
8000a3a8:	124010ef          	jal	ra,8000b4cc <finsh_token_token>
8000a3ac:	00e00993          	li	s3,14
8000a3b0:	05350663          	beq	a0,s3,8000a3fc <proc_assign_expr+0x80>
8000a3b4:	00100993          	li	s3,1
8000a3b8:	013482a3          	sb	s3,5(s1)
8000a3bc:	00090513          	mv	a0,s2
8000a3c0:	10c010ef          	jal	ra,8000b4cc <finsh_token_token>
8000a3c4:	00c00793          	li	a5,12
8000a3c8:	06f51663          	bne	a0,a5,8000a434 <proc_assign_expr+0xb8>
8000a3cc:	00048513          	mv	a0,s1
8000a3d0:	fadff0ef          	jal	ra,8000a37c <proc_assign_expr>
8000a3d4:	00040593          	mv	a1,s0
8000a3d8:	01812403          	lw	s0,24(sp)
8000a3dc:	01c12083          	lw	ra,28(sp)
8000a3e0:	01412483          	lw	s1,20(sp)
8000a3e4:	01012903          	lw	s2,16(sp)
8000a3e8:	00c12983          	lw	s3,12(sp)
8000a3ec:	00050613          	mv	a2,a0
8000a3f0:	01300513          	li	a0,19
8000a3f4:	02010113          	addi	sp,sp,32
8000a3f8:	f29ff06f          	j	8000a320 <make_sys_node>
8000a3fc:	00048513          	mv	a0,s1
8000a400:	780000ef          	jal	ra,8000ab80 <proc_exclusive_or_expr>
8000a404:	00050613          	mv	a2,a0
8000a408:	00051c63          	bnez	a0,8000a420 <proc_assign_expr+0xa4>
8000a40c:	00500513          	li	a0,5
8000a410:	c95fe0ef          	jal	ra,800090a4 <finsh_error_set>
8000a414:	00090513          	mv	a0,s2
8000a418:	0b4010ef          	jal	ra,8000b4cc <finsh_token_token>
8000a41c:	f95ff06f          	j	8000a3b0 <proc_assign_expr+0x34>
8000a420:	00040593          	mv	a1,s0
8000a424:	00d00513          	li	a0,13
8000a428:	ef9ff0ef          	jal	ra,8000a320 <make_sys_node>
8000a42c:	00050413          	mv	s0,a0
8000a430:	fe5ff06f          	j	8000a414 <proc_assign_expr+0x98>
8000a434:	01c12083          	lw	ra,28(sp)
8000a438:	00040513          	mv	a0,s0
8000a43c:	01812403          	lw	s0,24(sp)
8000a440:	013482a3          	sb	s3,5(s1)
8000a444:	01012903          	lw	s2,16(sp)
8000a448:	01412483          	lw	s1,20(sp)
8000a44c:	00c12983          	lw	s3,12(sp)
8000a450:	02010113          	addi	sp,sp,32
8000a454:	00008067          	ret

8000a458 <proc_expr_statement>:
8000a458:	fe010113          	addi	sp,sp,-32
8000a45c:	01412423          	sw	s4,8(sp)
8000a460:	00450a13          	addi	s4,a0,4
8000a464:	00812c23          	sw	s0,24(sp)
8000a468:	00050413          	mv	s0,a0
8000a46c:	000a0513          	mv	a0,s4
8000a470:	00912a23          	sw	s1,20(sp)
8000a474:	01312623          	sw	s3,12(sp)
8000a478:	00112e23          	sw	ra,28(sp)
8000a47c:	01212823          	sw	s2,16(sp)
8000a480:	00400993          	li	s3,4
8000a484:	048010ef          	jal	ra,8000b4cc <finsh_token_token>
8000a488:	00000493          	li	s1,0
8000a48c:	03350863          	beq	a0,s3,8000a4bc <proc_expr_statement+0x64>
8000a490:	00100913          	li	s2,1
8000a494:	012402a3          	sb	s2,5(s0)
8000a498:	00040513          	mv	a0,s0
8000a49c:	ee1ff0ef          	jal	ra,8000a37c <proc_assign_expr>
8000a4a0:	00050493          	mv	s1,a0
8000a4a4:	000a0513          	mv	a0,s4
8000a4a8:	024010ef          	jal	ra,8000b4cc <finsh_token_token>
8000a4ac:	01350863          	beq	a0,s3,8000a4bc <proc_expr_statement+0x64>
8000a4b0:	00100513          	li	a0,1
8000a4b4:	bf1fe0ef          	jal	ra,800090a4 <finsh_error_set>
8000a4b8:	012402a3          	sb	s2,5(s0)
8000a4bc:	01c12083          	lw	ra,28(sp)
8000a4c0:	01812403          	lw	s0,24(sp)
8000a4c4:	01012903          	lw	s2,16(sp)
8000a4c8:	00c12983          	lw	s3,12(sp)
8000a4cc:	00812a03          	lw	s4,8(sp)
8000a4d0:	00048513          	mv	a0,s1
8000a4d4:	01412483          	lw	s1,20(sp)
8000a4d8:	02010113          	addi	sp,sp,32
8000a4dc:	00008067          	ret

8000a4e0 <proc_cast_expr>:
8000a4e0:	f9010113          	addi	sp,sp,-112
8000a4e4:	05312e23          	sw	s3,92(sp)
8000a4e8:	00450993          	addi	s3,a0,4
8000a4ec:	06912223          	sw	s1,100(sp)
8000a4f0:	00050493          	mv	s1,a0
8000a4f4:	00098513          	mv	a0,s3
8000a4f8:	06112623          	sw	ra,108(sp)
8000a4fc:	06812423          	sw	s0,104(sp)
8000a500:	07212023          	sw	s2,96(sp)
8000a504:	05412c23          	sw	s4,88(sp)
8000a508:	05512a23          	sw	s5,84(sp)
8000a50c:	05612823          	sw	s6,80(sp)
8000a510:	05712623          	sw	s7,76(sp)
8000a514:	05812423          	sw	s8,72(sp)
8000a518:	05912223          	sw	s9,68(sp)
8000a51c:	05a12023          	sw	s10,64(sp)
8000a520:	03b12e23          	sw	s11,60(sp)
8000a524:	7a9000ef          	jal	ra,8000b4cc <finsh_token_token>
8000a528:	00100793          	li	a5,1
8000a52c:	08f51263          	bne	a0,a5,8000a5b0 <proc_cast_expr+0xd0>
8000a530:	00050413          	mv	s0,a0
8000a534:	00048513          	mv	a0,s1
8000a538:	c89ff0ef          	jal	ra,8000a1c0 <proc_type>
8000a53c:	00050913          	mv	s2,a0
8000a540:	00098513          	mv	a0,s3
8000a544:	789000ef          	jal	ra,8000b4cc <finsh_token_token>
8000a548:	00200793          	li	a5,2
8000a54c:	00f50863          	beq	a0,a5,8000a55c <proc_cast_expr+0x7c>
8000a550:	00100513          	li	a0,1
8000a554:	b51fe0ef          	jal	ra,800090a4 <finsh_error_set>
8000a558:	008482a3          	sb	s0,5(s1)
8000a55c:	00048513          	mv	a0,s1
8000a560:	f81ff0ef          	jal	ra,8000a4e0 <proc_cast_expr>
8000a564:	00050413          	mv	s0,a0
8000a568:	04050463          	beqz	a0,8000a5b0 <proc_cast_expr+0xd0>
8000a56c:	012500a3          	sb	s2,1(a0)
8000a570:	06c12083          	lw	ra,108(sp)
8000a574:	00040513          	mv	a0,s0
8000a578:	06812403          	lw	s0,104(sp)
8000a57c:	06412483          	lw	s1,100(sp)
8000a580:	06012903          	lw	s2,96(sp)
8000a584:	05c12983          	lw	s3,92(sp)
8000a588:	05812a03          	lw	s4,88(sp)
8000a58c:	05412a83          	lw	s5,84(sp)
8000a590:	05012b03          	lw	s6,80(sp)
8000a594:	04c12b83          	lw	s7,76(sp)
8000a598:	04812c03          	lw	s8,72(sp)
8000a59c:	04412c83          	lw	s9,68(sp)
8000a5a0:	04012d03          	lw	s10,64(sp)
8000a5a4:	03c12d83          	lw	s11,60(sp)
8000a5a8:	07010113          	addi	sp,sp,112
8000a5ac:	00008067          	ret
8000a5b0:	00100793          	li	a5,1
8000a5b4:	00f482a3          	sb	a5,5(s1)
8000a5b8:	00098513          	mv	a0,s3
8000a5bc:	711000ef          	jal	ra,8000b4cc <finsh_token_token>
8000a5c0:	ffb50513          	addi	a0,a0,-5
8000a5c4:	00b00793          	li	a5,11
8000a5c8:	0ca7e863          	bltu	a5,a0,8000a698 <proc_cast_expr+0x1b8>
8000a5cc:	00004717          	auipc	a4,0x4
8000a5d0:	ffc70713          	addi	a4,a4,-4 # 8000e5c8 <op_table+0xc4>
8000a5d4:	00251513          	slli	a0,a0,0x2
8000a5d8:	00e50533          	add	a0,a0,a4
8000a5dc:	00052783          	lw	a5,0(a0)
8000a5e0:	00e787b3          	add	a5,a5,a4
8000a5e4:	00078067          	jr	a5
8000a5e8:	00048513          	mv	a0,s1
8000a5ec:	ef5ff0ef          	jal	ra,8000a4e0 <proc_cast_expr>
8000a5f0:	00050413          	mv	s0,a0
8000a5f4:	f7dff06f          	j	8000a570 <proc_cast_expr+0x90>
8000a5f8:	00048513          	mv	a0,s1
8000a5fc:	ee5ff0ef          	jal	ra,8000a4e0 <proc_cast_expr>
8000a600:	00050593          	mv	a1,a0
8000a604:	00000613          	li	a2,0
8000a608:	01500513          	li	a0,21
8000a60c:	d15ff0ef          	jal	ra,8000a320 <make_sys_node>
8000a610:	fe1ff06f          	j	8000a5f0 <proc_cast_expr+0x110>
8000a614:	00048513          	mv	a0,s1
8000a618:	ec9ff0ef          	jal	ra,8000a4e0 <proc_cast_expr>
8000a61c:	00a12623          	sw	a0,12(sp)
8000a620:	00000513          	li	a0,0
8000a624:	fa1fe0ef          	jal	ra,800095c4 <finsh_node_new_long>
8000a628:	00050593          	mv	a1,a0
8000a62c:	00c12603          	lw	a2,12(sp)
8000a630:	00800513          	li	a0,8
8000a634:	fd9ff06f          	j	8000a60c <proc_cast_expr+0x12c>
8000a638:	00048513          	mv	a0,s1
8000a63c:	ea5ff0ef          	jal	ra,8000a4e0 <proc_cast_expr>
8000a640:	00050593          	mv	a1,a0
8000a644:	00000613          	li	a2,0
8000a648:	01600513          	li	a0,22
8000a64c:	fc1ff06f          	j	8000a60c <proc_cast_expr+0x12c>
8000a650:	00048513          	mv	a0,s1
8000a654:	e8dff0ef          	jal	ra,8000a4e0 <proc_cast_expr>
8000a658:	00050593          	mv	a1,a0
8000a65c:	00000613          	li	a2,0
8000a660:	00f00513          	li	a0,15
8000a664:	fa9ff06f          	j	8000a60c <proc_cast_expr+0x12c>
8000a668:	00048513          	mv	a0,s1
8000a66c:	e75ff0ef          	jal	ra,8000a4e0 <proc_cast_expr>
8000a670:	00050593          	mv	a1,a0
8000a674:	00000613          	li	a2,0
8000a678:	01900513          	li	a0,25
8000a67c:	f91ff06f          	j	8000a60c <proc_cast_expr+0x12c>
8000a680:	00048513          	mv	a0,s1
8000a684:	e5dff0ef          	jal	ra,8000a4e0 <proc_cast_expr>
8000a688:	00050593          	mv	a1,a0
8000a68c:	00000613          	li	a2,0
8000a690:	01a00513          	li	a0,26
8000a694:	f79ff06f          	j	8000a60c <proc_cast_expr+0x12c>
8000a698:	00100793          	li	a5,1
8000a69c:	00f482a3          	sb	a5,5(s1)
8000a6a0:	00098513          	mv	a0,s3
8000a6a4:	629000ef          	jal	ra,8000b4cc <finsh_token_token>
8000a6a8:	00100793          	li	a5,1
8000a6ac:	00050913          	mv	s2,a0
8000a6b0:	04f50863          	beq	a0,a5,8000a700 <proc_cast_expr+0x220>
8000a6b4:	fe650913          	addi	s2,a0,-26
8000a6b8:	00500793          	li	a5,5
8000a6bc:	0d27ee63          	bltu	a5,s2,8000a798 <proc_cast_expr+0x2b8>
8000a6c0:	00004717          	auipc	a4,0x4
8000a6c4:	f3870713          	addi	a4,a4,-200 # 8000e5f8 <op_table+0xf4>
8000a6c8:	00291913          	slli	s2,s2,0x2
8000a6cc:	00e90933          	add	s2,s2,a4
8000a6d0:	00092783          	lw	a5,0(s2)
8000a6d4:	00e787b3          	add	a5,a5,a4
8000a6d8:	00078067          	jr	a5
8000a6dc:	00100793          	li	a5,1
8000a6e0:	00f482a3          	sb	a5,5(s1)
8000a6e4:	01c10593          	addi	a1,sp,28
8000a6e8:	00048513          	mv	a0,s1
8000a6ec:	bd5ff0ef          	jal	ra,8000a2c0 <proc_identifier>
8000a6f0:	01c10513          	addi	a0,sp,28
8000a6f4:	d81fe0ef          	jal	ra,80009474 <finsh_node_new_id>
8000a6f8:	00050413          	mv	s0,a0
8000a6fc:	02c0006f          	j	8000a728 <proc_cast_expr+0x248>
8000a700:	00048513          	mv	a0,s1
8000a704:	c79ff0ef          	jal	ra,8000a37c <proc_assign_expr>
8000a708:	00050413          	mv	s0,a0
8000a70c:	00098513          	mv	a0,s3
8000a710:	5bd000ef          	jal	ra,8000b4cc <finsh_token_token>
8000a714:	00200793          	li	a5,2
8000a718:	00f50863          	beq	a0,a5,8000a728 <proc_cast_expr+0x248>
8000a71c:	00100513          	li	a0,1
8000a720:	985fe0ef          	jal	ra,800090a4 <finsh_error_set>
8000a724:	012482a3          	sb	s2,5(s1)
8000a728:	00098513          	mv	a0,s3
8000a72c:	5a1000ef          	jal	ra,8000b4cc <finsh_token_token>
8000a730:	00700b93          	li	s7,7
8000a734:	00900c13          	li	s8,9
8000a738:	00100a13          	li	s4,1
8000a73c:	00200a93          	li	s5,2
8000a740:	00100b13          	li	s6,1
8000a744:	00300c93          	li	s9,3
8000a748:	07750063          	beq	a0,s7,8000a7a8 <proc_cast_expr+0x2c8>
8000a74c:	07850e63          	beq	a0,s8,8000a7c8 <proc_cast_expr+0x2e8>
8000a750:	09450463          	beq	a0,s4,8000a7d8 <proc_cast_expr+0x2f8>
8000a754:	014482a3          	sb	s4,5(s1)
8000a758:	e19ff06f          	j	8000a570 <proc_cast_expr+0x90>
8000a75c:	0104a503          	lw	a0,16(s1)
8000a760:	e19fe0ef          	jal	ra,80009578 <finsh_node_new_int>
8000a764:	f95ff06f          	j	8000a6f8 <proc_cast_expr+0x218>
8000a768:	0104a503          	lw	a0,16(s1)
8000a76c:	e59fe0ef          	jal	ra,800095c4 <finsh_node_new_long>
8000a770:	f89ff06f          	j	8000a6f8 <proc_cast_expr+0x218>
8000a774:	0104c503          	lbu	a0,16(s1)
8000a778:	db5fe0ef          	jal	ra,8000952c <finsh_node_new_char>
8000a77c:	f7dff06f          	j	8000a6f8 <proc_cast_expr+0x218>
8000a780:	01448513          	addi	a0,s1,20
8000a784:	e8dfe0ef          	jal	ra,80009610 <finsh_node_new_string>
8000a788:	f71ff06f          	j	8000a6f8 <proc_cast_expr+0x218>
8000a78c:	00000513          	li	a0,0
8000a790:	f15fe0ef          	jal	ra,800096a4 <finsh_node_new_ptr>
8000a794:	f65ff06f          	j	8000a6f8 <proc_cast_expr+0x218>
8000a798:	00100513          	li	a0,1
8000a79c:	909fe0ef          	jal	ra,800090a4 <finsh_error_set>
8000a7a0:	00000413          	li	s0,0
8000a7a4:	f85ff06f          	j	8000a728 <proc_cast_expr+0x248>
8000a7a8:	00000613          	li	a2,0
8000a7ac:	00040593          	mv	a1,s0
8000a7b0:	01700513          	li	a0,23
8000a7b4:	b6dff0ef          	jal	ra,8000a320 <make_sys_node>
8000a7b8:	00050413          	mv	s0,a0
8000a7bc:	00098513          	mv	a0,s3
8000a7c0:	50d000ef          	jal	ra,8000b4cc <finsh_token_token>
8000a7c4:	f85ff06f          	j	8000a748 <proc_cast_expr+0x268>
8000a7c8:	00000613          	li	a2,0
8000a7cc:	00040593          	mv	a1,s0
8000a7d0:	01800513          	li	a0,24
8000a7d4:	fe1ff06f          	j	8000a7b4 <proc_cast_expr+0x2d4>
8000a7d8:	00098513          	mv	a0,s3
8000a7dc:	4f1000ef          	jal	ra,8000b4cc <finsh_token_token>
8000a7e0:	00000913          	li	s2,0
8000a7e4:	05550263          	beq	a0,s5,8000a828 <proc_cast_expr+0x348>
8000a7e8:	014482a3          	sb	s4,5(s1)
8000a7ec:	00048513          	mv	a0,s1
8000a7f0:	b8dff0ef          	jal	ra,8000a37c <proc_assign_expr>
8000a7f4:	00050913          	mv	s2,a0
8000a7f8:	00050c63          	beqz	a0,8000a810 <proc_cast_expr+0x330>
8000a7fc:	00098513          	mv	a0,s3
8000a800:	4cd000ef          	jal	ra,8000b4cc <finsh_token_token>
8000a804:	00090d93          	mv	s11,s2
8000a808:	03950863          	beq	a0,s9,8000a838 <proc_cast_expr+0x358>
8000a80c:	016482a3          	sb	s6,5(s1)
8000a810:	00098513          	mv	a0,s3
8000a814:	4b9000ef          	jal	ra,8000b4cc <finsh_token_token>
8000a818:	01550863          	beq	a0,s5,8000a828 <proc_cast_expr+0x348>
8000a81c:	00100513          	li	a0,1
8000a820:	885fe0ef          	jal	ra,800090a4 <finsh_error_set>
8000a824:	016482a3          	sb	s6,5(s1)
8000a828:	00090613          	mv	a2,s2
8000a82c:	00040593          	mv	a1,s0
8000a830:	01200513          	li	a0,18
8000a834:	f81ff06f          	j	8000a7b4 <proc_cast_expr+0x2d4>
8000a838:	00048513          	mv	a0,s1
8000a83c:	b41ff0ef          	jal	ra,8000a37c <proc_assign_expr>
8000a840:	00ada623          	sw	a0,12(s11)
8000a844:	00050d13          	mv	s10,a0
8000a848:	00051863          	bnez	a0,8000a858 <proc_cast_expr+0x378>
8000a84c:	00500513          	li	a0,5
8000a850:	855fe0ef          	jal	ra,800090a4 <finsh_error_set>
8000a854:	000d8d13          	mv	s10,s11
8000a858:	00098513          	mv	a0,s3
8000a85c:	471000ef          	jal	ra,8000b4cc <finsh_token_token>
8000a860:	000d0d93          	mv	s11,s10
8000a864:	fa5ff06f          	j	8000a808 <proc_cast_expr+0x328>

8000a868 <proc_multiplicative_expr>:
8000a868:	fd010113          	addi	sp,sp,-48
8000a86c:	03212023          	sw	s2,32(sp)
8000a870:	00050913          	mv	s2,a0
8000a874:	02112623          	sw	ra,44(sp)
8000a878:	02812423          	sw	s0,40(sp)
8000a87c:	02912223          	sw	s1,36(sp)
8000a880:	01312e23          	sw	s3,28(sp)
8000a884:	01412c23          	sw	s4,24(sp)
8000a888:	01512a23          	sw	s5,20(sp)
8000a88c:	01612823          	sw	s6,16(sp)
8000a890:	01712623          	sw	s7,12(sp)
8000a894:	00490a13          	addi	s4,s2,4
8000a898:	c49ff0ef          	jal	ra,8000a4e0 <proc_cast_expr>
8000a89c:	00050413          	mv	s0,a0
8000a8a0:	000a0513          	mv	a0,s4
8000a8a4:	429000ef          	jal	ra,8000b4cc <finsh_token_token>
8000a8a8:	00050493          	mv	s1,a0
8000a8ac:	00500a93          	li	s5,5
8000a8b0:	00100993          	li	s3,1
8000a8b4:	00a00b13          	li	s6,10
8000a8b8:	00b00b93          	li	s7,11
8000a8bc:	05548063          	beq	s1,s5,8000a8fc <proc_multiplicative_expr+0x94>
8000a8c0:	ff648793          	addi	a5,s1,-10
8000a8c4:	02f9fc63          	bgeu	s3,a5,8000a8fc <proc_multiplicative_expr+0x94>
8000a8c8:	02c12083          	lw	ra,44(sp)
8000a8cc:	00040513          	mv	a0,s0
8000a8d0:	02812403          	lw	s0,40(sp)
8000a8d4:	013902a3          	sb	s3,5(s2)
8000a8d8:	02412483          	lw	s1,36(sp)
8000a8dc:	02012903          	lw	s2,32(sp)
8000a8e0:	01c12983          	lw	s3,28(sp)
8000a8e4:	01812a03          	lw	s4,24(sp)
8000a8e8:	01412a83          	lw	s5,20(sp)
8000a8ec:	01012b03          	lw	s6,16(sp)
8000a8f0:	00c12b83          	lw	s7,12(sp)
8000a8f4:	03010113          	addi	sp,sp,48
8000a8f8:	00008067          	ret
8000a8fc:	00090513          	mv	a0,s2
8000a900:	be1ff0ef          	jal	ra,8000a4e0 <proc_cast_expr>
8000a904:	00050613          	mv	a2,a0
8000a908:	00051863          	bnez	a0,8000a918 <proc_multiplicative_expr+0xb0>
8000a90c:	00500513          	li	a0,5
8000a910:	f94fe0ef          	jal	ra,800090a4 <finsh_error_set>
8000a914:	0200006f          	j	8000a934 <proc_multiplicative_expr+0xcc>
8000a918:	03648663          	beq	s1,s6,8000a944 <proc_multiplicative_expr+0xdc>
8000a91c:	03748a63          	beq	s1,s7,8000a950 <proc_multiplicative_expr+0xe8>
8000a920:	ff5496e3          	bne	s1,s5,8000a90c <proc_multiplicative_expr+0xa4>
8000a924:	00040593          	mv	a1,s0
8000a928:	00900513          	li	a0,9
8000a92c:	9f5ff0ef          	jal	ra,8000a320 <make_sys_node>
8000a930:	00050413          	mv	s0,a0
8000a934:	000a0513          	mv	a0,s4
8000a938:	395000ef          	jal	ra,8000b4cc <finsh_token_token>
8000a93c:	00050493          	mv	s1,a0
8000a940:	f7dff06f          	j	8000a8bc <proc_multiplicative_expr+0x54>
8000a944:	00040593          	mv	a1,s0
8000a948:	00a00513          	li	a0,10
8000a94c:	fe1ff06f          	j	8000a92c <proc_multiplicative_expr+0xc4>
8000a950:	00040593          	mv	a1,s0
8000a954:	00b00513          	li	a0,11
8000a958:	fd5ff06f          	j	8000a92c <proc_multiplicative_expr+0xc4>

8000a95c <proc_additive_expr>:
8000a95c:	fe010113          	addi	sp,sp,-32
8000a960:	01212823          	sw	s2,16(sp)
8000a964:	00050913          	mv	s2,a0
8000a968:	00112e23          	sw	ra,28(sp)
8000a96c:	00812c23          	sw	s0,24(sp)
8000a970:	00912a23          	sw	s1,20(sp)
8000a974:	01312623          	sw	s3,12(sp)
8000a978:	01412423          	sw	s4,8(sp)
8000a97c:	01512223          	sw	s5,4(sp)
8000a980:	00490993          	addi	s3,s2,4
8000a984:	ee5ff0ef          	jal	ra,8000a868 <proc_multiplicative_expr>
8000a988:	00050413          	mv	s0,a0
8000a98c:	00098513          	mv	a0,s3
8000a990:	33d000ef          	jal	ra,8000b4cc <finsh_token_token>
8000a994:	00050493          	mv	s1,a0
8000a998:	00600a13          	li	s4,6
8000a99c:	00800a93          	li	s5,8
8000a9a0:	ffa48793          	addi	a5,s1,-6
8000a9a4:	ffd7f793          	andi	a5,a5,-3
8000a9a8:	02078a63          	beqz	a5,8000a9dc <proc_additive_expr+0x80>
8000a9ac:	01c12083          	lw	ra,28(sp)
8000a9b0:	00040513          	mv	a0,s0
8000a9b4:	01812403          	lw	s0,24(sp)
8000a9b8:	00100793          	li	a5,1
8000a9bc:	00f902a3          	sb	a5,5(s2)
8000a9c0:	01412483          	lw	s1,20(sp)
8000a9c4:	01012903          	lw	s2,16(sp)
8000a9c8:	00c12983          	lw	s3,12(sp)
8000a9cc:	00812a03          	lw	s4,8(sp)
8000a9d0:	00412a83          	lw	s5,4(sp)
8000a9d4:	02010113          	addi	sp,sp,32
8000a9d8:	00008067          	ret
8000a9dc:	00090513          	mv	a0,s2
8000a9e0:	e89ff0ef          	jal	ra,8000a868 <proc_multiplicative_expr>
8000a9e4:	00050613          	mv	a2,a0
8000a9e8:	00051863          	bnez	a0,8000a9f8 <proc_additive_expr+0x9c>
8000a9ec:	00500513          	li	a0,5
8000a9f0:	eb4fe0ef          	jal	ra,800090a4 <finsh_error_set>
8000a9f4:	01c0006f          	j	8000aa10 <proc_additive_expr+0xb4>
8000a9f8:	03448463          	beq	s1,s4,8000aa20 <proc_additive_expr+0xc4>
8000a9fc:	ff5498e3          	bne	s1,s5,8000a9ec <proc_additive_expr+0x90>
8000aa00:	00040593          	mv	a1,s0
8000aa04:	00800513          	li	a0,8
8000aa08:	919ff0ef          	jal	ra,8000a320 <make_sys_node>
8000aa0c:	00050413          	mv	s0,a0
8000aa10:	00098513          	mv	a0,s3
8000aa14:	2b9000ef          	jal	ra,8000b4cc <finsh_token_token>
8000aa18:	00050493          	mv	s1,a0
8000aa1c:	f85ff06f          	j	8000a9a0 <proc_additive_expr+0x44>
8000aa20:	00040593          	mv	a1,s0
8000aa24:	00700513          	li	a0,7
8000aa28:	fe1ff06f          	j	8000aa08 <proc_additive_expr+0xac>

8000aa2c <proc_shift_expr>:
8000aa2c:	fe010113          	addi	sp,sp,-32
8000aa30:	01212823          	sw	s2,16(sp)
8000aa34:	00050913          	mv	s2,a0
8000aa38:	00112e23          	sw	ra,28(sp)
8000aa3c:	00812c23          	sw	s0,24(sp)
8000aa40:	00912a23          	sw	s1,20(sp)
8000aa44:	01312623          	sw	s3,12(sp)
8000aa48:	01412423          	sw	s4,8(sp)
8000aa4c:	01512223          	sw	s5,4(sp)
8000aa50:	00490a13          	addi	s4,s2,4
8000aa54:	f09ff0ef          	jal	ra,8000a95c <proc_additive_expr>
8000aa58:	00050413          	mv	s0,a0
8000aa5c:	000a0513          	mv	a0,s4
8000aa60:	26d000ef          	jal	ra,8000b4cc <finsh_token_token>
8000aa64:	00050493          	mv	s1,a0
8000aa68:	00100993          	li	s3,1
8000aa6c:	01200a93          	li	s5,18
8000aa70:	fef48793          	addi	a5,s1,-17
8000aa74:	02f9f863          	bgeu	s3,a5,8000aaa4 <proc_shift_expr+0x78>
8000aa78:	01c12083          	lw	ra,28(sp)
8000aa7c:	00040513          	mv	a0,s0
8000aa80:	01812403          	lw	s0,24(sp)
8000aa84:	013902a3          	sb	s3,5(s2)
8000aa88:	01412483          	lw	s1,20(sp)
8000aa8c:	01012903          	lw	s2,16(sp)
8000aa90:	00c12983          	lw	s3,12(sp)
8000aa94:	00812a03          	lw	s4,8(sp)
8000aa98:	00412a83          	lw	s5,4(sp)
8000aa9c:	02010113          	addi	sp,sp,32
8000aaa0:	00008067          	ret
8000aaa4:	00090513          	mv	a0,s2
8000aaa8:	eb5ff0ef          	jal	ra,8000a95c <proc_additive_expr>
8000aaac:	00050613          	mv	a2,a0
8000aab0:	00051e63          	bnez	a0,8000aacc <proc_shift_expr+0xa0>
8000aab4:	00500513          	li	a0,5
8000aab8:	decfe0ef          	jal	ra,800090a4 <finsh_error_set>
8000aabc:	000a0513          	mv	a0,s4
8000aac0:	20d000ef          	jal	ra,8000b4cc <finsh_token_token>
8000aac4:	00050493          	mv	s1,a0
8000aac8:	fa9ff06f          	j	8000aa70 <proc_shift_expr+0x44>
8000aacc:	00040593          	mv	a1,s0
8000aad0:	01000513          	li	a0,16
8000aad4:	01549463          	bne	s1,s5,8000aadc <proc_shift_expr+0xb0>
8000aad8:	01100513          	li	a0,17
8000aadc:	845ff0ef          	jal	ra,8000a320 <make_sys_node>
8000aae0:	00050413          	mv	s0,a0
8000aae4:	fd9ff06f          	j	8000aabc <proc_shift_expr+0x90>

8000aae8 <proc_and_expr>:
8000aae8:	fe010113          	addi	sp,sp,-32
8000aaec:	00912a23          	sw	s1,20(sp)
8000aaf0:	00050493          	mv	s1,a0
8000aaf4:	00112e23          	sw	ra,28(sp)
8000aaf8:	00812c23          	sw	s0,24(sp)
8000aafc:	01212823          	sw	s2,16(sp)
8000ab00:	01312623          	sw	s3,12(sp)
8000ab04:	00448913          	addi	s2,s1,4
8000ab08:	f25ff0ef          	jal	ra,8000aa2c <proc_shift_expr>
8000ab0c:	00050413          	mv	s0,a0
8000ab10:	00090513          	mv	a0,s2
8000ab14:	1b9000ef          	jal	ra,8000b4cc <finsh_token_token>
8000ab18:	00d00993          	li	s3,13
8000ab1c:	03350663          	beq	a0,s3,8000ab48 <proc_and_expr+0x60>
8000ab20:	01c12083          	lw	ra,28(sp)
8000ab24:	00040513          	mv	a0,s0
8000ab28:	01812403          	lw	s0,24(sp)
8000ab2c:	00100793          	li	a5,1
8000ab30:	00f482a3          	sb	a5,5(s1)
8000ab34:	01012903          	lw	s2,16(sp)
8000ab38:	01412483          	lw	s1,20(sp)
8000ab3c:	00c12983          	lw	s3,12(sp)
8000ab40:	02010113          	addi	sp,sp,32
8000ab44:	00008067          	ret
8000ab48:	00048513          	mv	a0,s1
8000ab4c:	ee1ff0ef          	jal	ra,8000aa2c <proc_shift_expr>
8000ab50:	00050613          	mv	a2,a0
8000ab54:	00051c63          	bnez	a0,8000ab6c <proc_and_expr+0x84>
8000ab58:	00500513          	li	a0,5
8000ab5c:	d48fe0ef          	jal	ra,800090a4 <finsh_error_set>
8000ab60:	00090513          	mv	a0,s2
8000ab64:	169000ef          	jal	ra,8000b4cc <finsh_token_token>
8000ab68:	fb5ff06f          	j	8000ab1c <proc_and_expr+0x34>
8000ab6c:	00040593          	mv	a1,s0
8000ab70:	00c00513          	li	a0,12
8000ab74:	facff0ef          	jal	ra,8000a320 <make_sys_node>
8000ab78:	00050413          	mv	s0,a0
8000ab7c:	fe5ff06f          	j	8000ab60 <proc_and_expr+0x78>

8000ab80 <proc_exclusive_or_expr>:
8000ab80:	fe010113          	addi	sp,sp,-32
8000ab84:	00912a23          	sw	s1,20(sp)
8000ab88:	00050493          	mv	s1,a0
8000ab8c:	00112e23          	sw	ra,28(sp)
8000ab90:	00812c23          	sw	s0,24(sp)
8000ab94:	01212823          	sw	s2,16(sp)
8000ab98:	01312623          	sw	s3,12(sp)
8000ab9c:	00448913          	addi	s2,s1,4
8000aba0:	f49ff0ef          	jal	ra,8000aae8 <proc_and_expr>
8000aba4:	00050413          	mv	s0,a0
8000aba8:	00090513          	mv	a0,s2
8000abac:	121000ef          	jal	ra,8000b4cc <finsh_token_token>
8000abb0:	00f00993          	li	s3,15
8000abb4:	03350663          	beq	a0,s3,8000abe0 <proc_exclusive_or_expr+0x60>
8000abb8:	01c12083          	lw	ra,28(sp)
8000abbc:	00040513          	mv	a0,s0
8000abc0:	01812403          	lw	s0,24(sp)
8000abc4:	00100793          	li	a5,1
8000abc8:	00f482a3          	sb	a5,5(s1)
8000abcc:	01012903          	lw	s2,16(sp)
8000abd0:	01412483          	lw	s1,20(sp)
8000abd4:	00c12983          	lw	s3,12(sp)
8000abd8:	02010113          	addi	sp,sp,32
8000abdc:	00008067          	ret
8000abe0:	00048513          	mv	a0,s1
8000abe4:	f05ff0ef          	jal	ra,8000aae8 <proc_and_expr>
8000abe8:	00050613          	mv	a2,a0
8000abec:	00051c63          	bnez	a0,8000ac04 <proc_exclusive_or_expr+0x84>
8000abf0:	00500513          	li	a0,5
8000abf4:	cb0fe0ef          	jal	ra,800090a4 <finsh_error_set>
8000abf8:	00090513          	mv	a0,s2
8000abfc:	0d1000ef          	jal	ra,8000b4cc <finsh_token_token>
8000ac00:	fb5ff06f          	j	8000abb4 <proc_exclusive_or_expr+0x34>
8000ac04:	00040593          	mv	a1,s0
8000ac08:	00e00513          	li	a0,14
8000ac0c:	f14ff0ef          	jal	ra,8000a320 <make_sys_node>
8000ac10:	00050413          	mv	s0,a0
8000ac14:	fe5ff06f          	j	8000abf8 <proc_exclusive_or_expr+0x78>

8000ac18 <proc_variable_decl>:
8000ac18:	fa010113          	addi	sp,sp,-96
8000ac1c:	05212823          	sw	s2,80(sp)
8000ac20:	05412423          	sw	s4,72(sp)
8000ac24:	04112e23          	sw	ra,92(sp)
8000ac28:	04812c23          	sw	s0,88(sp)
8000ac2c:	04912a23          	sw	s1,84(sp)
8000ac30:	05312623          	sw	s3,76(sp)
8000ac34:	05512223          	sw	s5,68(sp)
8000ac38:	05612023          	sw	s6,64(sp)
8000ac3c:	03712e23          	sw	s7,60(sp)
8000ac40:	03812c23          	sw	s8,56(sp)
8000ac44:	00050913          	mv	s2,a0
8000ac48:	d78ff0ef          	jal	ra,8000a1c0 <proc_type>
8000ac4c:	00050a13          	mv	s4,a0
8000ac50:	01c10593          	addi	a1,sp,28
8000ac54:	00090513          	mv	a0,s2
8000ac58:	e68ff0ef          	jal	ra,8000a2c0 <proc_identifier>
8000ac5c:	00051e63          	bnez	a0,8000ac78 <proc_variable_decl+0x60>
8000ac60:	000a0593          	mv	a1,s4
8000ac64:	01c10513          	addi	a0,sp,28
8000ac68:	3dc000ef          	jal	ra,8000b044 <finsh_var_insert>
8000ac6c:	00055663          	bgez	a0,8000ac78 <proc_variable_decl+0x60>
8000ac70:	00400513          	li	a0,4
8000ac74:	c30fe0ef          	jal	ra,800090a4 <finsh_error_set>
8000ac78:	00490993          	addi	s3,s2,4
8000ac7c:	00098513          	mv	a0,s3
8000ac80:	04d000ef          	jal	ra,8000b4cc <finsh_token_token>
8000ac84:	00400793          	li	a5,4
8000ac88:	00050493          	mv	s1,a0
8000ac8c:	00000413          	li	s0,0
8000ac90:	12f50a63          	beq	a0,a5,8000adc4 <proc_variable_decl+0x1ac>
8000ac94:	00c00793          	li	a5,12
8000ac98:	16f50863          	beq	a0,a5,8000ae08 <proc_variable_decl+0x1f0>
8000ac9c:	00300793          	li	a5,3
8000aca0:	24f51263          	bne	a0,a5,8000aee4 <proc_variable_decl+0x2cc>
8000aca4:	01c10593          	addi	a1,sp,28
8000aca8:	00090513          	mv	a0,s2
8000acac:	e14ff0ef          	jal	ra,8000a2c0 <proc_identifier>
8000acb0:	00051e63          	bnez	a0,8000accc <proc_variable_decl+0xb4>
8000acb4:	000a0593          	mv	a1,s4
8000acb8:	01c10513          	addi	a0,sp,28
8000acbc:	388000ef          	jal	ra,8000b044 <finsh_var_insert>
8000acc0:	00055663          	bgez	a0,8000accc <proc_variable_decl+0xb4>
8000acc4:	00400513          	li	a0,4
8000acc8:	bdcfe0ef          	jal	ra,800090a4 <finsh_error_set>
8000accc:	00098513          	mv	a0,s3
8000acd0:	7fc000ef          	jal	ra,8000b4cc <finsh_token_token>
8000acd4:	00c00793          	li	a5,12
8000acd8:	00050493          	mv	s1,a0
8000acdc:	00000413          	li	s0,0
8000ace0:	02f51e63          	bne	a0,a5,8000ad1c <proc_variable_decl+0x104>
8000ace4:	00090513          	mv	a0,s2
8000ace8:	e94ff0ef          	jal	ra,8000a37c <proc_assign_expr>
8000acec:	00050413          	mv	s0,a0
8000acf0:	02050663          	beqz	a0,8000ad1c <proc_variable_decl+0x104>
8000acf4:	01c10513          	addi	a0,sp,28
8000acf8:	f7cfe0ef          	jal	ra,80009474 <finsh_node_new_id>
8000acfc:	00050593          	mv	a1,a0
8000ad00:	00040613          	mv	a2,s0
8000ad04:	01300513          	li	a0,19
8000ad08:	e18ff0ef          	jal	ra,8000a320 <make_sys_node>
8000ad0c:	00050413          	mv	s0,a0
8000ad10:	00098513          	mv	a0,s3
8000ad14:	7b8000ef          	jal	ra,8000b4cc <finsh_token_token>
8000ad18:	00050493          	mv	s1,a0
8000ad1c:	00040c13          	mv	s8,s0
8000ad20:	00300b13          	li	s6,3
8000ad24:	00c00b93          	li	s7,12
8000ad28:	0800006f          	j	8000ada8 <proc_variable_decl+0x190>
8000ad2c:	01c10593          	addi	a1,sp,28
8000ad30:	00090513          	mv	a0,s2
8000ad34:	d8cff0ef          	jal	ra,8000a2c0 <proc_identifier>
8000ad38:	00051e63          	bnez	a0,8000ad54 <proc_variable_decl+0x13c>
8000ad3c:	000a0593          	mv	a1,s4
8000ad40:	01c10513          	addi	a0,sp,28
8000ad44:	300000ef          	jal	ra,8000b044 <finsh_var_insert>
8000ad48:	00055663          	bgez	a0,8000ad54 <proc_variable_decl+0x13c>
8000ad4c:	00400513          	li	a0,4
8000ad50:	b54fe0ef          	jal	ra,800090a4 <finsh_error_set>
8000ad54:	00098513          	mv	a0,s3
8000ad58:	774000ef          	jal	ra,8000b4cc <finsh_token_token>
8000ad5c:	00050493          	mv	s1,a0
8000ad60:	05751463          	bne	a0,s7,8000ada8 <proc_variable_decl+0x190>
8000ad64:	00090513          	mv	a0,s2
8000ad68:	e14ff0ef          	jal	ra,8000a37c <proc_assign_expr>
8000ad6c:	02050e63          	beqz	a0,8000ada8 <proc_variable_decl+0x190>
8000ad70:	00a12623          	sw	a0,12(sp)
8000ad74:	01c10513          	addi	a0,sp,28
8000ad78:	efcfe0ef          	jal	ra,80009474 <finsh_node_new_id>
8000ad7c:	00050593          	mv	a1,a0
8000ad80:	00c12603          	lw	a2,12(sp)
8000ad84:	01300513          	li	a0,19
8000ad88:	06040863          	beqz	s0,8000adf8 <proc_variable_decl+0x1e0>
8000ad8c:	d94ff0ef          	jal	ra,8000a320 <make_sys_node>
8000ad90:	00050a93          	mv	s5,a0
8000ad94:	00ac2623          	sw	a0,12(s8)
8000ad98:	00098513          	mv	a0,s3
8000ad9c:	730000ef          	jal	ra,8000b4cc <finsh_token_token>
8000ada0:	00050493          	mv	s1,a0
8000ada4:	000a8c13          	mv	s8,s5
8000ada8:	f96482e3          	beq	s1,s6,8000ad2c <proc_variable_decl+0x114>
8000adac:	00400793          	li	a5,4
8000adb0:	00f48a63          	beq	s1,a5,8000adc4 <proc_variable_decl+0x1ac>
8000adb4:	00100513          	li	a0,1
8000adb8:	aecfe0ef          	jal	ra,800090a4 <finsh_error_set>
8000adbc:	00100793          	li	a5,1
8000adc0:	00f902a3          	sb	a5,5(s2)
8000adc4:	05c12083          	lw	ra,92(sp)
8000adc8:	00040513          	mv	a0,s0
8000adcc:	05812403          	lw	s0,88(sp)
8000add0:	05412483          	lw	s1,84(sp)
8000add4:	05012903          	lw	s2,80(sp)
8000add8:	04c12983          	lw	s3,76(sp)
8000addc:	04812a03          	lw	s4,72(sp)
8000ade0:	04412a83          	lw	s5,68(sp)
8000ade4:	04012b03          	lw	s6,64(sp)
8000ade8:	03c12b83          	lw	s7,60(sp)
8000adec:	03812c03          	lw	s8,56(sp)
8000adf0:	06010113          	addi	sp,sp,96
8000adf4:	00008067          	ret
8000adf8:	d28ff0ef          	jal	ra,8000a320 <make_sys_node>
8000adfc:	00050413          	mv	s0,a0
8000ae00:	00050a93          	mv	s5,a0
8000ae04:	f95ff06f          	j	8000ad98 <proc_variable_decl+0x180>
8000ae08:	00090513          	mv	a0,s2
8000ae0c:	d70ff0ef          	jal	ra,8000a37c <proc_assign_expr>
8000ae10:	00050413          	mv	s0,a0
8000ae14:	02050663          	beqz	a0,8000ae40 <proc_variable_decl+0x228>
8000ae18:	01c10513          	addi	a0,sp,28
8000ae1c:	e58fe0ef          	jal	ra,80009474 <finsh_node_new_id>
8000ae20:	00050593          	mv	a1,a0
8000ae24:	00040613          	mv	a2,s0
8000ae28:	01300513          	li	a0,19
8000ae2c:	cf4ff0ef          	jal	ra,8000a320 <make_sys_node>
8000ae30:	00050413          	mv	s0,a0
8000ae34:	00098513          	mv	a0,s3
8000ae38:	694000ef          	jal	ra,8000b4cc <finsh_token_token>
8000ae3c:	00050493          	mv	s1,a0
8000ae40:	00040c13          	mv	s8,s0
8000ae44:	00300b13          	li	s6,3
8000ae48:	00c00b93          	li	s7,12
8000ae4c:	0800006f          	j	8000aecc <proc_variable_decl+0x2b4>
8000ae50:	01c10593          	addi	a1,sp,28
8000ae54:	00090513          	mv	a0,s2
8000ae58:	c68ff0ef          	jal	ra,8000a2c0 <proc_identifier>
8000ae5c:	00051e63          	bnez	a0,8000ae78 <proc_variable_decl+0x260>
8000ae60:	000a0593          	mv	a1,s4
8000ae64:	01c10513          	addi	a0,sp,28
8000ae68:	1dc000ef          	jal	ra,8000b044 <finsh_var_insert>
8000ae6c:	00055663          	bgez	a0,8000ae78 <proc_variable_decl+0x260>
8000ae70:	00400513          	li	a0,4
8000ae74:	a30fe0ef          	jal	ra,800090a4 <finsh_error_set>
8000ae78:	00098513          	mv	a0,s3
8000ae7c:	650000ef          	jal	ra,8000b4cc <finsh_token_token>
8000ae80:	00050493          	mv	s1,a0
8000ae84:	05751463          	bne	a0,s7,8000aecc <proc_variable_decl+0x2b4>
8000ae88:	00090513          	mv	a0,s2
8000ae8c:	cf0ff0ef          	jal	ra,8000a37c <proc_assign_expr>
8000ae90:	02050e63          	beqz	a0,8000aecc <proc_variable_decl+0x2b4>
8000ae94:	00a12623          	sw	a0,12(sp)
8000ae98:	01c10513          	addi	a0,sp,28
8000ae9c:	dd8fe0ef          	jal	ra,80009474 <finsh_node_new_id>
8000aea0:	00050593          	mv	a1,a0
8000aea4:	00c12603          	lw	a2,12(sp)
8000aea8:	01300513          	li	a0,19
8000aeac:	02040463          	beqz	s0,8000aed4 <proc_variable_decl+0x2bc>
8000aeb0:	c70ff0ef          	jal	ra,8000a320 <make_sys_node>
8000aeb4:	00050a93          	mv	s5,a0
8000aeb8:	00ac2623          	sw	a0,12(s8)
8000aebc:	00098513          	mv	a0,s3
8000aec0:	60c000ef          	jal	ra,8000b4cc <finsh_token_token>
8000aec4:	00050493          	mv	s1,a0
8000aec8:	000a8c13          	mv	s8,s5
8000aecc:	f96482e3          	beq	s1,s6,8000ae50 <proc_variable_decl+0x238>
8000aed0:	eddff06f          	j	8000adac <proc_variable_decl+0x194>
8000aed4:	c4cff0ef          	jal	ra,8000a320 <make_sys_node>
8000aed8:	00050413          	mv	s0,a0
8000aedc:	00050a93          	mv	s5,a0
8000aee0:	fddff06f          	j	8000aebc <proc_variable_decl+0x2a4>
8000aee4:	00200513          	li	a0,2
8000aee8:	9bcfe0ef          	jal	ra,800090a4 <finsh_error_set>
8000aeec:	00000413          	li	s0,0
8000aef0:	ed5ff06f          	j	8000adc4 <proc_variable_decl+0x1ac>

8000aef4 <finsh_parser_run>:
8000aef4:	fe010113          	addi	sp,sp,-32
8000aef8:	00112e23          	sw	ra,28(sp)
8000aefc:	00812c23          	sw	s0,24(sp)
8000af00:	00912a23          	sw	s1,20(sp)
8000af04:	01212823          	sw	s2,16(sp)
8000af08:	01312623          	sw	s3,12(sp)
8000af0c:	01412423          	sw	s4,8(sp)
8000af10:	01512223          	sw	s5,4(sp)
8000af14:	00450993          	addi	s3,a0,4
8000af18:	00b52023          	sw	a1,0(a0)
8000af1c:	00050493          	mv	s1,a0
8000af20:	00098513          	mv	a0,s3
8000af24:	490000ef          	jal	ra,8000b3b4 <finsh_token_init>
8000af28:	00098513          	mv	a0,s3
8000af2c:	5a0000ef          	jal	ra,8000b4cc <finsh_token_token>
8000af30:	00000413          	li	s0,0
8000af34:	00100913          	li	s2,1
8000af38:	01f00a13          	li	s4,31
8000af3c:	00500a93          	li	s5,5
8000af40:	fe050793          	addi	a5,a0,-32
8000af44:	02f96463          	bltu	s2,a5,8000af6c <finsh_parser_run+0x78>
8000af48:	01c12083          	lw	ra,28(sp)
8000af4c:	01812403          	lw	s0,24(sp)
8000af50:	01412483          	lw	s1,20(sp)
8000af54:	01012903          	lw	s2,16(sp)
8000af58:	00c12983          	lw	s3,12(sp)
8000af5c:	00812a03          	lw	s4,8(sp)
8000af60:	00412a83          	lw	s5,4(sp)
8000af64:	02010113          	addi	sp,sp,32
8000af68:	00008067          	ret
8000af6c:	0984a783          	lw	a5,152(s1)
8000af70:	03451263          	bne	a0,s4,8000af94 <finsh_parser_run+0xa0>
8000af74:	012482a3          	sb	s2,5(s1)
8000af78:	00048513          	mv	a0,s1
8000af7c:	06078a63          	beqz	a5,8000aff0 <finsh_parser_run+0xfc>
8000af80:	cd8ff0ef          	jal	ra,8000a458 <proc_expr_statement>
8000af84:	00a42623          	sw	a0,12(s0)
8000af88:	04050a63          	beqz	a0,8000afdc <finsh_parser_run+0xe8>
8000af8c:	00050413          	mv	s0,a0
8000af90:	04c0006f          	j	8000afdc <finsh_parser_run+0xe8>
8000af94:	fec50513          	addi	a0,a0,-20
8000af98:	012482a3          	sb	s2,5(s1)
8000af9c:	02aae263          	bltu	s5,a0,8000afc0 <finsh_parser_run+0xcc>
8000afa0:	00048513          	mv	a0,s1
8000afa4:	00078663          	beqz	a5,8000afb0 <finsh_parser_run+0xbc>
8000afa8:	c71ff0ef          	jal	ra,8000ac18 <proc_variable_decl>
8000afac:	fd9ff06f          	j	8000af84 <finsh_parser_run+0x90>
8000afb0:	c69ff0ef          	jal	ra,8000ac18 <proc_variable_decl>
8000afb4:	00050413          	mv	s0,a0
8000afb8:	08a4ac23          	sw	a0,152(s1)
8000afbc:	0200006f          	j	8000afdc <finsh_parser_run+0xe8>
8000afc0:	00048513          	mv	a0,s1
8000afc4:	02078663          	beqz	a5,8000aff0 <finsh_parser_run+0xfc>
8000afc8:	c90ff0ef          	jal	ra,8000a458 <proc_expr_statement>
8000afcc:	00a42623          	sw	a0,12(s0)
8000afd0:	fa051ee3          	bnez	a0,8000af8c <finsh_parser_run+0x98>
8000afd4:	00098513          	mv	a0,s3
8000afd8:	4f4000ef          	jal	ra,8000b4cc <finsh_token_token>
8000afdc:	0984a783          	lw	a5,152(s1)
8000afe0:	f60784e3          	beqz	a5,8000af48 <finsh_parser_run+0x54>
8000afe4:	00098513          	mv	a0,s3
8000afe8:	4e4000ef          	jal	ra,8000b4cc <finsh_token_token>
8000afec:	f55ff06f          	j	8000af40 <finsh_parser_run+0x4c>
8000aff0:	c68ff0ef          	jal	ra,8000a458 <proc_expr_statement>
8000aff4:	fc1ff06f          	j	8000afb4 <finsh_parser_run+0xc0>

8000aff8 <finsh_parser_init>:
8000aff8:	ff010113          	addi	sp,sp,-16
8000affc:	09c00613          	li	a2,156
8000b000:	00000593          	li	a1,0
8000b004:	00112623          	sw	ra,12(sp)
8000b008:	585000ef          	jal	ra,8000bd8c <memset>
8000b00c:	00c12083          	lw	ra,12(sp)
8000b010:	00000513          	li	a0,0
8000b014:	01010113          	addi	sp,sp,16
8000b018:	00008067          	ret

8000b01c <finsh_var_init>:
8000b01c:	ff010113          	addi	sp,sp,-16
8000b020:	0c000613          	li	a2,192
8000b024:	00000593          	li	a1,0
8000b028:	2ec18513          	addi	a0,gp,748 # 80020d4c <global_variable>
8000b02c:	00112623          	sw	ra,12(sp)
8000b030:	55d000ef          	jal	ra,8000bd8c <memset>
8000b034:	00c12083          	lw	ra,12(sp)
8000b038:	00000513          	li	a0,0
8000b03c:	01010113          	addi	sp,sp,16
8000b040:	00008067          	ret

8000b044 <finsh_var_insert>:
8000b044:	fd010113          	addi	sp,sp,-48
8000b048:	02912223          	sw	s1,36(sp)
8000b04c:	2ec18493          	addi	s1,gp,748 # 80020d4c <global_variable>
8000b050:	02812423          	sw	s0,40(sp)
8000b054:	03212023          	sw	s2,32(sp)
8000b058:	01312e23          	sw	s3,28(sp)
8000b05c:	01412c23          	sw	s4,24(sp)
8000b060:	01512a23          	sw	s5,20(sp)
8000b064:	01612823          	sw	s6,16(sp)
8000b068:	01712623          	sw	s7,12(sp)
8000b06c:	02112623          	sw	ra,44(sp)
8000b070:	00050993          	mv	s3,a0
8000b074:	00058a93          	mv	s5,a1
8000b078:	fff00413          	li	s0,-1
8000b07c:	00000a13          	li	s4,0
8000b080:	00048913          	mv	s2,s1
8000b084:	fff00b93          	li	s7,-1
8000b088:	00800b13          	li	s6,8
8000b08c:	01000613          	li	a2,16
8000b090:	00098593          	mv	a1,s3
8000b094:	00048513          	mv	a0,s1
8000b098:	7b1000ef          	jal	ra,8000c048 <strncmp>
8000b09c:	06050c63          	beqz	a0,8000b114 <finsh_var_insert+0xd0>
8000b0a0:	0114c783          	lbu	a5,17(s1)
8000b0a4:	00079663          	bnez	a5,8000b0b0 <finsh_var_insert+0x6c>
8000b0a8:	01741463          	bne	s0,s7,8000b0b0 <finsh_var_insert+0x6c>
8000b0ac:	000a0413          	mv	s0,s4
8000b0b0:	001a0a13          	addi	s4,s4,1
8000b0b4:	01848493          	addi	s1,s1,24
8000b0b8:	fd6a1ae3          	bne	s4,s6,8000b08c <finsh_var_insert+0x48>
8000b0bc:	fff00793          	li	a5,-1
8000b0c0:	02f40263          	beq	s0,a5,8000b0e4 <finsh_var_insert+0xa0>
8000b0c4:	01800793          	li	a5,24
8000b0c8:	02f407b3          	mul	a5,s0,a5
8000b0cc:	01000613          	li	a2,16
8000b0d0:	00098593          	mv	a1,s3
8000b0d4:	00f907b3          	add	a5,s2,a5
8000b0d8:	00078513          	mv	a0,a5
8000b0dc:	7a9000ef          	jal	ra,8000c084 <strncpy>
8000b0e0:	015508a3          	sb	s5,17(a0)
8000b0e4:	02c12083          	lw	ra,44(sp)
8000b0e8:	00040513          	mv	a0,s0
8000b0ec:	02812403          	lw	s0,40(sp)
8000b0f0:	02412483          	lw	s1,36(sp)
8000b0f4:	02012903          	lw	s2,32(sp)
8000b0f8:	01c12983          	lw	s3,28(sp)
8000b0fc:	01812a03          	lw	s4,24(sp)
8000b100:	01412a83          	lw	s5,20(sp)
8000b104:	01012b03          	lw	s6,16(sp)
8000b108:	00c12b83          	lw	s7,12(sp)
8000b10c:	03010113          	addi	sp,sp,48
8000b110:	00008067          	ret
8000b114:	fff00413          	li	s0,-1
8000b118:	fcdff06f          	j	8000b0e4 <finsh_var_insert+0xa0>

8000b11c <finsh_var_lookup>:
8000b11c:	ff010113          	addi	sp,sp,-16
8000b120:	00812423          	sw	s0,8(sp)
8000b124:	00912223          	sw	s1,4(sp)
8000b128:	01212023          	sw	s2,0(sp)
8000b12c:	00112623          	sw	ra,12(sp)
8000b130:	00050493          	mv	s1,a0
8000b134:	2ec18413          	addi	s0,gp,748 # 80020d4c <global_variable>
8000b138:	3ac18913          	addi	s2,gp,940 # 80020e0c <finsh_vm_stack>
8000b13c:	01000613          	li	a2,16
8000b140:	00048593          	mv	a1,s1
8000b144:	00040513          	mv	a0,s0
8000b148:	701000ef          	jal	ra,8000c048 <strncmp>
8000b14c:	00050863          	beqz	a0,8000b15c <finsh_var_lookup+0x40>
8000b150:	01840413          	addi	s0,s0,24
8000b154:	ff2414e3          	bne	s0,s2,8000b13c <finsh_var_lookup+0x20>
8000b158:	00000413          	li	s0,0
8000b15c:	00c12083          	lw	ra,12(sp)
8000b160:	00040513          	mv	a0,s0
8000b164:	00812403          	lw	s0,8(sp)
8000b168:	00412483          	lw	s1,4(sp)
8000b16c:	00012903          	lw	s2,0(sp)
8000b170:	01010113          	addi	sp,sp,16
8000b174:	00008067          	ret

8000b178 <finsh_sysvar_lookup>:
8000b178:	ff010113          	addi	sp,sp,-16
8000b17c:	00812423          	sw	s0,8(sp)
8000b180:	00912223          	sw	s1,4(sp)
8000b184:	01212023          	sw	s2,0(sp)
8000b188:	00112623          	sw	ra,12(sp)
8000b18c:	00050493          	mv	s1,a0
8000b190:	8d81a403          	lw	s0,-1832(gp) # 80020338 <_sysvar_table_begin>
8000b194:	8dc1a903          	lw	s2,-1828(gp) # 8002033c <_sysvar_table_end>
8000b198:	05246463          	bltu	s0,s2,8000b1e0 <finsh_sysvar_lookup+0x68>
8000b19c:	9001a403          	lw	s0,-1792(gp) # 80020360 <global_sysvar_list>
8000b1a0:	02040263          	beqz	s0,8000b1c4 <finsh_sysvar_lookup+0x4c>
8000b1a4:	00048513          	mv	a0,s1
8000b1a8:	685000ef          	jal	ra,8000c02c <strlen>
8000b1ac:	00050613          	mv	a2,a0
8000b1b0:	00442503          	lw	a0,4(s0)
8000b1b4:	00048593          	mv	a1,s1
8000b1b8:	691000ef          	jal	ra,8000c048 <strncmp>
8000b1bc:	02051e63          	bnez	a0,8000b1f8 <finsh_sysvar_lookup+0x80>
8000b1c0:	00440413          	addi	s0,s0,4
8000b1c4:	00c12083          	lw	ra,12(sp)
8000b1c8:	00040513          	mv	a0,s0
8000b1cc:	00812403          	lw	s0,8(sp)
8000b1d0:	00412483          	lw	s1,4(sp)
8000b1d4:	00012903          	lw	s2,0(sp)
8000b1d8:	01010113          	addi	sp,sp,16
8000b1dc:	00008067          	ret
8000b1e0:	00042503          	lw	a0,0(s0)
8000b1e4:	00048593          	mv	a1,s1
8000b1e8:	4ad000ef          	jal	ra,8000be94 <strcmp>
8000b1ec:	fc050ce3          	beqz	a0,8000b1c4 <finsh_sysvar_lookup+0x4c>
8000b1f0:	01040413          	addi	s0,s0,16
8000b1f4:	fa5ff06f          	j	8000b198 <finsh_sysvar_lookup+0x20>
8000b1f8:	00042403          	lw	s0,0(s0)
8000b1fc:	fa5ff06f          	j	8000b1a0 <finsh_sysvar_lookup+0x28>

8000b200 <finsh_vm_run>:
8000b200:	fe010113          	addi	sp,sp,-32
8000b204:	3ac18793          	addi	a5,gp,940 # 80020e0c <finsh_vm_stack>
8000b208:	00812c23          	sw	s0,24(sp)
8000b20c:	90f1a423          	sw	a5,-1784(gp) # 80020368 <finsh_sp>
8000b210:	90418413          	addi	s0,gp,-1788 # 80020364 <finsh_pc>
8000b214:	4ac18793          	addi	a5,gp,1196 # 80020f0c <text_segment>
8000b218:	00912a23          	sw	s1,20(sp)
8000b21c:	01212823          	sw	s2,16(sp)
8000b220:	01312623          	sw	s3,12(sp)
8000b224:	00112e23          	sw	ra,28(sp)
8000b228:	00f42023          	sw	a5,0(s0)
8000b22c:	00078493          	mv	s1,a5
8000b230:	07f00913          	li	s2,127
8000b234:	00003997          	auipc	s3,0x3
8000b238:	2d098993          	addi	s3,s3,720 # 8000e504 <op_table>
8000b23c:	00042783          	lw	a5,0(s0)
8000b240:	40978733          	sub	a4,a5,s1
8000b244:	02e97063          	bgeu	s2,a4,8000b264 <finsh_vm_run+0x64>
8000b248:	01c12083          	lw	ra,28(sp)
8000b24c:	01812403          	lw	s0,24(sp)
8000b250:	01412483          	lw	s1,20(sp)
8000b254:	01012903          	lw	s2,16(sp)
8000b258:	00c12983          	lw	s3,12(sp)
8000b25c:	02010113          	addi	sp,sp,32
8000b260:	00008067          	ret
8000b264:	00178713          	addi	a4,a5,1
8000b268:	00e42023          	sw	a4,0(s0)
8000b26c:	0007c783          	lbu	a5,0(a5)
8000b270:	00279793          	slli	a5,a5,0x2
8000b274:	00f987b3          	add	a5,s3,a5
8000b278:	0007a783          	lw	a5,0(a5)
8000b27c:	000780e7          	jalr	a5
8000b280:	fbdff06f          	j	8000b23c <finsh_vm_run+0x3c>

8000b284 <finsh_syscall_lookup>:
8000b284:	ff010113          	addi	sp,sp,-16
8000b288:	00812423          	sw	s0,8(sp)
8000b28c:	00912223          	sw	s1,4(sp)
8000b290:	01212023          	sw	s2,0(sp)
8000b294:	00112623          	sw	ra,12(sp)
8000b298:	00050493          	mv	s1,a0
8000b29c:	8d01a403          	lw	s0,-1840(gp) # 80020330 <_syscall_table_begin>
8000b2a0:	8d41a903          	lw	s2,-1836(gp) # 80020334 <_syscall_table_end>
8000b2a4:	05246463          	bltu	s0,s2,8000b2ec <finsh_syscall_lookup+0x68>
8000b2a8:	90c1a403          	lw	s0,-1780(gp) # 8002036c <global_syscall_list>
8000b2ac:	02040263          	beqz	s0,8000b2d0 <finsh_syscall_lookup+0x4c>
8000b2b0:	00048513          	mv	a0,s1
8000b2b4:	579000ef          	jal	ra,8000c02c <strlen>
8000b2b8:	00050613          	mv	a2,a0
8000b2bc:	00442503          	lw	a0,4(s0)
8000b2c0:	00048593          	mv	a1,s1
8000b2c4:	585000ef          	jal	ra,8000c048 <strncmp>
8000b2c8:	02051e63          	bnez	a0,8000b304 <finsh_syscall_lookup+0x80>
8000b2cc:	00440413          	addi	s0,s0,4
8000b2d0:	00c12083          	lw	ra,12(sp)
8000b2d4:	00040513          	mv	a0,s0
8000b2d8:	00812403          	lw	s0,8(sp)
8000b2dc:	00412483          	lw	s1,4(sp)
8000b2e0:	00012903          	lw	s2,0(sp)
8000b2e4:	01010113          	addi	sp,sp,16
8000b2e8:	00008067          	ret
8000b2ec:	00042503          	lw	a0,0(s0)
8000b2f0:	00048593          	mv	a1,s1
8000b2f4:	3a1000ef          	jal	ra,8000be94 <strcmp>
8000b2f8:	fc050ce3          	beqz	a0,8000b2d0 <finsh_syscall_lookup+0x4c>
8000b2fc:	00c40413          	addi	s0,s0,12
8000b300:	fa5ff06f          	j	8000b2a4 <finsh_syscall_lookup+0x20>
8000b304:	00042403          	lw	s0,0(s0)
8000b308:	fa5ff06f          	j	8000b2ac <finsh_syscall_lookup+0x28>

8000b30c <token_prev_char>:
8000b30c:	00054783          	lbu	a5,0(a0)
8000b310:	00079a63          	bnez	a5,8000b324 <token_prev_char+0x18>
8000b314:	00452783          	lw	a5,4(a0)
8000b318:	00078663          	beqz	a5,8000b324 <token_prev_char+0x18>
8000b31c:	fff78793          	addi	a5,a5,-1
8000b320:	00f52223          	sw	a5,4(a0)
8000b324:	00008067          	ret

8000b328 <token_next_char>:
8000b328:	fe010113          	addi	sp,sp,-32
8000b32c:	00112e23          	sw	ra,28(sp)
8000b330:	00812c23          	sw	s0,24(sp)
8000b334:	00912a23          	sw	s1,20(sp)
8000b338:	01212823          	sw	s2,16(sp)
8000b33c:	01312623          	sw	s3,12(sp)
8000b340:	00054983          	lbu	s3,0(a0)
8000b344:	06099463          	bnez	s3,8000b3ac <token_next_char+0x84>
8000b348:	09052483          	lw	s1,144(a0)
8000b34c:	00452903          	lw	s2,4(a0)
8000b350:	00050413          	mv	s0,a0
8000b354:	00048513          	mv	a0,s1
8000b358:	4d5000ef          	jal	ra,8000c02c <strlen>
8000b35c:	00a90a63          	beq	s2,a0,8000b370 <token_next_char+0x48>
8000b360:	012484b3          	add	s1,s1,s2
8000b364:	0004c703          	lbu	a4,0(s1)
8000b368:	00a00793          	li	a5,10
8000b36c:	02f71863          	bne	a4,a5,8000b39c <token_next_char+0x74>
8000b370:	00100793          	li	a5,1
8000b374:	00f40023          	sb	a5,0(s0)
8000b378:	00042223          	sw	zero,4(s0)
8000b37c:	01c12083          	lw	ra,28(sp)
8000b380:	01812403          	lw	s0,24(sp)
8000b384:	01412483          	lw	s1,20(sp)
8000b388:	01012903          	lw	s2,16(sp)
8000b38c:	00098513          	mv	a0,s3
8000b390:	00c12983          	lw	s3,12(sp)
8000b394:	02010113          	addi	sp,sp,32
8000b398:	00008067          	ret
8000b39c:	00190913          	addi	s2,s2,1
8000b3a0:	01242223          	sw	s2,4(s0)
8000b3a4:	0004c983          	lbu	s3,0(s1)
8000b3a8:	fd5ff06f          	j	8000b37c <token_next_char+0x54>
8000b3ac:	00000993          	li	s3,0
8000b3b0:	fcdff06f          	j	8000b37c <token_next_char+0x54>

8000b3b4 <finsh_token_init>:
8000b3b4:	ff010113          	addi	sp,sp,-16
8000b3b8:	00912223          	sw	s1,4(sp)
8000b3bc:	09400613          	li	a2,148
8000b3c0:	00058493          	mv	s1,a1
8000b3c4:	00000593          	li	a1,0
8000b3c8:	00812423          	sw	s0,8(sp)
8000b3cc:	00112623          	sw	ra,12(sp)
8000b3d0:	00050413          	mv	s0,a0
8000b3d4:	1b9000ef          	jal	ra,8000bd8c <memset>
8000b3d8:	00c12083          	lw	ra,12(sp)
8000b3dc:	08942823          	sw	s1,144(s0)
8000b3e0:	00812403          	lw	s0,8(sp)
8000b3e4:	00412483          	lw	s1,4(sp)
8000b3e8:	01010113          	addi	sp,sp,16
8000b3ec:	00008067          	ret

8000b3f0 <token_get_string>:
8000b3f0:	fe010113          	addi	sp,sp,-32
8000b3f4:	00812c23          	sw	s0,24(sp)
8000b3f8:	00912a23          	sw	s1,20(sp)
8000b3fc:	00050413          	mv	s0,a0
8000b400:	00112e23          	sw	ra,28(sp)
8000b404:	01212823          	sw	s2,16(sp)
8000b408:	01312623          	sw	s3,12(sp)
8000b40c:	01412423          	sw	s4,8(sp)
8000b410:	00058493          	mv	s1,a1
8000b414:	f15ff0ef          	jal	ra,8000b328 <token_next_char>
8000b418:	00044783          	lbu	a5,0(s0)
8000b41c:	08079063          	bnez	a5,8000b49c <token_get_string+0xac>
8000b420:	fd050793          	addi	a5,a0,-48
8000b424:	00048023          	sb	zero,0(s1)
8000b428:	0ff7f793          	andi	a5,a5,255
8000b42c:	00900713          	li	a4,9
8000b430:	06f77263          	bgeu	a4,a5,8000b494 <token_get_string+0xa4>
8000b434:	01900913          	li	s2,25
8000b438:	00900993          	li	s3,9
8000b43c:	05f00a13          	li	s4,95
8000b440:	fdf57793          	andi	a5,a0,-33
8000b444:	fbf78793          	addi	a5,a5,-65
8000b448:	0ff7f793          	andi	a5,a5,255
8000b44c:	04f97c63          	bgeu	s2,a5,8000b4a4 <token_get_string+0xb4>
8000b450:	fd050793          	addi	a5,a0,-48
8000b454:	0ff7f793          	andi	a5,a5,255
8000b458:	04f9f663          	bgeu	s3,a5,8000b4a4 <token_get_string+0xb4>
8000b45c:	05450463          	beq	a0,s4,8000b4a4 <token_get_string+0xb4>
8000b460:	00442783          	lw	a5,4(s0)
8000b464:	00040023          	sb	zero,0(s0)
8000b468:	04079c63          	bnez	a5,8000b4c0 <token_get_string+0xd0>
8000b46c:	00048023          	sb	zero,0(s1)
8000b470:	00000513          	li	a0,0
8000b474:	01c12083          	lw	ra,28(sp)
8000b478:	01812403          	lw	s0,24(sp)
8000b47c:	01412483          	lw	s1,20(sp)
8000b480:	01012903          	lw	s2,16(sp)
8000b484:	00c12983          	lw	s3,12(sp)
8000b488:	00812a03          	lw	s4,8(sp)
8000b48c:	02010113          	addi	sp,sp,32
8000b490:	00008067          	ret
8000b494:	00040513          	mv	a0,s0
8000b498:	e75ff0ef          	jal	ra,8000b30c <token_prev_char>
8000b49c:	fff00513          	li	a0,-1
8000b4a0:	fd5ff06f          	j	8000b474 <token_get_string+0x84>
8000b4a4:	00044783          	lbu	a5,0(s0)
8000b4a8:	fa079ce3          	bnez	a5,8000b460 <token_get_string+0x70>
8000b4ac:	00a48023          	sb	a0,0(s1)
8000b4b0:	00040513          	mv	a0,s0
8000b4b4:	00148493          	addi	s1,s1,1
8000b4b8:	e71ff0ef          	jal	ra,8000b328 <token_next_char>
8000b4bc:	f85ff06f          	j	8000b440 <token_get_string+0x50>
8000b4c0:	fff78793          	addi	a5,a5,-1
8000b4c4:	00f42223          	sw	a5,4(s0)
8000b4c8:	fa5ff06f          	j	8000b46c <token_get_string+0x7c>

8000b4cc <finsh_token_token>:
8000b4cc:	f5010113          	addi	sp,sp,-176
8000b4d0:	0a812423          	sw	s0,168(sp)
8000b4d4:	0a112623          	sw	ra,172(sp)
8000b4d8:	0a912223          	sw	s1,164(sp)
8000b4dc:	0b212023          	sw	s2,160(sp)
8000b4e0:	09312e23          	sw	s3,156(sp)
8000b4e4:	09412c23          	sw	s4,152(sp)
8000b4e8:	09512a23          	sw	s5,148(sp)
8000b4ec:	09612823          	sw	s6,144(sp)
8000b4f0:	09712623          	sw	s7,140(sp)
8000b4f4:	09812423          	sw	s8,136(sp)
8000b4f8:	09912223          	sw	s9,132(sp)
8000b4fc:	09a12023          	sw	s10,128(sp)
8000b500:	00154783          	lbu	a5,1(a0)
8000b504:	00050413          	mv	s0,a0
8000b508:	04079663          	bnez	a5,8000b554 <finsh_token_token+0x88>
8000b50c:	02000913          	li	s2,32
8000b510:	00900493          	li	s1,9
8000b514:	00040513          	mv	a0,s0
8000b518:	e11ff0ef          	jal	ra,8000b328 <token_next_char>
8000b51c:	ff250ce3          	beq	a0,s2,8000b514 <finsh_token_token+0x48>
8000b520:	0fb57513          	andi	a0,a0,251
8000b524:	fe9508e3          	beq	a0,s1,8000b514 <finsh_token_token+0x48>
8000b528:	00040513          	mv	a0,s0
8000b52c:	de1ff0ef          	jal	ra,8000b30c <token_prev_char>
8000b530:	01040993          	addi	s3,s0,16
8000b534:	00098593          	mv	a1,s3
8000b538:	00040513          	mv	a0,s0
8000b53c:	eb5ff0ef          	jal	ra,8000b3f0 <token_get_string>
8000b540:	00044783          	lbu	a5,0(s0)
8000b544:	04078863          	beqz	a5,8000b594 <finsh_token_token+0xc8>
8000b548:	02100793          	li	a5,33
8000b54c:	00f40423          	sb	a5,8(s0)
8000b550:	0080006f          	j	8000b558 <finsh_token_token+0x8c>
8000b554:	000500a3          	sb	zero,1(a0)
8000b558:	00844503          	lbu	a0,8(s0)
8000b55c:	0ac12083          	lw	ra,172(sp)
8000b560:	0a812403          	lw	s0,168(sp)
8000b564:	0a412483          	lw	s1,164(sp)
8000b568:	0a012903          	lw	s2,160(sp)
8000b56c:	09c12983          	lw	s3,156(sp)
8000b570:	09812a03          	lw	s4,152(sp)
8000b574:	09412a83          	lw	s5,148(sp)
8000b578:	09012b03          	lw	s6,144(sp)
8000b57c:	08c12b83          	lw	s7,140(sp)
8000b580:	08812c03          	lw	s8,136(sp)
8000b584:	08412c83          	lw	s9,132(sp)
8000b588:	08012d03          	lw	s10,128(sp)
8000b58c:	0b010113          	addi	sp,sp,176
8000b590:	00008067          	ret
8000b594:	01044783          	lbu	a5,16(s0)
8000b598:	04078663          	beqz	a5,8000b5e4 <finsh_token_token+0x118>
8000b59c:	00003917          	auipc	s2,0x3
8000b5a0:	18c90913          	addi	s2,s2,396 # 8000e728 <finsh_name_table>
8000b5a4:	00000493          	li	s1,0
8000b5a8:	00090a13          	mv	s4,s2
8000b5ac:	00800a93          	li	s5,8
8000b5b0:	00092503          	lw	a0,0(s2)
8000b5b4:	00098593          	mv	a1,s3
8000b5b8:	0dd000ef          	jal	ra,8000be94 <strcmp>
8000b5bc:	00051a63          	bnez	a0,8000b5d0 <finsh_token_token+0x104>
8000b5c0:	00349493          	slli	s1,s1,0x3
8000b5c4:	009a04b3          	add	s1,s4,s1
8000b5c8:	0044a783          	lw	a5,4(s1)
8000b5cc:	f81ff06f          	j	8000b54c <finsh_token_token+0x80>
8000b5d0:	00148493          	addi	s1,s1,1
8000b5d4:	00890913          	addi	s2,s2,8
8000b5d8:	fd549ce3          	bne	s1,s5,8000b5b0 <finsh_token_token+0xe4>
8000b5dc:	01f00793          	li	a5,31
8000b5e0:	f6dff06f          	j	8000b54c <finsh_token_token+0x80>
8000b5e4:	00040513          	mv	a0,s0
8000b5e8:	d41ff0ef          	jal	ra,8000b328 <token_next_char>
8000b5ec:	03e00793          	li	a5,62
8000b5f0:	02a7ec63          	bltu	a5,a0,8000b628 <finsh_token_token+0x15c>
8000b5f4:	02100793          	li	a5,33
8000b5f8:	04a7f463          	bgeu	a5,a0,8000b640 <finsh_token_token+0x174>
8000b5fc:	fde50793          	addi	a5,a0,-34
8000b600:	0ff7f793          	andi	a5,a5,255
8000b604:	01c00713          	li	a4,28
8000b608:	02f76c63          	bltu	a4,a5,8000b640 <finsh_token_token+0x174>
8000b60c:	00003717          	auipc	a4,0x3
8000b610:	01070713          	addi	a4,a4,16 # 8000e61c <CSWTCH.5+0xc>
8000b614:	00279793          	slli	a5,a5,0x2
8000b618:	00e787b3          	add	a5,a5,a4
8000b61c:	0007a783          	lw	a5,0(a5)
8000b620:	00e787b3          	add	a5,a5,a4
8000b624:	00078067          	jr	a5
8000b628:	07c00793          	li	a5,124
8000b62c:	14f50063          	beq	a0,a5,8000b76c <finsh_token_token+0x2a0>
8000b630:	07e00793          	li	a5,126
8000b634:	14f50463          	beq	a0,a5,8000b77c <finsh_token_token+0x2b0>
8000b638:	05e00793          	li	a5,94
8000b63c:	14f50463          	beq	a0,a5,8000b784 <finsh_token_token+0x2b8>
8000b640:	fd050513          	addi	a0,a0,-48
8000b644:	0ff57513          	andi	a0,a0,255
8000b648:	00900793          	li	a5,9
8000b64c:	56a7ec63          	bltu	a5,a0,8000bbc4 <finsh_token_token+0x6f8>
8000b650:	00040513          	mv	a0,s0
8000b654:	cb9ff0ef          	jal	ra,8000b30c <token_prev_char>
8000b658:	00040513          	mv	a0,s0
8000b65c:	ccdff0ef          	jal	ra,8000b328 <token_next_char>
8000b660:	03000793          	li	a5,48
8000b664:	00050493          	mv	s1,a0
8000b668:	00000913          	li	s2,0
8000b66c:	38f50c63          	beq	a0,a5,8000ba04 <finsh_token_token+0x538>
8000b670:	00900993          	li	s3,9
8000b674:	00a00a13          	li	s4,10
8000b678:	fd048793          	addi	a5,s1,-48
8000b67c:	0ff7f713          	andi	a4,a5,255
8000b680:	52e9f063          	bgeu	s3,a4,8000bba0 <finsh_token_token+0x6d4>
8000b684:	01242623          	sw	s2,12(s0)
8000b688:	4080006f          	j	8000ba90 <finsh_token_token+0x5c4>
8000b68c:	00100793          	li	a5,1
8000b690:	ebdff06f          	j	8000b54c <finsh_token_token+0x80>
8000b694:	00200793          	li	a5,2
8000b698:	eb5ff06f          	j	8000b54c <finsh_token_token+0x80>
8000b69c:	00300793          	li	a5,3
8000b6a0:	eadff06f          	j	8000b54c <finsh_token_token+0x80>
8000b6a4:	00400793          	li	a5,4
8000b6a8:	ea5ff06f          	j	8000b54c <finsh_token_token+0x80>
8000b6ac:	00d00793          	li	a5,13
8000b6b0:	e9dff06f          	j	8000b54c <finsh_token_token+0x80>
8000b6b4:	00500793          	li	a5,5
8000b6b8:	e95ff06f          	j	8000b54c <finsh_token_token+0x80>
8000b6bc:	00040513          	mv	a0,s0
8000b6c0:	c69ff0ef          	jal	ra,8000b328 <token_next_char>
8000b6c4:	02b00793          	li	a5,43
8000b6c8:	00f51663          	bne	a0,a5,8000b6d4 <finsh_token_token+0x208>
8000b6cc:	00700793          	li	a5,7
8000b6d0:	e7dff06f          	j	8000b54c <finsh_token_token+0x80>
8000b6d4:	00040513          	mv	a0,s0
8000b6d8:	c35ff0ef          	jal	ra,8000b30c <token_prev_char>
8000b6dc:	00600793          	li	a5,6
8000b6e0:	e6dff06f          	j	8000b54c <finsh_token_token+0x80>
8000b6e4:	00040513          	mv	a0,s0
8000b6e8:	c41ff0ef          	jal	ra,8000b328 <token_next_char>
8000b6ec:	02d00793          	li	a5,45
8000b6f0:	00f51663          	bne	a0,a5,8000b6fc <finsh_token_token+0x230>
8000b6f4:	00900793          	li	a5,9
8000b6f8:	e55ff06f          	j	8000b54c <finsh_token_token+0x80>
8000b6fc:	00040513          	mv	a0,s0
8000b700:	c0dff0ef          	jal	ra,8000b30c <token_prev_char>
8000b704:	00800793          	li	a5,8
8000b708:	e45ff06f          	j	8000b54c <finsh_token_token+0x80>
8000b70c:	00040513          	mv	a0,s0
8000b710:	c19ff0ef          	jal	ra,8000b328 <token_next_char>
8000b714:	02f00793          	li	a5,47
8000b718:	e2f508e3          	beq	a0,a5,8000b548 <finsh_token_token+0x7c>
8000b71c:	00040513          	mv	a0,s0
8000b720:	bedff0ef          	jal	ra,8000b30c <token_prev_char>
8000b724:	00a00793          	li	a5,10
8000b728:	e25ff06f          	j	8000b54c <finsh_token_token+0x80>
8000b72c:	00040513          	mv	a0,s0
8000b730:	bf9ff0ef          	jal	ra,8000b328 <token_next_char>
8000b734:	03c00793          	li	a5,60
8000b738:	00f51663          	bne	a0,a5,8000b744 <finsh_token_token+0x278>
8000b73c:	01100793          	li	a5,17
8000b740:	e0dff06f          	j	8000b54c <finsh_token_token+0x80>
8000b744:	00040513          	mv	a0,s0
8000b748:	bc5ff0ef          	jal	ra,8000b30c <token_prev_char>
8000b74c:	02000793          	li	a5,32
8000b750:	dfdff06f          	j	8000b54c <finsh_token_token+0x80>
8000b754:	00040513          	mv	a0,s0
8000b758:	bd1ff0ef          	jal	ra,8000b328 <token_next_char>
8000b75c:	03e00793          	li	a5,62
8000b760:	fef512e3          	bne	a0,a5,8000b744 <finsh_token_token+0x278>
8000b764:	01200793          	li	a5,18
8000b768:	de5ff06f          	j	8000b54c <finsh_token_token+0x80>
8000b76c:	00e00793          	li	a5,14
8000b770:	dddff06f          	j	8000b54c <finsh_token_token+0x80>
8000b774:	00b00793          	li	a5,11
8000b778:	dd5ff06f          	j	8000b54c <finsh_token_token+0x80>
8000b77c:	01000793          	li	a5,16
8000b780:	dcdff06f          	j	8000b54c <finsh_token_token+0x80>
8000b784:	00f00793          	li	a5,15
8000b788:	dc5ff06f          	j	8000b54c <finsh_token_token+0x80>
8000b78c:	00c00793          	li	a5,12
8000b790:	dbdff06f          	j	8000b54c <finsh_token_token+0x80>
8000b794:	00040513          	mv	a0,s0
8000b798:	b91ff0ef          	jal	ra,8000b328 <token_next_char>
8000b79c:	05c00793          	li	a5,92
8000b7a0:	00050493          	mv	s1,a0
8000b7a4:	00050913          	mv	s2,a0
8000b7a8:	04f51e63          	bne	a0,a5,8000b804 <finsh_token_token+0x338>
8000b7ac:	00040513          	mv	a0,s0
8000b7b0:	b79ff0ef          	jal	ra,8000b328 <token_next_char>
8000b7b4:	06e00793          	li	a5,110
8000b7b8:	00050493          	mv	s1,a0
8000b7bc:	0af50463          	beq	a0,a5,8000b864 <finsh_token_token+0x398>
8000b7c0:	06a7e863          	bltu	a5,a0,8000b830 <finsh_token_token+0x364>
8000b7c4:	05250063          	beq	a0,s2,8000b804 <finsh_token_token+0x338>
8000b7c8:	06200793          	li	a5,98
8000b7cc:	0af50063          	beq	a0,a5,8000b86c <finsh_token_token+0x3a0>
8000b7d0:	02700793          	li	a5,39
8000b7d4:	02f50863          	beq	a0,a5,8000b804 <finsh_token_token+0x338>
8000b7d8:	00010913          	mv	s2,sp
8000b7dc:	00900993          	li	s3,9
8000b7e0:	fd048493          	addi	s1,s1,-48
8000b7e4:	0ff4f493          	andi	s1,s1,255
8000b7e8:	00040513          	mv	a0,s0
8000b7ec:	0699f263          	bgeu	s3,s1,8000b850 <finsh_token_token+0x384>
8000b7f0:	b1dff0ef          	jal	ra,8000b30c <token_prev_char>
8000b7f4:	00090513          	mv	a0,s2
8000b7f8:	00090023          	sb	zero,0(s2)
8000b7fc:	3f4000ef          	jal	ra,8000bbf0 <atoi>
8000b800:	0ff57493          	andi	s1,a0,255
8000b804:	00040513          	mv	a0,s0
8000b808:	b21ff0ef          	jal	ra,8000b328 <token_next_char>
8000b80c:	02700793          	li	a5,39
8000b810:	00f50a63          	beq	a0,a5,8000b824 <finsh_token_token+0x358>
8000b814:	00040513          	mv	a0,s0
8000b818:	af5ff0ef          	jal	ra,8000b30c <token_prev_char>
8000b81c:	00900513          	li	a0,9
8000b820:	885fd0ef          	jal	ra,800090a4 <finsh_error_set>
8000b824:	00940623          	sb	s1,12(s0)
8000b828:	01a00793          	li	a5,26
8000b82c:	d21ff06f          	j	8000b54c <finsh_token_token+0x80>
8000b830:	07400793          	li	a5,116
8000b834:	04f50063          	beq	a0,a5,8000b874 <finsh_token_token+0x3a8>
8000b838:	07600793          	li	a5,118
8000b83c:	04f50063          	beq	a0,a5,8000b87c <finsh_token_token+0x3b0>
8000b840:	07200793          	li	a5,114
8000b844:	f8f51ae3          	bne	a0,a5,8000b7d8 <finsh_token_token+0x30c>
8000b848:	00d00493          	li	s1,13
8000b84c:	fb9ff06f          	j	8000b804 <finsh_token_token+0x338>
8000b850:	ad9ff0ef          	jal	ra,8000b328 <token_next_char>
8000b854:	00190913          	addi	s2,s2,1
8000b858:	00050493          	mv	s1,a0
8000b85c:	fea90fa3          	sb	a0,-1(s2)
8000b860:	f81ff06f          	j	8000b7e0 <finsh_token_token+0x314>
8000b864:	00a00493          	li	s1,10
8000b868:	f9dff06f          	j	8000b804 <finsh_token_token+0x338>
8000b86c:	00800493          	li	s1,8
8000b870:	f95ff06f          	j	8000b804 <finsh_token_token+0x338>
8000b874:	00900493          	li	s1,9
8000b878:	f8dff06f          	j	8000b804 <finsh_token_token+0x338>
8000b87c:	00b00493          	li	s1,11
8000b880:	f85ff06f          	j	8000b804 <finsh_token_token+0x338>
8000b884:	15751863          	bne	a0,s7,8000b9d4 <finsh_token_token+0x508>
8000b888:	00040513          	mv	a0,s0
8000b88c:	a9dff0ef          	jal	ra,8000b328 <token_next_char>
8000b890:	07800793          	li	a5,120
8000b894:	00a7ee63          	bltu	a5,a0,8000b8b0 <finsh_token_token+0x3e4>
8000b898:	06000793          	li	a5,96
8000b89c:	02a7e663          	bltu	a5,a0,8000b8c8 <finsh_token_token+0x3fc>
8000b8a0:	02200493          	li	s1,34
8000b8a4:	05450663          	beq	a0,s4,8000b8f0 <finsh_token_token+0x424>
8000b8a8:	05800793          	li	a5,88
8000b8ac:	0af50263          	beq	a0,a5,8000b950 <finsh_token_token+0x484>
8000b8b0:	fd050793          	addi	a5,a0,-48
8000b8b4:	00700713          	li	a4,7
8000b8b8:	00000493          	li	s1,0
8000b8bc:	02f76a63          	bltu	a4,a5,8000b8f0 <finsh_token_token+0x424>
8000b8c0:	00700d13          	li	s10,7
8000b8c4:	0fc0006f          	j	8000b9c0 <finsh_token_token+0x4f4>
8000b8c8:	f9f50793          	addi	a5,a0,-97
8000b8cc:	0ff7f793          	andi	a5,a5,255
8000b8d0:	01700713          	li	a4,23
8000b8d4:	fcf76ee3          	bltu	a4,a5,8000b8b0 <finsh_token_token+0x3e4>
8000b8d8:	00279793          	slli	a5,a5,0x2
8000b8dc:	015787b3          	add	a5,a5,s5
8000b8e0:	0007a783          	lw	a5,0(a5)
8000b8e4:	015787b3          	add	a5,a5,s5
8000b8e8:	00078067          	jr	a5
8000b8ec:	00900493          	li	s1,9
8000b8f0:	0ff4f493          	andi	s1,s1,255
8000b8f4:	00190913          	addi	s2,s2,1
8000b8f8:	fe990fa3          	sb	s1,-1(s2)
8000b8fc:	413907b3          	sub	a5,s2,s3
8000b900:	02fb4063          	blt	s6,a5,8000b920 <finsh_token_token+0x454>
8000b904:	00040513          	mv	a0,s0
8000b908:	a21ff0ef          	jal	ra,8000b328 <token_next_char>
8000b90c:	00044783          	lbu	a5,0(s0)
8000b910:	00050493          	mv	s1,a0
8000b914:	f60788e3          	beqz	a5,8000b884 <finsh_token_token+0x3b8>
8000b918:	00a00513          	li	a0,10
8000b91c:	f88fd0ef          	jal	ra,800090a4 <finsh_error_set>
8000b920:	01d00793          	li	a5,29
8000b924:	c29ff06f          	j	8000b54c <finsh_token_token+0x80>
8000b928:	00b00493          	li	s1,11
8000b92c:	fc5ff06f          	j	8000b8f0 <finsh_token_token+0x424>
8000b930:	00800493          	li	s1,8
8000b934:	fbdff06f          	j	8000b8f0 <finsh_token_token+0x424>
8000b938:	00d00493          	li	s1,13
8000b93c:	fb5ff06f          	j	8000b8f0 <finsh_token_token+0x424>
8000b940:	00c00493          	li	s1,12
8000b944:	fadff06f          	j	8000b8f0 <finsh_token_token+0x424>
8000b948:	00700493          	li	s1,7
8000b94c:	fa5ff06f          	j	8000b8f0 <finsh_token_token+0x424>
8000b950:	00040513          	mv	a0,s0
8000b954:	9d5ff0ef          	jal	ra,8000b328 <token_next_char>
8000b958:	00000493          	li	s1,0
8000b95c:	00900d13          	li	s10,9
8000b960:	fd050713          	addi	a4,a0,-48
8000b964:	0ff77793          	andi	a5,a4,255
8000b968:	02fd7063          	bgeu	s10,a5,8000b988 <finsh_token_token+0x4bc>
8000b96c:	02056793          	ori	a5,a0,32
8000b970:	0ff7f793          	andi	a5,a5,255
8000b974:	f9f78793          	addi	a5,a5,-97
8000b978:	00fc7863          	bgeu	s8,a5,8000b988 <finsh_token_token+0x4bc>
8000b97c:	00040513          	mv	a0,s0
8000b980:	98dff0ef          	jal	ra,8000b30c <token_prev_char>
8000b984:	f6dff06f          	j	8000b8f0 <finsh_token_token+0x424>
8000b988:	00449793          	slli	a5,s1,0x4
8000b98c:	00acf863          	bgeu	s9,a0,8000b99c <finsh_token_token+0x4d0>
8000b990:	02056513          	ori	a0,a0,32
8000b994:	0ff57513          	andi	a0,a0,255
8000b998:	fa950713          	addi	a4,a0,-87
8000b99c:	00040513          	mv	a0,s0
8000b9a0:	00e784b3          	add	s1,a5,a4
8000b9a4:	985ff0ef          	jal	ra,8000b328 <token_next_char>
8000b9a8:	fb9ff06f          	j	8000b960 <finsh_token_token+0x494>
8000b9ac:	00349493          	slli	s1,s1,0x3
8000b9b0:	00a484b3          	add	s1,s1,a0
8000b9b4:	00040513          	mv	a0,s0
8000b9b8:	fd048493          	addi	s1,s1,-48
8000b9bc:	96dff0ef          	jal	ra,8000b328 <token_next_char>
8000b9c0:	fd050793          	addi	a5,a0,-48
8000b9c4:	fefd74e3          	bgeu	s10,a5,8000b9ac <finsh_token_token+0x4e0>
8000b9c8:	fb5ff06f          	j	8000b97c <finsh_token_token+0x4b0>
8000b9cc:	00a00493          	li	s1,10
8000b9d0:	f21ff06f          	j	8000b8f0 <finsh_token_token+0x424>
8000b9d4:	f34510e3          	bne	a0,s4,8000b8f4 <finsh_token_token+0x428>
8000b9d8:	00090023          	sb	zero,0(s2)
8000b9dc:	f45ff06f          	j	8000b920 <finsh_token_token+0x454>
8000b9e0:	00098913          	mv	s2,s3
8000b9e4:	07f00b13          	li	s6,127
8000b9e8:	05c00b93          	li	s7,92
8000b9ec:	02200a13          	li	s4,34
8000b9f0:	00500c13          	li	s8,5
8000b9f4:	04000c93          	li	s9,64
8000b9f8:	00003a97          	auipc	s5,0x3
8000b9fc:	c98a8a93          	addi	s5,s5,-872 # 8000e690 <CSWTCH.5+0x80>
8000ba00:	efdff06f          	j	8000b8fc <finsh_token_token+0x430>
8000ba04:	00040513          	mv	a0,s0
8000ba08:	921ff0ef          	jal	ra,8000b328 <token_next_char>
8000ba0c:	0df57793          	andi	a5,a0,223
8000ba10:	05800713          	li	a4,88
8000ba14:	00050493          	mv	s1,a0
8000ba18:	0ae79663          	bne	a5,a4,8000bac4 <finsh_token_token+0x5f8>
8000ba1c:	00040513          	mv	a0,s0
8000ba20:	909ff0ef          	jal	ra,8000b328 <token_next_char>
8000ba24:	00050493          	mv	s1,a0
8000ba28:	00010913          	mv	s2,sp
8000ba2c:	00900a13          	li	s4,9
8000ba30:	01900993          	li	s3,25
8000ba34:	fd048793          	addi	a5,s1,-48
8000ba38:	0ff7f793          	andi	a5,a5,255
8000ba3c:	06fa7863          	bgeu	s4,a5,8000baac <finsh_token_token+0x5e0>
8000ba40:	0204e793          	ori	a5,s1,32
8000ba44:	0ff7f793          	andi	a5,a5,255
8000ba48:	f9f78793          	addi	a5,a5,-97
8000ba4c:	06f9f063          	bgeu	s3,a5,8000baac <finsh_token_token+0x5e0>
8000ba50:	00090023          	sb	zero,0(s2)
8000ba54:	01000913          	li	s2,16
8000ba58:	00010513          	mv	a0,sp
8000ba5c:	5d0000ef          	jal	ra,8000c02c <strlen>
8000ba60:	00800793          	li	a5,8
8000ba64:	00300613          	li	a2,3
8000ba68:	00f90a63          	beq	s2,a5,8000ba7c <finsh_token_token+0x5b0>
8000ba6c:	01000793          	li	a5,16
8000ba70:	00100613          	li	a2,1
8000ba74:	00f91463          	bne	s2,a5,8000ba7c <finsh_token_token+0x5b0>
8000ba78:	00400613          	li	a2,4
8000ba7c:	00000793          	li	a5,0
8000ba80:	00000693          	li	a3,0
8000ba84:	00500893          	li	a7,5
8000ba88:	0ea6c063          	blt	a3,a0,8000bb68 <finsh_token_token+0x69c>
8000ba8c:	00f42623          	sw	a5,12(s0)
8000ba90:	01b00793          	li	a5,27
8000ba94:	00f40423          	sb	a5,8(s0)
8000ba98:	0df4f513          	andi	a0,s1,223
8000ba9c:	04c00793          	li	a5,76
8000baa0:	10f51c63          	bne	a0,a5,8000bbb8 <finsh_token_token+0x6ec>
8000baa4:	01c00793          	li	a5,28
8000baa8:	aa5ff06f          	j	8000b54c <finsh_token_token+0x80>
8000baac:	00990023          	sb	s1,0(s2)
8000bab0:	00040513          	mv	a0,s0
8000bab4:	875ff0ef          	jal	ra,8000b328 <token_next_char>
8000bab8:	00190913          	addi	s2,s2,1
8000babc:	00050493          	mv	s1,a0
8000bac0:	f75ff06f          	j	8000ba34 <finsh_token_token+0x568>
8000bac4:	04200713          	li	a4,66
8000bac8:	04e79463          	bne	a5,a4,8000bb10 <finsh_token_token+0x644>
8000bacc:	00040513          	mv	a0,s0
8000bad0:	859ff0ef          	jal	ra,8000b328 <token_next_char>
8000bad4:	00050493          	mv	s1,a0
8000bad8:	00010913          	mv	s2,sp
8000badc:	00100993          	li	s3,1
8000bae0:	fd048793          	addi	a5,s1,-48
8000bae4:	0ff7f793          	andi	a5,a5,255
8000bae8:	00f9f863          	bgeu	s3,a5,8000baf8 <finsh_token_token+0x62c>
8000baec:	00090023          	sb	zero,0(s2)
8000baf0:	00200913          	li	s2,2
8000baf4:	f65ff06f          	j	8000ba58 <finsh_token_token+0x58c>
8000baf8:	00990023          	sb	s1,0(s2)
8000bafc:	00040513          	mv	a0,s0
8000bb00:	829ff0ef          	jal	ra,8000b328 <token_next_char>
8000bb04:	00190913          	addi	s2,s2,1
8000bb08:	00050493          	mv	s1,a0
8000bb0c:	fd5ff06f          	j	8000bae0 <finsh_token_token+0x614>
8000bb10:	fd050793          	addi	a5,a0,-48
8000bb14:	0ff7f793          	andi	a5,a5,255
8000bb18:	00700713          	li	a4,7
8000bb1c:	02f76c63          	bltu	a4,a5,8000bb54 <finsh_token_token+0x688>
8000bb20:	00010913          	mv	s2,sp
8000bb24:	00700993          	li	s3,7
8000bb28:	00990023          	sb	s1,0(s2)
8000bb2c:	00040513          	mv	a0,s0
8000bb30:	ff8ff0ef          	jal	ra,8000b328 <token_next_char>
8000bb34:	fd050793          	addi	a5,a0,-48
8000bb38:	0ff7f793          	andi	a5,a5,255
8000bb3c:	00190913          	addi	s2,s2,1
8000bb40:	00050493          	mv	s1,a0
8000bb44:	fef9f2e3          	bgeu	s3,a5,8000bb28 <finsh_token_token+0x65c>
8000bb48:	00090023          	sb	zero,0(s2)
8000bb4c:	00800913          	li	s2,8
8000bb50:	f09ff06f          	j	8000ba58 <finsh_token_token+0x58c>
8000bb54:	00040513          	mv	a0,s0
8000bb58:	fb4ff0ef          	jal	ra,8000b30c <token_prev_char>
8000bb5c:	01b00793          	li	a5,27
8000bb60:	00042623          	sw	zero,12(s0)
8000bb64:	9e9ff06f          	j	8000b54c <finsh_token_token+0x80>
8000bb68:	00d10733          	add	a4,sp,a3
8000bb6c:	00074703          	lbu	a4,0(a4)
8000bb70:	f9f70593          	addi	a1,a4,-97
8000bb74:	00b8ec63          	bltu	a7,a1,8000bb8c <finsh_token_token+0x6c0>
8000bb78:	fa970593          	addi	a1,a4,-87
8000bb7c:	00c797b3          	sll	a5,a5,a2
8000bb80:	00b7e7b3          	or	a5,a5,a1
8000bb84:	00168693          	addi	a3,a3,1
8000bb88:	f01ff06f          	j	8000ba88 <finsh_token_token+0x5bc>
8000bb8c:	fbf70813          	addi	a6,a4,-65
8000bb90:	fd070593          	addi	a1,a4,-48
8000bb94:	ff08e4e3          	bltu	a7,a6,8000bb7c <finsh_token_token+0x6b0>
8000bb98:	fc970593          	addi	a1,a4,-55
8000bb9c:	fe1ff06f          	j	8000bb7c <finsh_token_token+0x6b0>
8000bba0:	03490933          	mul	s2,s2,s4
8000bba4:	00040513          	mv	a0,s0
8000bba8:	01278933          	add	s2,a5,s2
8000bbac:	f7cff0ef          	jal	ra,8000b328 <token_next_char>
8000bbb0:	00050493          	mv	s1,a0
8000bbb4:	ac5ff06f          	j	8000b678 <finsh_token_token+0x1ac>
8000bbb8:	00040513          	mv	a0,s0
8000bbbc:	f50ff0ef          	jal	ra,8000b30c <token_prev_char>
8000bbc0:	999ff06f          	j	8000b558 <finsh_token_token+0x8c>
8000bbc4:	00b00513          	li	a0,11
8000bbc8:	cdcfd0ef          	jal	ra,800090a4 <finsh_error_set>
8000bbcc:	b81ff06f          	j	8000b74c <finsh_token_token+0x280>

8000bbd0 <libc_system_init>:
8000bbd0:	00000513          	li	a0,0
8000bbd4:	00008067          	ret

8000bbd8 <__libc_init_array>:
8000bbd8:	00008067          	ret

8000bbdc <atexit>:
8000bbdc:	00050593          	mv	a1,a0
8000bbe0:	00000693          	li	a3,0
8000bbe4:	00000613          	li	a2,0
8000bbe8:	00000513          	li	a0,0
8000bbec:	6c40006f          	j	8000c2b0 <__register_exitproc>

8000bbf0 <atoi>:
8000bbf0:	00a00613          	li	a2,10
8000bbf4:	00000593          	li	a1,0
8000bbf8:	6900006f          	j	8000c288 <strtol>

8000bbfc <__libc_fini_array>:
8000bbfc:	ff010113          	addi	sp,sp,-16
8000bc00:	00003797          	auipc	a5,0x3
8000bc04:	ee078793          	addi	a5,a5,-288 # 8000eae0 <__fini_array_end>
8000bc08:	00812423          	sw	s0,8(sp)
8000bc0c:	00003417          	auipc	s0,0x3
8000bc10:	ed440413          	addi	s0,s0,-300 # 8000eae0 <__fini_array_end>
8000bc14:	40f40433          	sub	s0,s0,a5
8000bc18:	00912223          	sw	s1,4(sp)
8000bc1c:	00112623          	sw	ra,12(sp)
8000bc20:	40245413          	srai	s0,s0,0x2
8000bc24:	00078493          	mv	s1,a5
8000bc28:	00041c63          	bnez	s0,8000bc40 <__libc_fini_array+0x44>
8000bc2c:	00812403          	lw	s0,8(sp)
8000bc30:	00c12083          	lw	ra,12(sp)
8000bc34:	00412483          	lw	s1,4(sp)
8000bc38:	01010113          	addi	sp,sp,16
8000bc3c:	efcf406f          	j	80000338 <_fini>
8000bc40:	fff40413          	addi	s0,s0,-1
8000bc44:	00241793          	slli	a5,s0,0x2
8000bc48:	00f487b3          	add	a5,s1,a5
8000bc4c:	0007a783          	lw	a5,0(a5)
8000bc50:	000780e7          	jalr	a5
8000bc54:	fd5ff06f          	j	8000bc28 <__libc_fini_array+0x2c>

8000bc58 <memcmp>:
8000bc58:	00000713          	li	a4,0
8000bc5c:	00e61663          	bne	a2,a4,8000bc68 <memcmp+0x10>
8000bc60:	00000513          	li	a0,0
8000bc64:	00008067          	ret
8000bc68:	00e507b3          	add	a5,a0,a4
8000bc6c:	00170713          	addi	a4,a4,1
8000bc70:	00e586b3          	add	a3,a1,a4
8000bc74:	0007c783          	lbu	a5,0(a5)
8000bc78:	fff6c683          	lbu	a3,-1(a3)
8000bc7c:	fed780e3          	beq	a5,a3,8000bc5c <memcmp+0x4>
8000bc80:	40d78533          	sub	a0,a5,a3
8000bc84:	00008067          	ret

8000bc88 <memcpy>:
8000bc88:	00a5c7b3          	xor	a5,a1,a0
8000bc8c:	0037f793          	andi	a5,a5,3
8000bc90:	00c506b3          	add	a3,a0,a2
8000bc94:	00079663          	bnez	a5,8000bca0 <memcpy+0x18>
8000bc98:	00300793          	li	a5,3
8000bc9c:	02c7e263          	bltu	a5,a2,8000bcc0 <memcpy+0x38>
8000bca0:	00050793          	mv	a5,a0
8000bca4:	0cd57863          	bgeu	a0,a3,8000bd74 <memcpy+0xec>
8000bca8:	0005c703          	lbu	a4,0(a1)
8000bcac:	00178793          	addi	a5,a5,1
8000bcb0:	00158593          	addi	a1,a1,1
8000bcb4:	fee78fa3          	sb	a4,-1(a5)
8000bcb8:	fed7e8e3          	bltu	a5,a3,8000bca8 <memcpy+0x20>
8000bcbc:	00008067          	ret
8000bcc0:	00357713          	andi	a4,a0,3
8000bcc4:	00050793          	mv	a5,a0
8000bcc8:	00070e63          	beqz	a4,8000bce4 <memcpy+0x5c>
8000bccc:	0005c703          	lbu	a4,0(a1)
8000bcd0:	00178793          	addi	a5,a5,1
8000bcd4:	00158593          	addi	a1,a1,1
8000bcd8:	fee78fa3          	sb	a4,-1(a5)
8000bcdc:	0037f713          	andi	a4,a5,3
8000bce0:	fe9ff06f          	j	8000bcc8 <memcpy+0x40>
8000bce4:	ffc6f713          	andi	a4,a3,-4
8000bce8:	fe070613          	addi	a2,a4,-32
8000bcec:	04c7fc63          	bgeu	a5,a2,8000bd44 <memcpy+0xbc>
8000bcf0:	0005a383          	lw	t2,0(a1)
8000bcf4:	0045a283          	lw	t0,4(a1)
8000bcf8:	0085af83          	lw	t6,8(a1)
8000bcfc:	00c5af03          	lw	t5,12(a1)
8000bd00:	0105ae83          	lw	t4,16(a1)
8000bd04:	0145ae03          	lw	t3,20(a1)
8000bd08:	0185a303          	lw	t1,24(a1)
8000bd0c:	01c5a883          	lw	a7,28(a1)
8000bd10:	0077a023          	sw	t2,0(a5)
8000bd14:	0057a223          	sw	t0,4(a5)
8000bd18:	0205a803          	lw	a6,32(a1)
8000bd1c:	01f7a423          	sw	t6,8(a5)
8000bd20:	01e7a623          	sw	t5,12(a5)
8000bd24:	01d7a823          	sw	t4,16(a5)
8000bd28:	01c7aa23          	sw	t3,20(a5)
8000bd2c:	0067ac23          	sw	t1,24(a5)
8000bd30:	0117ae23          	sw	a7,28(a5)
8000bd34:	02458593          	addi	a1,a1,36
8000bd38:	02478793          	addi	a5,a5,36
8000bd3c:	ff07ae23          	sw	a6,-4(a5)
8000bd40:	fadff06f          	j	8000bcec <memcpy+0x64>
8000bd44:	00058813          	mv	a6,a1
8000bd48:	00078613          	mv	a2,a5
8000bd4c:	02e66663          	bltu	a2,a4,8000bd78 <memcpy+0xf0>
8000bd50:	ffd78813          	addi	a6,a5,-3
8000bd54:	00000613          	li	a2,0
8000bd58:	01076863          	bltu	a4,a6,8000bd68 <memcpy+0xe0>
8000bd5c:	00370713          	addi	a4,a4,3
8000bd60:	40f70733          	sub	a4,a4,a5
8000bd64:	ffc77613          	andi	a2,a4,-4
8000bd68:	00c787b3          	add	a5,a5,a2
8000bd6c:	00c585b3          	add	a1,a1,a2
8000bd70:	f2d7ece3          	bltu	a5,a3,8000bca8 <memcpy+0x20>
8000bd74:	00008067          	ret
8000bd78:	00082883          	lw	a7,0(a6)
8000bd7c:	00460613          	addi	a2,a2,4
8000bd80:	00480813          	addi	a6,a6,4
8000bd84:	ff162e23          	sw	a7,-4(a2)
8000bd88:	fc5ff06f          	j	8000bd4c <memcpy+0xc4>

8000bd8c <memset>:
8000bd8c:	00f00313          	li	t1,15
8000bd90:	00050713          	mv	a4,a0
8000bd94:	02c37e63          	bgeu	t1,a2,8000bdd0 <memset+0x44>
8000bd98:	00f77793          	andi	a5,a4,15
8000bd9c:	0a079063          	bnez	a5,8000be3c <memset+0xb0>
8000bda0:	08059263          	bnez	a1,8000be24 <memset+0x98>
8000bda4:	ff067693          	andi	a3,a2,-16
8000bda8:	00f67613          	andi	a2,a2,15
8000bdac:	00e686b3          	add	a3,a3,a4
8000bdb0:	00b72023          	sw	a1,0(a4)
8000bdb4:	00b72223          	sw	a1,4(a4)
8000bdb8:	00b72423          	sw	a1,8(a4)
8000bdbc:	00b72623          	sw	a1,12(a4)
8000bdc0:	01070713          	addi	a4,a4,16
8000bdc4:	fed766e3          	bltu	a4,a3,8000bdb0 <memset+0x24>
8000bdc8:	00061463          	bnez	a2,8000bdd0 <memset+0x44>
8000bdcc:	00008067          	ret
8000bdd0:	40c306b3          	sub	a3,t1,a2
8000bdd4:	00269693          	slli	a3,a3,0x2
8000bdd8:	00000297          	auipc	t0,0x0
8000bddc:	005686b3          	add	a3,a3,t0
8000bde0:	00c68067          	jr	12(a3)
8000bde4:	00b70723          	sb	a1,14(a4)
8000bde8:	00b706a3          	sb	a1,13(a4)
8000bdec:	00b70623          	sb	a1,12(a4)
8000bdf0:	00b705a3          	sb	a1,11(a4)
8000bdf4:	00b70523          	sb	a1,10(a4)
8000bdf8:	00b704a3          	sb	a1,9(a4)
8000bdfc:	00b70423          	sb	a1,8(a4)
8000be00:	00b703a3          	sb	a1,7(a4)
8000be04:	00b70323          	sb	a1,6(a4)
8000be08:	00b702a3          	sb	a1,5(a4)
8000be0c:	00b70223          	sb	a1,4(a4)
8000be10:	00b701a3          	sb	a1,3(a4)
8000be14:	00b70123          	sb	a1,2(a4)
8000be18:	00b700a3          	sb	a1,1(a4)
8000be1c:	00b70023          	sb	a1,0(a4)
8000be20:	00008067          	ret
8000be24:	0ff5f593          	andi	a1,a1,255
8000be28:	00859693          	slli	a3,a1,0x8
8000be2c:	00d5e5b3          	or	a1,a1,a3
8000be30:	01059693          	slli	a3,a1,0x10
8000be34:	00d5e5b3          	or	a1,a1,a3
8000be38:	f6dff06f          	j	8000bda4 <memset+0x18>
8000be3c:	00279693          	slli	a3,a5,0x2
8000be40:	00000297          	auipc	t0,0x0
8000be44:	005686b3          	add	a3,a3,t0
8000be48:	00008293          	mv	t0,ra
8000be4c:	fa0680e7          	jalr	-96(a3)
8000be50:	00028093          	mv	ra,t0
8000be54:	ff078793          	addi	a5,a5,-16
8000be58:	40f70733          	sub	a4,a4,a5
8000be5c:	00f60633          	add	a2,a2,a5
8000be60:	f6c378e3          	bgeu	t1,a2,8000bdd0 <memset+0x44>
8000be64:	f3dff06f          	j	8000bda0 <memset+0x14>

8000be68 <strcat>:
8000be68:	00050793          	mv	a5,a0
8000be6c:	0007c683          	lbu	a3,0(a5)
8000be70:	00078713          	mv	a4,a5
8000be74:	00178793          	addi	a5,a5,1
8000be78:	fe069ae3          	bnez	a3,8000be6c <strcat+0x4>
8000be7c:	0005c783          	lbu	a5,0(a1)
8000be80:	00158593          	addi	a1,a1,1
8000be84:	00170713          	addi	a4,a4,1
8000be88:	fef70fa3          	sb	a5,-1(a4)
8000be8c:	fe0798e3          	bnez	a5,8000be7c <strcat+0x14>
8000be90:	00008067          	ret

8000be94 <strcmp>:
8000be94:	00b56733          	or	a4,a0,a1
8000be98:	fff00393          	li	t2,-1
8000be9c:	00377713          	andi	a4,a4,3
8000bea0:	10071063          	bnez	a4,8000bfa0 <strcmp+0x10c>
8000bea4:	7f7f87b7          	lui	a5,0x7f7f8
8000bea8:	f7f78793          	addi	a5,a5,-129 # 7f7f7f7f <__RAM_SIZE+0x7f7d7f7f>
8000beac:	00052603          	lw	a2,0(a0)
8000beb0:	0005a683          	lw	a3,0(a1)
8000beb4:	00f672b3          	and	t0,a2,a5
8000beb8:	00f66333          	or	t1,a2,a5
8000bebc:	00f282b3          	add	t0,t0,a5
8000bec0:	0062e2b3          	or	t0,t0,t1
8000bec4:	10729263          	bne	t0,t2,8000bfc8 <strcmp+0x134>
8000bec8:	08d61663          	bne	a2,a3,8000bf54 <strcmp+0xc0>
8000becc:	00452603          	lw	a2,4(a0)
8000bed0:	0045a683          	lw	a3,4(a1)
8000bed4:	00f672b3          	and	t0,a2,a5
8000bed8:	00f66333          	or	t1,a2,a5
8000bedc:	00f282b3          	add	t0,t0,a5
8000bee0:	0062e2b3          	or	t0,t0,t1
8000bee4:	0c729e63          	bne	t0,t2,8000bfc0 <strcmp+0x12c>
8000bee8:	06d61663          	bne	a2,a3,8000bf54 <strcmp+0xc0>
8000beec:	00852603          	lw	a2,8(a0)
8000bef0:	0085a683          	lw	a3,8(a1)
8000bef4:	00f672b3          	and	t0,a2,a5
8000bef8:	00f66333          	or	t1,a2,a5
8000befc:	00f282b3          	add	t0,t0,a5
8000bf00:	0062e2b3          	or	t0,t0,t1
8000bf04:	0c729863          	bne	t0,t2,8000bfd4 <strcmp+0x140>
8000bf08:	04d61663          	bne	a2,a3,8000bf54 <strcmp+0xc0>
8000bf0c:	00c52603          	lw	a2,12(a0)
8000bf10:	00c5a683          	lw	a3,12(a1)
8000bf14:	00f672b3          	and	t0,a2,a5
8000bf18:	00f66333          	or	t1,a2,a5
8000bf1c:	00f282b3          	add	t0,t0,a5
8000bf20:	0062e2b3          	or	t0,t0,t1
8000bf24:	0c729263          	bne	t0,t2,8000bfe8 <strcmp+0x154>
8000bf28:	02d61663          	bne	a2,a3,8000bf54 <strcmp+0xc0>
8000bf2c:	01052603          	lw	a2,16(a0)
8000bf30:	0105a683          	lw	a3,16(a1)
8000bf34:	00f672b3          	and	t0,a2,a5
8000bf38:	00f66333          	or	t1,a2,a5
8000bf3c:	00f282b3          	add	t0,t0,a5
8000bf40:	0062e2b3          	or	t0,t0,t1
8000bf44:	0a729c63          	bne	t0,t2,8000bffc <strcmp+0x168>
8000bf48:	01450513          	addi	a0,a0,20
8000bf4c:	01458593          	addi	a1,a1,20
8000bf50:	f4d60ee3          	beq	a2,a3,8000beac <strcmp+0x18>
8000bf54:	01061713          	slli	a4,a2,0x10
8000bf58:	01069793          	slli	a5,a3,0x10
8000bf5c:	00f71e63          	bne	a4,a5,8000bf78 <strcmp+0xe4>
8000bf60:	01065713          	srli	a4,a2,0x10
8000bf64:	0106d793          	srli	a5,a3,0x10
8000bf68:	40f70533          	sub	a0,a4,a5
8000bf6c:	0ff57593          	andi	a1,a0,255
8000bf70:	02059063          	bnez	a1,8000bf90 <strcmp+0xfc>
8000bf74:	00008067          	ret
8000bf78:	01075713          	srli	a4,a4,0x10
8000bf7c:	0107d793          	srli	a5,a5,0x10
8000bf80:	40f70533          	sub	a0,a4,a5
8000bf84:	0ff57593          	andi	a1,a0,255
8000bf88:	00059463          	bnez	a1,8000bf90 <strcmp+0xfc>
8000bf8c:	00008067          	ret
8000bf90:	0ff77713          	andi	a4,a4,255
8000bf94:	0ff7f793          	andi	a5,a5,255
8000bf98:	40f70533          	sub	a0,a4,a5
8000bf9c:	00008067          	ret
8000bfa0:	00054603          	lbu	a2,0(a0)
8000bfa4:	0005c683          	lbu	a3,0(a1)
8000bfa8:	00150513          	addi	a0,a0,1
8000bfac:	00158593          	addi	a1,a1,1
8000bfb0:	00d61463          	bne	a2,a3,8000bfb8 <strcmp+0x124>
8000bfb4:	fe0616e3          	bnez	a2,8000bfa0 <strcmp+0x10c>
8000bfb8:	40d60533          	sub	a0,a2,a3
8000bfbc:	00008067          	ret
8000bfc0:	00450513          	addi	a0,a0,4
8000bfc4:	00458593          	addi	a1,a1,4
8000bfc8:	fcd61ce3          	bne	a2,a3,8000bfa0 <strcmp+0x10c>
8000bfcc:	00000513          	li	a0,0
8000bfd0:	00008067          	ret
8000bfd4:	00850513          	addi	a0,a0,8
8000bfd8:	00858593          	addi	a1,a1,8
8000bfdc:	fcd612e3          	bne	a2,a3,8000bfa0 <strcmp+0x10c>
8000bfe0:	00000513          	li	a0,0
8000bfe4:	00008067          	ret
8000bfe8:	00c50513          	addi	a0,a0,12
8000bfec:	00c58593          	addi	a1,a1,12
8000bff0:	fad618e3          	bne	a2,a3,8000bfa0 <strcmp+0x10c>
8000bff4:	00000513          	li	a0,0
8000bff8:	00008067          	ret
8000bffc:	01050513          	addi	a0,a0,16
8000c000:	01058593          	addi	a1,a1,16
8000c004:	f8d61ee3          	bne	a2,a3,8000bfa0 <strcmp+0x10c>
8000c008:	00000513          	li	a0,0
8000c00c:	00008067          	ret

8000c010 <strcpy>:
8000c010:	00050793          	mv	a5,a0
8000c014:	0005c703          	lbu	a4,0(a1)
8000c018:	00178793          	addi	a5,a5,1
8000c01c:	00158593          	addi	a1,a1,1
8000c020:	fee78fa3          	sb	a4,-1(a5)
8000c024:	fe0718e3          	bnez	a4,8000c014 <strcpy+0x4>
8000c028:	00008067          	ret

8000c02c <strlen>:
8000c02c:	00050793          	mv	a5,a0
8000c030:	0007c703          	lbu	a4,0(a5)
8000c034:	00178793          	addi	a5,a5,1
8000c038:	fe071ce3          	bnez	a4,8000c030 <strlen+0x4>
8000c03c:	40a78533          	sub	a0,a5,a0
8000c040:	fff50513          	addi	a0,a0,-1
8000c044:	00008067          	ret

8000c048 <strncmp>:
8000c048:	02060a63          	beqz	a2,8000c07c <strncmp+0x34>
8000c04c:	fff60613          	addi	a2,a2,-1
8000c050:	00000713          	li	a4,0
8000c054:	00e507b3          	add	a5,a0,a4
8000c058:	00e586b3          	add	a3,a1,a4
8000c05c:	0007c783          	lbu	a5,0(a5)
8000c060:	0006c683          	lbu	a3,0(a3)
8000c064:	00d79863          	bne	a5,a3,8000c074 <strncmp+0x2c>
8000c068:	00c70663          	beq	a4,a2,8000c074 <strncmp+0x2c>
8000c06c:	00170713          	addi	a4,a4,1
8000c070:	fe0792e3          	bnez	a5,8000c054 <strncmp+0xc>
8000c074:	40d78533          	sub	a0,a5,a3
8000c078:	00008067          	ret
8000c07c:	00000513          	li	a0,0
8000c080:	00008067          	ret

8000c084 <strncpy>:
8000c084:	00050793          	mv	a5,a0
8000c088:	00060e63          	beqz	a2,8000c0a4 <strncpy+0x20>
8000c08c:	0005c703          	lbu	a4,0(a1)
8000c090:	00158593          	addi	a1,a1,1
8000c094:	00178793          	addi	a5,a5,1
8000c098:	fee78fa3          	sb	a4,-1(a5)
8000c09c:	fff60613          	addi	a2,a2,-1
8000c0a0:	fe0714e3          	bnez	a4,8000c088 <strncpy+0x4>
8000c0a4:	00c78633          	add	a2,a5,a2
8000c0a8:	00c79463          	bne	a5,a2,8000c0b0 <strncpy+0x2c>
8000c0ac:	00008067          	ret
8000c0b0:	00178793          	addi	a5,a5,1
8000c0b4:	fe078fa3          	sb	zero,-1(a5)
8000c0b8:	ff1ff06f          	j	8000c0a8 <strncpy+0x24>

8000c0bc <_strtol_l.isra.0>:
8000c0bc:	fd010113          	addi	sp,sp,-48
8000c0c0:	02912223          	sw	s1,36(sp)
8000c0c4:	03212023          	sw	s2,32(sp)
8000c0c8:	01312e23          	sw	s3,28(sp)
8000c0cc:	01412c23          	sw	s4,24(sp)
8000c0d0:	01512a23          	sw	s5,20(sp)
8000c0d4:	01612823          	sw	s6,16(sp)
8000c0d8:	02112623          	sw	ra,44(sp)
8000c0dc:	02812423          	sw	s0,40(sp)
8000c0e0:	01712623          	sw	s7,12(sp)
8000c0e4:	00050a93          	mv	s5,a0
8000c0e8:	00058993          	mv	s3,a1
8000c0ec:	00060a13          	mv	s4,a2
8000c0f0:	00068913          	mv	s2,a3
8000c0f4:	00070b13          	mv	s6,a4
8000c0f8:	00058493          	mv	s1,a1
8000c0fc:	00048b93          	mv	s7,s1
8000c100:	0004c403          	lbu	s0,0(s1)
8000c104:	000b0513          	mv	a0,s6
8000c108:	24c000ef          	jal	ra,8000c354 <__locale_ctype_ptr_l>
8000c10c:	00850533          	add	a0,a0,s0
8000c110:	00154783          	lbu	a5,1(a0)
8000c114:	00148493          	addi	s1,s1,1
8000c118:	0087f793          	andi	a5,a5,8
8000c11c:	fe0790e3          	bnez	a5,8000c0fc <_strtol_l.isra.0+0x40>
8000c120:	02d00793          	li	a5,45
8000c124:	0af41263          	bne	s0,a5,8000c1c8 <_strtol_l.isra.0+0x10c>
8000c128:	0004c783          	lbu	a5,0(s1)
8000c12c:	00100593          	li	a1,1
8000c130:	002b8493          	addi	s1,s7,2
8000c134:	14090263          	beqz	s2,8000c278 <_strtol_l.isra.0+0x1bc>
8000c138:	01000713          	li	a4,16
8000c13c:	02e91463          	bne	s2,a4,8000c164 <_strtol_l.isra.0+0xa8>
8000c140:	03000713          	li	a4,48
8000c144:	02e79063          	bne	a5,a4,8000c164 <_strtol_l.isra.0+0xa8>
8000c148:	0004c783          	lbu	a5,0(s1)
8000c14c:	05800713          	li	a4,88
8000c150:	0df7f793          	andi	a5,a5,223
8000c154:	10e79a63          	bne	a5,a4,8000c268 <_strtol_l.isra.0+0x1ac>
8000c158:	0014c783          	lbu	a5,1(s1)
8000c15c:	01000913          	li	s2,16
8000c160:	00248493          	addi	s1,s1,2
8000c164:	800006b7          	lui	a3,0x80000
8000c168:	fff6c693          	not	a3,a3
8000c16c:	00d586b3          	add	a3,a1,a3
8000c170:	0326f333          	remu	t1,a3,s2
8000c174:	00000613          	li	a2,0
8000c178:	00000513          	li	a0,0
8000c17c:	00900e13          	li	t3,9
8000c180:	01900893          	li	a7,25
8000c184:	fff00e93          	li	t4,-1
8000c188:	0326d833          	divu	a6,a3,s2
8000c18c:	fd078713          	addi	a4,a5,-48
8000c190:	04ee6c63          	bltu	t3,a4,8000c1e8 <_strtol_l.isra.0+0x12c>
8000c194:	00070793          	mv	a5,a4
8000c198:	0727d863          	bge	a5,s2,8000c208 <_strtol_l.isra.0+0x14c>
8000c19c:	03d60063          	beq	a2,t4,8000c1bc <_strtol_l.isra.0+0x100>
8000c1a0:	fff00613          	li	a2,-1
8000c1a4:	00a86c63          	bltu	a6,a0,8000c1bc <_strtol_l.isra.0+0x100>
8000c1a8:	00a81463          	bne	a6,a0,8000c1b0 <_strtol_l.isra.0+0xf4>
8000c1ac:	00f34863          	blt	t1,a5,8000c1bc <_strtol_l.isra.0+0x100>
8000c1b0:	00100613          	li	a2,1
8000c1b4:	02a90533          	mul	a0,s2,a0
8000c1b8:	00a78533          	add	a0,a5,a0
8000c1bc:	00148493          	addi	s1,s1,1
8000c1c0:	fff4c783          	lbu	a5,-1(s1)
8000c1c4:	fc9ff06f          	j	8000c18c <_strtol_l.isra.0+0xd0>
8000c1c8:	02b00793          	li	a5,43
8000c1cc:	00f40863          	beq	s0,a5,8000c1dc <_strtol_l.isra.0+0x120>
8000c1d0:	00040793          	mv	a5,s0
8000c1d4:	00000593          	li	a1,0
8000c1d8:	f5dff06f          	j	8000c134 <_strtol_l.isra.0+0x78>
8000c1dc:	0004c783          	lbu	a5,0(s1)
8000c1e0:	002b8493          	addi	s1,s7,2
8000c1e4:	ff1ff06f          	j	8000c1d4 <_strtol_l.isra.0+0x118>
8000c1e8:	fbf78713          	addi	a4,a5,-65
8000c1ec:	00e8e663          	bltu	a7,a4,8000c1f8 <_strtol_l.isra.0+0x13c>
8000c1f0:	fc978793          	addi	a5,a5,-55
8000c1f4:	fa5ff06f          	j	8000c198 <_strtol_l.isra.0+0xdc>
8000c1f8:	f9f78713          	addi	a4,a5,-97
8000c1fc:	00e8e663          	bltu	a7,a4,8000c208 <_strtol_l.isra.0+0x14c>
8000c200:	fa978793          	addi	a5,a5,-87
8000c204:	f95ff06f          	j	8000c198 <_strtol_l.isra.0+0xdc>
8000c208:	fff00793          	li	a5,-1
8000c20c:	04f61063          	bne	a2,a5,8000c24c <_strtol_l.isra.0+0x190>
8000c210:	02200793          	li	a5,34
8000c214:	00faa023          	sw	a5,0(s5)
8000c218:	00068513          	mv	a0,a3
8000c21c:	040a1063          	bnez	s4,8000c25c <_strtol_l.isra.0+0x1a0>
8000c220:	02c12083          	lw	ra,44(sp)
8000c224:	02812403          	lw	s0,40(sp)
8000c228:	02412483          	lw	s1,36(sp)
8000c22c:	02012903          	lw	s2,32(sp)
8000c230:	01c12983          	lw	s3,28(sp)
8000c234:	01812a03          	lw	s4,24(sp)
8000c238:	01412a83          	lw	s5,20(sp)
8000c23c:	01012b03          	lw	s6,16(sp)
8000c240:	00c12b83          	lw	s7,12(sp)
8000c244:	03010113          	addi	sp,sp,48
8000c248:	00008067          	ret
8000c24c:	00058463          	beqz	a1,8000c254 <_strtol_l.isra.0+0x198>
8000c250:	40a00533          	neg	a0,a0
8000c254:	fc0a06e3          	beqz	s4,8000c220 <_strtol_l.isra.0+0x164>
8000c258:	00060463          	beqz	a2,8000c260 <_strtol_l.isra.0+0x1a4>
8000c25c:	fff48993          	addi	s3,s1,-1
8000c260:	013a2023          	sw	s3,0(s4)
8000c264:	fbdff06f          	j	8000c220 <_strtol_l.isra.0+0x164>
8000c268:	03000793          	li	a5,48
8000c26c:	ee091ce3          	bnez	s2,8000c164 <_strtol_l.isra.0+0xa8>
8000c270:	00800913          	li	s2,8
8000c274:	ef1ff06f          	j	8000c164 <_strtol_l.isra.0+0xa8>
8000c278:	03000713          	li	a4,48
8000c27c:	ece786e3          	beq	a5,a4,8000c148 <_strtol_l.isra.0+0x8c>
8000c280:	00a00913          	li	s2,10
8000c284:	ee1ff06f          	j	8000c164 <_strtol_l.isra.0+0xa8>

8000c288 <strtol>:
8000c288:	00050793          	mv	a5,a0
8000c28c:	8181a503          	lw	a0,-2024(gp) # 80020278 <_impure_ptr>
8000c290:	02052703          	lw	a4,32(a0)
8000c294:	00060693          	mv	a3,a2
8000c298:	00071663          	bnez	a4,8000c2a4 <strtol+0x1c>
8000c29c:	00014717          	auipc	a4,0x14
8000c2a0:	e5470713          	addi	a4,a4,-428 # 800200f0 <__global_locale>
8000c2a4:	00058613          	mv	a2,a1
8000c2a8:	00078593          	mv	a1,a5
8000c2ac:	e11ff06f          	j	8000c0bc <_strtol_l.isra.0>

8000c2b0 <__register_exitproc>:
8000c2b0:	00050893          	mv	a7,a0
8000c2b4:	91018513          	addi	a0,gp,-1776 # 80020370 <_global_atexit>
8000c2b8:	00052783          	lw	a5,0(a0)
8000c2bc:	02079463          	bnez	a5,8000c2e4 <__register_exitproc+0x34>
8000c2c0:	52c18713          	addi	a4,gp,1324 # 80020f8c <_global_atexit0>
8000c2c4:	00e52023          	sw	a4,0(a0)
8000c2c8:	7fff4517          	auipc	a0,0x7fff4
8000c2cc:	d3850513          	addi	a0,a0,-712 # 0 <_sp+0x7ffc0000>
8000c2d0:	00070793          	mv	a5,a4
8000c2d4:	00050863          	beqz	a0,8000c2e4 <__register_exitproc+0x34>
8000c2d8:	00052783          	lw	a5,0(a0)
8000c2dc:	08f72423          	sw	a5,136(a4)
8000c2e0:	00070793          	mv	a5,a4
8000c2e4:	0047a703          	lw	a4,4(a5)
8000c2e8:	01f00813          	li	a6,31
8000c2ec:	fff00513          	li	a0,-1
8000c2f0:	06e84063          	blt	a6,a4,8000c350 <__register_exitproc+0xa0>
8000c2f4:	04088263          	beqz	a7,8000c338 <__register_exitproc+0x88>
8000c2f8:	0887a803          	lw	a6,136(a5)
8000c2fc:	04080a63          	beqz	a6,8000c350 <__register_exitproc+0xa0>
8000c300:	00271513          	slli	a0,a4,0x2
8000c304:	00a80533          	add	a0,a6,a0
8000c308:	00c52023          	sw	a2,0(a0)
8000c30c:	10082303          	lw	t1,256(a6)
8000c310:	00100613          	li	a2,1
8000c314:	00e61633          	sll	a2,a2,a4
8000c318:	00c36333          	or	t1,t1,a2
8000c31c:	10682023          	sw	t1,256(a6)
8000c320:	08d52023          	sw	a3,128(a0)
8000c324:	00200693          	li	a3,2
8000c328:	00d89863          	bne	a7,a3,8000c338 <__register_exitproc+0x88>
8000c32c:	10482683          	lw	a3,260(a6)
8000c330:	00c6e633          	or	a2,a3,a2
8000c334:	10c82223          	sw	a2,260(a6)
8000c338:	00170693          	addi	a3,a4,1
8000c33c:	00271713          	slli	a4,a4,0x2
8000c340:	00d7a223          	sw	a3,4(a5)
8000c344:	00e787b3          	add	a5,a5,a4
8000c348:	00b7a423          	sw	a1,8(a5)
8000c34c:	00000513          	li	a0,0
8000c350:	00008067          	ret

8000c354 <__locale_ctype_ptr_l>:
8000c354:	0ec52503          	lw	a0,236(a0)
8000c358:	00008067          	ret

8000c35c <__ascii_mbtowc>:
8000c35c:	02059a63          	bnez	a1,8000c390 <__ascii_mbtowc+0x34>
8000c360:	ff010113          	addi	sp,sp,-16
8000c364:	00c10593          	addi	a1,sp,12
8000c368:	00000513          	li	a0,0
8000c36c:	00060e63          	beqz	a2,8000c388 <__ascii_mbtowc+0x2c>
8000c370:	ffe00513          	li	a0,-2
8000c374:	00068a63          	beqz	a3,8000c388 <__ascii_mbtowc+0x2c>
8000c378:	00064783          	lbu	a5,0(a2)
8000c37c:	00f5a023          	sw	a5,0(a1)
8000c380:	00064503          	lbu	a0,0(a2)
8000c384:	00a03533          	snez	a0,a0
8000c388:	01010113          	addi	sp,sp,16
8000c38c:	00008067          	ret
8000c390:	00000513          	li	a0,0
8000c394:	02060063          	beqz	a2,8000c3b4 <__ascii_mbtowc+0x58>
8000c398:	ffe00513          	li	a0,-2
8000c39c:	00068c63          	beqz	a3,8000c3b4 <__ascii_mbtowc+0x58>
8000c3a0:	00064783          	lbu	a5,0(a2)
8000c3a4:	00f5a023          	sw	a5,0(a1)
8000c3a8:	00064503          	lbu	a0,0(a2)
8000c3ac:	00a03533          	snez	a0,a0
8000c3b0:	00008067          	ret
8000c3b4:	00008067          	ret

8000c3b8 <__ascii_wctomb>:
8000c3b8:	02058463          	beqz	a1,8000c3e0 <__ascii_wctomb+0x28>
8000c3bc:	0ff00793          	li	a5,255
8000c3c0:	00c7fa63          	bgeu	a5,a2,8000c3d4 <__ascii_wctomb+0x1c>
8000c3c4:	08a00793          	li	a5,138
8000c3c8:	00f52023          	sw	a5,0(a0)
8000c3cc:	fff00513          	li	a0,-1
8000c3d0:	00008067          	ret
8000c3d4:	00c58023          	sb	a2,0(a1)
8000c3d8:	00100513          	li	a0,1
8000c3dc:	00008067          	ret
8000c3e0:	00000513          	li	a0,0
8000c3e4:	00008067          	ret

Disassembly of section .rodata:

8000c3e8 <__fsym___cmd_testapp_desc-0x6c>:
8000c3e8:	5d64255b          	0x5d64255b
8000c3ec:	6554                	flw	fa3,12(a0)
8000c3ee:	72207473          	csrrci	s0,0x722,0
8000c3f2:	5f74                	lw	a3,124(a4)
8000c3f4:	6b5f 7270 6e69      	0x6e6972706b5f
8000c3fa:	6674                	flw	fa3,76(a2)
8000c3fc:	612d                	addi	sp,sp,224
8000c3fe:	000a                	c.slli	zero,0x2
8000c400:	5d64255b          	0x5d64255b
8000c404:	6554                	flw	fa3,12(a0)
8000c406:	72207473          	csrrci	s0,0x722,0
8000c40a:	5f74                	lw	a3,124(a4)
8000c40c:	6b5f 7270 6e69      	0x6e6972706b5f
8000c412:	6674                	flw	fa3,76(a2)
8000c414:	622d                	lui	tp,0xb
8000c416:	000a                	c.slli	zero,0x2
8000c418:	5d64255b          	0x5d64255b
8000c41c:	6554                	flw	fa3,12(a0)
8000c41e:	72207473          	csrrci	s0,0x722,0
8000c422:	5f74                	lw	a3,124(a4)
8000c424:	6b5f 7270 6e69      	0x6e6972706b5f
8000c42a:	6674                	flw	fa3,76(a2)
8000c42c:	632d                	lui	t1,0xb
8000c42e:	000a                	c.slli	zero,0x2
8000c430:	6874                	flw	fa3,84(s0)
8000c432:	6572                	flw	fa0,28(sp)
8000c434:	6461                	lui	s0,0x18
8000c436:	615f 0000 0000      	0x615f
8000c43c:	6874                	flw	fa3,84(s0)
8000c43e:	6572                	flw	fa0,28(sp)
8000c440:	6461                	lui	s0,0x18
8000c442:	625f 0000 0000      	0x625f
8000c448:	6874                	flw	fa3,84(s0)
8000c44a:	6572                	flw	fa0,28(sp)
8000c44c:	6461                	lui	s0,0x18
8000c44e:	635f 0000 0000      	0x635f

8000c454 <__fsym___cmd_testapp_desc>:
8000c454:	6574                	flw	fa3,76(a0)
8000c456:	70617473          	csrrci	s0,0x706,2
8000c45a:	0070                	addi	a2,sp,12

8000c45c <__fsym___cmd_testapp_name>:
8000c45c:	5f5f 6d63 5f64      	0x5f646d635f5f
8000c462:	6574                	flw	fa3,76(a0)
8000c464:	70617473          	csrrci	s0,0x706,2
8000c468:	0070                	addi	a2,sp,12
8000c46a:	0000                	unimp
8000c46c:	6264                	flw	fs1,68(a2)
8000c46e:	65730067          	jr	1623(t1) # b657 <__HEAP_SIZE+0x9657>
8000c472:	6972                	flw	fs2,28(sp)
8000c474:	6c61                	lui	s8,0x18
8000c476:	2120                	fld	fs0,64(a0)
8000c478:	203d                	jal	8000c4a6 <__fsym___cmd_testapp_name+0x4a>
8000c47a:	5452                	lw	s0,52(sp)
8000c47c:	4e5f 4c55 004c      	0x4c4c554e5f
8000c482:	0000                	unimp
8000c484:	20676663          	bltu	a4,t1,8000c690 <__rti_rti_start_name+0x54>
8000c488:	3d21                	jal	8000c2a0 <strtol+0x18>
8000c48a:	5220                	lw	s0,96(a2)
8000c48c:	5f54                	lw	a3,60(a4)
8000c48e:	554e                	lw	a0,240(sp)
8000c490:	4c4c                	lw	a1,28(s0)
8000c492:	0000                	unimp
8000c494:	6175                	addi	sp,sp,368
8000c496:	7472                	flw	fs0,60(sp)
8000c498:	7872                	flw	fa6,60(sp)
8000c49a:	645f 6762 0000      	0x6762645f
8000c4a0:	7428                	flw	fa0,104(s0)
8000c4a2:	2068                	fld	fa0,192(s0)
8000c4a4:	203d                	jal	8000c4d2 <__fsym___cmd_testapp_name+0x76>
8000c4a6:	7472                	flw	fs0,60(sp)
8000c4a8:	745f 7268 6165      	0x61657268745f
8000c4ae:	5f64                	lw	s1,124(a4)
8000c4b0:	61657263          	bgeu	a0,s6,8000cab4 <__lowest_bit_bitmap+0xc0>
8000c4b4:	6574                	flw	fa3,76(a0)
8000c4b6:	2228                	fld	fa0,64(a2)
8000c4b8:	6175                	addi	sp,sp,368
8000c4ba:	7472                	flw	fs0,60(sp)
8000c4bc:	7872                	flw	fa6,60(sp)
8000c4be:	645f 6762 2c22      	0x2c226762645f
8000c4c4:	6175                	addi	sp,sp,368
8000c4c6:	7472                	flw	fs0,60(sp)
8000c4c8:	725f 2c78 7628      	0x76282c78725f
8000c4ce:	2064696f          	jal	s2,800526d4 <_sp+0x126d4>
8000c4d2:	292a                	fld	fs2,136(sp)
8000c4d4:	7526                	flw	fa0,104(sp)
8000c4d6:	7261                	lui	tp,0xffff8
8000c4d8:	5f74                	lw	a3,124(a4)
8000c4da:	6564                	flw	fs1,76(a0)
8000c4dc:	6976                	flw	fs2,92(sp)
8000c4de:	695b6563          	bltu	s6,s5,8000cb68 <small_digits.3193+0x60>
8000c4e2:	646e                	flw	fs0,216(sp)
8000c4e4:	7865                	lui	a6,0xffff9
8000c4e6:	2c5d                	jal	8000c79c <__FUNCTION__.3020+0x2c>
8000c4e8:	3138                	fld	fa4,96(a0)
8000c4ea:	3239                	jal	8000bdf8 <memset+0x6c>
8000c4ec:	382c                	fld	fa1,112(s0)
8000c4ee:	322c                	fld	fa1,96(a2)
8000c4f0:	2930                	fld	fa2,80(a0)
8000c4f2:	2029                	jal	8000c4fc <__fsym___cmd_testapp_name+0xa0>
8000c4f4:	3d21                	jal	8000c30c <__register_exitproc+0x5c>
8000c4f6:	5220                	lw	s0,96(a2)
8000c4f8:	5f54                	lw	a3,60(a4)
8000c4fa:	554e                	lw	a0,240(sp)
8000c4fc:	4c4c                	lw	a1,28(s0)
8000c4fe:	0000                	unimp
8000c500:	7472                	flw	fs0,60(sp)
8000c502:	745f 7268 6165      	0x61657268745f
8000c508:	5f64                	lw	s1,124(a4)
8000c50a:	72617473          	csrrci	s0,0x726,2
8000c50e:	7574                	flw	fa3,108(a0)
8000c510:	2870                	fld	fa2,208(s0)
8000c512:	6874                	flw	fa3,84(s0)
8000c514:	2029                	jal	8000c51e <__fsym___cmd_testapp_name+0xc2>
8000c516:	3d3d                	jal	8000c354 <__locale_ctype_ptr_l>
8000c518:	5220                	lw	s0,96(a2)
8000c51a:	5f54                	lw	a3,60(a4)
8000c51c:	4f45                	li	t5,17
8000c51e:	6572004b          	0x6572004b
8000c522:	746c7573          	csrrci	a0,0x746,24
8000c526:	3d20                	fld	fs0,120(a0)
8000c528:	203d                	jal	8000c556 <__FUNCTION__.3582+0xa>
8000c52a:	5452                	lw	s0,52(sp)
8000c52c:	455f 4b4f 0000      	0x4b4f455f
	...

8000c534 <__FUNCTION__.3576>:
8000c534:	796d                	lui	s2,0xffffb
8000c536:	6972                	flw	fs2,28(sp)
8000c538:	63766373          	csrrsi	t1,0x637,12
8000c53c:	5f65726f          	jal	tp,80063b32 <_sp+0x23b32>
8000c540:	666e6f63          	bltu	t3,t1,8000cbbe <small_digits.3193+0xb6>
8000c544:	6769                	lui	a4,0x1a
8000c546:	7275                	lui	tp,0xffffd
8000c548:	0065                	c.nop	25
	...

8000c54c <__FUNCTION__.3582>:
8000c54c:	796d                	lui	s2,0xffffb
8000c54e:	6972                	flw	fs2,28(sp)
8000c550:	63766373          	csrrsi	t1,0x637,12
8000c554:	5f65726f          	jal	tp,80063b4a <_sp+0x23b4a>
8000c558:	746e6f63          	bltu	t3,t1,8000ccb6 <small_digits.3193+0x1ae>
8000c55c:	6f72                	flw	ft10,28(sp)
8000c55e:	006c                	addi	a1,sp,12

8000c560 <__FUNCTION__.3590>:
8000c560:	796d                	lui	s2,0xffffb
8000c562:	6972                	flw	fs2,28(sp)
8000c564:	63766373          	csrrsi	t1,0x637,12
8000c568:	5f65726f          	jal	tp,80063b5e <_sp+0x23b5e>
8000c56c:	7570                	flw	fa2,108(a0)
8000c56e:	6374                	flw	fa3,68(a4)
8000c570:	0000                	unimp
	...

8000c574 <__FUNCTION__.3606>:
8000c574:	7472                	flw	fs0,60(sp)
8000c576:	685f 5f77 6175      	0x61755f77685f
8000c57c:	7472                	flw	fs0,60(sp)
8000c57e:	735f 6174 7472      	0x74726174735f
8000c584:	725f 5f78 6874      	0x68745f78725f
8000c58a:	6572                	flw	fa0,28(sp)
8000c58c:	6461                	lui	s0,0x18
	...

8000c590 <__FUNCTION__.3615>:
8000c590:	7472                	flw	fs0,60(sp)
8000c592:	685f 5f77 6175      	0x61755f77685f
8000c598:	7472                	flw	fs0,60(sp)
8000c59a:	695f 696e 0074      	0x74696e695f

8000c5a0 <uart_ops>:
8000c5a0:	0590                	addi	a2,sp,704
8000c5a2:	8000                	0x8000
8000c5a4:	0504                	addi	s1,sp,640
8000c5a6:	8000                	0x8000
8000c5a8:	0670                	addi	a2,sp,780
8000c5aa:	8000                	0x8000
8000c5ac:	0638                	addi	a4,sp,776
8000c5ae:	8000                	0x8000
8000c5b0:	0000                	unimp
8000c5b2:	0000                	unimp
8000c5b4:	6e69                	lui	t3,0x1a
8000c5b6:	7469                	lui	s0,0xffffa
8000c5b8:	6169                	addi	sp,sp,208
8000c5ba:	696c                	flw	fa1,84(a0)
8000c5bc:	657a                	flw	fa0,156(sp)
8000c5be:	2520                	fld	fs0,72(a0)
8000c5c0:	00000073          	ecall
8000c5c4:	253a                	fld	fa0,392(sp)
8000c5c6:	2064                	fld	fs1,192(s0)
8000c5c8:	6f64                	flw	fs1,92(a4)
8000c5ca:	656e                	flw	fa0,216(sp)
8000c5cc:	000a                	c.slli	zero,0x2
8000c5ce:	0000                	unimp
8000c5d0:	6f64                	flw	fs1,92(a4)
8000c5d2:	6320                	flw	fs0,64(a4)
8000c5d4:	6f706d6f          	jal	s10,800134ca <__fini_array_end+0x49ea>
8000c5d8:	656e                	flw	fa0,216(sp)
8000c5da:	746e                	flw	fs0,248(sp)
8000c5dc:	6e692073          	csrs	0x6e6,s2
8000c5e0:	7469                	lui	s0,0xffffa
8000c5e2:	6169                	addi	sp,sp,208
8000c5e4:	696c                	flw	fa1,84(a0)
8000c5e6:	617a                	flw	ft2,156(sp)
8000c5e8:	6974                	flw	fa3,84(a0)
8000c5ea:	0a2e6e6f          	jal	t3,800f268c <_sp+0xb268c>
8000c5ee:	0000                	unimp
8000c5f0:	616d                	addi	sp,sp,240
8000c5f2:	6e69                	lui	t3,0x1a
8000c5f4:	0000                	unimp
8000c5f6:	0000                	unimp
8000c5f8:	6974                	flw	fa3,84(a0)
8000c5fa:	2064                	fld	fs1,192(s0)
8000c5fc:	3d21                	jal	8000c414 <__ascii_wctomb+0x5c>
8000c5fe:	5220                	lw	s0,96(a2)
8000c600:	5f54                	lw	a3,60(a4)
8000c602:	554e                	lw	a0,240(sp)
8000c604:	4c4c                	lw	a1,28(s0)
	...

8000c608 <__FUNCTION__.3078>:
8000c608:	7472                	flw	fs0,60(sp)
8000c60a:	615f 7070 696c      	0x696c7070615f
8000c610:	69746163          	bltu	s0,s7,8000cc92 <small_digits.3193+0x18a>
8000c614:	695f6e6f          	jal	t3,801034a8 <_sp+0xc34a8>
8000c618:	696e                	flw	fs2,216(sp)
8000c61a:	0074                	addi	a3,sp,12

8000c61c <__rti_rti_board_end_name>:
8000c61c:	7472                	flw	fs0,60(sp)
8000c61e:	5f69                	li	t5,-6
8000c620:	6f62                	flw	ft10,24(sp)
8000c622:	7261                	lui	tp,0xffff8
8000c624:	5f64                	lw	s1,124(a4)
8000c626:	6e65                	lui	t3,0x19
8000c628:	0064                	addi	s1,sp,12
	...

8000c62c <__rti_rti_board_start_name>:
8000c62c:	7472                	flw	fs0,60(sp)
8000c62e:	5f69                	li	t5,-6
8000c630:	6f62                	flw	ft10,24(sp)
8000c632:	7261                	lui	tp,0xffff8
8000c634:	5f64                	lw	s1,124(a4)
8000c636:	72617473          	csrrci	s0,0x726,2
8000c63a:	0074                	addi	a3,sp,12

8000c63c <__rti_rti_start_name>:
8000c63c:	7472                	flw	fs0,60(sp)
8000c63e:	5f69                	li	t5,-6
8000c640:	72617473          	csrrci	s0,0x726,2
8000c644:	0074                	addi	a3,sp,12
8000c646:	0000                	unimp
8000c648:	6564                	flw	fs1,76(a0)
8000c64a:	2076                	fld	ft0,344(sp)
8000c64c:	3d21                	jal	8000c464 <__fsym___cmd_testapp_name+0x8>
8000c64e:	5220                	lw	s0,96(a2)
8000c650:	5f54                	lw	a3,60(a4)
8000c652:	554e                	lw	a0,240(sp)
8000c654:	4c4c                	lw	a1,28(s0)
8000c656:	0000                	unimp
8000c658:	7472                	flw	fs0,60(sp)
8000c65a:	6f5f 6a62 6365      	0x63656a626f5f
8000c660:	5f74                	lw	a3,124(a4)
8000c662:	5f746567          	0x5f746567
8000c666:	7974                	flw	fa3,116(a0)
8000c668:	6570                	flw	fa2,76(a0)
8000c66a:	2628                	fld	fa0,72(a2)
8000c66c:	6564                	flw	fs1,76(a0)
8000c66e:	2d76                	fld	fs10,344(sp)
8000c670:	703e                	flw	ft0,236(sp)
8000c672:	7261                	lui	tp,0xffff8
8000c674:	6e65                	lui	t3,0x19
8000c676:	2974                	fld	fa3,208(a0)
8000c678:	3d20                	fld	fs0,120(a0)
8000c67a:	203d                	jal	8000c6a8 <__rti_rti_start_name+0x6c>
8000c67c:	5452                	lw	s0,52(sp)
8000c67e:	4f5f 6a62 6365      	0x63656a624f5f
8000c684:	5f74                	lw	a3,124(a4)
8000c686:	73616c43          	fmadd.d	fs8,ft2,fs6,fa4,unknown
8000c68a:	65445f73          	csrrwi	t5,0x654,8
8000c68e:	6976                	flw	fs2,92(sp)
8000c690:	00006563          	bltu	zero,zero,8000c69a <__rti_rti_start_name+0x5e>
8000c694:	7472                	flw	fs0,60(sp)
8000c696:	6f5f 6a62 6365      	0x63656a626f5f
8000c69c:	5f74                	lw	a3,124(a4)
8000c69e:	7369                	lui	t1,0xffffa
8000c6a0:	735f 7379 6574      	0x65747379735f
8000c6a6:	6f6d                	lui	t5,0x1b
8000c6a8:	6a62                	flw	fs4,24(sp)
8000c6aa:	6365                	lui	t1,0x19
8000c6ac:	2874                	fld	fa3,208(s0)
8000c6ae:	6426                	flw	fs0,72(sp)
8000c6b0:	7665                	lui	a2,0xffff9
8000c6b2:	3e2d                	jal	8000c1ec <_strtol_l.isra.0+0x130>
8000c6b4:	6170                	flw	fa2,68(a0)
8000c6b6:	6572                	flw	fa0,28(sp)
8000c6b8:	746e                	flw	fs0,248(sp)
8000c6ba:	0029                	c.nop	10
8000c6bc:	6e69                	lui	t3,0x1a
8000c6be:	6f66                	flw	ft10,88(sp)
8000c6c0:	6d72                	flw	fs10,28(sp)
8000c6c2:	7461                	lui	s0,0xffff8
8000c6c4:	6f69                	lui	t5,0x1a
8000c6c6:	206e                	fld	ft0,216(sp)
8000c6c8:	3d21                	jal	8000c4e0 <__fsym___cmd_testapp_name+0x84>
8000c6ca:	5220                	lw	s0,96(a2)
8000c6cc:	5f54                	lw	a3,60(a4)
8000c6ce:	554e                	lw	a0,240(sp)
8000c6d0:	4c4c                	lw	a1,28(s0)
8000c6d2:	0000                	unimp
8000c6d4:	6f54                	flw	fa3,28(a4)
8000c6d6:	6920                	flw	fs0,80(a0)
8000c6d8:	696e                	flw	fs2,216(sp)
8000c6da:	6974                	flw	fa3,84(a0)
8000c6dc:	6c61                	lui	s8,0x18
8000c6de:	7a69                	lui	s4,0xffffa
8000c6e0:	2065                	jal	8000c788 <__FUNCTION__.3020+0x18>
8000c6e2:	6564                	flw	fs1,76(a0)
8000c6e4:	6976                	flw	fs2,92(sp)
8000c6e6:	253a6563          	bltu	s4,s3,8000c930 <__FUNCTION__.3096+0x6c>
8000c6ea:	61662073          	csrs	0x616,a2
8000c6ee:	6c69                	lui	s8,0x1a
8000c6f0:	6465                	lui	s0,0x19
8000c6f2:	202e                	fld	ft0,200(sp)
8000c6f4:	6854                	flw	fa3,20(s0)
8000c6f6:	2065                	jal	8000c79e <__FUNCTION__.3020+0x2e>
8000c6f8:	7265                	lui	tp,0xffff9
8000c6fa:	6f72                	flw	ft10,28(sp)
8000c6fc:	2072                	fld	ft0,280(sp)
8000c6fe:	65646f63          	bltu	s0,s6,8000cd5c <small_digits.3193+0x254>
8000c702:	6920                	flw	fs0,80(a0)
8000c704:	64252073          	csrs	0x642,a0
8000c708:	000a                	c.slli	zero,0x2
8000c70a:	0000                	unimp
8000c70c:	6564                	flw	fs1,76(a0)
8000c70e:	2d76                	fld	fs10,344(sp)
8000c710:	723e                	flw	ft4,236(sp)
8000c712:	6665                	lui	a2,0x19
8000c714:	635f 756f 746e      	0x746e756f635f
8000c71a:	2120                	fld	fs0,64(a0)
8000c71c:	203d                	jal	8000c74a <__FUNCTION__.2993+0xa>
8000c71e:	0030                	addi	a2,sp,8

8000c720 <__FUNCTION__.2964>:
8000c720:	7472                	flw	fs0,60(sp)
8000c722:	645f 7665 6369      	0x63697665645f
8000c728:	5f65                	li	t5,-7
8000c72a:	6966                	flw	fs2,88(sp)
8000c72c:	646e                	flw	fs0,216(sp)
	...

8000c730 <__FUNCTION__.2988>:
8000c730:	7472                	flw	fs0,60(sp)
8000c732:	645f 7665 6369      	0x63697665645f
8000c738:	5f65                	li	t5,-7
8000c73a:	6e65706f          	j	80063e20 <_sp+0x23e20>
	...

8000c740 <__FUNCTION__.2993>:
8000c740:	7472                	flw	fs0,60(sp)
8000c742:	645f 7665 6369      	0x63697665645f
8000c748:	5f65                	li	t5,-7
8000c74a:	736f6c63          	bltu	t5,s6,8000ce82 <__FUNCTION__.3113+0x6>
8000c74e:	0065                	c.nop	25

8000c750 <__FUNCTION__.3000>:
8000c750:	7472                	flw	fs0,60(sp)
8000c752:	645f 7665 6369      	0x63697665645f
8000c758:	5f65                	li	t5,-7
8000c75a:	6572                	flw	fa0,28(sp)
8000c75c:	6461                	lui	s0,0x18
	...

8000c760 <__FUNCTION__.3007>:
8000c760:	7472                	flw	fs0,60(sp)
8000c762:	645f 7665 6369      	0x63697665645f
8000c768:	5f65                	li	t5,-7
8000c76a:	74697277          	0x74697277
8000c76e:	0065                	c.nop	25

8000c770 <__FUNCTION__.3020>:
8000c770:	7472                	flw	fs0,60(sp)
8000c772:	645f 7665 6369      	0x63697665645f
8000c778:	5f65                	li	t5,-7
8000c77a:	5f746573          	csrrsi	a0,0x5f7,8
8000c77e:	7872                	flw	fa6,60(sp)
8000c780:	695f 646e 6369      	0x6369646e695f
8000c786:	7461                	lui	s0,0xffff8
8000c788:	0065                	c.nop	25
8000c78a:	0000                	unimp
8000c78c:	7546                	flw	fa0,112(sp)
8000c78e:	636e                	flw	ft6,216(sp)
8000c790:	6974                	flw	fa3,84(a0)
8000c792:	255b6e6f          	jal	t3,800c31e6 <_sp+0x831e6>
8000c796:	73205d73          	csrrwi	s10,0x732,0
8000c79a:	6168                	flw	fa0,68(a0)
8000c79c:	6c6c                	flw	fa1,92(s0)
8000c79e:	6e20                	flw	fs0,88(a2)
8000c7a0:	6220746f          	jal	s0,80013dc2 <__fini_array_end+0x52e2>
8000c7a4:	2065                	jal	8000c84c <__FUNCTION__.3055+0x8c>
8000c7a6:	7375                	lui	t1,0xffffd
8000c7a8:	6465                	lui	s0,0x19
8000c7aa:	6920                	flw	fs0,80(a0)
8000c7ac:	206e                	fld	ft0,216(sp)
8000c7ae:	5349                	li	t1,-14
8000c7b0:	0a52                	slli	s4,s4,0x14
8000c7b2:	0000                	unimp
8000c7b4:	0030                	addi	a2,sp,8
8000c7b6:	0000                	unimp
8000c7b8:	6974                	flw	fa3,84(a0)
8000c7ba:	6c64                	flw	fs1,92(s0)
8000c7bc:	2565                	jal	8000ce64 <__fsym_list_mem_name+0x54>
8000c7be:	0064                	addi	s1,sp,12

8000c7c0 <__FUNCTION__.3055>:
8000c7c0:	7472                	flw	fs0,60(sp)
8000c7c2:	745f 7268 6165      	0x61657268745f
8000c7c8:	5f64                	lw	s1,124(a4)
8000c7ca:	6469                	lui	s0,0x1a
8000c7cc:	656c                	flw	fa1,76(a0)
8000c7ce:	655f 6378 7475      	0x74756378655f
8000c7d4:	0065                	c.nop	25
8000c7d6:	0000                	unimp
8000c7d8:	206d6573          	csrrsi	a0,0x206,26
8000c7dc:	3d21                	jal	8000c5f4 <uart_ops+0x54>
8000c7de:	5220                	lw	s0,96(a2)
8000c7e0:	5f54                	lw	a3,60(a4)
8000c7e2:	554e                	lw	a0,240(sp)
8000c7e4:	4c4c                	lw	a1,28(s0)
8000c7e6:	0000                	unimp
8000c7e8:	6176                	flw	ft2,92(sp)
8000c7ea:	756c                	flw	fa1,108(a0)
8000c7ec:	2065                	jal	8000c894 <__FUNCTION__.3055+0xd4>
8000c7ee:	203c                	fld	fa5,64(s0)
8000c7f0:	7830                	flw	fa2,112(s0)
8000c7f2:	3031                	jal	8000bffe <strcmp+0x16a>
8000c7f4:	3030                	fld	fa2,96(s0)
8000c7f6:	5530                	lw	a2,104(a0)
8000c7f8:	0000                	unimp
8000c7fa:	0000                	unimp
8000c7fc:	7472                	flw	fs0,60(sp)
8000c7fe:	6f5f 6a62 6365      	0x63656a626f5f
8000c804:	5f74                	lw	a3,124(a4)
8000c806:	5f746567          	0x5f746567
8000c80a:	7974                	flw	fa3,116(a0)
8000c80c:	6570                	flw	fa2,76(a0)
8000c80e:	2628                	fld	fa0,72(a2)
8000c810:	2d6d6573          	csrrsi	a0,0x2d6,26
8000c814:	703e                	flw	ft0,236(sp)
8000c816:	7261                	lui	tp,0xffff8
8000c818:	6e65                	lui	t3,0x19
8000c81a:	2e74                	fld	fa3,216(a2)
8000c81c:	6170                	flw	fa2,68(a0)
8000c81e:	6572                	flw	fa0,28(sp)
8000c820:	746e                	flw	fs0,248(sp)
8000c822:	2029                	jal	8000c82c <__FUNCTION__.3055+0x6c>
8000c824:	3d3d                	jal	8000c662 <__rti_rti_start_name+0x26>
8000c826:	5220                	lw	s0,96(a2)
8000c828:	5f54                	lw	a3,60(a4)
8000c82a:	656a624f          	0x656a624f
8000c82e:	435f7463          	bgeu	t5,s5,8000cc56 <small_digits.3193+0x14e>
8000c832:	616c                	flw	fa1,68(a0)
8000c834:	535f7373          	csrrci	t1,0x535,30
8000c838:	6d65                	lui	s10,0x19
8000c83a:	7061                	c.lui	zero,0xffff8
8000c83c:	6f68                	flw	fa0,92(a4)
8000c83e:	6572                	flw	fa0,28(sp)
8000c840:	0000                	unimp
8000c842:	0000                	unimp
8000c844:	7472                	flw	fs0,60(sp)
8000c846:	6f5f 6a62 6365      	0x63656a626f5f
8000c84c:	5f74                	lw	a3,124(a4)
8000c84e:	7369                	lui	t1,0xffffa
8000c850:	735f 7379 6574      	0x65747379735f
8000c856:	6f6d                	lui	t5,0x1b
8000c858:	6a62                	flw	fs4,24(sp)
8000c85a:	6365                	lui	t1,0x19
8000c85c:	2874                	fld	fa3,208(s0)
8000c85e:	7326                	flw	ft6,104(sp)
8000c860:	6d65                	lui	s10,0x19
8000c862:	3e2d                	jal	8000c39c <__ascii_mbtowc+0x40>
8000c864:	6170                	flw	fa2,68(a0)
8000c866:	6572                	flw	fa0,28(sp)
8000c868:	746e                	flw	fs0,248(sp)
8000c86a:	702e                	flw	ft0,232(sp)
8000c86c:	7261                	lui	tp,0xffff8
8000c86e:	6e65                	lui	t3,0x19
8000c870:	2974                	fld	fa3,208(a0)
8000c872:	0000                	unimp
8000c874:	7546                	flw	fa0,112(sp)
8000c876:	636e                	flw	ft6,216(sp)
8000c878:	6974                	flw	fa3,84(a0)
8000c87a:	255b6e6f          	jal	t3,800c32ce <_sp+0x832ce>
8000c87e:	73205d73          	csrrwi	s10,0x732,0
8000c882:	6168                	flw	fa0,68(a0)
8000c884:	6c6c                	flw	fa1,92(s0)
8000c886:	6e20                	flw	fs0,88(a2)
8000c888:	6220746f          	jal	s0,80013eaa <__fini_array_end+0x53ca>
8000c88c:	2065                	jal	8000c934 <__FUNCTION__.3096+0x70>
8000c88e:	7375                	lui	t1,0xffffd
8000c890:	6465                	lui	s0,0x19
8000c892:	6220                	flw	fs0,64(a2)
8000c894:	6665                	lui	a2,0x19
8000c896:	2065726f          	jal	tp,80063a9c <_sp+0x23a9c>
8000c89a:	65686373          	csrrsi	t1,0x656,16
8000c89e:	7564                	flw	fs1,108(a0)
8000c8a0:	656c                	flw	fa1,76(a0)
8000c8a2:	2072                	fld	ft0,280(sp)
8000c8a4:	72617473          	csrrci	s0,0x726,2
8000c8a8:	0a74                	addi	a3,sp,284
	...

8000c8ac <__FUNCTION__.3061>:
8000c8ac:	7472                	flw	fs0,60(sp)
8000c8ae:	735f 6d65 695f      	0x695f6d65735f
8000c8b4:	696e                	flw	fs2,216(sp)
8000c8b6:	0074                	addi	a3,sp,12

8000c8b8 <__FUNCTION__.3085>:
8000c8b8:	7472                	flw	fs0,60(sp)
8000c8ba:	735f 6d65 745f      	0x745f6d65735f
8000c8c0:	6b61                	lui	s6,0x18
8000c8c2:	0065                	c.nop	25

8000c8c4 <__FUNCTION__.3096>:
8000c8c4:	7472                	flw	fs0,60(sp)
8000c8c6:	735f 6d65 725f      	0x725f6d65735f
8000c8cc:	6c65                	lui	s8,0x19
8000c8ce:	6165                	addi	sp,sp,112
8000c8d0:	00006573          	csrrsi	a0,ustatus,0
8000c8d4:	4e28                	lw	a0,88(a2)
8000c8d6:	4c55                	li	s8,21
8000c8d8:	294c                	fld	fa1,144(a0)
8000c8da:	0000                	unimp
8000c8dc:	5494                	lw	a3,40(s1)
8000c8de:	ffff                	0xffff
8000c8e0:	56a4                	lw	s1,104(a3)
8000c8e2:	ffff                	0xffff
8000c8e4:	5414                	lw	a3,40(s0)
8000c8e6:	ffff                	0xffff
8000c8e8:	5414                	lw	a3,40(s0)
8000c8ea:	ffff                	0xffff
8000c8ec:	5414                	lw	a3,40(s0)
8000c8ee:	ffff                	0xffff
8000c8f0:	5414                	lw	a3,40(s0)
8000c8f2:	ffff                	0xffff
8000c8f4:	56a4                	lw	s1,104(a3)
8000c8f6:	ffff                	0xffff
8000c8f8:	5414                	lw	a3,40(s0)
8000c8fa:	ffff                	0xffff
8000c8fc:	5414                	lw	a3,40(s0)
8000c8fe:	ffff                	0xffff
8000c900:	5414                	lw	a3,40(s0)
8000c902:	ffff                	0xffff
8000c904:	5414                	lw	a3,40(s0)
8000c906:	ffff                	0xffff
8000c908:	5414                	lw	a3,40(s0)
8000c90a:	ffff                	0xffff
8000c90c:	56b8                	lw	a4,104(a3)
8000c90e:	ffff                	0xffff
8000c910:	5638                	lw	a4,104(a2)
8000c912:	ffff                	0xffff
8000c914:	5414                	lw	a3,40(s0)
8000c916:	ffff                	0xffff
8000c918:	5414                	lw	a3,40(s0)
8000c91a:	ffff                	0xffff
8000c91c:	5534                	lw	a3,104(a0)
8000c91e:	ffff                	0xffff
8000c920:	5414                	lw	a3,40(s0)
8000c922:	ffff                	0xffff
8000c924:	56a8                	lw	a0,104(a3)
8000c926:	ffff                	0xffff
8000c928:	5414                	lw	a3,40(s0)
8000c92a:	ffff                	0xffff
8000c92c:	5414                	lw	a3,40(s0)
8000c92e:	ffff                	0xffff
8000c930:	5668                	lw	a0,108(a2)
8000c932:	ffff                	0xffff
8000c934:	200a                	fld	ft0,128(sp)
8000c936:	205c                	fld	fa5,128(s0)
8000c938:	207c                	fld	fa5,192(s0)
8000c93a:	00000a2f          	0xa2f
8000c93e:	0000                	unimp
8000c940:	202d                	jal	8000c96a <__FUNCTION__.3096+0xa6>
8000c942:	5452                	lw	s0,52(sp)
8000c944:	2d20                	fld	fs0,88(a0)
8000c946:	2020                	fld	fs0,64(s0)
8000c948:	2020                	fld	fs0,64(s0)
8000c94a:	5420                	lw	s0,104(s0)
8000c94c:	7268                	flw	fa0,100(a2)
8000c94e:	6165                	addi	sp,sp,112
8000c950:	2064                	fld	fs1,192(s0)
8000c952:	7265704f          	fnmadd.d	ft0,fa0,ft6,fa4
8000c956:	7461                	lui	s0,0xffff8
8000c958:	6e69                	lui	t3,0x1a
8000c95a:	79532067          	0x79532067
8000c95e:	6d657473          	csrrci	s0,0x6d6,10
8000c962:	000a                	c.slli	zero,0x2
8000c964:	614d                	addi	sp,sp,176
8000c966:	2072                	fld	ft0,280(sp)
8000c968:	3431                	jal	8000c374 <__ascii_mbtowc+0x18>
8000c96a:	3220                	fld	fs0,96(a2)
8000c96c:	3230                	fld	fa2,96(a2)
8000c96e:	0032                	c.slli	zero,0xc
8000c970:	2f20                	fld	fs0,88(a4)
8000c972:	7c20                	flw	fs0,120(s0)
8000c974:	5c20                	lw	s0,120(s0)
8000c976:	2020                	fld	fs0,64(s0)
8000c978:	2020                	fld	fs0,64(s0)
8000c97a:	2520                	fld	fs0,72(a0)
8000c97c:	2e64                	fld	fs1,216(a2)
8000c97e:	6425                	lui	s0,0x9
8000c980:	252e                	fld	fa0,200(sp)
8000c982:	2064                	fld	fs1,192(s0)
8000c984:	7562                	flw	fa0,56(sp)
8000c986:	6c69                	lui	s8,0x1a
8000c988:	2064                	fld	fs1,192(s0)
8000c98a:	7325                	lui	t1,0xfffe9
8000c98c:	000a                	c.slli	zero,0x2
8000c98e:	0000                	unimp
8000c990:	3220                	fld	fs0,96(a2)
8000c992:	3030                	fld	fa2,96(s0)
8000c994:	2036                	fld	ft0,328(sp)
8000c996:	202d                	jal	8000c9c0 <__FUNCTION__.3096+0xfc>
8000c998:	3032                	fld	ft0,296(sp)
8000c99a:	3032                	fld	ft0,296(sp)
8000c99c:	4320                	lw	s0,64(a4)
8000c99e:	7279706f          	j	800a48c4 <_sp+0x648c4>
8000c9a2:	6769                	lui	a4,0x1a
8000c9a4:	7468                	flw	fa0,108(s0)
8000c9a6:	6220                	flw	fs0,64(a2)
8000c9a8:	2079                	jal	8000ca36 <__lowest_bit_bitmap+0x42>
8000c9aa:	7472                	flw	fs0,60(sp)
8000c9ac:	742d                	lui	s0,0xfffeb
8000c9ae:	7268                	flw	fa0,100(a2)
8000c9b0:	6165                	addi	sp,sp,112
8000c9b2:	2064                	fld	fs1,192(s0)
8000c9b4:	6574                	flw	fa3,76(a0)
8000c9b6:	6d61                	lui	s10,0x18
8000c9b8:	000a                	c.slli	zero,0x2
8000c9ba:	0000                	unimp
8000c9bc:	2528                	fld	fa0,72(a0)
8000c9be:	61202973          	csrr	s2,0x612
8000c9c2:	72657373          	csrrci	t1,0x726,10
8000c9c6:	6974                	flw	fa3,84(a0)
8000c9c8:	66206e6f          	jal	t3,8001302a <__fini_array_end+0x454a>
8000c9cc:	6961                	lui	s2,0x18
8000c9ce:	656c                	flw	fa1,76(a0)
8000c9d0:	2064                	fld	fs1,192(s0)
8000c9d2:	7461                	lui	s0,0xffff8
8000c9d4:	6620                	flw	fs0,72(a2)
8000c9d6:	6e75                	lui	t3,0x1d
8000c9d8:	6f697463          	bgeu	s2,s6,8000d0c0 <__FUNCTION__.3076+0x8>
8000c9dc:	3a6e                	fld	fs4,248(sp)
8000c9de:	7325                	lui	t1,0xfffe9
8000c9e0:	202c                	fld	fa1,64(s0)
8000c9e2:	696c                	flw	fa1,84(a0)
8000c9e4:	656e                	flw	fa0,216(sp)
8000c9e6:	6e20                	flw	fs0,88(a2)
8000c9e8:	6d75                	lui	s10,0x1d
8000c9ea:	6562                	flw	fa0,24(sp)
8000c9ec:	3a72                	fld	fs4,312(sp)
8000c9ee:	6425                	lui	s0,0x9
8000c9f0:	0a20                	addi	s0,sp,280
	...

8000c9f4 <__lowest_bit_bitmap>:
8000c9f4:	0000                	unimp
8000c9f6:	0001                	nop
8000c9f8:	0002                	c.slli64	zero
8000c9fa:	0001                	nop
8000c9fc:	00010003          	lb	zero,0(sp)
8000ca00:	0002                	c.slli64	zero
8000ca02:	0001                	nop
8000ca04:	0004                	0x4
8000ca06:	0001                	nop
8000ca08:	0002                	c.slli64	zero
8000ca0a:	0001                	nop
8000ca0c:	00010003          	lb	zero,0(sp)
8000ca10:	0002                	c.slli64	zero
8000ca12:	0001                	nop
8000ca14:	0005                	c.nop	1
8000ca16:	0001                	nop
8000ca18:	0002                	c.slli64	zero
8000ca1a:	0001                	nop
8000ca1c:	00010003          	lb	zero,0(sp)
8000ca20:	0002                	c.slli64	zero
8000ca22:	0001                	nop
8000ca24:	0004                	0x4
8000ca26:	0001                	nop
8000ca28:	0002                	c.slli64	zero
8000ca2a:	0001                	nop
8000ca2c:	00010003          	lb	zero,0(sp)
8000ca30:	0002                	c.slli64	zero
8000ca32:	0001                	nop
8000ca34:	0006                	c.slli	zero,0x1
8000ca36:	0001                	nop
8000ca38:	0002                	c.slli64	zero
8000ca3a:	0001                	nop
8000ca3c:	00010003          	lb	zero,0(sp)
8000ca40:	0002                	c.slli64	zero
8000ca42:	0001                	nop
8000ca44:	0004                	0x4
8000ca46:	0001                	nop
8000ca48:	0002                	c.slli64	zero
8000ca4a:	0001                	nop
8000ca4c:	00010003          	lb	zero,0(sp)
8000ca50:	0002                	c.slli64	zero
8000ca52:	0001                	nop
8000ca54:	0005                	c.nop	1
8000ca56:	0001                	nop
8000ca58:	0002                	c.slli64	zero
8000ca5a:	0001                	nop
8000ca5c:	00010003          	lb	zero,0(sp)
8000ca60:	0002                	c.slli64	zero
8000ca62:	0001                	nop
8000ca64:	0004                	0x4
8000ca66:	0001                	nop
8000ca68:	0002                	c.slli64	zero
8000ca6a:	0001                	nop
8000ca6c:	00010003          	lb	zero,0(sp)
8000ca70:	0002                	c.slli64	zero
8000ca72:	0001                	nop
8000ca74:	00010007          	0x10007
8000ca78:	0002                	c.slli64	zero
8000ca7a:	0001                	nop
8000ca7c:	00010003          	lb	zero,0(sp)
8000ca80:	0002                	c.slli64	zero
8000ca82:	0001                	nop
8000ca84:	0004                	0x4
8000ca86:	0001                	nop
8000ca88:	0002                	c.slli64	zero
8000ca8a:	0001                	nop
8000ca8c:	00010003          	lb	zero,0(sp)
8000ca90:	0002                	c.slli64	zero
8000ca92:	0001                	nop
8000ca94:	0005                	c.nop	1
8000ca96:	0001                	nop
8000ca98:	0002                	c.slli64	zero
8000ca9a:	0001                	nop
8000ca9c:	00010003          	lb	zero,0(sp)
8000caa0:	0002                	c.slli64	zero
8000caa2:	0001                	nop
8000caa4:	0004                	0x4
8000caa6:	0001                	nop
8000caa8:	0002                	c.slli64	zero
8000caaa:	0001                	nop
8000caac:	00010003          	lb	zero,0(sp)
8000cab0:	0002                	c.slli64	zero
8000cab2:	0001                	nop
8000cab4:	0006                	c.slli	zero,0x1
8000cab6:	0001                	nop
8000cab8:	0002                	c.slli64	zero
8000caba:	0001                	nop
8000cabc:	00010003          	lb	zero,0(sp)
8000cac0:	0002                	c.slli64	zero
8000cac2:	0001                	nop
8000cac4:	0004                	0x4
8000cac6:	0001                	nop
8000cac8:	0002                	c.slli64	zero
8000caca:	0001                	nop
8000cacc:	00010003          	lb	zero,0(sp)
8000cad0:	0002                	c.slli64	zero
8000cad2:	0001                	nop
8000cad4:	0005                	c.nop	1
8000cad6:	0001                	nop
8000cad8:	0002                	c.slli64	zero
8000cada:	0001                	nop
8000cadc:	00010003          	lb	zero,0(sp)
8000cae0:	0002                	c.slli64	zero
8000cae2:	0001                	nop
8000cae4:	0004                	0x4
8000cae6:	0001                	nop
8000cae8:	0002                	c.slli64	zero
8000caea:	0001                	nop
8000caec:	00010003          	lb	zero,0(sp)
8000caf0:	0002                	c.slli64	zero
8000caf2:	0001                	nop

8000caf4 <large_digits.3194>:
8000caf4:	3130                	fld	fa2,96(a0)
8000caf6:	3332                	fld	ft6,296(sp)
8000caf8:	3534                	fld	fa3,104(a0)
8000cafa:	3736                	fld	fa4,360(sp)
8000cafc:	3938                	fld	fa4,112(a0)
8000cafe:	4241                	li	tp,16
8000cb00:	46454443          	fmadd.q	fs0,fa0,ft4,fs0,rmm
8000cb04:	0000                	unimp
	...

8000cb08 <small_digits.3193>:
8000cb08:	3130                	fld	fa2,96(a0)
8000cb0a:	3332                	fld	ft6,296(sp)
8000cb0c:	3534                	fld	fa3,104(a0)
8000cb0e:	3736                	fld	fa4,360(sp)
8000cb10:	3938                	fld	fa4,112(a0)
8000cb12:	6261                	lui	tp,0x18
8000cb14:	66656463          	bltu	a0,t1,8000d17c <__FUNCTION__.3150+0x78>
8000cb18:	0000                	unimp
8000cb1a:	0000                	unimp
8000cb1c:	6f74                	flw	fa3,92(a4)
8000cb1e:	6174                	flw	fa3,68(a0)
8000cb20:	206c                	fld	fa1,192(s0)
8000cb22:	656d                	lui	a0,0x1b
8000cb24:	6f6d                	lui	t5,0x1b
8000cb26:	7972                	flw	fs2,60(sp)
8000cb28:	203a                	fld	ft0,392(sp)
8000cb2a:	6425                	lui	s0,0x9
8000cb2c:	000a                	c.slli	zero,0x2
8000cb2e:	0000                	unimp
8000cb30:	7375                	lui	t1,0xffffd
8000cb32:	6465                	lui	s0,0x19
8000cb34:	6d20                	flw	fs0,88(a0)
8000cb36:	6d65                	lui	s10,0x19
8000cb38:	2079726f          	jal	tp,800a453e <_sp+0x6453e>
8000cb3c:	203a                	fld	ft0,392(sp)
8000cb3e:	6425                	lui	s0,0x9
8000cb40:	000a                	c.slli	zero,0x2
8000cb42:	0000                	unimp
8000cb44:	616d                	addi	sp,sp,240
8000cb46:	6978                	flw	fa4,84(a0)
8000cb48:	756d                	lui	a0,0xffffb
8000cb4a:	206d                	jal	8000cbf4 <small_digits.3193+0xec>
8000cb4c:	6c61                	lui	s8,0x18
8000cb4e:	6f6c                	flw	fa1,92(a4)
8000cb50:	65746163          	bltu	s0,s7,8000d192 <__FUNCTION__.3150+0x8e>
8000cb54:	2064                	fld	fs1,192(s0)
8000cb56:	656d                	lui	a0,0x1b
8000cb58:	6f6d                	lui	t5,0x1b
8000cb5a:	7972                	flw	fs2,60(sp)
8000cb5c:	203a                	fld	ft0,392(sp)
8000cb5e:	6425                	lui	s0,0x9
8000cb60:	000a                	c.slli	zero,0x2
8000cb62:	0000                	unimp
8000cb64:	7228                	flw	fa0,96(a2)
8000cb66:	5f74                	lw	a3,124(a4)
8000cb68:	6975                	lui	s2,0x1d
8000cb6a:	746e                	flw	fs0,248(sp)
8000cb6c:	5f38                	lw	a4,120(a4)
8000cb6e:	2074                	fld	fa3,192(s0)
8000cb70:	292a                	fld	fs2,136(sp)
8000cb72:	656d                	lui	a0,0x1b
8000cb74:	206d                	jal	8000cc1e <small_digits.3193+0x116>
8000cb76:	3d3e                	fld	fs10,488(sp)
8000cb78:	6820                	flw	fs0,80(s0)
8000cb7a:	6165                	addi	sp,sp,112
8000cb7c:	5f70                	lw	a2,124(a4)
8000cb7e:	7470                	flw	fa2,108(s0)
8000cb80:	0072                	c.slli	zero,0x1c
8000cb82:	0000                	unimp
8000cb84:	7228                	flw	fa0,96(a2)
8000cb86:	5f74                	lw	a3,124(a4)
8000cb88:	6975                	lui	s2,0x1d
8000cb8a:	746e                	flw	fs0,248(sp)
8000cb8c:	5f38                	lw	a4,120(a4)
8000cb8e:	2074                	fld	fa3,192(s0)
8000cb90:	292a                	fld	fs2,136(sp)
8000cb92:	656d                	lui	a0,0x1b
8000cb94:	206d                	jal	8000cc3e <small_digits.3193+0x136>
8000cb96:	203c                	fld	fa5,64(s0)
8000cb98:	7228                	flw	fa0,96(a2)
8000cb9a:	5f74                	lw	a3,124(a4)
8000cb9c:	6975                	lui	s2,0x1d
8000cb9e:	746e                	flw	fs0,248(sp)
8000cba0:	5f38                	lw	a4,120(a4)
8000cba2:	2074                	fld	fa3,192(s0)
8000cba4:	292a                	fld	fs2,136(sp)
8000cba6:	6568                	flw	fa0,76(a0)
8000cba8:	7061                	c.lui	zero,0xffff8
8000cbaa:	655f 646e 0000      	0x646e655f
8000cbb0:	656d                	lui	a0,0x1b
8000cbb2:	2d6d                	jal	8000d26c <__FUNCTION__.3128+0x58>
8000cbb4:	753e                	flw	fa0,236(sp)
8000cbb6:	20646573          	csrrsi	a0,0x206,8
8000cbba:	3d3d                	jal	8000c9f8 <__lowest_bit_bitmap+0x4>
8000cbbc:	3020                	fld	fs0,96(s0)
8000cbbe:	0000                	unimp
8000cbc0:	6568                	flw	fa0,76(a0)
8000cbc2:	7061                	c.lui	zero,0xffff8
8000cbc4:	0000                	unimp
8000cbc6:	0000                	unimp
8000cbc8:	656d                	lui	a0,0x1b
8000cbca:	206d                	jal	8000cc74 <small_digits.3193+0x16c>
8000cbcc:	6e69                	lui	t3,0x1a
8000cbce:	7469                	lui	s0,0xffffa
8000cbd0:	202c                	fld	fa1,64(s0)
8000cbd2:	7265                	lui	tp,0xffff9
8000cbd4:	6f72                	flw	ft10,28(sp)
8000cbd6:	2072                	fld	ft0,280(sp)
8000cbd8:	6562                	flw	fa0,24(sp)
8000cbda:	206e6967          	0x206e6967
8000cbde:	6461                	lui	s0,0x18
8000cbe0:	7264                	flw	fs1,100(a2)
8000cbe2:	7365                	lui	t1,0xffff9
8000cbe4:	78302073          	csrr	zero,0x783
8000cbe8:	7825                	lui	a6,0xfffe9
8000cbea:	202c                	fld	fa1,64(s0)
8000cbec:	6e61                	lui	t3,0x18
8000cbee:	2064                	fld	fs1,192(s0)
8000cbf0:	6e65                	lui	t3,0x19
8000cbf2:	2064                	fld	fs1,192(s0)
8000cbf4:	6461                	lui	s0,0x18
8000cbf6:	7264                	flw	fs1,100(a2)
8000cbf8:	7365                	lui	t1,0xffff9
8000cbfa:	78302073          	csrr	zero,0x783
8000cbfe:	7825                	lui	a6,0xfffe9
8000cc00:	000a                	c.slli	zero,0x2
8000cc02:	0000                	unimp
8000cc04:	7228                	flw	fa0,96(a2)
8000cc06:	5f74                	lw	a3,124(a4)
8000cc08:	6275                	lui	tp,0x1d
8000cc0a:	7361                	lui	t1,0xffff8
8000cc0c:	5f65                	li	t5,-7
8000cc0e:	2974                	fld	fa3,208(a0)
8000cc10:	656d                	lui	a0,0x1b
8000cc12:	206d                	jal	8000ccbc <small_digits.3193+0x1b4>
8000cc14:	4953202b          	0x4953202b
8000cc18:	455a                	lw	a0,148(sp)
8000cc1a:	535f464f          	fnmadd.d	fa2,ft10,fs5,fa0,rmm
8000cc1e:	5254                	lw	a3,36(a2)
8000cc20:	4355                	li	t1,21
8000cc22:	5f54                	lw	a3,60(a4)
8000cc24:	454d                	li	a0,19
8000cc26:	204d                	jal	8000ccc8 <small_digits.3193+0x1c0>
8000cc28:	6973202b          	0x6973202b
8000cc2c:	657a                	flw	fa0,156(sp)
8000cc2e:	3c20                	fld	fs0,120(s0)
8000cc30:	203d                	jal	8000cc5e <small_digits.3193+0x156>
8000cc32:	7228                	flw	fa0,96(a2)
8000cc34:	5f74                	lw	a3,124(a4)
8000cc36:	6275                	lui	tp,0x1d
8000cc38:	7361                	lui	t1,0xffff8
8000cc3a:	5f65                	li	t5,-7
8000cc3c:	2974                	fld	fa3,208(a0)
8000cc3e:	6568                	flw	fa0,76(a0)
8000cc40:	7061                	c.lui	zero,0xffff8
8000cc42:	655f 646e 0000      	0x646e655f
8000cc48:	7228                	flw	fa0,96(a2)
8000cc4a:	5f74                	lw	a3,124(a4)
8000cc4c:	6275                	lui	tp,0x1d
8000cc4e:	7361                	lui	t1,0xffff8
8000cc50:	5f65                	li	t5,-7
8000cc52:	2974                	fld	fa3,208(a0)
8000cc54:	2828                	fld	fa0,80(s0)
8000cc56:	7472                	flw	fs0,60(sp)
8000cc58:	755f 6e69 3874      	0x38746e69755f
8000cc5e:	745f 2a20 6d29      	0x6d292a20745f
8000cc64:	6d65                	lui	s10,0x19
8000cc66:	2b20                	fld	fs0,80(a4)
8000cc68:	5320                	lw	s0,96(a4)
8000cc6a:	5a49                	li	s4,-14
8000cc6c:	4f45                	li	t5,17
8000cc6e:	5f46                	lw	t5,112(sp)
8000cc70:	55525453          	0x55525453
8000cc74:	4d5f5443          	0x4d5f5443
8000cc78:	4d45                	li	s10,17
8000cc7a:	2029                	jal	8000cc84 <small_digits.3193+0x17c>
8000cc7c:	2025                	jal	8000cca4 <small_digits.3193+0x19c>
8000cc7e:	5452                	lw	s0,52(sp)
8000cc80:	415f 494c 4e47      	0x4e47494c415f
8000cc86:	535f 5a49 2045      	0x20455a49535f
8000cc8c:	3d3d                	jal	8000caca <__lowest_bit_bitmap+0xd6>
8000cc8e:	3020                	fld	fs0,96(s0)
8000cc90:	0000                	unimp
8000cc92:	0000                	unimp
8000cc94:	2828                	fld	fa0,80(s0)
8000cc96:	7228                	flw	fa0,96(a2)
8000cc98:	5f74                	lw	a3,124(a4)
8000cc9a:	6275                	lui	tp,0x1d
8000cc9c:	7361                	lui	t1,0xffff8
8000cc9e:	5f65                	li	t5,-7
8000cca0:	2974                	fld	fa3,208(a0)
8000cca2:	656d                	lui	a0,0x1b
8000cca4:	296d                	jal	8000d15e <__FUNCTION__.3150+0x5a>
8000cca6:	2620                	fld	fs0,72(a2)
8000cca8:	2820                	fld	fs0,80(s0)
8000ccaa:	5452                	lw	s0,52(sp)
8000ccac:	415f 494c 4e47      	0x4e47494c415f
8000ccb2:	535f 5a49 2045      	0x20455a49535f
8000ccb8:	202d                	jal	8000cce2 <small_digits.3193+0x1da>
8000ccba:	2931                	jal	8000d0d6 <__FUNCTION__.3108+0xa>
8000ccbc:	2029                	jal	8000ccc6 <small_digits.3193+0x1be>
8000ccbe:	3d3d                	jal	8000cafc <large_digits.3194+0x8>
8000ccc0:	3020                	fld	fs0,96(s0)
8000ccc2:	0000                	unimp
8000ccc4:	2828                	fld	fa0,80(s0)
8000ccc6:	7228                	flw	fa0,96(a2)
8000ccc8:	5f74                	lw	a3,124(a4)
8000ccca:	6275                	lui	tp,0x1d
8000cccc:	7361                	lui	t1,0xffff8
8000ccce:	5f65                	li	t5,-7
8000ccd0:	2974                	fld	fa3,208(a0)
8000ccd2:	6d72                	flw	fs10,28(sp)
8000ccd4:	6d65                	lui	s10,0x19
8000ccd6:	2029                	jal	8000cce0 <small_digits.3193+0x1d8>
8000ccd8:	2026                	fld	ft0,72(sp)
8000ccda:	5228                	lw	a0,96(a2)
8000ccdc:	5f54                	lw	a3,60(a4)
8000ccde:	4c41                	li	s8,16
8000cce0:	4749                	li	a4,18
8000cce2:	5f4e                	lw	t5,240(sp)
8000cce4:	455a4953          	0x455a4953
8000cce8:	2d20                	fld	fs0,88(a0)
8000ccea:	3120                	fld	fs0,96(a0)
8000ccec:	2929                	jal	8000d106 <__FUNCTION__.3150+0x2>
8000ccee:	3d20                	fld	fs0,120(a0)
8000ccf0:	203d                	jal	8000cd1e <small_digits.3193+0x216>
8000ccf2:	0030                	addi	a2,sp,8
8000ccf4:	7228                	flw	fa0,96(a2)
8000ccf6:	5f74                	lw	a3,124(a4)
8000ccf8:	6975                	lui	s2,0x1d
8000ccfa:	746e                	flw	fs0,248(sp)
8000ccfc:	5f38                	lw	a4,120(a4)
8000ccfe:	2074                	fld	fa3,192(s0)
8000cd00:	292a                	fld	fs2,136(sp)
8000cd02:	6d72                	flw	fs10,28(sp)
8000cd04:	6d65                	lui	s10,0x19
8000cd06:	3e20                	fld	fs0,120(a2)
8000cd08:	203d                	jal	8000cd36 <small_digits.3193+0x22e>
8000cd0a:	7228                	flw	fa0,96(a2)
8000cd0c:	5f74                	lw	a3,124(a4)
8000cd0e:	6975                	lui	s2,0x1d
8000cd10:	746e                	flw	fs0,248(sp)
8000cd12:	5f38                	lw	a4,120(a4)
8000cd14:	2074                	fld	fa3,192(s0)
8000cd16:	292a                	fld	fs2,136(sp)
8000cd18:	6568                	flw	fa0,76(a0)
8000cd1a:	7061                	c.lui	zero,0xffff8
8000cd1c:	705f 7274 2620      	0x26207274705f
8000cd22:	2026                	fld	ft0,72(sp)
8000cd24:	7228                	flw	fa0,96(a2)
8000cd26:	5f74                	lw	a3,124(a4)
8000cd28:	6975                	lui	s2,0x1d
8000cd2a:	746e                	flw	fs0,248(sp)
8000cd2c:	5f38                	lw	a4,120(a4)
8000cd2e:	2074                	fld	fa3,192(s0)
8000cd30:	292a                	fld	fs2,136(sp)
8000cd32:	6d72                	flw	fs10,28(sp)
8000cd34:	6d65                	lui	s10,0x19
8000cd36:	3c20                	fld	fs0,120(s0)
8000cd38:	2820                	fld	fs0,80(s0)
8000cd3a:	7472                	flw	fs0,60(sp)
8000cd3c:	755f 6e69 3874      	0x38746e69755f
8000cd42:	745f 2a20 6829      	0x68292a20745f
8000cd48:	6165                	addi	sp,sp,112
8000cd4a:	5f70                	lw	a2,124(a4)
8000cd4c:	6e65                	lui	t3,0x19
8000cd4e:	0064                	addi	s1,sp,12
8000cd50:	6f74                	flw	fa3,92(a4)
8000cd52:	6620                	flw	fs0,72(a2)
8000cd54:	6572                	flw	fa0,28(sp)
8000cd56:	2065                	jal	8000cdfe <__fsym_list_mem_desc+0xe>
8000cd58:	2061                	jal	8000cde0 <__FUNCTION__.3060+0x10>
8000cd5a:	6162                	flw	ft2,24(sp)
8000cd5c:	2064                	fld	fs1,192(s0)
8000cd5e:	6164                	flw	fs1,68(a0)
8000cd60:	6174                	flw	fa3,68(a0)
8000cd62:	6220                	flw	fs0,64(a2)
8000cd64:	6f6c                	flw	fa1,92(a4)
8000cd66:	0a3a6b63          	bltu	s4,gp,8000ce1c <__fsym_list_mem_name+0xc>
8000cd6a:	0000                	unimp
8000cd6c:	656d                	lui	a0,0x1b
8000cd6e:	3a6d                	jal	8000c728 <__FUNCTION__.2964+0x8>
8000cd70:	3020                	fld	fs0,96(s0)
8000cd72:	2578                	fld	fa4,200(a0)
8000cd74:	3830                	fld	fa2,112(s0)
8000cd76:	2c78                	fld	fa4,216(s0)
8000cd78:	7520                	flw	fs0,104(a0)
8000cd7a:	20646573          	csrrsi	a0,0x206,8
8000cd7e:	6c66                	flw	fs8,88(sp)
8000cd80:	6761                	lui	a4,0x18
8000cd82:	203a                	fld	ft0,392(sp)
8000cd84:	6425                	lui	s0,0x9
8000cd86:	202c                	fld	fa1,64(s0)
8000cd88:	616d                	addi	sp,sp,240
8000cd8a:	20636967          	0x20636967
8000cd8e:	65646f63          	bltu	s0,s6,8000d3ec <__fsym_pinMode_name+0x4c>
8000cd92:	203a                	fld	ft0,392(sp)
8000cd94:	7830                	flw	fa2,112(s0)
8000cd96:	3025                	jal	8000c5be <uart_ops+0x1e>
8000cd98:	7834                	flw	fa3,112(s0)
8000cd9a:	000a                	c.slli	zero,0x2
8000cd9c:	656d                	lui	a0,0x1b
8000cd9e:	2d6d                	jal	8000d458 <__fsym_pinMode_name+0xb8>
8000cda0:	753e                	flw	fa0,236(sp)
8000cda2:	00646573          	csrrsi	a0,0x6,8
8000cda6:	0000                	unimp
8000cda8:	656d                	lui	a0,0x1b
8000cdaa:	2d6d                	jal	8000d464 <__FUNCTION__.3449+0x8>
8000cdac:	6d3e                	flw	fs10,204(sp)
8000cdae:	6761                	lui	a4,0x18
8000cdb0:	6369                	lui	t1,0x1a
8000cdb2:	3d20                	fld	fs0,120(a0)
8000cdb4:	203d                	jal	8000cde2 <__FUNCTION__.3060+0x12>
8000cdb6:	4548                	lw	a0,12(a0)
8000cdb8:	5041                	c.li	zero,-16
8000cdba:	4d5f 4741 4349      	0x434947414d5f
8000cdc0:	0000                	unimp
	...

8000cdc4 <__FUNCTION__.3051>:
8000cdc4:	6c70                	flw	fa2,92(s0)
8000cdc6:	6775                	lui	a4,0x1d
8000cdc8:	685f 6c6f 7365      	0x73656c6f685f
	...

8000cdd0 <__FUNCTION__.3060>:
8000cdd0:	7472                	flw	fs0,60(sp)
8000cdd2:	735f 7379 6574      	0x65747379735f
8000cdd8:	5f6d                	li	t5,-5
8000cdda:	6568                	flw	fa0,76(a0)
8000cddc:	7061                	c.lui	zero,0xffff8
8000cdde:	695f 696e 0074      	0x74696e695f

8000cde4 <__FUNCTION__.3069>:
8000cde4:	7472                	flw	fs0,60(sp)
8000cde6:	6d5f 6c61 6f6c      	0x6f6c6c616d5f
8000cdec:	00000063          	beqz	zero,8000cdec <__FUNCTION__.3069+0x8>

8000cdf0 <__fsym_list_mem_desc>:
8000cdf0:	696c                	flw	fa1,84(a0)
8000cdf2:	6d207473          	csrrci	s0,0x6d2,0
8000cdf6:	6d65                	lui	s10,0x19
8000cdf8:	2079726f          	jal	tp,800a47fe <_sp+0x647fe>
8000cdfc:	7375                	lui	t1,0xffffd
8000cdfe:	6761                	lui	a4,0x18
8000ce00:	2065                	jal	8000cea8 <__FUNCTION__.3127+0x4>
8000ce02:	6e69                	lui	t3,0x1a
8000ce04:	6f66                	flw	ft10,88(sp)
8000ce06:	6d72                	flw	fs10,28(sp)
8000ce08:	7461                	lui	s0,0xffff8
8000ce0a:	6f69                	lui	t5,0x1a
8000ce0c:	006e                	c.slli	zero,0x1b
	...

8000ce10 <__fsym_list_mem_name>:
8000ce10:	696c                	flw	fa1,84(a0)
8000ce12:	6d5f7473          	csrrci	s0,0x6d5,30
8000ce16:	6d65                	lui	s10,0x19
8000ce18:	0000                	unimp
8000ce1a:	0000                	unimp
8000ce1c:	206a626f          	jal	tp,800b3022 <_sp+0x73022>
8000ce20:	3d21                	jal	8000cc38 <small_digits.3193+0x130>
8000ce22:	6f20                	flw	fs0,88(a4)
8000ce24:	6a62                	flw	fs4,24(sp)
8000ce26:	6365                	lui	t1,0x19
8000ce28:	0074                	addi	a3,sp,12
8000ce2a:	0000                	unimp
8000ce2c:	656a626f          	jal	tp,800b3482 <_sp+0x73482>
8000ce30:	21207463          	bgeu	zero,s2,8000d038 <__FUNCTION__.3085+0xcc>
8000ce34:	203d                	jal	8000ce62 <__fsym_list_mem_name+0x52>
8000ce36:	5452                	lw	s0,52(sp)
8000ce38:	4e5f 4c55 004c      	0x4c4c554e5f
8000ce3e:	0000                	unimp
8000ce40:	2821                	jal	8000ce58 <__fsym_list_mem_name+0x48>
8000ce42:	656a626f          	jal	tp,800b3498 <_sp+0x73498>
8000ce46:	3e2d7463          	bgeu	s10,sp,8000d22e <__FUNCTION__.3128+0x1a>
8000ce4a:	7974                	flw	fa3,116(a0)
8000ce4c:	6570                	flw	fa2,76(a0)
8000ce4e:	2620                	fld	fs0,72(a2)
8000ce50:	5220                	lw	s0,96(a2)
8000ce52:	5f54                	lw	a3,60(a4)
8000ce54:	656a624f          	0x656a624f
8000ce58:	435f7463          	bgeu	t5,s5,8000d280 <__FUNCTION__.3166+0x4>
8000ce5c:	616c                	flw	fa1,68(a0)
8000ce5e:	535f7373          	csrrci	t1,0x535,30
8000ce62:	6174                	flw	fa3,68(a0)
8000ce64:	6974                	flw	fa3,84(a0)
8000ce66:	00002963          	0x2963
	...

8000ce6c <__FUNCTION__.3104>:
8000ce6c:	7472                	flw	fs0,60(sp)
8000ce6e:	6f5f 6a62 6365      	0x63656a626f5f
8000ce74:	5f74                	lw	a3,124(a4)
8000ce76:	6e69                	lui	t3,0x1a
8000ce78:	7469                	lui	s0,0xffffa
	...

8000ce7c <__FUNCTION__.3113>:
8000ce7c:	7472                	flw	fs0,60(sp)
8000ce7e:	6f5f 6a62 6365      	0x63656a626f5f
8000ce84:	5f74                	lw	a3,124(a4)
8000ce86:	6564                	flw	fs1,76(a0)
8000ce88:	6174                	flw	fa3,68(a0)
8000ce8a:	00006863          	bltu	zero,zero,8000ce9a <__FUNCTION__.3122+0xa>
	...

8000ce90 <__FUNCTION__.3122>:
8000ce90:	7472                	flw	fs0,60(sp)
8000ce92:	6f5f 6a62 6365      	0x63656a626f5f
8000ce98:	5f74                	lw	a3,124(a4)
8000ce9a:	6c61                	lui	s8,0x18
8000ce9c:	6f6c                	flw	fa1,92(a4)
8000ce9e:	65746163          	bltu	s0,s7,8000d4e0 <__FUNCTION__.3530>
	...

8000cea4 <__FUNCTION__.3127>:
8000cea4:	7472                	flw	fs0,60(sp)
8000cea6:	6f5f 6a62 6365      	0x63656a626f5f
8000ceac:	5f74                	lw	a3,124(a4)
8000ceae:	6564                	flw	fs1,76(a0)
8000ceb0:	656c                	flw	fa1,76(a0)
8000ceb2:	6574                	flw	fa3,76(a0)
8000ceb4:	0000                	unimp
	...

8000ceb8 <__FUNCTION__.3131>:
8000ceb8:	7472                	flw	fs0,60(sp)
8000ceba:	6f5f 6a62 6365      	0x63656a626f5f
8000cec0:	5f74                	lw	a3,124(a4)
8000cec2:	7369                	lui	t1,0xffffa
8000cec4:	735f 7379 6574      	0x65747379735f
8000ceca:	6f6d                	lui	t5,0x1b
8000cecc:	6a62                	flw	fs4,24(sp)
8000cece:	6365                	lui	t1,0x19
8000ced0:	0074                	addi	a3,sp,12
	...

8000ced4 <__FUNCTION__.3135>:
8000ced4:	7472                	flw	fs0,60(sp)
8000ced6:	6f5f 6a62 6365      	0x63656a626f5f
8000cedc:	5f74                	lw	a3,124(a4)
8000cede:	5f746567          	0x5f746567
8000cee2:	7974                	flw	fa3,116(a0)
8000cee4:	6570                	flw	fa2,76(a0)
8000cee6:	0000                	unimp
8000cee8:	6874                	flw	fa3,84(s0)
8000ceea:	6572                	flw	fa0,28(sp)
8000ceec:	6461                	lui	s0,0x18
8000ceee:	2120                	fld	fs0,64(a0)
8000cef0:	203d                	jal	8000cf1e <__FUNCTION__.3135+0x4a>
8000cef2:	5452                	lw	s0,52(sp)
8000cef4:	4e5f 4c55 004c      	0x4c4c554e5f
8000cefa:	0000                	unimp
8000cefc:	6874                	flw	fa3,84(s0)
8000cefe:	6572                	flw	fa0,28(sp)
8000cf00:	6461                	lui	s0,0x18
8000cf02:	253a                	fld	fa0,392(sp)
8000cf04:	74732073          	csrs	0x747,t1
8000cf08:	6361                	lui	t1,0x18
8000cf0a:	766f206b          	0x766f206b
8000cf0e:	7265                	lui	tp,0xffff9
8000cf10:	6c66                	flw	fs8,88(sp)
8000cf12:	000a776f          	jal	a4,800b3f12 <_sp+0x73f12>
8000cf16:	0000                	unimp
8000cf18:	6e726177          	0x6e726177
8000cf1c:	6e69                	lui	t3,0x1a
8000cf1e:	25203a67          	0x25203a67
8000cf22:	74732073          	csrs	0x747,t1
8000cf26:	6361                	lui	t1,0x18
8000cf28:	7369206b          	0x7369206b
8000cf2c:	6320                	flw	fs0,64(a4)
8000cf2e:	6f6c                	flw	fa1,92(a4)
8000cf30:	74206573          	csrrsi	a0,0x742,0
8000cf34:	6e65206f          	j	8005f61a <_sp+0x1f61a>
8000cf38:	2064                	fld	fs1,192(s0)
8000cf3a:	7320666f          	jal	a2,8001366c <__fini_array_end+0x4b8c>
8000cf3e:	6174                	flw	fa3,68(a0)
8000cf40:	61206b63          	bltu	zero,s2,8000d556 <__FUNCTION__.3425+0x2>
8000cf44:	6464                	flw	fs1,76(s0)
8000cf46:	6572                	flw	fa0,28(sp)
8000cf48:	0a2e7373          	csrrci	t1,0xa2,28
8000cf4c:	0000                	unimp
	...

8000cf50 <__FUNCTION__.3079>:
8000cf50:	7472                	flw	fs0,60(sp)
8000cf52:	735f 6863 6465      	0x64656863735f
8000cf58:	6c75                	lui	s8,0x1d
8000cf5a:	5f65                	li	t5,-7
8000cf5c:	6e69                	lui	t3,0x1a
8000cf5e:	74726573          	csrrsi	a0,0x747,4
8000cf62:	745f 7268 6165      	0x61657268745f
8000cf68:	0064                	addi	s1,sp,12
	...

8000cf6c <__FUNCTION__.3085>:
8000cf6c:	7472                	flw	fs0,60(sp)
8000cf6e:	735f 6863 6465      	0x64656863735f
8000cf74:	6c75                	lui	s8,0x1d
8000cf76:	5f65                	li	t5,-7
8000cf78:	6572                	flw	fa0,28(sp)
8000cf7a:	6f6d                	lui	t5,0x1b
8000cf7c:	6576                	flw	fa0,92(sp)
8000cf7e:	745f 7268 6165      	0x61657268745f
8000cf84:	0064                	addi	s1,sp,12
8000cf86:	0000                	unimp
8000cf88:	7270                	flw	fa2,100(a2)
8000cf8a:	6f69                	lui	t5,0x1a
8000cf8c:	6972                	flw	fs2,28(sp)
8000cf8e:	7974                	flw	fa3,116(a0)
8000cf90:	3c20                	fld	fs0,120(s0)
8000cf92:	5220                	lw	s0,96(a2)
8000cf94:	5f54                	lw	a3,60(a4)
8000cf96:	4854                	lw	a3,20(s0)
8000cf98:	4552                	lw	a0,20(sp)
8000cf9a:	4441                	li	s0,16
8000cf9c:	505f 4952 524f      	0x524f4952505f
8000cfa2:	5449                	li	s0,-14
8000cfa4:	5f59                	li	t5,-10
8000cfa6:	414d                	li	sp,19
8000cfa8:	0058                	addi	a4,sp,4
8000cfaa:	0000                	unimp
8000cfac:	7428                	flw	fa0,104(s0)
8000cfae:	7268                	flw	fa0,100(a2)
8000cfb0:	6165                	addi	sp,sp,112
8000cfb2:	2d64                	fld	fs1,216(a0)
8000cfb4:	733e                	flw	ft6,236(sp)
8000cfb6:	6174                	flw	fa3,68(a0)
8000cfb8:	2074                	fld	fa3,192(s0)
8000cfba:	2026                	fld	ft0,72(sp)
8000cfbc:	5452                	lw	s0,52(sp)
8000cfbe:	545f 5248 4145      	0x41455248545f
8000cfc4:	5f44                	lw	s1,60(a4)
8000cfc6:	54415453          	0x54415453
8000cfca:	4d5f 5341 294b      	0x294b53414d5f
8000cfd0:	3d20                	fld	fs0,120(a0)
8000cfd2:	203d                	jal	8000d000 <__FUNCTION__.3085+0x94>
8000cfd4:	5452                	lw	s0,52(sp)
8000cfd6:	545f 5248 4145      	0x41455248545f
8000cfdc:	5f44                	lw	s1,60(a4)
8000cfde:	50535553          	0x50535553
8000cfe2:	4e45                	li	t3,17
8000cfe4:	0044                	addi	s1,sp,4
8000cfe6:	0000                	unimp
8000cfe8:	7472                	flw	fs0,60(sp)
8000cfea:	6f5f 6a62 6365      	0x63656a626f5f
8000cff0:	5f74                	lw	a3,124(a4)
8000cff2:	5f746567          	0x5f746567
8000cff6:	7974                	flw	fa3,116(a0)
8000cff8:	6570                	flw	fa2,76(a0)
8000cffa:	2828                	fld	fa0,80(s0)
8000cffc:	7472                	flw	fs0,60(sp)
8000cffe:	6f5f 6a62 6365      	0x63656a626f5f
8000d004:	5f74                	lw	a3,124(a4)
8000d006:	2974                	fld	fa3,208(a0)
8000d008:	6874                	flw	fa3,84(s0)
8000d00a:	6572                	flw	fa0,28(sp)
8000d00c:	6461                	lui	s0,0x18
8000d00e:	2029                	jal	8000d018 <__FUNCTION__.3085+0xac>
8000d010:	3d3d                	jal	8000ce4e <__fsym_list_mem_name+0x3e>
8000d012:	5220                	lw	s0,96(a2)
8000d014:	5f54                	lw	a3,60(a4)
8000d016:	656a624f          	0x656a624f
8000d01a:	435f7463          	bgeu	t5,s5,8000d442 <__fsym_pinMode_name+0xa2>
8000d01e:	616c                	flw	fa1,68(a0)
8000d020:	545f7373          	csrrci	t1,0x545,30
8000d024:	7268                	flw	fa0,100(a2)
8000d026:	6165                	addi	sp,sp,112
8000d028:	0064                	addi	s1,sp,12
8000d02a:	0000                	unimp
8000d02c:	63617473          	csrrci	s0,0x636,2
8000d030:	74735f6b          	0x74735f6b
8000d034:	7261                	lui	tp,0xffff8
8000d036:	2074                	fld	fa3,192(s0)
8000d038:	3d21                	jal	8000ce50 <__fsym_list_mem_name+0x40>
8000d03a:	5220                	lw	s0,96(a2)
8000d03c:	5f54                	lw	a3,60(a4)
8000d03e:	554e                	lw	a0,240(sp)
8000d040:	4c4c                	lw	a1,28(s0)
8000d042:	0000                	unimp
8000d044:	6874                	flw	fa3,84(s0)
8000d046:	6572                	flw	fa0,28(sp)
8000d048:	6461                	lui	s0,0x18
8000d04a:	3d20                	fld	fs0,120(a0)
8000d04c:	203d                	jal	8000d07a <__FUNCTION__.3085+0x10e>
8000d04e:	7472                	flw	fs0,60(sp)
8000d050:	745f 7268 6165      	0x61657268745f
8000d056:	5f64                	lw	s1,124(a4)
8000d058:	666c6573          	csrrsi	a0,0x666,24
8000d05c:	2928                	fld	fa0,80(a0)
8000d05e:	0000                	unimp
8000d060:	7428                	flw	fa0,104(s0)
8000d062:	7268                	flw	fa0,100(a2)
8000d064:	6165                	addi	sp,sp,112
8000d066:	2d64                	fld	fs1,216(a0)
8000d068:	733e                	flw	ft6,236(sp)
8000d06a:	6174                	flw	fa3,68(a0)
8000d06c:	2074                	fld	fa3,192(s0)
8000d06e:	2026                	fld	ft0,72(sp)
8000d070:	5452                	lw	s0,52(sp)
8000d072:	545f 5248 4145      	0x41455248545f
8000d078:	5f44                	lw	s1,60(a4)
8000d07a:	54415453          	0x54415453
8000d07e:	4d5f 5341 294b      	0x294b53414d5f
8000d084:	3d20                	fld	fs0,120(a0)
8000d086:	203d                	jal	8000d0b4 <__FUNCTION__.3067+0xc>
8000d088:	5452                	lw	s0,52(sp)
8000d08a:	545f 5248 4145      	0x41455248545f
8000d090:	5f44                	lw	s1,60(a4)
8000d092:	4e49                	li	t3,18
8000d094:	5449                	li	s0,-14
	...

8000d098 <__FUNCTION__.3055>:
8000d098:	725f 5f74 6874      	0x68745f74725f
8000d09e:	6572                	flw	fa0,28(sp)
8000d0a0:	6461                	lui	s0,0x18
8000d0a2:	695f 696e 0074      	0x74696e695f

8000d0a8 <__FUNCTION__.3067>:
8000d0a8:	7472                	flw	fs0,60(sp)
8000d0aa:	745f 7268 6165      	0x61657268745f
8000d0b0:	5f64                	lw	s1,124(a4)
8000d0b2:	6e69                	lui	t3,0x1a
8000d0b4:	7469                	lui	s0,0xffffa
	...

8000d0b8 <__FUNCTION__.3076>:
8000d0b8:	7472                	flw	fs0,60(sp)
8000d0ba:	745f 7268 6165      	0x61657268745f
8000d0c0:	5f64                	lw	s1,124(a4)
8000d0c2:	72617473          	csrrci	s0,0x726,2
8000d0c6:	7574                	flw	fa3,108(a0)
8000d0c8:	0070                	addi	a2,sp,12
	...

8000d0cc <__FUNCTION__.3108>:
8000d0cc:	7472                	flw	fs0,60(sp)
8000d0ce:	745f 7268 6165      	0x61657268745f
8000d0d4:	5f64                	lw	s1,124(a4)
8000d0d6:	65656c73          	csrrsi	s8,0x656,10
8000d0da:	0070                	addi	a2,sp,12

8000d0dc <__FUNCTION__.3140>:
8000d0dc:	7472                	flw	fs0,60(sp)
8000d0de:	745f 7268 6165      	0x61657268745f
8000d0e4:	5f64                	lw	s1,124(a4)
8000d0e6:	70737573          	csrrci	a0,0x707,6
8000d0ea:	6e65                	lui	t3,0x19
8000d0ec:	0064                	addi	s1,sp,12
	...

8000d0f0 <__FUNCTION__.3145>:
8000d0f0:	7472                	flw	fs0,60(sp)
8000d0f2:	745f 7268 6165      	0x61657268745f
8000d0f8:	5f64                	lw	s1,124(a4)
8000d0fa:	6572                	flw	fa0,28(sp)
8000d0fc:	656d7573          	csrrci	a0,0x656,26
8000d100:	0000                	unimp
	...

8000d104 <__FUNCTION__.3150>:
8000d104:	7472                	flw	fs0,60(sp)
8000d106:	745f 7268 6165      	0x61657268745f
8000d10c:	5f64                	lw	s1,124(a4)
8000d10e:	6974                	flw	fa3,84(a0)
8000d110:	656d                	lui	a0,0x1b
8000d112:	0074756f          	jal	a0,80054918 <_sp+0x14918>
8000d116:	0000                	unimp
8000d118:	6974                	flw	fa3,84(a0)
8000d11a:	656d                	lui	a0,0x1b
8000d11c:	2072                	fld	ft0,280(sp)
8000d11e:	3d21                	jal	8000cf36 <__FUNCTION__.3135+0x62>
8000d120:	5220                	lw	s0,96(a2)
8000d122:	5f54                	lw	a3,60(a4)
8000d124:	554e                	lw	a0,240(sp)
8000d126:	4c4c                	lw	a1,28(s0)
8000d128:	0000                	unimp
8000d12a:	0000                	unimp
8000d12c:	7472                	flw	fs0,60(sp)
8000d12e:	6f5f 6a62 6365      	0x63656a626f5f
8000d134:	5f74                	lw	a3,124(a4)
8000d136:	5f746567          	0x5f746567
8000d13a:	7974                	flw	fa3,116(a0)
8000d13c:	6570                	flw	fa2,76(a0)
8000d13e:	2628                	fld	fa0,72(a2)
8000d140:	6974                	flw	fa3,84(a0)
8000d142:	656d                	lui	a0,0x1b
8000d144:	2d72                	fld	fs10,280(sp)
8000d146:	703e                	flw	ft0,236(sp)
8000d148:	7261                	lui	tp,0xffff8
8000d14a:	6e65                	lui	t3,0x19
8000d14c:	2974                	fld	fa3,208(a0)
8000d14e:	3d20                	fld	fs0,120(a0)
8000d150:	203d                	jal	8000d17e <__FUNCTION__.3150+0x7a>
8000d152:	5452                	lw	s0,52(sp)
8000d154:	4f5f 6a62 6365      	0x63656a624f5f
8000d15a:	5f74                	lw	a3,124(a4)
8000d15c:	73616c43          	fmadd.d	fs8,ft2,fs6,fa4,unknown
8000d160:	69545f73          	csrrwi	t5,0x695,8
8000d164:	656d                	lui	a0,0x1b
8000d166:	0072                	c.slli	zero,0x1c
8000d168:	7472                	flw	fs0,60(sp)
8000d16a:	6f5f 6a62 6365      	0x63656a626f5f
8000d170:	5f74                	lw	a3,124(a4)
8000d172:	7369                	lui	t1,0xffffa
8000d174:	735f 7379 6574      	0x65747379735f
8000d17a:	6f6d                	lui	t5,0x1b
8000d17c:	6a62                	flw	fs4,24(sp)
8000d17e:	6365                	lui	t1,0x19
8000d180:	2874                	fld	fa3,208(s0)
8000d182:	7426                	flw	fs0,104(sp)
8000d184:	6d69                	lui	s10,0x1a
8000d186:	7265                	lui	tp,0xffff9
8000d188:	3e2d                	jal	8000ccc2 <small_digits.3193+0x1ba>
8000d18a:	6170                	flw	fa2,68(a0)
8000d18c:	6572                	flw	fa0,28(sp)
8000d18e:	746e                	flw	fs0,248(sp)
8000d190:	0029                	c.nop	10
8000d192:	0000                	unimp
8000d194:	6974                	flw	fa3,84(a0)
8000d196:	656d                	lui	a0,0x1b
8000d198:	2d72                	fld	fs10,280(sp)
8000d19a:	693e                	flw	fs2,204(sp)
8000d19c:	696e                	flw	fs2,216(sp)
8000d19e:	5f74                	lw	a3,124(a4)
8000d1a0:	6974                	flw	fa3,84(a0)
8000d1a2:	3c206b63          	bltu	zero,sp,8000d578 <__FUNCTION__.3433+0x10>
8000d1a6:	5220                	lw	s0,96(a2)
8000d1a8:	5f54                	lw	a3,60(a4)
8000d1aa:	4954                	lw	a3,20(a0)
8000d1ac:	4d5f4b43          	0x4d5f4b43
8000d1b0:	5841                	li	a6,-16
8000d1b2:	2f20                	fld	fs0,88(a4)
8000d1b4:	3220                	fld	fs0,96(a2)
8000d1b6:	0000                	unimp
8000d1b8:	6afc                	flw	fa5,84(a3)
8000d1ba:	ffff                	0xffff
8000d1bc:	6af0                	flw	fa2,84(a3)
8000d1be:	ffff                	0xffff
8000d1c0:	6b24                	flw	fs1,80(a4)
8000d1c2:	ffff                	0xffff
8000d1c4:	6b34                	flw	fa3,80(a4)
8000d1c6:	ffff                	0xffff
8000d1c8:	6b40                	flw	fs0,20(a4)
8000d1ca:	ffff                	0xffff
8000d1cc:	6974                	flw	fa3,84(a0)
8000d1ce:	656d                	lui	a0,0x1b
8000d1d0:	0072                	c.slli	zero,0x1c
	...

8000d1d4 <__FUNCTION__.3075>:
8000d1d4:	7472                	flw	fs0,60(sp)
8000d1d6:	745f 6d69 7265      	0x72656d69745f
8000d1dc:	695f 696e 0074      	0x74696e695f
	...

8000d1e4 <__FUNCTION__.3080>:
8000d1e4:	7472                	flw	fs0,60(sp)
8000d1e6:	745f 6d69 7265      	0x72656d69745f
8000d1ec:	645f 7465 6361      	0x63617465645f
8000d1f2:	0068                	addi	a0,sp,12

8000d1f4 <__FUNCTION__.3104>:
8000d1f4:	7472                	flw	fs0,60(sp)
8000d1f6:	745f 6d69 7265      	0x72656d69745f
8000d1fc:	735f 6174 7472      	0x74726174735f
	...

8000d204 <__FUNCTION__.3121>:
8000d204:	7472                	flw	fs0,60(sp)
8000d206:	745f 6d69 7265      	0x72656d69745f
8000d20c:	735f 6f74 0070      	0x706f74735f
	...

8000d214 <__FUNCTION__.3128>:
8000d214:	7472                	flw	fs0,60(sp)
8000d216:	745f 6d69 7265      	0x72656d69745f
8000d21c:	635f 6e6f 7274      	0x72746e6f635f
8000d222:	00006c6f          	jal	s8,80013222 <__fini_array_end+0x4742>
8000d226:	0000                	unimp
8000d228:	6e55                	lui	t3,0x15
8000d22a:	6168                	flw	fa0,68(a0)
8000d22c:	646e                	flw	fs0,216(sp)
8000d22e:	656c                	flw	fa1,76(a0)
8000d230:	2064                	fld	fs1,192(s0)
8000d232:	7254                	flw	fa3,36(a2)
8000d234:	7061                	c.lui	zero,0xffff8
8000d236:	0a21                	addi	s4,s4,8
8000d238:	0000                	unimp
8000d23a:	0000                	unimp
8000d23c:	7274                	flw	fa3,100(a2)
8000d23e:	7061                	c.lui	zero,0xffff8
8000d240:	695f 2064 203c      	0x203c2064695f
8000d246:	4952                	lw	s2,20(sp)
8000d248:	5f564353          	0x5f564353
8000d24c:	5254                	lw	a3,36(a2)
8000d24e:	5041                	c.li	zero,-16
8000d250:	495f 544e 4e5f      	0x4e5f544e495f
8000d256:	4d55                	li	s10,21
8000d258:	0000                	unimp
8000d25a:	0000                	unimp
8000d25c:	7274                	flw	fa3,100(a2)
8000d25e:	7061                	c.lui	zero,0xffff8
8000d260:	695f 2064 203c      	0x203c2064695f
8000d266:	4952                	lw	s2,20(sp)
8000d268:	5f564353          	0x5f564353
8000d26c:	5254                	lw	a3,36(a2)
8000d26e:	5041                	c.li	zero,-16
8000d270:	455f 4358 4e5f      	0x4e5f4358455f
8000d276:	4d55                	li	s10,21
8000d278:	0000                	unimp
	...

8000d27c <__FUNCTION__.3166>:
8000d27c:	65726f63          	bltu	tp,s7,8000d8da <__rti_finsh_system_init_name+0x1e6>
8000d280:	655f 6378 7065      	0x70656378655f
8000d286:	6974                	flw	fa3,84(a0)
8000d288:	685f6e6f          	jal	t3,8010410c <_sp+0xc410c>
8000d28c:	6e61                	lui	t3,0x18
8000d28e:	6c64                	flw	fs1,92(s0)
8000d290:	7265                	lui	tp,0xffff9
	...

8000d294 <__FUNCTION__.3181>:
8000d294:	6972                	flw	fs2,28(sp)
8000d296:	5f766373          	csrrsi	t1,0x5f7,12
8000d29a:	5f746573          	csrrsi	a0,0x5f7,8
8000d29e:	7274                	flw	fa3,100(a2)
8000d2a0:	7061                	c.lui	zero,0xffff8
8000d2a2:	695f 746e 685f      	0x685f746e695f
8000d2a8:	6e61                	lui	t3,0x18
8000d2aa:	6c64                	flw	fs1,92(s0)
8000d2ac:	7265                	lui	tp,0xffff9
8000d2ae:	0000                	unimp
8000d2b0:	685f 5f77 6970      	0x69705f77685f
8000d2b6:	2e6e                	fld	ft8,216(sp)
8000d2b8:	2073706f          	j	80044cbe <_sp+0x4cbe>
8000d2bc:	3d21                	jal	8000d0d4 <__FUNCTION__.3108+0x8>
8000d2be:	5220                	lw	s0,96(a2)
8000d2c0:	5f54                	lw	a3,60(a4)
8000d2c2:	554e                	lw	a0,240(sp)
8000d2c4:	4c4c                	lw	a1,28(s0)
8000d2c6:	0000                	unimp
8000d2c8:	616e                	flw	ft2,216(sp)
8000d2ca:	656d                	lui	a0,0x1b
8000d2cc:	205d305b          	0x205d305b
8000d2d0:	3d3d                	jal	8000d10e <__FUNCTION__.3150+0xa>
8000d2d2:	2720                	fld	fs0,72(a4)
8000d2d4:	2750                	fld	fa2,136(a4)
	...

8000d2d8 <__FUNCTION__.4923>:
8000d2d8:	7472                	flw	fs0,60(sp)
8000d2da:	705f 6e69 6d5f      	0x6d5f6e69705f
8000d2e0:	0065646f          	jal	s0,800632e6 <_sp+0x232e6>

8000d2e4 <__FUNCTION__.4931>:
8000d2e4:	7472                	flw	fs0,60(sp)
8000d2e6:	705f 6e69 775f      	0x775f6e69705f
8000d2ec:	6972                	flw	fs2,28(sp)
8000d2ee:	6574                	flw	fa3,76(a0)
8000d2f0:	0000                	unimp
	...

8000d2f4 <__FUNCTION__.4938>:
8000d2f4:	7472                	flw	fs0,60(sp)
8000d2f6:	705f 6e69 725f      	0x725f6e69705f
8000d2fc:	6165                	addi	sp,sp,112
8000d2fe:	0064                	addi	s1,sp,12

8000d300 <__FUNCTION__.4945>:
8000d300:	7472                	flw	fs0,60(sp)
8000d302:	705f 6e69 675f      	0x675f6e69705f
8000d308:	7465                	lui	s0,0xffff9
	...

8000d30c <__fsym_pinGet_desc>:
8000d30c:	20746567          	0x20746567
8000d310:	6970                	flw	fa2,84(a0)
8000d312:	206e                	fld	ft0,216(sp)
8000d314:	756e                	flw	fa0,248(sp)
8000d316:	626d                	lui	tp,0x1b
8000d318:	7265                	lui	tp,0xffff9
8000d31a:	6620                	flw	fs0,72(a2)
8000d31c:	6f72                	flw	ft10,28(sp)
8000d31e:	206d                	jal	8000d3c8 <__fsym_pinMode_name+0x28>
8000d320:	6168                	flw	fa0,68(a0)
8000d322:	6472                	flw	fs0,28(sp)
8000d324:	65726177          	0x65726177
8000d328:	7020                	flw	fs0,96(s0)
8000d32a:	6e69                	lui	t3,0x1a
8000d32c:	0000                	unimp
	...

8000d330 <__fsym_pinGet_name>:
8000d330:	6970                	flw	fa2,84(a0)
8000d332:	476e                	lw	a4,216(sp)
8000d334:	7465                	lui	s0,0xffff9
	...

8000d338 <__fsym_pinRead_desc>:
8000d338:	6572                	flw	fa0,28(sp)
8000d33a:	6461                	lui	s0,0x18
8000d33c:	7320                	flw	fs0,96(a4)
8000d33e:	6174                	flw	fa3,68(a0)
8000d340:	7574                	flw	fa3,108(a0)
8000d342:	72662073          	csrs	0x726,a2
8000d346:	68206d6f          	jal	s10,800139c8 <__fini_array_end+0x4ee8>
8000d34a:	7261                	lui	tp,0xffff8
8000d34c:	7764                	flw	fs1,108(a4)
8000d34e:	7261                	lui	tp,0xffff8
8000d350:	2065                	jal	8000d3f8 <__fsym_pinMode_name+0x58>
8000d352:	6970                	flw	fa2,84(a0)
8000d354:	006e                	c.slli	zero,0x1b
	...

8000d358 <__fsym_pinRead_name>:
8000d358:	6970                	flw	fa2,84(a0)
8000d35a:	526e                	lw	tp,248(sp)
8000d35c:	6165                	addi	sp,sp,112
8000d35e:	0064                	addi	s1,sp,12

8000d360 <__fsym_pinWrite_desc>:
8000d360:	74697277          	0x74697277
8000d364:	2065                	jal	8000d40c <__fsym_pinMode_name+0x6c>
8000d366:	6176                	flw	ft2,92(sp)
8000d368:	756c                	flw	fa1,108(a0)
8000d36a:	2065                	jal	8000d412 <__fsym_pinMode_name+0x72>
8000d36c:	6f74                	flw	fa3,92(a4)
8000d36e:	6820                	flw	fs0,80(s0)
8000d370:	7261                	lui	tp,0xffff8
8000d372:	7764                	flw	fs1,108(a4)
8000d374:	7261                	lui	tp,0xffff8
8000d376:	2065                	jal	8000d41e <__fsym_pinMode_name+0x7e>
8000d378:	6970                	flw	fa2,84(a0)
8000d37a:	006e                	c.slli	zero,0x1b

8000d37c <__fsym_pinWrite_name>:
8000d37c:	6970                	flw	fa2,84(a0)
8000d37e:	576e                	lw	a4,248(sp)
8000d380:	6972                	flw	fs2,28(sp)
8000d382:	6574                	flw	fa3,76(a0)
8000d384:	0000                	unimp
	...

8000d388 <__fsym_pinMode_desc>:
8000d388:	20746573          	csrrsi	a0,0x207,8
8000d38c:	6168                	flw	fa0,68(a0)
8000d38e:	6472                	flw	fs0,28(sp)
8000d390:	65726177          	0x65726177
8000d394:	7020                	flw	fs0,96(s0)
8000d396:	6e69                	lui	t3,0x1a
8000d398:	6d20                	flw	fs0,88(a0)
8000d39a:	0065646f          	jal	s0,800633a0 <_sp+0x233a0>
	...

8000d3a0 <__fsym_pinMode_name>:
8000d3a0:	6970                	flw	fa2,84(a0)
8000d3a2:	4d6e                	lw	s10,216(sp)
8000d3a4:	0065646f          	jal	s0,800633aa <_sp+0x233aa>
8000d3a8:	7872                	flw	fa6,60(sp)
8000d3aa:	665f 6669 206f      	0x206f6669665f
8000d3b0:	3d21                	jal	8000d1c8 <__FUNCTION__.3150+0xc4>
8000d3b2:	5220                	lw	s0,96(a2)
8000d3b4:	5f54                	lw	a3,60(a4)
8000d3b6:	554e                	lw	a0,240(sp)
8000d3b8:	4c4c                	lw	a1,28(s0)
8000d3ba:	0000                	unimp
8000d3bc:	7874                	flw	fa3,116(s0)
8000d3be:	665f 6669 206f      	0x206f6669665f
8000d3c4:	3d21                	jal	8000d1dc <__FUNCTION__.3075+0x8>
8000d3c6:	5220                	lw	s0,96(a2)
8000d3c8:	5f54                	lw	a3,60(a4)
8000d3ca:	554e                	lw	a0,240(sp)
8000d3cc:	4c4c                	lw	a1,28(s0)
8000d3ce:	0000                	unimp
8000d3d0:	7874                	flw	fa3,116(s0)
8000d3d2:	2120                	fld	fs0,64(a0)
8000d3d4:	203d                	jal	8000d402 <__fsym_pinMode_name+0x62>
8000d3d6:	5452                	lw	s0,52(sp)
8000d3d8:	4e5f 4c55 004c      	0x4c4c554e5f
8000d3de:	0000                	unimp
8000d3e0:	33335b1b          	0x33335b1b
8000d3e4:	5b6d                	li	s6,-5
8000d3e6:	41552f57          	0x41552f57
8000d3ea:	5452                	lw	s0,52(sp)
8000d3ec:	205d                	jal	8000d492 <__FUNCTION__.3482+0x6>
8000d3ee:	0000                	unimp
8000d3f0:	6e726157          	0x6e726157
8000d3f4:	6e69                	lui	t3,0x1a
8000d3f6:	54203a67          	0x54203a67
8000d3fa:	6568                	flw	fa0,76(a0)
8000d3fc:	6572                	flw	fa0,28(sp)
8000d3fe:	6920                	flw	fs0,80(a0)
8000d400:	6f6e2073          	csrs	0x6f6,t3
8000d404:	6520                	flw	fs0,72(a0)
8000d406:	6f6e                	flw	ft10,216(sp)
8000d408:	6775                	lui	a4,0x1d
8000d40a:	2068                	fld	fa0,192(s0)
8000d40c:	7562                	flw	fa0,56(sp)
8000d40e:	6666                	flw	fa2,88(sp)
8000d410:	7265                	lui	tp,0xffff9
8000d412:	6620                	flw	fs0,72(a2)
8000d414:	7320726f          	jal	tp,80014b46 <__fini_array_end+0x6066>
8000d418:	7661                	lui	a2,0xffff8
8000d41a:	6e69                	lui	t3,0x1a
8000d41c:	61642067          	0x61642067
8000d420:	6174                	flw	fa3,68(a0)
8000d422:	202c                	fld	fa1,64(s0)
8000d424:	6c70                	flw	fa2,92(s0)
8000d426:	6165                	addi	sp,sp,112
8000d428:	69206573          	csrrsi	a0,0x692,0
8000d42c:	636e                	flw	ft6,216(sp)
8000d42e:	6572                	flw	fa0,28(sp)
8000d430:	7361                	lui	t1,0xffff8
8000d432:	2065                	jal	8000d4da <__FUNCTION__.3515+0xe>
8000d434:	6874                	flw	fa3,84(s0)
8000d436:	2065                	jal	8000d4de <__FUNCTION__.3515+0x12>
8000d438:	5452                	lw	s0,52(sp)
8000d43a:	535f 5245 4149      	0x41495245535f
8000d440:	5f4c                	lw	a1,60(a4)
8000d442:	4252                	lw	tp,20(sp)
8000d444:	425f 4655 5a53      	0x5a534655425f
8000d44a:	6f20                	flw	fs0,88(a4)
8000d44c:	7470                	flw	fa2,108(s0)
8000d44e:	6f69                	lui	t5,0x1a
8000d450:	2e6e                	fld	ft8,216(sp)
8000d452:	0000                	unimp
8000d454:	6d305b1b          	0x6d305b1b
8000d458:	000a                	c.slli	zero,0x2
	...

8000d45c <__FUNCTION__.3449>:
8000d45c:	735f 7265 6169      	0x61697265735f
8000d462:	5f6c                	lw	a1,124(a4)
8000d464:	6e69                	lui	t3,0x1a
8000d466:	5f74                	lw	a3,124(a4)
8000d468:	7872                	flw	fa6,60(sp)
	...

8000d46c <__FUNCTION__.3462>:
8000d46c:	735f 7265 6169      	0x61697265735f
8000d472:	5f6c                	lw	a1,124(a4)
8000d474:	6e69                	lui	t3,0x1a
8000d476:	5f74                	lw	a3,124(a4)
8000d478:	7874                	flw	fa3,116(s0)
	...

8000d47c <__FUNCTION__.3475>:
8000d47c:	7472                	flw	fs0,60(sp)
8000d47e:	735f 7265 6169      	0x61697265735f
8000d484:	5f6c                	lw	a1,124(a4)
8000d486:	6e69                	lui	t3,0x1a
8000d488:	7469                	lui	s0,0xffffa
	...

8000d48c <__FUNCTION__.3482>:
8000d48c:	7472                	flw	fs0,60(sp)
8000d48e:	735f 7265 6169      	0x61697265735f
8000d494:	5f6c                	lw	a1,124(a4)
8000d496:	6e65706f          	j	80064b7c <_sp+0x24b7c>
	...

8000d49c <__FUNCTION__.3489>:
8000d49c:	7472                	flw	fs0,60(sp)
8000d49e:	735f 7265 6169      	0x61697265735f
8000d4a4:	5f6c                	lw	a1,124(a4)
8000d4a6:	736f6c63          	bltu	t5,s6,8000dbde <__rti_finsh_system_init_name+0x4ea>
8000d4aa:	0065                	c.nop	25

8000d4ac <__FUNCTION__.3499>:
8000d4ac:	7472                	flw	fs0,60(sp)
8000d4ae:	735f 7265 6169      	0x61697265735f
8000d4b4:	5f6c                	lw	a1,124(a4)
8000d4b6:	6572                	flw	fa0,28(sp)
8000d4b8:	6461                	lui	s0,0x18
	...

8000d4bc <__FUNCTION__.3507>:
8000d4bc:	7472                	flw	fs0,60(sp)
8000d4be:	735f 7265 6169      	0x61697265735f
8000d4c4:	5f6c                	lw	a1,124(a4)
8000d4c6:	74697277          	0x74697277
8000d4ca:	0065                	c.nop	25

8000d4cc <__FUNCTION__.3515>:
8000d4cc:	7472                	flw	fs0,60(sp)
8000d4ce:	735f 7265 6169      	0x61697265735f
8000d4d4:	5f6c                	lw	a1,124(a4)
8000d4d6:	746e6f63          	bltu	t3,t1,8000dc34 <__rti_finsh_system_init_name+0x540>
8000d4da:	6f72                	flw	ft10,28(sp)
8000d4dc:	006c                	addi	a1,sp,12
	...

8000d4e0 <__FUNCTION__.3530>:
8000d4e0:	7472                	flw	fs0,60(sp)
8000d4e2:	685f 5f77 6573      	0x65735f77685f
8000d4e8:	6972                	flw	fs2,28(sp)
8000d4ea:	6c61                	lui	s8,0x18
8000d4ec:	725f 6765 7369      	0x73696765725f
8000d4f2:	6574                	flw	fa3,76(a0)
8000d4f4:	0072                	c.slli	zero,0x1c
	...

8000d4f8 <__FUNCTION__.3539>:
8000d4f8:	7472                	flw	fs0,60(sp)
8000d4fa:	685f 5f77 6573      	0x65735f77685f
8000d500:	6972                	flw	fs2,28(sp)
8000d502:	6c61                	lui	s8,0x18
8000d504:	695f 7273 0000      	0x7273695f
8000d50a:	0000                	unimp
8000d50c:	706d6f63          	bltu	s10,t1,8000dc2a <__rti_finsh_system_init_name+0x536>
8000d510:	656c                	flw	fa1,76(a0)
8000d512:	6974                	flw	fa3,84(a0)
8000d514:	21206e6f          	jal	t3,80013726 <__fini_array_end+0x4c46>
8000d518:	203d                	jal	8000d546 <__FUNCTION__.3539+0x4e>
8000d51a:	5452                	lw	s0,52(sp)
8000d51c:	4e5f 4c55 004c      	0x4c4c554e5f
8000d522:	0000                	unimp
8000d524:	7472                	flw	fs0,60(sp)
8000d526:	6c5f 7369 5f74      	0x5f7473696c5f
8000d52c:	7369                	lui	t1,0xffffa
8000d52e:	6d65                	lui	s10,0x19
8000d530:	7470                	flw	fa2,108(s0)
8000d532:	2879                	jal	8000d5d0 <__rti_rt_work_sys_workqueue_init_name>
8000d534:	2826                	fld	fa6,72(sp)
8000d536:	706d6f63          	bltu	s10,t1,8000dc54 <__rti_finsh_system_init_name+0x560>
8000d53a:	656c                	flw	fa1,76(a0)
8000d53c:	6974                	flw	fa3,84(a0)
8000d53e:	3e2d6e6f          	jal	t3,800e3920 <_sp+0xa3920>
8000d542:	70737573          	csrrci	a0,0x707,6
8000d546:	6e65                	lui	t3,0x19
8000d548:	6564                	flw	fs1,76(a0)
8000d54a:	5f64                	lw	s1,124(a4)
8000d54c:	696c                	flw	fa1,84(a0)
8000d54e:	29297473          	csrrci	s0,0x292,18
	...

8000d554 <__FUNCTION__.3425>:
8000d554:	7472                	flw	fs0,60(sp)
8000d556:	635f 6d6f 6c70      	0x6c706d6f635f
8000d55c:	7465                	lui	s0,0xffff9
8000d55e:	6f69                	lui	t5,0x1a
8000d560:	5f6e                	lw	t5,248(sp)
8000d562:	6e69                	lui	t3,0x1a
8000d564:	7469                	lui	s0,0xffffa
	...

8000d568 <__FUNCTION__.3433>:
8000d568:	7472                	flw	fs0,60(sp)
8000d56a:	635f 6d6f 6c70      	0x6c706d6f635f
8000d570:	7465                	lui	s0,0xffff9
8000d572:	6f69                	lui	t5,0x1a
8000d574:	5f6e                	lw	t5,248(sp)
8000d576:	74696177          	0x74696177
	...

8000d57c <__FUNCTION__.3440>:
8000d57c:	7472                	flw	fs0,60(sp)
8000d57e:	635f 6d6f 6c70      	0x6c706d6f635f
8000d584:	7465                	lui	s0,0xffff9
8000d586:	6f69                	lui	t5,0x1a
8000d588:	5f6e                	lw	t5,248(sp)
8000d58a:	6f64                	flw	fs1,92(a4)
8000d58c:	656e                	flw	fa0,216(sp)
8000d58e:	0000                	unimp
8000d590:	7571                	lui	a0,0xffffc
8000d592:	7565                	lui	a0,0xffff9
8000d594:	2065                	jal	8000d63c <__rti_rt_work_sys_workqueue_init_name+0x6c>
8000d596:	3d21                	jal	8000d3ae <__fsym_pinMode_name+0xe>
8000d598:	5220                	lw	s0,96(a2)
8000d59a:	5f54                	lw	a3,60(a4)
8000d59c:	554e                	lw	a0,240(sp)
8000d59e:	4c4c                	lw	a1,28(s0)
8000d5a0:	0000                	unimp
8000d5a2:	0000                	unimp
8000d5a4:	65757177          	0x65757177
8000d5a8:	6575                	lui	a0,0x1d
8000d5aa:	0000                	unimp
8000d5ac:	5f737973          	csrrci	s2,0x5f7,6
8000d5b0:	6b726f77          	0x6b726f77
8000d5b4:	0000                	unimp
	...

8000d5b8 <__FUNCTION__.3435>:
8000d5b8:	775f 726f 716b      	0x716b726f775f
8000d5be:	6575                	lui	a0,0x1d
8000d5c0:	6575                	lui	a0,0x1d
8000d5c2:	745f 7268 6165      	0x61657268745f
8000d5c8:	5f64                	lw	s1,124(a4)
8000d5ca:	6e65                	lui	t3,0x19
8000d5cc:	7274                	flw	fa3,100(a2)
8000d5ce:	0079                	c.nop	30

8000d5d0 <__rti_rt_work_sys_workqueue_init_name>:
8000d5d0:	7472                	flw	fs0,60(sp)
8000d5d2:	775f 726f 5f6b      	0x5f6b726f775f
8000d5d8:	5f737973          	csrrci	s2,0x5f7,6
8000d5dc:	6b726f77          	0x6b726f77
8000d5e0:	7571                	lui	a0,0xffffc
8000d5e2:	7565                	lui	a0,0xffff9
8000d5e4:	5f65                	li	t5,-7
8000d5e6:	6e69                	lui	t3,0x1a
8000d5e8:	7469                	lui	s0,0xffffa
8000d5ea:	0000                	unimp
8000d5ec:	6c656873          	csrrsi	a6,0x6c6,10
8000d5f0:	206c                	fld	fa1,192(s0)
8000d5f2:	3d21                	jal	8000d40a <__fsym_pinMode_name+0x6a>
8000d5f4:	5220                	lw	s0,96(a2)
8000d5f6:	5f54                	lw	a3,60(a4)
8000d5f8:	554e                	lw	a0,240(sp)
8000d5fa:	4c4c                	lw	a1,28(s0)
8000d5fc:	0000                	unimp
8000d5fe:	0000                	unimp
8000d600:	736d                	lui	t1,0xffffb
8000d602:	2068                	fld	fa0,192(s0)
8000d604:	0000                	unimp
8000d606:	0000                	unimp
8000d608:	6966                	flw	fs2,88(sp)
8000d60a:	736e                	flw	ft6,248(sp)
8000d60c:	2068                	fld	fa0,192(s0)
8000d60e:	0000                	unimp
8000d610:	003e                	c.slli	zero,0xf
8000d612:	0000                	unimp
8000d614:	4b325b1b          	0x4b325b1b
8000d618:	000d                	c.nop	3
8000d61a:	0000                	unimp
8000d61c:	7325                	lui	t1,0xfffe9
8000d61e:	7325                	lui	t1,0xfffe9
8000d620:	0000                	unimp
8000d622:	0000                	unimp
8000d624:	6f6e                	flw	ft10,216(sp)
8000d626:	6d20                	flw	fs0,88(a0)
8000d628:	6d65                	lui	s10,0x19
8000d62a:	2079726f          	jal	tp,800a5030 <_sp+0x65030>
8000d62e:	6f66                	flw	ft10,88(sp)
8000d630:	2072                	fld	ft0,280(sp)
8000d632:	6c656873          	csrrsi	a6,0x6c6,10
8000d636:	0a6c                	addi	a1,sp,284
8000d638:	0000                	unimp
8000d63a:	0000                	unimp
8000d63c:	7374                	flw	fa3,100(a4)
8000d63e:	6568                	flw	fa0,76(a0)
8000d640:	6c6c                	flw	fa1,92(s0)
8000d642:	0000                	unimp
8000d644:	78726873          	csrrsi	a6,0x787,4
8000d648:	0000                	unimp
8000d64a:	0000                	unimp
8000d64c:	6966                	flw	fs2,88(sp)
8000d64e:	736e                	flw	ft6,248(sp)
8000d650:	3a68                	fld	fa0,240(a2)
8000d652:	6320                	flw	fs0,64(a4)
8000d654:	6e61                	lui	t3,0x18
8000d656:	6e20                	flw	fs0,88(a2)
8000d658:	6620746f          	jal	s0,80014cba <__fini_array_end+0x61da>
8000d65c:	6e69                	lui	t3,0x1a
8000d65e:	2064                	fld	fs1,192(s0)
8000d660:	6564                	flw	fs1,76(a0)
8000d662:	6976                	flw	fs2,92(sp)
8000d664:	203a6563          	bltu	s4,gp,8000d86e <__rti_finsh_system_init_name+0x17a>
8000d668:	7325                	lui	t1,0xfffe9
8000d66a:	000a                	c.slli	zero,0x2
8000d66c:	2709                	jal	8000dd6e <__rti_finsh_system_init_name+0x67a>
8000d66e:	6325                	lui	t1,0x9
8000d670:	25202c27          	fsw	fs2,600(zero) # 258 <__HEAP_SIZE-0x1da8>
8000d674:	2c64                	fld	fs1,216(s0)
8000d676:	3020                	fld	fs0,96(s0)
8000d678:	2578                	fld	fa4,200(a0)
8000d67a:	3830                	fld	fa2,112(s0)
8000d67c:	0a78                	addi	a4,sp,284
8000d67e:	0000                	unimp
8000d680:	2509                	jal	8000dc82 <__rti_finsh_system_init_name+0x58e>
8000d682:	2c64                	fld	fs1,216(s0)
8000d684:	3020                	fld	fs0,96(s0)
8000d686:	2578                	fld	fa4,200(a0)
8000d688:	3830                	fld	fa2,112(s0)
8000d68a:	0a78                	addi	a4,sp,284
8000d68c:	0000                	unimp
8000d68e:	0000                	unimp
8000d690:	0008                	0x8
8000d692:	0000                	unimp
8000d694:	6325                	lui	t1,0x9
8000d696:	0000                	unimp
8000d698:	2508                	fld	fa0,8(a0)
8000d69a:	08202073          	csrr	zero,0x82
8000d69e:	0000                	unimp
8000d6a0:	2008                	fld	fa0,0(s0)
8000d6a2:	0008                	0x8
8000d6a4:	7325                	lui	t1,0xfffe9
	...

8000d6a8 <__FUNCTION__.4613>:
8000d6a8:	6966                	flw	fs2,88(sp)
8000d6aa:	736e                	flw	ft6,248(sp)
8000d6ac:	5f68                	lw	a0,124(a4)
8000d6ae:	5f746573          	csrrsi	a0,0x5f7,8
8000d6b2:	7270                	flw	fa2,100(a2)
8000d6b4:	74706d6f          	jal	s10,800145fa <__fini_array_end+0x5b1a>
8000d6b8:	6d5f 646f 0065      	0x65646f6d5f
	...

8000d6c0 <__FUNCTION__.4618>:
8000d6c0:	6966                	flw	fs2,88(sp)
8000d6c2:	736e                	flw	ft6,248(sp)
8000d6c4:	5f68                	lw	a0,124(a4)
8000d6c6:	63746567          	0x63746567
8000d6ca:	6168                	flw	fa0,68(a0)
8000d6cc:	0072                	c.slli	zero,0x1c
	...

8000d6d0 <__FUNCTION__.4626>:
8000d6d0:	6966                	flw	fs2,88(sp)
8000d6d2:	736e                	flw	ft6,248(sp)
8000d6d4:	5f68                	lw	a0,124(a4)
8000d6d6:	7872                	flw	fa6,60(sp)
8000d6d8:	695f 646e 0000      	0x646e695f
	...

8000d6e0 <__FUNCTION__.4631>:
8000d6e0:	6966                	flw	fs2,88(sp)
8000d6e2:	736e                	flw	ft6,248(sp)
8000d6e4:	5f68                	lw	a0,124(a4)
8000d6e6:	5f746573          	csrrsi	a0,0x5f7,8
8000d6ea:	6564                	flw	fs1,76(a0)
8000d6ec:	6976                	flw	fs2,92(sp)
8000d6ee:	00006563          	bltu	zero,zero,8000d6f8 <__rti_finsh_system_init_name+0x4>
	...

8000d6f4 <__rti_finsh_system_init_name>:
8000d6f4:	6966                	flw	fs2,88(sp)
8000d6f6:	736e                	flw	ft6,248(sp)
8000d6f8:	5f68                	lw	a0,124(a4)
8000d6fa:	74737973          	csrrci	s2,0x747,6
8000d6fe:	6d65                	lui	s10,0x19
8000d700:	695f 696e 0074      	0x74696e695f
8000d706:	0000                	unimp
8000d708:	6548                	flw	fa0,12(a0)
8000d70a:	6c6c                	flw	fa1,92(s0)
8000d70c:	5452206f          	j	80030450 <_end+0xf438>
8000d710:	542d                	li	s0,-21
8000d712:	7268                	flw	fa0,100(a2)
8000d714:	6165                	addi	sp,sp,112
8000d716:	2164                	fld	fs1,192(a0)
8000d718:	000a                	c.slli	zero,0x2
8000d71a:	0000                	unimp
8000d71c:	4a325b1b          	0x4a325b1b
8000d720:	00485b1b          	0x485b1b
8000d724:	0000002f          	0x2f
8000d728:	2d2d                	jal	8000dd62 <__rti_finsh_system_init_name+0x66e>
8000d72a:	7546                	flw	fa0,112(sp)
8000d72c:	636e                	flw	ft6,216(sp)
8000d72e:	6974                	flw	fa3,84(a0)
8000d730:	4c206e6f          	jal	t3,80013bf2 <__fini_array_end+0x5112>
8000d734:	7369                	lui	t1,0xffffa
8000d736:	3a74                	fld	fa3,240(a2)
8000d738:	000a                	c.slli	zero,0x2
8000d73a:	0000                	unimp
8000d73c:	5f5f 0000 2d25      	0x2d2500005f5f
8000d742:	3631                	jal	8000d24e <__FUNCTION__.3128+0x3a>
8000d744:	2d2d2073          	csrs	0x2d2,s10
8000d748:	2520                	fld	fs0,72(a0)
8000d74a:	00000a73          	0xa73
8000d74e:	0000                	unimp
8000d750:	205d6c5b          	0x205d6c5b
8000d754:	7325                	lui	t1,0xfffe9
8000d756:	000a                	c.slli	zero,0x2
8000d758:	2d2d                	jal	8000dd92 <device_type_str+0x1a>
8000d75a:	6156                	flw	ft2,84(sp)
8000d75c:	6972                	flw	fs2,28(sp)
8000d75e:	6261                	lui	tp,0x18
8000d760:	656c                	flw	fa1,76(a0)
8000d762:	4c20                	lw	s0,88(s0)
8000d764:	7369                	lui	t1,0xffffa
8000d766:	3a74                	fld	fa3,240(a2)
8000d768:	000a                	c.slli	zero,0x2
8000d76a:	0000                	unimp
8000d76c:	002d                	c.nop	11
8000d76e:	0000                	unimp
8000d770:	6874                	flw	fa3,84(s0)
8000d772:	6572                	flw	fa0,28(sp)
8000d774:	6461                	lui	s0,0x18
8000d776:	0000                	unimp
8000d778:	2d25                	jal	8000ddb0 <device_type_str+0x38>
8000d77a:	2e2a                	fld	ft8,136(sp)
8000d77c:	72702073          	csrr	zero,0x727
8000d780:	2069                	jal	8000d80a <__rti_finsh_system_init_name+0x116>
8000d782:	7320                	flw	fs0,96(a4)
8000d784:	6174                	flw	fa3,68(a0)
8000d786:	7574                	flw	fa3,108(a0)
8000d788:	20202073          	csrr	zero,hedeleg
8000d78c:	2020                	fld	fs0,64(s0)
8000d78e:	7320                	flw	fs0,96(a4)
8000d790:	2070                	fld	fa2,192(s0)
8000d792:	2020                	fld	fs0,64(s0)
8000d794:	2020                	fld	fs0,64(s0)
8000d796:	63617473          	csrrci	s0,0x636,2
8000d79a:	6973206b          	0x6973206b
8000d79e:	657a                	flw	fa0,156(sp)
8000d7a0:	6d20                	flw	fs0,88(a0)
8000d7a2:	7861                	lui	a6,0xffff8
8000d7a4:	7520                	flw	fs0,104(a0)
8000d7a6:	20646573          	csrrsi	a0,0x206,8
8000d7aa:	656c                	flw	fa1,76(a0)
8000d7ac:	7466                	flw	fs0,120(sp)
8000d7ae:	7420                	flw	fs0,104(s0)
8000d7b0:	6369                	lui	t1,0x1a
8000d7b2:	6520206b          	0x6520206b
8000d7b6:	7272                	flw	ft4,60(sp)
8000d7b8:	000a726f          	jal	tp,800b47b8 <_sp+0x747b8>
8000d7bc:	2d20                	fld	fs0,88(a0)
8000d7be:	2d2d                	jal	8000ddf8 <__fsym_list_desc+0x4>
8000d7c0:	2020                	fld	fs0,64(s0)
8000d7c2:	2d2d                	jal	8000ddfc <__fsym_list_desc+0x8>
8000d7c4:	2d2d                	jal	8000ddfe <__fsym_list_desc+0xa>
8000d7c6:	2d2d                	jal	8000de00 <__fsym_list_desc+0xc>
8000d7c8:	202d                	jal	8000d7f2 <__rti_finsh_system_init_name+0xfe>
8000d7ca:	2d2d                	jal	8000de04 <__fsym_list_desc+0x10>
8000d7cc:	2d2d                	jal	8000de06 <__fsym_list_desc+0x12>
8000d7ce:	2d2d                	jal	8000de08 <__fsym_list_desc+0x14>
8000d7d0:	2d2d                	jal	8000de0a <__fsym_list_desc+0x16>
8000d7d2:	2d2d                	jal	8000de0c <__fsym_list_desc+0x18>
8000d7d4:	2d20                	fld	fs0,88(a0)
8000d7d6:	2d2d                	jal	8000de10 <__fsym_list_name>
8000d7d8:	2d2d                	jal	8000de12 <__fsym_list_name+0x2>
8000d7da:	2d2d                	jal	8000de14 <__fsym_list_name+0x4>
8000d7dc:	2d2d                	jal	8000de16 <__fsym_list_name+0x6>
8000d7de:	202d                	jal	8000d808 <__rti_finsh_system_init_name+0x114>
8000d7e0:	2d20                	fld	fs0,88(a0)
8000d7e2:	2d2d                	jal	8000de1c <__fsym___cmd_list_device_desc+0x4>
8000d7e4:	2d2d                	jal	8000de1e <__fsym___cmd_list_device_desc+0x6>
8000d7e6:	202d                	jal	8000d810 <__rti_finsh_system_init_name+0x11c>
8000d7e8:	2d20                	fld	fs0,88(a0)
8000d7ea:	2d2d                	jal	8000de24 <__fsym___cmd_list_device_desc+0xc>
8000d7ec:	2d2d                	jal	8000de26 <__fsym___cmd_list_device_desc+0xe>
8000d7ee:	2d2d                	jal	8000de28 <__fsym___cmd_list_device_desc+0x10>
8000d7f0:	2d2d                	jal	8000de2a <__fsym___cmd_list_device_desc+0x12>
8000d7f2:	202d                	jal	8000d81c <__rti_finsh_system_init_name+0x128>
8000d7f4:	2d2d                	jal	8000de2e <__fsym___cmd_list_device_desc+0x16>
8000d7f6:	0a2d                	addi	s4,s4,11
8000d7f8:	0000                	unimp
8000d7fa:	0000                	unimp
8000d7fc:	2d25                	jal	8000de34 <__fsym___cmd_list_device_name+0x4>
8000d7fe:	2e2a                	fld	ft8,136(sp)
8000d800:	732a                	flw	ft6,168(sp)
8000d802:	2520                	fld	fs0,72(a0)
8000d804:	00206433          	or	s0,zero,sp
8000d808:	7220                	flw	fs0,96(a2)
8000d80a:	6165                	addi	sp,sp,112
8000d80c:	7964                	flw	fs1,116(a0)
8000d80e:	2020                	fld	fs0,64(s0)
8000d810:	0000                	unimp
8000d812:	0000                	unimp
8000d814:	7320                	flw	fs0,96(a4)
8000d816:	7375                	lui	t1,0xffffd
8000d818:	6570                	flw	fa2,76(a0)
8000d81a:	646e                	flw	fs0,216(sp)
8000d81c:	0000                	unimp
8000d81e:	0000                	unimp
8000d820:	6920                	flw	fs0,80(a0)
8000d822:	696e                	flw	fs2,216(sp)
8000d824:	2074                	fld	fa3,192(s0)
8000d826:	2020                	fld	fs0,64(s0)
8000d828:	0000                	unimp
8000d82a:	0000                	unimp
8000d82c:	6320                	flw	fs0,64(a4)
8000d82e:	6f6c                	flw	fa1,92(a4)
8000d830:	20206573          	csrrsi	a0,hedeleg,0
8000d834:	0000                	unimp
8000d836:	0000                	unimp
8000d838:	7220                	flw	fs0,96(a2)
8000d83a:	6e75                	lui	t3,0x1d
8000d83c:	696e                	flw	fs2,216(sp)
8000d83e:	676e                	flw	fa4,216(sp)
8000d840:	0000                	unimp
8000d842:	0000                	unimp
8000d844:	3020                	fld	fs0,96(s0)
8000d846:	2578                	fld	fa4,200(a0)
8000d848:	3830                	fld	fa2,112(s0)
8000d84a:	2078                	fld	fa4,192(s0)
8000d84c:	7830                	flw	fa2,112(s0)
8000d84e:	3025                	jal	8000d076 <__FUNCTION__.3085+0x10a>
8000d850:	7838                	flw	fa4,112(s0)
8000d852:	2020                	fld	fs0,64(s0)
8000d854:	2020                	fld	fs0,64(s0)
8000d856:	3025                	jal	8000d07e <__FUNCTION__.3085+0x112>
8000d858:	6432                	flw	fs0,12(sp)
8000d85a:	2525                	jal	8000de82 <__fsym___cmd_list_timer_name+0x2>
8000d85c:	2020                	fld	fs0,64(s0)
8000d85e:	3020                	fld	fs0,96(s0)
8000d860:	2578                	fld	fa4,200(a0)
8000d862:	3830                	fld	fa2,112(s0)
8000d864:	2078                	fld	fa4,192(s0)
8000d866:	3025                	jal	8000d08e <__FUNCTION__.3085+0x122>
8000d868:	000a6433          	or	s0,s4,zero
8000d86c:	6e55                	lui	t3,0x15
8000d86e:	776f6e6b          	0x776f6e6b
8000d872:	006e                	c.slli	zero,0x1b
8000d874:	6564                	flw	fs1,76(a0)
8000d876:	6976                	flw	fs2,92(sp)
8000d878:	00006563          	bltu	zero,zero,8000d882 <__rti_finsh_system_init_name+0x18e>
8000d87c:	2d25                	jal	8000deb4 <__fsym_list_timer_name+0x8>
8000d87e:	2e2a                	fld	ft8,136(sp)
8000d880:	20202073          	csrr	zero,hedeleg
8000d884:	2020                	fld	fs0,64(s0)
8000d886:	2020                	fld	fs0,64(s0)
8000d888:	2020                	fld	fs0,64(s0)
8000d88a:	7974                	flw	fa3,116(a0)
8000d88c:	6570                	flw	fa2,76(a0)
8000d88e:	2020                	fld	fs0,64(s0)
8000d890:	2020                	fld	fs0,64(s0)
8000d892:	2020                	fld	fs0,64(s0)
8000d894:	2020                	fld	fs0,64(s0)
8000d896:	7220                	flw	fs0,96(a2)
8000d898:	6665                	lui	a2,0x19
8000d89a:	6320                	flw	fs0,64(a4)
8000d89c:	746e756f          	jal	a0,800f4fe2 <_sp+0xb4fe2>
8000d8a0:	000a                	c.slli	zero,0x2
8000d8a2:	0000                	unimp
8000d8a4:	2d20                	fld	fs0,88(a0)
8000d8a6:	2d2d                	jal	8000dee0 <__fsym___cmd_list_mempool_name+0xc>
8000d8a8:	2d2d                	jal	8000dee2 <__fsym___cmd_list_mempool_name+0xe>
8000d8aa:	2d2d                	jal	8000dee4 <__fsym___cmd_list_mempool_name+0x10>
8000d8ac:	2d2d                	jal	8000dee6 <__fsym___cmd_list_mempool_name+0x12>
8000d8ae:	2d2d                	jal	8000dee8 <__fsym_list_mempool_desc>
8000d8b0:	2d2d                	jal	8000deea <__fsym_list_mempool_desc+0x2>
8000d8b2:	2d2d                	jal	8000deec <__fsym_list_mempool_desc+0x4>
8000d8b4:	2d2d                	jal	8000deee <__fsym_list_mempool_desc+0x6>
8000d8b6:	2d2d                	jal	8000def0 <__fsym_list_mempool_desc+0x8>
8000d8b8:	202d                	jal	8000d8e2 <__rti_finsh_system_init_name+0x1ee>
8000d8ba:	2d2d                	jal	8000def4 <__fsym_list_mempool_desc+0xc>
8000d8bc:	2d2d                	jal	8000def6 <__fsym_list_mempool_desc+0xe>
8000d8be:	2d2d                	jal	8000def8 <__fsym_list_mempool_desc+0x10>
8000d8c0:	2d2d                	jal	8000defa <__fsym_list_mempool_desc+0x12>
8000d8c2:	2d2d                	jal	8000defc <__fsym_list_mempool_desc+0x14>
8000d8c4:	000a                	c.slli	zero,0x2
8000d8c6:	0000                	unimp
8000d8c8:	2d25                	jal	8000df00 <__fsym_list_mempool_desc+0x18>
8000d8ca:	2e2a                	fld	ft8,136(sp)
8000d8cc:	732a                	flw	ft6,168(sp)
8000d8ce:	2520                	fld	fs0,72(a0)
8000d8d0:	322d                	jal	8000d1fa <__FUNCTION__.3104+0x6>
8000d8d2:	7330                	flw	fa2,96(a4)
8000d8d4:	2520                	fld	fs0,72(a0)
8000d8d6:	382d                	jal	8000d110 <__FUNCTION__.3150+0xc>
8000d8d8:	0a64                	addi	s1,sp,284
8000d8da:	0000                	unimp
8000d8dc:	756d                	lui	a0,0xffffb
8000d8de:	6574                	flw	fa3,76(a0)
8000d8e0:	0078                	addi	a4,sp,12
8000d8e2:	0000                	unimp
8000d8e4:	2d25                	jal	8000df1c <__fsym___cmd_list_msgqueue_desc+0x8>
8000d8e6:	2e2a                	fld	ft8,136(sp)
8000d8e8:	20202073          	csrr	zero,hedeleg
8000d8ec:	656e776f          	jal	a4,800f4f42 <_sp+0xb4f42>
8000d8f0:	2072                	fld	ft0,280(sp)
8000d8f2:	6820                	flw	fs0,80(s0)
8000d8f4:	20646c6f          	jal	s8,80053afa <_sp+0x13afa>
8000d8f8:	70737573          	csrrci	a0,0x707,6
8000d8fc:	6e65                	lui	t3,0x19
8000d8fe:	2064                	fld	fs1,192(s0)
8000d900:	6874                	flw	fa3,84(s0)
8000d902:	6572                	flw	fa0,28(sp)
8000d904:	6461                	lui	s0,0x18
8000d906:	000a                	c.slli	zero,0x2
8000d908:	2d20                	fld	fs0,88(a0)
8000d90a:	2d2d                	jal	8000df44 <__fsym___cmd_list_msgqueue_name+0x10>
8000d90c:	2d2d                	jal	8000df46 <__fsym___cmd_list_msgqueue_name+0x12>
8000d90e:	2d2d                	jal	8000df48 <__fsym_list_msgqueue_desc>
8000d910:	202d                	jal	8000d93a <__rti_finsh_system_init_name+0x246>
8000d912:	2d2d                	jal	8000df4c <__fsym_list_msgqueue_desc+0x4>
8000d914:	2d2d                	jal	8000df4e <__fsym_list_msgqueue_desc+0x6>
8000d916:	2d20                	fld	fs0,88(a0)
8000d918:	2d2d                	jal	8000df52 <__fsym_list_msgqueue_desc+0xa>
8000d91a:	2d2d                	jal	8000df54 <__fsym_list_msgqueue_desc+0xc>
8000d91c:	2d2d                	jal	8000df56 <__fsym_list_msgqueue_desc+0xe>
8000d91e:	2d2d                	jal	8000df58 <__fsym_list_msgqueue_desc+0x10>
8000d920:	2d2d                	jal	8000df5a <__fsym_list_msgqueue_desc+0x12>
8000d922:	2d2d                	jal	8000df5c <__fsym_list_msgqueue_desc+0x14>
8000d924:	0a2d                	addi	s4,s4,11
8000d926:	0000                	unimp
8000d928:	2d25                	jal	8000df60 <__fsym_list_msgqueue_desc+0x18>
8000d92a:	2e2a                	fld	ft8,136(sp)
8000d92c:	732a                	flw	ft6,168(sp)
8000d92e:	2520                	fld	fs0,72(a0)
8000d930:	382d                	jal	8000d16a <__FUNCTION__.3150+0x66>
8000d932:	2a2e                	fld	fs4,200(sp)
8000d934:	30252073          	csrs	medeleg,a0
8000d938:	6434                	flw	fa3,72(s0)
8000d93a:	2520                	fld	fs0,72(a0)
8000d93c:	0a64                	addi	s1,sp,284
8000d93e:	0000                	unimp
8000d940:	2d25                	jal	8000df78 <__fsym___cmd_list_mailbox_desc>
8000d942:	2e2a                	fld	ft8,136(sp)
8000d944:	70202073          	csrr	zero,0x702
8000d948:	7265                	lui	tp,0xffff9
8000d94a:	6f69                	lui	t5,0x1a
8000d94c:	6964                	flw	fs1,84(a0)
8000d94e:	20202063          	0x20202063
8000d952:	6974                	flw	fa3,84(a0)
8000d954:	656d                	lui	a0,0x1b
8000d956:	2074756f          	jal	a0,8005535c <_sp+0x1535c>
8000d95a:	2020                	fld	fs0,64(s0)
8000d95c:	2020                	fld	fs0,64(s0)
8000d95e:	2020                	fld	fs0,64(s0)
8000d960:	6c66                	flw	fs8,88(sp)
8000d962:	6761                	lui	a4,0x18
8000d964:	000a                	c.slli	zero,0x2
8000d966:	0000                	unimp
8000d968:	2d20                	fld	fs0,88(a0)
8000d96a:	2d2d                	jal	8000dfa4 <__fsym_list_mailbox_desc>
8000d96c:	2d2d                	jal	8000dfa6 <__fsym_list_mailbox_desc+0x2>
8000d96e:	2d2d                	jal	8000dfa8 <__fsym_list_mailbox_desc+0x4>
8000d970:	2d2d                	jal	8000dfaa <__fsym_list_mailbox_desc+0x6>
8000d972:	202d                	jal	8000d99c <__rti_finsh_system_init_name+0x2a8>
8000d974:	2d2d                	jal	8000dfae <__fsym_list_mailbox_desc+0xa>
8000d976:	2d2d                	jal	8000dfb0 <__fsym_list_mailbox_desc+0xc>
8000d978:	2d2d                	jal	8000dfb2 <__fsym_list_mailbox_desc+0xe>
8000d97a:	2d2d                	jal	8000dfb4 <__fsym_list_mailbox_desc+0x10>
8000d97c:	2d2d                	jal	8000dfb6 <__fsym_list_mailbox_desc+0x12>
8000d97e:	2d20                	fld	fs0,88(a0)
8000d980:	2d2d                	jal	8000dfba <__fsym_list_mailbox_desc+0x16>
8000d982:	2d2d                	jal	8000dfbc <__fsym_list_mailbox_name>
8000d984:	2d2d                	jal	8000dfbe <__fsym_list_mailbox_name+0x2>
8000d986:	2d2d                	jal	8000dfc0 <__fsym_list_mailbox_name+0x4>
8000d988:	2d2d                	jal	8000dfc2 <__fsym_list_mailbox_name+0x6>
8000d98a:	000a                	c.slli	zero,0x2
8000d98c:	2d25                	jal	8000dfc4 <__fsym_list_mailbox_name+0x8>
8000d98e:	2e2a                	fld	ft8,136(sp)
8000d990:	732a                	flw	ft6,168(sp)
8000d992:	3020                	fld	fs0,96(s0)
8000d994:	2578                	fld	fa4,200(a0)
8000d996:	3830                	fld	fa2,112(s0)
8000d998:	2078                	fld	fa4,192(s0)
8000d99a:	7830                	flw	fa2,112(s0)
8000d99c:	3025                	jal	8000d1c4 <__FUNCTION__.3150+0xc0>
8000d99e:	7838                	flw	fa4,112(s0)
8000d9a0:	0020                	addi	s0,sp,8
8000d9a2:	0000                	unimp
8000d9a4:	6361                	lui	t1,0x18
8000d9a6:	6974                	flw	fa3,84(a0)
8000d9a8:	6176                	flw	ft2,92(sp)
8000d9aa:	6574                	flw	fa3,76(a0)
8000d9ac:	0a64                	addi	s1,sp,284
8000d9ae:	0000                	unimp
8000d9b0:	6564                	flw	fs1,76(a0)
8000d9b2:	6361                	lui	t1,0x18
8000d9b4:	6974                	flw	fa3,84(a0)
8000d9b6:	6176                	flw	ft2,92(sp)
8000d9b8:	6574                	flw	fa3,76(a0)
8000d9ba:	0a64                	addi	s1,sp,284
8000d9bc:	0000                	unimp
8000d9be:	0000                	unimp
8000d9c0:	72727563          	bgeu	tp,t2,8000e0ea <__fsym_list_thread_desc+0xa>
8000d9c4:	6e65                	lui	t3,0x19
8000d9c6:	2074                	fld	fa3,192(s0)
8000d9c8:	6974                	flw	fa3,84(a0)
8000d9ca:	303a6b63          	bltu	s4,gp,8000dce0 <__rti_finsh_system_init_name+0x5ec>
8000d9ce:	2578                	fld	fa4,200(a0)
8000d9d0:	3830                	fld	fa2,112(s0)
8000d9d2:	0a78                	addi	a4,sp,284
8000d9d4:	0000                	unimp
8000d9d6:	0000                	unimp
8000d9d8:	7665                	lui	a2,0xffff9
8000d9da:	6e65                	lui	t3,0x19
8000d9dc:	0074                	addi	a3,sp,12
8000d9de:	0000                	unimp
8000d9e0:	2d25                	jal	8000e018 <__fsym_list_mutex_name+0x8>
8000d9e2:	2e2a                	fld	ft8,136(sp)
8000d9e4:	20202073          	csrr	zero,hedeleg
8000d9e8:	2020                	fld	fs0,64(s0)
8000d9ea:	7320                	flw	fs0,96(a4)
8000d9ec:	7465                	lui	s0,0xffff9
8000d9ee:	2020                	fld	fs0,64(s0)
8000d9f0:	2020                	fld	fs0,64(s0)
8000d9f2:	70737573          	csrrci	a0,0x707,6
8000d9f6:	6e65                	lui	t3,0x19
8000d9f8:	2064                	fld	fs1,192(s0)
8000d9fa:	6874                	flw	fa3,84(s0)
8000d9fc:	6572                	flw	fa0,28(sp)
8000d9fe:	6461                	lui	s0,0x18
8000da00:	000a                	c.slli	zero,0x2
8000da02:	0000                	unimp
8000da04:	2020                	fld	fs0,64(s0)
8000da06:	2d2d                	jal	8000e040 <__fsym___cmd_list_event_name+0xc>
8000da08:	2d2d                	jal	8000e042 <__fsym___cmd_list_event_name+0xe>
8000da0a:	2d2d                	jal	8000e044 <__fsym___cmd_list_event_name+0x10>
8000da0c:	2d2d                	jal	8000e046 <__fsym___cmd_list_event_name+0x12>
8000da0e:	2d2d                	jal	8000e048 <__fsym_list_event_desc>
8000da10:	2d20                	fld	fs0,88(a0)
8000da12:	2d2d                	jal	8000e04c <__fsym_list_event_desc+0x4>
8000da14:	2d2d                	jal	8000e04e <__fsym_list_event_desc+0x6>
8000da16:	2d2d                	jal	8000e050 <__fsym_list_event_desc+0x8>
8000da18:	2d2d                	jal	8000e052 <__fsym_list_event_desc+0xa>
8000da1a:	2d2d                	jal	8000e054 <__fsym_list_event_desc+0xc>
8000da1c:	2d2d                	jal	8000e056 <__fsym_list_event_desc+0xe>
8000da1e:	0a2d                	addi	s4,s4,11
8000da20:	0000                	unimp
8000da22:	0000                	unimp
8000da24:	2d25                	jal	8000e05c <__fsym_list_event_desc+0x14>
8000da26:	2e2a                	fld	ft8,136(sp)
8000da28:	732a                	flw	ft6,168(sp)
8000da2a:	2020                	fld	fs0,64(s0)
8000da2c:	7830                	flw	fa2,112(s0)
8000da2e:	3025                	jal	8000d256 <__FUNCTION__.3128+0x42>
8000da30:	7838                	flw	fa4,112(s0)
8000da32:	2520                	fld	fs0,72(a0)
8000da34:	3330                	fld	fa2,96(a4)
8000da36:	3a64                	fld	fs1,240(a2)
8000da38:	0000                	unimp
8000da3a:	0000                	unimp
8000da3c:	2d25                	jal	8000e074 <__fsym___cmd_list_sem_desc+0x8>
8000da3e:	2e2a                	fld	ft8,136(sp)
8000da40:	732a                	flw	ft6,168(sp)
8000da42:	2020                	fld	fs0,64(s0)
8000da44:	7830                	flw	fa2,112(s0)
8000da46:	3025                	jal	8000d26e <__FUNCTION__.3128+0x5a>
8000da48:	7838                	flw	fa4,112(s0)
8000da4a:	3020                	fld	fs0,96(s0)
8000da4c:	000a                	c.slli	zero,0x2
8000da4e:	0000                	unimp
8000da50:	736d                	lui	t1,0xffffb
8000da52:	65757167          	0x65757167
8000da56:	6575                	lui	a0,0x1d
8000da58:	0000                	unimp
8000da5a:	0000                	unimp
8000da5c:	2d25                	jal	8000e094 <__fsym___cmd_list_sem_name+0xc>
8000da5e:	2e2a                	fld	ft8,136(sp)
8000da60:	6e652073          	csrs	0x6e6,a0
8000da64:	7274                	flw	fa3,100(a2)
8000da66:	2079                	jal	8000daf4 <__rti_finsh_system_init_name+0x400>
8000da68:	70737573          	csrrci	a0,0x707,6
8000da6c:	6e65                	lui	t3,0x19
8000da6e:	2064                	fld	fs1,192(s0)
8000da70:	6874                	flw	fa3,84(s0)
8000da72:	6572                	flw	fa0,28(sp)
8000da74:	6461                	lui	s0,0x18
8000da76:	000a                	c.slli	zero,0x2
8000da78:	2d20                	fld	fs0,88(a0)
8000da7a:	2d2d                	jal	8000e0b4 <__fsym_list_sem_name>
8000da7c:	202d                	jal	8000daa6 <__rti_finsh_system_init_name+0x3b2>
8000da7e:	2d20                	fld	fs0,88(a0)
8000da80:	2d2d                	jal	8000e0ba <__fsym_list_sem_name+0x6>
8000da82:	2d2d                	jal	8000e0bc <__fsym_list_sem_name+0x8>
8000da84:	2d2d                	jal	8000e0be <__fsym_list_sem_name+0xa>
8000da86:	2d2d                	jal	8000e0c0 <__fsym___cmd_list_thread_desc>
8000da88:	2d2d                	jal	8000e0c2 <__fsym___cmd_list_thread_desc+0x2>
8000da8a:	2d2d                	jal	8000e0c4 <__fsym___cmd_list_thread_desc+0x4>
8000da8c:	0a2d                	addi	s4,s4,11
8000da8e:	0000                	unimp
8000da90:	2d25                	jal	8000e0c8 <__fsym___cmd_list_thread_desc+0x8>
8000da92:	2e2a                	fld	ft8,136(sp)
8000da94:	732a                	flw	ft6,168(sp)
8000da96:	2520                	fld	fs0,72(a0)
8000da98:	3430                	fld	fa2,104(s0)
8000da9a:	2064                	fld	fs1,192(s0)
8000da9c:	2520                	fld	fs0,72(a0)
8000da9e:	3a64                	fld	fs1,240(a2)
8000daa0:	0000                	unimp
8000daa2:	0000                	unimp
8000daa4:	2d25                	jal	8000e0dc <__fsym___cmd_list_thread_name+0x10>
8000daa6:	2e2a                	fld	ft8,136(sp)
8000daa8:	732a                	flw	ft6,168(sp)
8000daaa:	2520                	fld	fs0,72(a0)
8000daac:	3430                	fld	fa2,104(s0)
8000daae:	2064                	fld	fs1,192(s0)
8000dab0:	2520                	fld	fs0,72(a0)
8000dab2:	0a64                	addi	s1,sp,284
8000dab4:	0000                	unimp
8000dab6:	0000                	unimp
8000dab8:	616d6573          	csrrsi	a0,0x616,26
8000dabc:	6870                	flw	fa2,84(s0)
8000dabe:	0065726f          	jal	tp,80064ac4 <_sp+0x24ac4>
8000dac2:	0000                	unimp
8000dac4:	2d25                	jal	8000e0fc <__fsym___cmd_version_desc+0x4>
8000dac6:	2e2a                	fld	ft8,136(sp)
8000dac8:	20762073          	csrs	0x207,a2
8000dacc:	2020                	fld	fs0,64(s0)
8000dace:	70737573          	csrrci	a0,0x707,6
8000dad2:	6e65                	lui	t3,0x19
8000dad4:	2064                	fld	fs1,192(s0)
8000dad6:	6874                	flw	fa3,84(s0)
8000dad8:	6572                	flw	fa0,28(sp)
8000dada:	6461                	lui	s0,0x18
8000dadc:	000a                	c.slli	zero,0x2
8000dade:	0000                	unimp
8000dae0:	2d20                	fld	fs0,88(a0)
8000dae2:	2d2d                	jal	8000e11c <__fsym___cmd_version_name>
8000dae4:	2d20                	fld	fs0,88(a0)
8000dae6:	2d2d                	jal	8000e120 <__fsym___cmd_version_name+0x4>
8000dae8:	2d2d                	jal	8000e122 <__fsym___cmd_version_name+0x6>
8000daea:	2d2d                	jal	8000e124 <__fsym___cmd_version_name+0x8>
8000daec:	2d2d                	jal	8000e126 <__fsym___cmd_version_name+0xa>
8000daee:	2d2d                	jal	8000e128 <__fsym___cmd_version_name+0xc>
8000daf0:	2d2d                	jal	8000e12a <__fsym___cmd_version_name+0xe>
8000daf2:	0a2d                	addi	s4,s4,11
8000daf4:	0000                	unimp
8000daf6:	0000                	unimp
8000daf8:	2d25                	jal	8000e130 <__fsym_version_desc+0x4>
8000dafa:	2e2a                	fld	ft8,136(sp)
8000dafc:	732a                	flw	ft6,168(sp)
8000dafe:	2520                	fld	fs0,72(a0)
8000db00:	3330                	fld	fa2,96(a4)
8000db02:	2064                	fld	fs1,192(s0)
8000db04:	6425                	lui	s0,0x9
8000db06:	003a                	c.slli	zero,0xe
8000db08:	2d25                	jal	8000e140 <__fsym_version_desc+0x14>
8000db0a:	2e2a                	fld	ft8,136(sp)
8000db0c:	732a                	flw	ft6,168(sp)
8000db0e:	2520                	fld	fs0,72(a0)
8000db10:	3330                	fld	fa2,96(a4)
8000db12:	2064                	fld	fs1,192(s0)
8000db14:	6425                	lui	s0,0x9
8000db16:	000a                	c.slli	zero,0x2
8000db18:	616d                	addi	sp,sp,240
8000db1a:	6c69                	lui	s8,0x1a
8000db1c:	6f62                	flw	ft10,24(sp)
8000db1e:	0078                	addi	a4,sp,12
8000db20:	2d25                	jal	8000e158 <__fsym___cmd_clear_desc>
8000db22:	2e2a                	fld	ft8,136(sp)
8000db24:	6e652073          	csrs	0x6e6,a0
8000db28:	7274                	flw	fa3,100(a2)
8000db2a:	2079                	jal	8000dbb8 <__rti_finsh_system_init_name+0x4c4>
8000db2c:	657a6973          	csrrsi	s2,0x657,20
8000db30:	7320                	flw	fs0,96(a4)
8000db32:	7375                	lui	t1,0xffffd
8000db34:	6570                	flw	fa2,76(a0)
8000db36:	646e                	flw	fs0,216(sp)
8000db38:	7420                	flw	fs0,104(s0)
8000db3a:	7268                	flw	fa0,100(a2)
8000db3c:	6165                	addi	sp,sp,112
8000db3e:	0a64                	addi	s1,sp,284
8000db40:	0000                	unimp
8000db42:	0000                	unimp
8000db44:	2d20                	fld	fs0,88(a0)
8000db46:	2d2d                	jal	8000e180 <__fsym_clear_desc>
8000db48:	202d                	jal	8000db72 <__rti_finsh_system_init_name+0x47e>
8000db4a:	2d20                	fld	fs0,88(a0)
8000db4c:	2d2d                	jal	8000e186 <__fsym_clear_desc+0x6>
8000db4e:	202d                	jal	8000db78 <__rti_finsh_system_init_name+0x484>
8000db50:	2d2d                	jal	8000e18a <__fsym_clear_desc+0xa>
8000db52:	2d2d                	jal	8000e18c <__fsym_clear_desc+0xc>
8000db54:	2d2d                	jal	8000e18e <__fsym_clear_desc+0xe>
8000db56:	2d2d                	jal	8000e190 <__fsym_clear_desc+0x10>
8000db58:	2d2d                	jal	8000e192 <__fsym_clear_desc+0x12>
8000db5a:	2d2d                	jal	8000e194 <__fsym_clear_desc+0x14>
8000db5c:	2d2d                	jal	8000e196 <__fsym_clear_desc+0x16>
8000db5e:	000a                	c.slli	zero,0x2
8000db60:	2d25                	jal	8000e198 <__fsym_clear_desc+0x18>
8000db62:	2e2a                	fld	ft8,136(sp)
8000db64:	732a                	flw	ft6,168(sp)
8000db66:	2520                	fld	fs0,72(a0)
8000db68:	3430                	fld	fa2,104(s0)
8000db6a:	2064                	fld	fs1,192(s0)
8000db6c:	2520                	fld	fs0,72(a0)
8000db6e:	3430                	fld	fa2,104(s0)
8000db70:	2064                	fld	fs1,192(s0)
8000db72:	6425                	lui	s0,0x9
8000db74:	003a                	c.slli	zero,0xe
8000db76:	0000                	unimp
8000db78:	2d25                	jal	8000e1b0 <__fsym_hello_desc+0xc>
8000db7a:	2e2a                	fld	ft8,136(sp)
8000db7c:	732a                	flw	ft6,168(sp)
8000db7e:	2520                	fld	fs0,72(a0)
8000db80:	3430                	fld	fa2,104(s0)
8000db82:	2064                	fld	fs1,192(s0)
8000db84:	2520                	fld	fs0,72(a0)
8000db86:	3430                	fld	fa2,104(s0)
8000db88:	2064                	fld	fs1,192(s0)
8000db8a:	6425                	lui	s0,0x9
8000db8c:	000a                	c.slli	zero,0x2
8000db8e:	0000                	unimp
8000db90:	656d                	lui	a0,0x1b
8000db92:	706d                	c.lui	zero,0xffffb
8000db94:	006c6f6f          	jal	t5,800d3b9a <_sp+0x93b9a>
8000db98:	2d25                	jal	8000e1d0 <__fsym_hello_name+0x1c>
8000db9a:	2e2a                	fld	ft8,136(sp)
8000db9c:	6c622073          	csrs	0x6c6,tp
8000dba0:	206b636f          	jal	t1,800c3da6 <_sp+0x83da6>
8000dba4:	6f74                	flw	fa3,92(a4)
8000dba6:	6174                	flw	fa3,68(a0)
8000dba8:	206c                	fld	fa1,192(s0)
8000dbaa:	7266                	flw	ft4,120(sp)
8000dbac:	6565                	lui	a0,0x19
8000dbae:	7320                	flw	fs0,96(a4)
8000dbb0:	7375                	lui	t1,0xffffd
8000dbb2:	6570                	flw	fa2,76(a0)
8000dbb4:	646e                	flw	fs0,216(sp)
8000dbb6:	7420                	flw	fs0,104(s0)
8000dbb8:	7268                	flw	fa0,100(a2)
8000dbba:	6165                	addi	sp,sp,112
8000dbbc:	0a64                	addi	s1,sp,284
8000dbbe:	0000                	unimp
8000dbc0:	2d20                	fld	fs0,88(a0)
8000dbc2:	2d2d                	jal	8000e1fc <__fsym_hello_name+0x48>
8000dbc4:	202d                	jal	8000dbee <__rti_finsh_system_init_name+0x4fa>
8000dbc6:	2d20                	fld	fs0,88(a0)
8000dbc8:	2d2d                	jal	8000e202 <__fsym_hello_name+0x4e>
8000dbca:	202d                	jal	8000dbf4 <__rti_finsh_system_init_name+0x500>
8000dbcc:	2d20                	fld	fs0,88(a0)
8000dbce:	2d2d                	jal	8000e208 <__fsym_hello_name+0x54>
8000dbd0:	202d                	jal	8000dbfa <__rti_finsh_system_init_name+0x506>
8000dbd2:	2d2d                	jal	8000e20c <__fsym_hello_name+0x58>
8000dbd4:	2d2d                	jal	8000e20e <__fsym_hello_name+0x5a>
8000dbd6:	2d2d                	jal	8000e210 <__fsym_hello_name+0x5c>
8000dbd8:	2d2d                	jal	8000e212 <__fsym_hello_name+0x5e>
8000dbda:	2d2d                	jal	8000e214 <__fsym_hello_name+0x60>
8000dbdc:	2d2d                	jal	8000e216 <__fsym_hello_name+0x62>
8000dbde:	2d2d                	jal	8000e218 <__fsym_hello_name+0x64>
8000dbe0:	000a                	c.slli	zero,0x2
8000dbe2:	0000                	unimp
8000dbe4:	2d25                	jal	8000e21c <__fsym_hello_name+0x68>
8000dbe6:	2e2a                	fld	ft8,136(sp)
8000dbe8:	732a                	flw	ft6,168(sp)
8000dbea:	2520                	fld	fs0,72(a0)
8000dbec:	3430                	fld	fa2,104(s0)
8000dbee:	2064                	fld	fs1,192(s0)
8000dbf0:	2520                	fld	fs0,72(a0)
8000dbf2:	3430                	fld	fa2,104(s0)
8000dbf4:	2064                	fld	fs1,192(s0)
8000dbf6:	2520                	fld	fs0,72(a0)
8000dbf8:	3430                	fld	fa2,104(s0)
8000dbfa:	2064                	fld	fs1,192(s0)
8000dbfc:	6425                	lui	s0,0x9
8000dbfe:	003a                	c.slli	zero,0xe
8000dc00:	2d25                	jal	8000e238 <__fsym___cmd_free_desc+0x10>
8000dc02:	2e2a                	fld	ft8,136(sp)
8000dc04:	732a                	flw	ft6,168(sp)
8000dc06:	2520                	fld	fs0,72(a0)
8000dc08:	3430                	fld	fa2,104(s0)
8000dc0a:	2064                	fld	fs1,192(s0)
8000dc0c:	2520                	fld	fs0,72(a0)
8000dc0e:	3430                	fld	fa2,104(s0)
8000dc10:	2064                	fld	fs1,192(s0)
8000dc12:	2520                	fld	fs0,72(a0)
8000dc14:	3430                	fld	fa2,104(s0)
8000dc16:	2064                	fld	fs1,192(s0)
8000dc18:	6425                	lui	s0,0x9
8000dc1a:	000a                	c.slli	zero,0x2
8000dc1c:	2d2d                	jal	8000e256 <__fsym___cmd_free_name+0x6>
8000dc1e:	7566                	flw	fa0,120(sp)
8000dc20:	636e                	flw	ft6,216(sp)
8000dc22:	6974                	flw	fa3,84(a0)
8000dc24:	0a3a6e6f          	jal	t3,800b44c6 <_sp+0x744c6>
8000dc28:	0000                	unimp
8000dc2a:	0000                	unimp
8000dc2c:	2d2d                	jal	8000e266 <__fsym___cmd_ps_desc+0xa>
8000dc2e:	6176                	flw	ft2,92(sp)
8000dc30:	6972                	flw	fs2,28(sp)
8000dc32:	6261                	lui	tp,0x18
8000dc34:	656c                	flw	fa1,76(a0)
8000dc36:	0a3a                	slli	s4,s4,0xe
8000dc38:	0000                	unimp
8000dc3a:	0000                	unimp
8000dc3c:	205d765b          	0x205d765b
8000dc40:	7325                	lui	t1,0xfffe9
8000dc42:	000a                	c.slli	zero,0x2
8000dc44:	72616843          	fmadd.d	fa6,ft2,ft6,fa4,unknown
8000dc48:	6361                	lui	t1,0x18
8000dc4a:	6574                	flw	fa3,76(a0)
8000dc4c:	2072                	fld	ft0,280(sp)
8000dc4e:	6544                	flw	fs1,12(a0)
8000dc50:	6976                	flw	fs2,92(sp)
8000dc52:	00006563          	bltu	zero,zero,8000dc5c <__rti_finsh_system_init_name+0x568>
8000dc56:	0000                	unimp
8000dc58:	6c42                	flw	fs8,16(sp)
8000dc5a:	206b636f          	jal	t1,800c3e60 <_sp+0x83e60>
8000dc5e:	6544                	flw	fs1,12(a0)
8000dc60:	6976                	flw	fs2,92(sp)
8000dc62:	00006563          	bltu	zero,zero,8000dc6c <__rti_finsh_system_init_name+0x578>
8000dc66:	0000                	unimp
8000dc68:	654e                	flw	fa0,208(sp)
8000dc6a:	7774                	flw	fa3,108(a4)
8000dc6c:	206b726f          	jal	tp,800c4e72 <_sp+0x84e72>
8000dc70:	6e49                	lui	t3,0x12
8000dc72:	6574                	flw	fa3,76(a0)
8000dc74:	6672                	flw	fa2,28(sp)
8000dc76:	6361                	lui	t1,0x18
8000dc78:	0065                	c.nop	25
8000dc7a:	0000                	unimp
8000dc7c:	544d                	li	s0,-13
8000dc7e:	2044                	fld	fs1,128(s0)
8000dc80:	6544                	flw	fs1,12(a0)
8000dc82:	6976                	flw	fs2,92(sp)
8000dc84:	00006563          	bltu	zero,zero,8000dc8e <__rti_finsh_system_init_name+0x59a>
8000dc88:	204e4143          	fmadd.s	ft2,ft8,ft4,ft4,rmm
8000dc8c:	6544                	flw	fs1,12(a0)
8000dc8e:	6976                	flw	fs2,92(sp)
8000dc90:	00006563          	bltu	zero,zero,8000dc9a <__rti_finsh_system_init_name+0x5a6>
8000dc94:	5452                	lw	s0,52(sp)
8000dc96:	6f530043          	fmadd.q	ft0,ft6,fs5,fa3,rne
8000dc9a:	6e75                	lui	t3,0x1d
8000dc9c:	2064                	fld	fs1,192(s0)
8000dc9e:	6544                	flw	fs1,12(a0)
8000dca0:	6976                	flw	fs2,92(sp)
8000dca2:	00006563          	bltu	zero,zero,8000dcac <__rti_finsh_system_init_name+0x5b8>
8000dca6:	0000                	unimp
8000dca8:	70617247          	fmsub.s	ft4,ft2,ft6,fa4
8000dcac:	6968                	flw	fa0,84(a0)
8000dcae:	65442063          	0x65442063
8000dcb2:	6976                	flw	fs2,92(sp)
8000dcb4:	00006563          	bltu	zero,zero,8000dcbe <__rti_finsh_system_init_name+0x5ca>
8000dcb8:	3249                	jal	8000d63a <__rti_rt_work_sys_workqueue_init_name+0x6a>
8000dcba:	75422043          	0x75422043
8000dcbe:	53550073          	0x53550073
8000dcc2:	2042                	fld	ft0,16(sp)
8000dcc4:	76616c53          	0x76616c53
8000dcc8:	2065                	jal	8000dd70 <__rti_finsh_system_init_name+0x67c>
8000dcca:	6544                	flw	fs1,12(a0)
8000dccc:	6976                	flw	fs2,92(sp)
8000dcce:	00006563          	bltu	zero,zero,8000dcd8 <__rti_finsh_system_init_name+0x5e4>
8000dcd2:	0000                	unimp
8000dcd4:	5355                	li	t1,-11
8000dcd6:	2042                	fld	ft0,16(sp)
8000dcd8:	6f48                	flw	fa0,28(a4)
8000dcda:	42207473          	csrrci	s0,0x422,0
8000dcde:	7375                	lui	t1,0xffffd
8000dce0:	0000                	unimp
8000dce2:	0000                	unimp
8000dce4:	20495053          	0x20495053
8000dce8:	7542                	flw	fa0,48(sp)
8000dcea:	50530073          	0x50530073
8000dcee:	2049                	jal	8000dd70 <__rti_finsh_system_init_name+0x67c>
8000dcf0:	6544                	flw	fs1,12(a0)
8000dcf2:	6976                	flw	fs2,92(sp)
8000dcf4:	00006563          	bltu	zero,zero,8000dcfe <__rti_finsh_system_init_name+0x60a>
8000dcf8:	4f494453          	0x4f494453
8000dcfc:	4220                	lw	s0,64(a2)
8000dcfe:	7375                	lui	t1,0xffffd
8000dd00:	0000                	unimp
8000dd02:	0000                	unimp
8000dd04:	4d50                	lw	a2,28(a0)
8000dd06:	5020                	lw	s0,96(s0)
8000dd08:	64756573          	csrrsi	a0,0x647,10
8000dd0c:	6544206f          	j	80050360 <_sp+0x10360>
8000dd10:	6976                	flw	fs2,92(sp)
8000dd12:	00006563          	bltu	zero,zero,8000dd1c <__rti_finsh_system_init_name+0x628>
8000dd16:	0000                	unimp
8000dd18:	6950                	flw	fa2,20(a0)
8000dd1a:	6570                	flw	fa2,76(a0)
8000dd1c:	0000                	unimp
8000dd1e:	0000                	unimp
8000dd20:	6f50                	flw	fa2,28(a4)
8000dd22:	7472                	flw	fs0,60(sp)
8000dd24:	6c61                	lui	s8,0x18
8000dd26:	4420                	lw	s0,72(s0)
8000dd28:	7665                	lui	a2,0xffff9
8000dd2a:	6369                	lui	t1,0x1a
8000dd2c:	0065                	c.nop	25
8000dd2e:	0000                	unimp
8000dd30:	6954                	flw	fa3,20(a0)
8000dd32:	656d                	lui	a0,0x1b
8000dd34:	2072                	fld	ft0,280(sp)
8000dd36:	6544                	flw	fs1,12(a0)
8000dd38:	6976                	flw	fs2,92(sp)
8000dd3a:	00006563          	bltu	zero,zero,8000dd44 <__rti_finsh_system_init_name+0x650>
8000dd3e:	0000                	unimp
8000dd40:	694d                	lui	s2,0x13
8000dd42:	6c656373          	csrrsi	t1,0x6c6,10
8000dd46:	616c                	flw	fa1,68(a0)
8000dd48:	656e                	flw	fa0,216(sp)
8000dd4a:	2073756f          	jal	a0,80045750 <_sp+0x5750>
8000dd4e:	6544                	flw	fs1,12(a0)
8000dd50:	6976                	flw	fs2,92(sp)
8000dd52:	00006563          	bltu	zero,zero,8000dd5c <__rti_finsh_system_init_name+0x668>
8000dd56:	0000                	unimp
8000dd58:	736e6553          	0x736e6553
8000dd5c:	4420726f          	jal	tp,8001519e <__fini_array_end+0x66be>
8000dd60:	7665                	lui	a2,0xffff9
8000dd62:	6369                	lui	t1,0x1a
8000dd64:	0065                	c.nop	25
8000dd66:	0000                	unimp
8000dd68:	6f54                	flw	fa3,28(a4)
8000dd6a:	6375                	lui	t1,0x1d
8000dd6c:	2068                	fld	fa0,192(s0)
8000dd6e:	6544                	flw	fs1,12(a0)
8000dd70:	6976                	flw	fs2,92(sp)
8000dd72:	00006563          	bltu	zero,zero,8000dd7c <device_type_str+0x4>
	...

8000dd78 <device_type_str>:
8000dd78:	dc44                	sw	s1,60(s0)
8000dd7a:	8000                	0x8000
8000dd7c:	dc58                	sw	a4,60(s0)
8000dd7e:	8000                	0x8000
8000dd80:	dc68                	sw	a0,124(s0)
8000dd82:	8000                	0x8000
8000dd84:	dc7c                	sw	a5,124(s0)
8000dd86:	8000                	0x8000
8000dd88:	dc88                	sw	a0,56(s1)
8000dd8a:	8000                	0x8000
8000dd8c:	dc94                	sw	a3,56(s1)
8000dd8e:	8000                	0x8000
8000dd90:	dc98                	sw	a4,56(s1)
8000dd92:	8000                	0x8000
8000dd94:	dca8                	sw	a0,120(s1)
8000dd96:	8000                	0x8000
8000dd98:	dcb8                	sw	a4,120(s1)
8000dd9a:	8000                	0x8000
8000dd9c:	dcc0                	sw	s0,60(s1)
8000dd9e:	8000                	0x8000
8000dda0:	dcd4                	sw	a3,60(s1)
8000dda2:	8000                	0x8000
8000dda4:	dce4                	sw	s1,124(s1)
8000dda6:	8000                	0x8000
8000dda8:	dcec                	sw	a1,124(s1)
8000ddaa:	8000                	0x8000
8000ddac:	dcf8                	sw	a4,124(s1)
8000ddae:	8000                	0x8000
8000ddb0:	dd04                	sw	s1,56(a0)
8000ddb2:	8000                	0x8000
8000ddb4:	dd18                	sw	a4,56(a0)
8000ddb6:	8000                	0x8000
8000ddb8:	dd20                	sw	s0,120(a0)
8000ddba:	8000                	0x8000
8000ddbc:	dd30                	sw	a2,120(a0)
8000ddbe:	8000                	0x8000
8000ddc0:	dd40                	sw	s0,60(a0)
8000ddc2:	8000                	0x8000
8000ddc4:	dd58                	sw	a4,60(a0)
8000ddc6:	8000                	0x8000
8000ddc8:	dd68                	sw	a0,124(a0)
8000ddca:	8000                	0x8000
8000ddcc:	d86c                	sw	a1,116(s0)
8000ddce:	8000                	0x8000

8000ddd0 <__vsym_dummy_desc>:
8000ddd0:	7564                	flw	fs1,108(a0)
8000ddd2:	6d6d                	lui	s10,0x1b
8000ddd4:	2079                	jal	8000de62 <__fsym_list_device_name+0x6>
8000ddd6:	6176                	flw	ft2,92(sp)
8000ddd8:	6972                	flw	fs2,28(sp)
8000ddda:	6261                	lui	tp,0x18
8000dddc:	656c                	flw	fa1,76(a0)
8000ddde:	6620                	flw	fs0,72(a2)
8000dde0:	6620726f          	jal	tp,80015442 <__fini_array_end+0x6962>
8000dde4:	6e69                	lui	t3,0x1a
8000dde6:	00006873          	csrrsi	a6,ustatus,0
	...

8000ddec <__vsym_dummy_name>:
8000ddec:	7564                	flw	fs1,108(a0)
8000ddee:	6d6d                	lui	s10,0x1b
8000ddf0:	0079                	c.nop	30
	...

8000ddf4 <__fsym_list_desc>:
8000ddf4:	696c                	flw	fa1,84(a0)
8000ddf6:	61207473          	csrrci	s0,0x612,0
8000ddfa:	6c6c                	flw	fa1,92(s0)
8000ddfc:	7320                	flw	fs0,96(a4)
8000ddfe:	6d79                	lui	s10,0x1e
8000de00:	6f62                	flw	ft10,24(sp)
8000de02:	206c                	fld	fa1,192(s0)
8000de04:	6e69                	lui	t3,0x1a
8000de06:	7320                	flw	fs0,96(a4)
8000de08:	7379                	lui	t1,0xffffe
8000de0a:	6574                	flw	fa3,76(a0)
8000de0c:	006d                	c.nop	27
	...

8000de10 <__fsym_list_name>:
8000de10:	696c                	flw	fa1,84(a0)
8000de12:	00007473          	csrrci	s0,ustatus,0
	...

8000de18 <__fsym___cmd_list_device_desc>:
8000de18:	696c                	flw	fa1,84(a0)
8000de1a:	64207473          	csrrci	s0,0x642,0
8000de1e:	7665                	lui	a2,0xffff9
8000de20:	6369                	lui	t1,0x1a
8000de22:	2065                	jal	8000deca <__fsym___cmd_list_mempool_desc+0x12>
8000de24:	6e69                	lui	t3,0x1a
8000de26:	7320                	flw	fs0,96(a4)
8000de28:	7379                	lui	t1,0xffffe
8000de2a:	6574                	flw	fa3,76(a0)
8000de2c:	006d                	c.nop	27
	...

8000de30 <__fsym___cmd_list_device_name>:
8000de30:	5f5f 6d63 5f64      	0x5f646d635f5f
8000de36:	696c                	flw	fa1,84(a0)
8000de38:	645f7473          	csrrci	s0,0x645,30
8000de3c:	7665                	lui	a2,0xffff9
8000de3e:	6369                	lui	t1,0x1a
8000de40:	0065                	c.nop	25
	...

8000de44 <__fsym_list_device_desc>:
8000de44:	696c                	flw	fa1,84(a0)
8000de46:	64207473          	csrrci	s0,0x642,0
8000de4a:	7665                	lui	a2,0xffff9
8000de4c:	6369                	lui	t1,0x1a
8000de4e:	2065                	jal	8000def6 <__fsym_list_mempool_desc+0xe>
8000de50:	6e69                	lui	t3,0x1a
8000de52:	7320                	flw	fs0,96(a4)
8000de54:	7379                	lui	t1,0xffffe
8000de56:	6574                	flw	fa3,76(a0)
8000de58:	006d                	c.nop	27
	...

8000de5c <__fsym_list_device_name>:
8000de5c:	696c                	flw	fa1,84(a0)
8000de5e:	645f7473          	csrrci	s0,0x645,30
8000de62:	7665                	lui	a2,0xffff9
8000de64:	6369                	lui	t1,0x1a
8000de66:	0065                	c.nop	25

8000de68 <__fsym___cmd_list_timer_desc>:
8000de68:	696c                	flw	fa1,84(a0)
8000de6a:	74207473          	csrrci	s0,0x742,0
8000de6e:	6d69                	lui	s10,0x1a
8000de70:	7265                	lui	tp,0xffff9
8000de72:	6920                	flw	fs0,80(a0)
8000de74:	206e                	fld	ft0,216(sp)
8000de76:	74737973          	csrrci	s2,0x747,6
8000de7a:	6d65                	lui	s10,0x19
8000de7c:	0000                	unimp
	...

8000de80 <__fsym___cmd_list_timer_name>:
8000de80:	5f5f 6d63 5f64      	0x5f646d635f5f
8000de86:	696c                	flw	fa1,84(a0)
8000de88:	745f7473          	csrrci	s0,0x745,30
8000de8c:	6d69                	lui	s10,0x1a
8000de8e:	7265                	lui	tp,0xffff9
8000de90:	0000                	unimp
	...

8000de94 <__fsym_list_timer_desc>:
8000de94:	696c                	flw	fa1,84(a0)
8000de96:	74207473          	csrrci	s0,0x742,0
8000de9a:	6d69                	lui	s10,0x1a
8000de9c:	7265                	lui	tp,0xffff9
8000de9e:	6920                	flw	fs0,80(a0)
8000dea0:	206e                	fld	ft0,216(sp)
8000dea2:	74737973          	csrrci	s2,0x747,6
8000dea6:	6d65                	lui	s10,0x19
8000dea8:	0000                	unimp
	...

8000deac <__fsym_list_timer_name>:
8000deac:	696c                	flw	fa1,84(a0)
8000deae:	745f7473          	csrrci	s0,0x745,30
8000deb2:	6d69                	lui	s10,0x1a
8000deb4:	7265                	lui	tp,0xffff9
	...

8000deb8 <__fsym___cmd_list_mempool_desc>:
8000deb8:	696c                	flw	fa1,84(a0)
8000deba:	6d207473          	csrrci	s0,0x6d2,0
8000debe:	6d65                	lui	s10,0x19
8000dec0:	2079726f          	jal	tp,800a58c6 <_sp+0x658c6>
8000dec4:	6f70                	flw	fa2,92(a4)
8000dec6:	69206c6f          	jal	s8,80014558 <__fini_array_end+0x5a78>
8000deca:	206e                	fld	ft0,216(sp)
8000decc:	74737973          	csrrci	s2,0x747,6
8000ded0:	6d65                	lui	s10,0x19
	...

8000ded4 <__fsym___cmd_list_mempool_name>:
8000ded4:	5f5f 6d63 5f64      	0x5f646d635f5f
8000deda:	696c                	flw	fa1,84(a0)
8000dedc:	6d5f7473          	csrrci	s0,0x6d5,30
8000dee0:	6d65                	lui	s10,0x19
8000dee2:	6f70                	flw	fa2,92(a4)
8000dee4:	00006c6f          	jal	s8,80013ee4 <__fini_array_end+0x5404>

8000dee8 <__fsym_list_mempool_desc>:
8000dee8:	696c                	flw	fa1,84(a0)
8000deea:	6d207473          	csrrci	s0,0x6d2,0
8000deee:	6d65                	lui	s10,0x19
8000def0:	2079726f          	jal	tp,800a58f6 <_sp+0x658f6>
8000def4:	6f70                	flw	fa2,92(a4)
8000def6:	69206c6f          	jal	s8,80014588 <__fini_array_end+0x5aa8>
8000defa:	206e                	fld	ft0,216(sp)
8000defc:	74737973          	csrrci	s2,0x747,6
8000df00:	6d65                	lui	s10,0x19
	...

8000df04 <__fsym_list_mempool_name>:
8000df04:	696c                	flw	fa1,84(a0)
8000df06:	6d5f7473          	csrrci	s0,0x6d5,30
8000df0a:	6d65                	lui	s10,0x19
8000df0c:	6f70                	flw	fa2,92(a4)
8000df0e:	00006c6f          	jal	s8,80013f0e <__fini_array_end+0x542e>
	...

8000df14 <__fsym___cmd_list_msgqueue_desc>:
8000df14:	696c                	flw	fa1,84(a0)
8000df16:	6d207473          	csrrci	s0,0x6d2,0
8000df1a:	7365                	lui	t1,0xffff9
8000df1c:	65676173          	csrrsi	sp,0x656,14
8000df20:	7120                	flw	fs0,96(a0)
8000df22:	6575                	lui	a0,0x1d
8000df24:	6575                	lui	a0,0x1d
8000df26:	6920                	flw	fs0,80(a0)
8000df28:	206e                	fld	ft0,216(sp)
8000df2a:	74737973          	csrrci	s2,0x747,6
8000df2e:	6d65                	lui	s10,0x19
8000df30:	0000                	unimp
	...

8000df34 <__fsym___cmd_list_msgqueue_name>:
8000df34:	5f5f 6d63 5f64      	0x5f646d635f5f
8000df3a:	696c                	flw	fa1,84(a0)
8000df3c:	6d5f7473          	csrrci	s0,0x6d5,30
8000df40:	75716773          	csrrsi	a4,0x757,2
8000df44:	7565                	lui	a0,0xffff9
8000df46:	0065                	c.nop	25

8000df48 <__fsym_list_msgqueue_desc>:
8000df48:	696c                	flw	fa1,84(a0)
8000df4a:	6d207473          	csrrci	s0,0x6d2,0
8000df4e:	7365                	lui	t1,0xffff9
8000df50:	65676173          	csrrsi	sp,0x656,14
8000df54:	7120                	flw	fs0,96(a0)
8000df56:	6575                	lui	a0,0x1d
8000df58:	6575                	lui	a0,0x1d
8000df5a:	6920                	flw	fs0,80(a0)
8000df5c:	206e                	fld	ft0,216(sp)
8000df5e:	74737973          	csrrci	s2,0x747,6
8000df62:	6d65                	lui	s10,0x19
8000df64:	0000                	unimp
	...

8000df68 <__fsym_list_msgqueue_name>:
8000df68:	696c                	flw	fa1,84(a0)
8000df6a:	6d5f7473          	csrrci	s0,0x6d5,30
8000df6e:	75716773          	csrrsi	a4,0x757,2
8000df72:	7565                	lui	a0,0xffff9
8000df74:	0065                	c.nop	25
	...

8000df78 <__fsym___cmd_list_mailbox_desc>:
8000df78:	696c                	flw	fa1,84(a0)
8000df7a:	6d207473          	csrrci	s0,0x6d2,0
8000df7e:	6961                	lui	s2,0x18
8000df80:	206c                	fld	fa1,192(s0)
8000df82:	6f62                	flw	ft10,24(sp)
8000df84:	2078                	fld	fa4,192(s0)
8000df86:	6e69                	lui	t3,0x1a
8000df88:	7320                	flw	fs0,96(a4)
8000df8a:	7379                	lui	t1,0xffffe
8000df8c:	6574                	flw	fa3,76(a0)
8000df8e:	006d                	c.nop	27

8000df90 <__fsym___cmd_list_mailbox_name>:
8000df90:	5f5f 6d63 5f64      	0x5f646d635f5f
8000df96:	696c                	flw	fa1,84(a0)
8000df98:	6d5f7473          	csrrci	s0,0x6d5,30
8000df9c:	6961                	lui	s2,0x18
8000df9e:	626c                	flw	fa1,68(a2)
8000dfa0:	0000786f          	jal	a6,80014fa0 <__fini_array_end+0x64c0>

8000dfa4 <__fsym_list_mailbox_desc>:
8000dfa4:	696c                	flw	fa1,84(a0)
8000dfa6:	6d207473          	csrrci	s0,0x6d2,0
8000dfaa:	6961                	lui	s2,0x18
8000dfac:	206c                	fld	fa1,192(s0)
8000dfae:	6f62                	flw	ft10,24(sp)
8000dfb0:	2078                	fld	fa4,192(s0)
8000dfb2:	6e69                	lui	t3,0x1a
8000dfb4:	7320                	flw	fs0,96(a4)
8000dfb6:	7379                	lui	t1,0xffffe
8000dfb8:	6574                	flw	fa3,76(a0)
8000dfba:	006d                	c.nop	27

8000dfbc <__fsym_list_mailbox_name>:
8000dfbc:	696c                	flw	fa1,84(a0)
8000dfbe:	6d5f7473          	csrrci	s0,0x6d5,30
8000dfc2:	6961                	lui	s2,0x18
8000dfc4:	626c                	flw	fa1,68(a2)
8000dfc6:	0000786f          	jal	a6,80014fc6 <__fini_array_end+0x64e6>
	...

8000dfcc <__fsym___cmd_list_mutex_desc>:
8000dfcc:	696c                	flw	fa1,84(a0)
8000dfce:	6d207473          	csrrci	s0,0x6d2,0
8000dfd2:	7475                	lui	s0,0xffffd
8000dfd4:	7865                	lui	a6,0xffff9
8000dfd6:	6920                	flw	fs0,80(a0)
8000dfd8:	206e                	fld	ft0,216(sp)
8000dfda:	74737973          	csrrci	s2,0x747,6
8000dfde:	6d65                	lui	s10,0x19
8000dfe0:	0000                	unimp
	...

8000dfe4 <__fsym___cmd_list_mutex_name>:
8000dfe4:	5f5f 6d63 5f64      	0x5f646d635f5f
8000dfea:	696c                	flw	fa1,84(a0)
8000dfec:	6d5f7473          	csrrci	s0,0x6d5,30
8000dff0:	7475                	lui	s0,0xffffd
8000dff2:	7865                	lui	a6,0xffff9
8000dff4:	0000                	unimp
	...

8000dff8 <__fsym_list_mutex_desc>:
8000dff8:	696c                	flw	fa1,84(a0)
8000dffa:	6d207473          	csrrci	s0,0x6d2,0
8000dffe:	7475                	lui	s0,0xffffd
8000e000:	7865                	lui	a6,0xffff9
8000e002:	6920                	flw	fs0,80(a0)
8000e004:	206e                	fld	ft0,216(sp)
8000e006:	74737973          	csrrci	s2,0x747,6
8000e00a:	6d65                	lui	s10,0x19
8000e00c:	0000                	unimp
	...

8000e010 <__fsym_list_mutex_name>:
8000e010:	696c                	flw	fa1,84(a0)
8000e012:	6d5f7473          	csrrci	s0,0x6d5,30
8000e016:	7475                	lui	s0,0xffffd
8000e018:	7865                	lui	a6,0xffff9
	...

8000e01c <__fsym___cmd_list_event_desc>:
8000e01c:	696c                	flw	fa1,84(a0)
8000e01e:	65207473          	csrrci	s0,0x652,0
8000e022:	6576                	flw	fa0,92(sp)
8000e024:	746e                	flw	fs0,248(sp)
8000e026:	6920                	flw	fs0,80(a0)
8000e028:	206e                	fld	ft0,216(sp)
8000e02a:	74737973          	csrrci	s2,0x747,6
8000e02e:	6d65                	lui	s10,0x19
8000e030:	0000                	unimp
	...

8000e034 <__fsym___cmd_list_event_name>:
8000e034:	5f5f 6d63 5f64      	0x5f646d635f5f
8000e03a:	696c                	flw	fa1,84(a0)
8000e03c:	655f7473          	csrrci	s0,0x655,30
8000e040:	6576                	flw	fa0,92(sp)
8000e042:	746e                	flw	fs0,248(sp)
8000e044:	0000                	unimp
	...

8000e048 <__fsym_list_event_desc>:
8000e048:	696c                	flw	fa1,84(a0)
8000e04a:	65207473          	csrrci	s0,0x652,0
8000e04e:	6576                	flw	fa0,92(sp)
8000e050:	746e                	flw	fs0,248(sp)
8000e052:	6920                	flw	fs0,80(a0)
8000e054:	206e                	fld	ft0,216(sp)
8000e056:	74737973          	csrrci	s2,0x747,6
8000e05a:	6d65                	lui	s10,0x19
8000e05c:	0000                	unimp
	...

8000e060 <__fsym_list_event_name>:
8000e060:	696c                	flw	fa1,84(a0)
8000e062:	655f7473          	csrrci	s0,0x655,30
8000e066:	6576                	flw	fa0,92(sp)
8000e068:	746e                	flw	fs0,248(sp)
	...

8000e06c <__fsym___cmd_list_sem_desc>:
8000e06c:	696c                	flw	fa1,84(a0)
8000e06e:	73207473          	csrrci	s0,0x732,0
8000e072:	6d65                	lui	s10,0x19
8000e074:	7061                	c.lui	zero,0xffff8
8000e076:	6f68                	flw	fa0,92(a4)
8000e078:	6572                	flw	fa0,28(sp)
8000e07a:	6920                	flw	fs0,80(a0)
8000e07c:	206e                	fld	ft0,216(sp)
8000e07e:	74737973          	csrrci	s2,0x747,6
8000e082:	6d65                	lui	s10,0x19
8000e084:	0000                	unimp
	...

8000e088 <__fsym___cmd_list_sem_name>:
8000e088:	5f5f 6d63 5f64      	0x5f646d635f5f
8000e08e:	696c                	flw	fa1,84(a0)
8000e090:	735f7473          	csrrci	s0,0x735,30
8000e094:	6d65                	lui	s10,0x19
	...

8000e098 <__fsym_list_sem_desc>:
8000e098:	696c                	flw	fa1,84(a0)
8000e09a:	73207473          	csrrci	s0,0x732,0
8000e09e:	6d65                	lui	s10,0x19
8000e0a0:	7061                	c.lui	zero,0xffff8
8000e0a2:	6f68                	flw	fa0,92(a4)
8000e0a4:	6572                	flw	fa0,28(sp)
8000e0a6:	6920                	flw	fs0,80(a0)
8000e0a8:	206e                	fld	ft0,216(sp)
8000e0aa:	74737973          	csrrci	s2,0x747,6
8000e0ae:	6d65                	lui	s10,0x19
8000e0b0:	0000                	unimp
	...

8000e0b4 <__fsym_list_sem_name>:
8000e0b4:	696c                	flw	fa1,84(a0)
8000e0b6:	735f7473          	csrrci	s0,0x735,30
8000e0ba:	6d65                	lui	s10,0x19
8000e0bc:	0000                	unimp
	...

8000e0c0 <__fsym___cmd_list_thread_desc>:
8000e0c0:	696c                	flw	fa1,84(a0)
8000e0c2:	74207473          	csrrci	s0,0x742,0
8000e0c6:	7268                	flw	fa0,100(a2)
8000e0c8:	6165                	addi	sp,sp,112
8000e0ca:	0064                	addi	s1,sp,12

8000e0cc <__fsym___cmd_list_thread_name>:
8000e0cc:	5f5f 6d63 5f64      	0x5f646d635f5f
8000e0d2:	696c                	flw	fa1,84(a0)
8000e0d4:	745f7473          	csrrci	s0,0x745,30
8000e0d8:	7268                	flw	fa0,100(a2)
8000e0da:	6165                	addi	sp,sp,112
8000e0dc:	0064                	addi	s1,sp,12
	...

8000e0e0 <__fsym_list_thread_desc>:
8000e0e0:	696c                	flw	fa1,84(a0)
8000e0e2:	74207473          	csrrci	s0,0x742,0
8000e0e6:	7268                	flw	fa0,100(a2)
8000e0e8:	6165                	addi	sp,sp,112
8000e0ea:	0064                	addi	s1,sp,12

8000e0ec <__fsym_list_thread_name>:
8000e0ec:	696c                	flw	fa1,84(a0)
8000e0ee:	745f7473          	csrrci	s0,0x745,30
8000e0f2:	7268                	flw	fa0,100(a2)
8000e0f4:	6165                	addi	sp,sp,112
8000e0f6:	0064                	addi	s1,sp,12

8000e0f8 <__fsym___cmd_version_desc>:
8000e0f8:	776f6873          	csrrsi	a6,0x776,30
8000e0fc:	5220                	lw	s0,96(a2)
8000e0fe:	2d54                	fld	fa3,152(a0)
8000e100:	6854                	flw	fa3,20(s0)
8000e102:	6572                	flw	fa0,28(sp)
8000e104:	6461                	lui	s0,0x18
8000e106:	7620                	flw	fs0,104(a2)
8000e108:	7265                	lui	tp,0xffff9
8000e10a:	6e6f6973          	csrrsi	s2,0x6e6,30
8000e10e:	6920                	flw	fs0,80(a0)
8000e110:	666e                	flw	fa2,216(sp)
8000e112:	616d726f          	jal	tp,800e5728 <_sp+0xa5728>
8000e116:	6974                	flw	fa3,84(a0)
8000e118:	00006e6f          	jal	t3,80014118 <__fini_array_end+0x5638>

8000e11c <__fsym___cmd_version_name>:
8000e11c:	5f5f 6d63 5f64      	0x5f646d635f5f
8000e122:	6576                	flw	fa0,92(sp)
8000e124:	7372                	flw	ft6,60(sp)
8000e126:	6f69                	lui	t5,0x1a
8000e128:	006e                	c.slli	zero,0x1b
	...

8000e12c <__fsym_version_desc>:
8000e12c:	776f6873          	csrrsi	a6,0x776,30
8000e130:	5220                	lw	s0,96(a2)
8000e132:	2d54                	fld	fa3,152(a0)
8000e134:	6854                	flw	fa3,20(s0)
8000e136:	6572                	flw	fa0,28(sp)
8000e138:	6461                	lui	s0,0x18
8000e13a:	7620                	flw	fs0,104(a2)
8000e13c:	7265                	lui	tp,0xffff9
8000e13e:	6e6f6973          	csrrsi	s2,0x6e6,30
8000e142:	6920                	flw	fs0,80(a0)
8000e144:	666e                	flw	fa2,216(sp)
8000e146:	616d726f          	jal	tp,800e575c <_sp+0xa575c>
8000e14a:	6974                	flw	fa3,84(a0)
8000e14c:	00006e6f          	jal	t3,8001414c <__fini_array_end+0x566c>

8000e150 <__fsym_version_name>:
8000e150:	6576                	flw	fa0,92(sp)
8000e152:	7372                	flw	ft6,60(sp)
8000e154:	6f69                	lui	t5,0x1a
8000e156:	006e                	c.slli	zero,0x1b

8000e158 <__fsym___cmd_clear_desc>:
8000e158:	61656c63          	bltu	a0,s6,8000e770 <__rti_libc_system_init_name+0x8>
8000e15c:	2072                	fld	ft0,280(sp)
8000e15e:	6874                	flw	fa3,84(s0)
8000e160:	2065                	jal	8000e208 <__fsym_hello_name+0x54>
8000e162:	6574                	flw	fa3,76(a0)
8000e164:	6d72                	flw	fs10,28(sp)
8000e166:	6e69                	lui	t3,0x1a
8000e168:	6c61                	lui	s8,0x18
8000e16a:	7320                	flw	fs0,96(a4)
8000e16c:	65657263          	bgeu	a0,s6,8000e7b0 <__sf_fake_stdin+0x14>
8000e170:	006e                	c.slli	zero,0x1b
	...

8000e174 <__fsym___cmd_clear_name>:
8000e174:	5f5f 6d63 5f64      	0x5f646d635f5f
8000e17a:	61656c63          	bltu	a0,s6,8000e792 <__sf_fake_stderr+0x16>
8000e17e:	0072                	c.slli	zero,0x1c

8000e180 <__fsym_clear_desc>:
8000e180:	61656c63          	bltu	a0,s6,8000e798 <__sf_fake_stderr+0x1c>
8000e184:	2072                	fld	ft0,280(sp)
8000e186:	6874                	flw	fa3,84(s0)
8000e188:	2065                	jal	8000e230 <__fsym___cmd_free_desc+0x8>
8000e18a:	6574                	flw	fa3,76(a0)
8000e18c:	6d72                	flw	fs10,28(sp)
8000e18e:	6e69                	lui	t3,0x1a
8000e190:	6c61                	lui	s8,0x18
8000e192:	7320                	flw	fs0,96(a4)
8000e194:	65657263          	bgeu	a0,s6,8000e7d8 <__sf_fake_stdout+0x1c>
8000e198:	006e                	c.slli	zero,0x1b
	...

8000e19c <__fsym_clear_name>:
8000e19c:	61656c63          	bltu	a0,s6,8000e7b4 <__sf_fake_stdin+0x18>
8000e1a0:	0072                	c.slli	zero,0x1c
	...

8000e1a4 <__fsym_hello_desc>:
8000e1a4:	20796173          	csrrsi	sp,0x207,18
8000e1a8:	6568                	flw	fa0,76(a0)
8000e1aa:	6c6c                	flw	fa1,92(s0)
8000e1ac:	6f77206f          	j	800810a2 <_sp+0x410a2>
8000e1b0:	6c72                	flw	fs8,28(sp)
8000e1b2:	0064                	addi	s1,sp,12

8000e1b4 <__fsym_hello_name>:
8000e1b4:	6568                	flw	fa0,76(a0)
8000e1b6:	6c6c                	flw	fa1,92(s0)
8000e1b8:	0000006f          	j	8000e1b8 <__fsym_hello_name+0x4>
8000e1bc:	5452                	lw	s0,52(sp)
8000e1be:	542d                	li	s0,-21
8000e1c0:	7268                	flw	fa0,100(a2)
8000e1c2:	6165                	addi	sp,sp,112
8000e1c4:	2064                	fld	fs1,192(s0)
8000e1c6:	6c656873          	csrrsi	a6,0x6c6,10
8000e1ca:	206c                	fld	fa1,192(s0)
8000e1cc:	6d6d6f63          	bltu	s10,s6,8000e8aa <_ctype_+0xbe>
8000e1d0:	6e61                	lui	t3,0x18
8000e1d2:	7364                	flw	fs1,100(a4)
8000e1d4:	0a3a                	slli	s4,s4,0xe
8000e1d6:	0000                	unimp
8000e1d8:	5f5f 6d63 5f64      	0x5f646d635f5f
8000e1de:	0000                	unimp
8000e1e0:	2d25                	jal	8000e818 <_ctype_+0x2c>
8000e1e2:	3631                	jal	8000dcee <__rti_finsh_system_init_name+0x5fa>
8000e1e4:	202d2073          	csrs	hedeleg,s10
8000e1e8:	7325                	lui	t1,0xfffe9
8000e1ea:	000a                	c.slli	zero,0x2
8000e1ec:	6f54                	flw	fa3,28(a4)
8000e1ee:	616d206f          	j	800e0804 <_sp+0xa0804>
8000e1f2:	796e                	flw	fs2,248(sp)
8000e1f4:	6120                	flw	fs0,64(a0)
8000e1f6:	6772                	flw	fa4,28(sp)
8000e1f8:	20212073          	csrs	hedeleg,sp
8000e1fc:	6f206557          	0x6f206557
8000e200:	6c6e                	flw	fs8,216(sp)
8000e202:	2079                	jal	8000e290 <__fsym___cmd_help_desc+0xc>
8000e204:	7355                	lui	t1,0xffff5
8000e206:	3a65                	jal	8000dbbe <__rti_finsh_system_init_name+0x4ca>
8000e208:	000a                	c.slli	zero,0x2
8000e20a:	0000                	unimp
8000e20c:	7325                	lui	t1,0xfffe9
8000e20e:	0020                	addi	s0,sp,8
8000e210:	7325                	lui	t1,0xfffe9
8000e212:	203a                	fld	ft0,392(sp)
8000e214:	6d6d6f63          	bltu	s10,s6,8000e8f2 <__rt_init_desc_rti_start+0x2>
8000e218:	6e61                	lui	t3,0x18
8000e21a:	2064                	fld	fs1,192(s0)
8000e21c:	6f6e                	flw	ft10,216(sp)
8000e21e:	2074                	fld	fa3,192(s0)
8000e220:	6f66                	flw	ft10,88(sp)
8000e222:	6e75                	lui	t3,0x1d
8000e224:	2e64                	fld	fs1,216(a2)
8000e226:	000a                	c.slli	zero,0x2

8000e228 <__fsym___cmd_free_desc>:
8000e228:	776f6853          	0x776f6853
8000e22c:	7420                	flw	fs0,104(s0)
8000e22e:	6568                	flw	fa0,76(a0)
8000e230:	6d20                	flw	fs0,88(a0)
8000e232:	6d65                	lui	s10,0x19
8000e234:	2079726f          	jal	tp,800a5c3a <_sp+0x65c3a>
8000e238:	7375                	lui	t1,0xffffd
8000e23a:	6761                	lui	a4,0x18
8000e23c:	2065                	jal	8000e2e4 <__fsym___cmd_exit_name+0x4>
8000e23e:	6e69                	lui	t3,0x1a
8000e240:	7420                	flw	fs0,104(s0)
8000e242:	6568                	flw	fa0,76(a0)
8000e244:	7320                	flw	fs0,96(a4)
8000e246:	7379                	lui	t1,0xffffe
8000e248:	6574                	flw	fa3,76(a0)
8000e24a:	2e6d                	jal	8000e604 <op_table+0x100>
8000e24c:	0000                	unimp
	...

8000e250 <__fsym___cmd_free_name>:
8000e250:	5f5f 6d63 5f64      	0x5f646d635f5f
8000e256:	7266                	flw	ft4,120(sp)
8000e258:	6565                	lui	a0,0x19
	...

8000e25c <__fsym___cmd_ps_desc>:
8000e25c:	694c                	flw	fa1,20(a0)
8000e25e:	74207473          	csrrci	s0,0x742,0
8000e262:	7268                	flw	fa0,100(a2)
8000e264:	6165                	addi	sp,sp,112
8000e266:	7364                	flw	fs1,100(a4)
8000e268:	6920                	flw	fs0,80(a0)
8000e26a:	206e                	fld	ft0,216(sp)
8000e26c:	6874                	flw	fa3,84(s0)
8000e26e:	2065                	jal	8000e316 <__fsym___cmd_exit_name+0x36>
8000e270:	74737973          	csrrci	s2,0x747,6
8000e274:	6d65                	lui	s10,0x19
8000e276:	002e                	c.slli	zero,0xb

8000e278 <__fsym___cmd_ps_name>:
8000e278:	5f5f 6d63 5f64      	0x5f646d635f5f
8000e27e:	7370                	flw	fa2,100(a4)
8000e280:	0000                	unimp
	...

8000e284 <__fsym___cmd_help_desc>:
8000e284:	5452                	lw	s0,52(sp)
8000e286:	542d                	li	s0,-21
8000e288:	7268                	flw	fa0,100(a2)
8000e28a:	6165                	addi	sp,sp,112
8000e28c:	2064                	fld	fs1,192(s0)
8000e28e:	6c656873          	csrrsi	a6,0x6c6,10
8000e292:	206c                	fld	fa1,192(s0)
8000e294:	6568                	flw	fa0,76(a0)
8000e296:	706c                	flw	fa1,100(s0)
8000e298:	002e                	c.slli	zero,0xb
	...

8000e29c <__fsym___cmd_help_name>:
8000e29c:	5f5f 6d63 5f64      	0x5f646d635f5f
8000e2a2:	6568                	flw	fa0,76(a0)
8000e2a4:	706c                	flw	fa1,100(s0)
	...

8000e2a8 <__fsym_msh_desc>:
8000e2a8:	7375                	lui	t1,0xffffd
8000e2aa:	2065                	jal	8000e352 <__fsym___cmd_exit_name+0x72>
8000e2ac:	6f6d                	lui	t5,0x1b
8000e2ae:	7564                	flw	fs1,108(a0)
8000e2b0:	656c                	flw	fa1,76(a0)
8000e2b2:	7320                	flw	fs0,96(a4)
8000e2b4:	6568                	flw	fa0,76(a0)
8000e2b6:	6c6c                	flw	fa1,92(s0)
8000e2b8:	0000                	unimp
	...

8000e2bc <__fsym_msh_name>:
8000e2bc:	736d                	lui	t1,0xffffb
8000e2be:	0068                	addi	a0,sp,12

8000e2c0 <__fsym___cmd_exit_desc>:
8000e2c0:	6572                	flw	fa0,28(sp)
8000e2c2:	7574                	flw	fa3,108(a0)
8000e2c4:	6e72                	flw	ft8,28(sp)
8000e2c6:	7420                	flw	fs0,104(s0)
8000e2c8:	5452206f          	j	8003100c <_end+0xfff4>
8000e2cc:	542d                	li	s0,-21
8000e2ce:	7268                	flw	fa0,100(a2)
8000e2d0:	6165                	addi	sp,sp,112
8000e2d2:	2064                	fld	fs1,192(s0)
8000e2d4:	6c656873          	csrrsi	a6,0x6c6,10
8000e2d8:	206c                	fld	fa1,192(s0)
8000e2da:	6f6d                	lui	t5,0x1b
8000e2dc:	6564                	flw	fs1,76(a0)
8000e2de:	002e                	c.slli	zero,0xb

8000e2e0 <__fsym___cmd_exit_name>:
8000e2e0:	5f5f 6d63 5f64      	0x5f646d635f5f
8000e2e6:	7865                	lui	a6,0xffff9
8000e2e8:	7469                	lui	s0,0xffffa
8000e2ea:	0000                	unimp
8000e2ec:	9804                	0x9804
8000e2ee:	ffff                	0xffff
8000e2f0:	9830                	0x9830
8000e2f2:	ffff                	0xffff
8000e2f4:	9820                	0x9820
8000e2f6:	ffff                	0xffff
8000e2f8:	9820                	0x9820
8000e2fa:	ffff                	0xffff
8000e2fc:	9830                	0x9830
8000e2fe:	ffff                	0xffff
8000e300:	9828                	0x9828
8000e302:	ffff                	0xffff
8000e304:	9828                	0x9828
8000e306:	ffff                	0xffff
8000e308:	9830                	0x9830
8000e30a:	ffff                	0xffff
8000e30c:	9830                	0x9830
8000e30e:	ffff                	0xffff
8000e310:	9830                	0x9830
8000e312:	ffff                	0xffff
8000e314:	9830                	0x9830
8000e316:	ffff                	0xffff
8000e318:	9830                	0x9830
8000e31a:	ffff                	0xffff
8000e31c:	9830                	0x9830
8000e31e:	ffff                	0xffff
8000e320:	9830                	0x9830
8000e322:	ffff                	0xffff
8000e324:	98a8                	0x98a8
8000e326:	ffff                	0xffff
8000e328:	9c44                	0x9c44
8000e32a:	ffff                	0xffff
8000e32c:	9c78                	0x9c78
8000e32e:	ffff                	0xffff
8000e330:	9c78                	0x9c78
8000e332:	ffff                	0xffff
8000e334:	9cd4                	0x9cd4
8000e336:	ffff                	0xffff
8000e338:	9cd4                	0x9cd4
8000e33a:	ffff                	0xffff
8000e33c:	9d30                	0x9d30
8000e33e:	ffff                	0xffff
8000e340:	9da0                	0x9da0
8000e342:	ffff                	0xffff
8000e344:	9e1c                	0x9e1c
8000e346:	ffff                	0xffff
8000e348:	9e98                	0x9e98
8000e34a:	ffff                	0xffff
8000e34c:	9f14                	0x9f14
8000e34e:	ffff                	0xffff
8000e350:	9f90                	0x9f90
8000e352:	ffff                	0xffff
8000e354:	a00c                	fsd	fa1,0(s0)
8000e356:	ffff                	0xffff
8000e358:	a088                	fsd	fa0,0(s1)
8000e35a:	ffff                	0xffff
8000e35c:	a104                	fsd	fs1,0(a0)
8000e35e:	ffff                	0xffff
8000e360:	a180                	fsd	fs0,0(a1)
8000e362:	ffff                	0xffff
8000e364:	a1fc                	fsd	fa5,192(a1)
8000e366:	ffff                	0xffff
8000e368:	a278                	fsd	fa4,192(a2)
8000e36a:	ffff                	0xffff
8000e36c:	a2c8                	fsd	fa0,128(a3)
8000e36e:	ffff                	0xffff
8000e370:	acb0                	fsd	fa2,88(s1)
8000e372:	ffff                	0xffff
8000e374:	a458                	fsd	fa4,136(s0)
8000e376:	ffff                	0xffff
8000e378:	a600                	fsd	fs0,8(a2)
8000e37a:	ffff                	0xffff
8000e37c:	a7b4                	fsd	fa3,72(a5)
8000e37e:	ffff                	0xffff
8000e380:	a9c4                	fsd	fs1,144(a1)
8000e382:	ffff                	0xffff
8000e384:	ac20                	fsd	fs0,88(s0)
8000e386:	ffff                	0xffff
8000e388:	991c                	0x991c
8000e38a:	ffff                	0xffff
8000e38c:	abec                	fsd	fa1,208(a5)
8000e38e:	ffff                	0xffff
8000e390:	6f4e                	flw	ft10,208(sp)
8000e392:	6520                	flw	fs0,72(a0)
8000e394:	7272                	flw	ft4,60(sp)
8000e396:	0000726f          	jal	tp,80015396 <__fini_array_end+0x68b6>
8000e39a:	0000                	unimp
8000e39c:	6e49                	lui	t3,0x12
8000e39e:	6176                	flw	ft2,92(sp)
8000e3a0:	696c                	flw	fa1,84(a0)
8000e3a2:	2064                	fld	fs1,192(s0)
8000e3a4:	6f74                	flw	fa3,92(a4)
8000e3a6:	006e656b          	0x6e656b
8000e3aa:	0000                	unimp
8000e3ac:	7845                	lui	a6,0xffff1
8000e3ae:	6570                	flw	fa2,76(a0)
8000e3b0:	61207463          	bgeu	zero,s2,8000e9b8 <__fsym_list_mempool>
8000e3b4:	7420                	flw	fs0,104(s0)
8000e3b6:	7079                	c.lui	zero,0xffffe
8000e3b8:	0065                	c.nop	25
8000e3ba:	0000                	unimp
8000e3bc:	6e55                	lui	t3,0x15
8000e3be:	776f6e6b          	0x776f6e6b
8000e3c2:	206e                	fld	ft0,216(sp)
8000e3c4:	7974                	flw	fa3,116(a0)
8000e3c6:	6570                	flw	fa2,76(a0)
8000e3c8:	0000                	unimp
8000e3ca:	0000                	unimp
8000e3cc:	6156                	flw	ft2,84(sp)
8000e3ce:	6972                	flw	fs2,28(sp)
8000e3d0:	6261                	lui	tp,0x18
8000e3d2:	656c                	flw	fa1,76(a0)
8000e3d4:	6520                	flw	fs0,72(a0)
8000e3d6:	6978                	flw	fa4,84(a0)
8000e3d8:	00007473          	csrrci	s0,ustatus,0
8000e3dc:	7845                	lui	a6,0xffff1
8000e3de:	6570                	flw	fa2,76(a0)
8000e3e0:	61207463          	bgeu	zero,s2,8000e9e8 <__fsym_list_mailbox>
8000e3e4:	6f20                	flw	fs0,88(a4)
8000e3e6:	6570                	flw	fa2,76(a0)
8000e3e8:	6172                	flw	ft2,28(sp)
8000e3ea:	6574                	flw	fa3,76(a0)
8000e3ec:	0072                	c.slli	zero,0x1c
8000e3ee:	0000                	unimp
8000e3f0:	654d                	lui	a0,0x13
8000e3f2:	6f6d                	lui	t5,0x1b
8000e3f4:	7972                	flw	fs2,60(sp)
8000e3f6:	6620                	flw	fs0,72(a2)
8000e3f8:	6c75                	lui	s8,0x1d
8000e3fa:	006c                	addi	a1,sp,12
8000e3fc:	6e55                	lui	t3,0x15
8000e3fe:	776f6e6b          	0x776f6e6b
8000e402:	206e                	fld	ft0,216(sp)
8000e404:	7265706f          	j	80065b2a <_sp+0x25b2a>
8000e408:	7461                	lui	s0,0xffff8
8000e40a:	0000726f          	jal	tp,8001540a <__fini_array_end+0x692a>
8000e40e:	0000                	unimp
8000e410:	6e55                	lui	t3,0x15
8000e412:	776f6e6b          	0x776f6e6b
8000e416:	206e                	fld	ft0,216(sp)
8000e418:	6f6e                	flw	ft10,216(sp)
8000e41a:	6564                	flw	fs1,76(a0)
8000e41c:	0000                	unimp
8000e41e:	0000                	unimp
8000e420:	7845                	lui	a6,0xffff1
8000e422:	6570                	flw	fa2,76(a0)
8000e424:	61207463          	bgeu	zero,s2,8000ea2c <__fsym___cmd_list_sem+0x8>
8000e428:	6320                	flw	fs0,64(a4)
8000e42a:	6168                	flw	fa0,68(a0)
8000e42c:	6172                	flw	ft2,28(sp)
8000e42e:	72657463          	bgeu	a0,t1,8000eb56 <__fini_array_end+0x76>
8000e432:	0000                	unimp
8000e434:	6e55                	lui	t3,0x15
8000e436:	7865                	lui	a6,0xffff9
8000e438:	6570                	flw	fa2,76(a0)
8000e43a:	65207463          	bgeu	zero,s2,8000ea82 <__fsym_clear+0xa>
8000e43e:	646e                	flw	fs0,216(sp)
8000e440:	0000                	unimp
8000e442:	0000                	unimp
8000e444:	6e55                	lui	t3,0x15
8000e446:	776f6e6b          	0x776f6e6b
8000e44a:	206e                	fld	ft0,216(sp)
8000e44c:	6f74                	flw	fa3,92(a4)
8000e44e:	006e656b          	0x6e656b
8000e452:	0000                	unimp
8000e454:	6c46                	flw	fs8,80(sp)
8000e456:	2074616f          	jal	sp,80054e5c <_sp+0x14e5c>
8000e45a:	6f6e                	flw	ft10,216(sp)
8000e45c:	2074                	fld	fa3,192(s0)
8000e45e:	70707573          	csrrci	a0,0x707,0
8000e462:	6574726f          	jal	tp,800562b8 <_sp+0x162b8>
8000e466:	0064                	addi	s1,sp,12
8000e468:	6e55                	lui	t3,0x15
8000e46a:	776f6e6b          	0x776f6e6b
8000e46e:	206e                	fld	ft0,216(sp)
8000e470:	626d7973          	csrrci	s2,0x626,26
8000e474:	00006c6f          	jal	s8,80014474 <__fini_array_end+0x5994>
8000e478:	754e                	flw	fa0,240(sp)
8000e47a:	6c6c                	flw	fa1,92(s0)
8000e47c:	6e20                	flw	fs0,88(a2)
8000e47e:	0065646f          	jal	s0,80064484 <_sp+0x24484>
	...

8000e484 <finsh_error_string_table>:
8000e484:	e390                	fsw	fa2,0(a5)
8000e486:	8000                	0x8000
8000e488:	e39c                	fsw	fa5,0(a5)
8000e48a:	8000                	0x8000
8000e48c:	e3ac                	fsw	fa1,64(a5)
8000e48e:	8000                	0x8000
8000e490:	e3bc                	fsw	fa5,64(a5)
8000e492:	8000                	0x8000
8000e494:	e3cc                	fsw	fa1,4(a5)
8000e496:	8000                	0x8000
8000e498:	e3dc                	fsw	fa5,4(a5)
8000e49a:	8000                	0x8000
8000e49c:	e3f0                	fsw	fa2,68(a5)
8000e49e:	8000                	0x8000
8000e4a0:	e3fc                	fsw	fa5,68(a5)
8000e4a2:	8000                	0x8000
8000e4a4:	e410                	fsw	fa2,8(s0)
8000e4a6:	8000                	0x8000
8000e4a8:	e420                	fsw	fs0,72(s0)
8000e4aa:	8000                	0x8000
8000e4ac:	e434                	fsw	fa3,72(s0)
8000e4ae:	8000                	0x8000
8000e4b0:	e444                	fsw	fs1,12(s0)
8000e4b2:	8000                	0x8000
8000e4b4:	e454                	fsw	fa3,12(s0)
8000e4b6:	8000                	0x8000
8000e4b8:	e468                	fsw	fa0,76(s0)
8000e4ba:	8000                	0x8000
8000e4bc:	e478                	fsw	fa4,76(s0)
8000e4be:	8000                	0x8000
8000e4c0:	b9ac                	fsd	fa1,112(a1)
8000e4c2:	ffff                	0xffff
8000e4c4:	b9d4                	fsd	fa3,176(a1)
8000e4c6:	ffff                	0xffff
8000e4c8:	b9dc                	fsd	fa5,176(a1)
8000e4ca:	ffff                	0xffff
8000e4cc:	b9ec                	fsd	fa1,240(a1)
8000e4ce:	ffff                	0xffff
8000e4d0:	ba00                	fsd	fs0,48(a2)
8000e4d2:	ffff                	0xffff
8000e4d4:	ba18                	fsd	fa4,48(a2)
8000e4d6:	ffff                	0xffff
8000e4d8:	ba34                	fsd	fa3,112(a2)
8000e4da:	ffff                	0xffff
8000e4dc:	ba54                	fsd	fa3,176(a2)
8000e4de:	ffff                	0xffff
8000e4e0:	ba78                	fsd	fa4,240(a2)
8000e4e2:	ffff                	0xffff
8000e4e4:	baa0                	fsd	fs0,112(a3)
8000e4e6:	ffff                	0xffff
8000e4e8:	bad0                	fsd	fa2,176(a3)
8000e4ea:	ffff                	0xffff
8000e4ec:	bb08                	fsd	fa0,48(a4)
8000e4ee:	ffff                	0xffff
8000e4f0:	bb48                	fsd	fa0,176(a4)
8000e4f2:	ffff                	0xffff
8000e4f4:	bb90                	fsd	fa2,48(a5)
8000e4f6:	ffff                	0xffff
8000e4f8:	bbe0                	fsd	fs0,240(a5)
8000e4fa:	ffff                	0xffff
8000e4fc:	bc38                	fsd	fa4,120(s0)
8000e4fe:	ffff                	0xffff
8000e500:	bc98                	fsd	fa4,56(s1)
8000e502:	ffff                	0xffff

8000e504 <op_table>:
8000e504:	96f0                	0x96f0
8000e506:	8000                	0x8000
8000e508:	96f4                	0x96f4
8000e50a:	8000                	0x8000
8000e50c:	9718                	0x9718
8000e50e:	8000                	0x8000
8000e510:	973c                	0x973c
8000e512:	8000                	0x8000
8000e514:	9760                	0x9760
8000e516:	8000                	0x8000
8000e518:	9784                	0x9784
8000e51a:	8000                	0x8000
8000e51c:	97a8                	0x97a8
8000e51e:	8000                	0x8000
8000e520:	97cc                	0x97cc
8000e522:	8000                	0x8000
8000e524:	97f0                	0x97f0
8000e526:	8000                	0x8000
8000e528:	9814                	0x9814
8000e52a:	8000                	0x8000
8000e52c:	9838                	0x9838
8000e52e:	8000                	0x8000
8000e530:	985c                	0x985c
8000e532:	8000                	0x8000
8000e534:	9880                	0x9880
8000e536:	8000                	0x8000
8000e538:	98a4                	0x98a4
8000e53a:	8000                	0x8000
8000e53c:	98c8                	0x98c8
8000e53e:	8000                	0x8000
8000e540:	98ec                	0x98ec
8000e542:	8000                	0x8000
8000e544:	9910                	0x9910
8000e546:	8000                	0x8000
8000e548:	9934                	0x9934
8000e54a:	8000                	0x8000
8000e54c:	9958                	0x9958
8000e54e:	8000                	0x8000
8000e550:	997c                	0x997c
8000e552:	8000                	0x8000
8000e554:	99a0                	0x99a0
8000e556:	8000                	0x8000
8000e558:	99c4                	0x99c4
8000e55a:	8000                	0x8000
8000e55c:	99e8                	0x99e8
8000e55e:	8000                	0x8000
8000e560:	9a0c                	0x9a0c
8000e562:	8000                	0x8000
8000e564:	9a30                	0x9a30
8000e566:	8000                	0x8000
8000e568:	9a54                	0x9a54
8000e56a:	8000                	0x8000
8000e56c:	9a68                	0x9a68
8000e56e:	8000                	0x8000
8000e570:	9a7c                	0x9a7c
8000e572:	8000                	0x8000
8000e574:	9a90                	0x9a90
8000e576:	8000                	0x8000
8000e578:	9ab4                	0x9ab4
8000e57a:	8000                	0x8000
8000e57c:	9ad8                	0x9ad8
8000e57e:	8000                	0x8000
8000e580:	9afc                	0x9afc
8000e582:	8000                	0x8000
8000e584:	9b20                	0x9b20
8000e586:	8000                	0x8000
8000e588:	9b44                	0x9b44
8000e58a:	8000                	0x8000
8000e58c:	9b68                	0x9b68
8000e58e:	8000                	0x8000
8000e590:	9b94                	0x9b94
8000e592:	8000                	0x8000
8000e594:	9bcc                	0x9bcc
8000e596:	8000                	0x8000
8000e598:	9c1c                	0x9c1c
8000e59a:	8000                	0x8000
8000e59c:	9c84                	0x9c84
8000e59e:	8000                	0x8000
8000e5a0:	9cec                	0x9cec
8000e5a2:	8000                	0x8000
8000e5a4:	9d54                	0x9d54
8000e5a6:	8000                	0x8000
8000e5a8:	9d78                	0x9d78
8000e5aa:	8000                	0x8000
8000e5ac:	9d98                	0x9d98
8000e5ae:	8000                	0x8000
8000e5b0:	9db8                	0x9db8
8000e5b2:	8000                	0x8000
8000e5b4:	9dcc                	0x9dcc
8000e5b6:	8000                	0x8000
8000e5b8:	9c70                	0x9c70
8000e5ba:	8000                	0x8000
8000e5bc:	9cd8                	0x9cd8
8000e5be:	8000                	0x8000
8000e5c0:	9d40                	0x9d40
8000e5c2:	8000                	0x8000
8000e5c4:	0000                	unimp
8000e5c6:	0000                	unimp
8000e5c8:	c0a0                	sw	s0,64(s1)
8000e5ca:	ffff                	0xffff
8000e5cc:	c020                	sw	s0,64(s0)
8000e5ce:	ffff                	0xffff
8000e5d0:	c030                	sw	a2,64(s0)
8000e5d2:	ffff                	0xffff
8000e5d4:	c04c                	sw	a1,4(s0)
8000e5d6:	ffff                	0xffff
8000e5d8:	c070                	sw	a2,68(s0)
8000e5da:	ffff                	0xffff
8000e5dc:	c0d0                	sw	a2,4(s1)
8000e5de:	ffff                	0xffff
8000e5e0:	c0d0                	sw	a2,4(s1)
8000e5e2:	ffff                	0xffff
8000e5e4:	c0d0                	sw	a2,4(s1)
8000e5e6:	ffff                	0xffff
8000e5e8:	c0b8                	sw	a4,64(s1)
8000e5ea:	ffff                	0xffff
8000e5ec:	c0d0                	sw	a2,4(s1)
8000e5ee:	ffff                	0xffff
8000e5f0:	c0d0                	sw	a2,4(s1)
8000e5f2:	ffff                	0xffff
8000e5f4:	c088                	sw	a0,0(s1)
8000e5f6:	ffff                	0xffff
8000e5f8:	c17c                	sw	a5,68(a0)
8000e5fa:	ffff                	0xffff
8000e5fc:	c164                	sw	s1,68(a0)
8000e5fe:	ffff                	0xffff
8000e600:	c170                	sw	a2,68(a0)
8000e602:	ffff                	0xffff
8000e604:	c188                	sw	a0,0(a1)
8000e606:	ffff                	0xffff
8000e608:	c194                	sw	a3,0(a1)
8000e60a:	ffff                	0xffff
8000e60c:	c0e4                	sw	s1,68(s1)
8000e60e:	ffff                	0xffff

8000e610 <CSWTCH.5>:
8000e610:	0505                	addi	a0,a0,1
8000e612:	0802                	c.slli64	a6
8000e614:	0208                	addi	a0,sp,256
8000e616:	0e020b0b          	0xe020b0b
8000e61a:	000e                	c.slli	zero,0x3
8000e61c:	d3c4                	sw	s1,36(a5)
8000e61e:	ffff                	0xffff
8000e620:	d024                	sw	s1,96(s0)
8000e622:	ffff                	0xffff
8000e624:	d024                	sw	s1,96(s0)
8000e626:	ffff                	0xffff
8000e628:	d158                	sw	a4,36(a0)
8000e62a:	ffff                	0xffff
8000e62c:	d090                	sw	a2,32(s1)
8000e62e:	ffff                	0xffff
8000e630:	d178                	sw	a4,100(a0)
8000e632:	ffff                	0xffff
8000e634:	d070                	sw	a2,100(s0)
8000e636:	ffff                	0xffff
8000e638:	d078                	sw	a4,100(s0)
8000e63a:	ffff                	0xffff
8000e63c:	d098                	sw	a4,32(s1)
8000e63e:	ffff                	0xffff
8000e640:	d0a0                	sw	s0,96(s1)
8000e642:	ffff                	0xffff
8000e644:	d080                	sw	s0,32(s1)
8000e646:	ffff                	0xffff
8000e648:	d0c8                	sw	a0,36(s1)
8000e64a:	ffff                	0xffff
8000e64c:	d024                	sw	s1,96(s0)
8000e64e:	ffff                	0xffff
8000e650:	d0f0                	sw	a2,100(s1)
8000e652:	ffff                	0xffff
8000e654:	d024                	sw	s1,96(s0)
8000e656:	ffff                	0xffff
8000e658:	d024                	sw	s1,96(s0)
8000e65a:	ffff                	0xffff
8000e65c:	d024                	sw	s1,96(s0)
8000e65e:	ffff                	0xffff
8000e660:	d024                	sw	s1,96(s0)
8000e662:	ffff                	0xffff
8000e664:	d024                	sw	s1,96(s0)
8000e666:	ffff                	0xffff
8000e668:	d024                	sw	s1,96(s0)
8000e66a:	ffff                	0xffff
8000e66c:	d024                	sw	s1,96(s0)
8000e66e:	ffff                	0xffff
8000e670:	d024                	sw	s1,96(s0)
8000e672:	ffff                	0xffff
8000e674:	d024                	sw	s1,96(s0)
8000e676:	ffff                	0xffff
8000e678:	d024                	sw	s1,96(s0)
8000e67a:	ffff                	0xffff
8000e67c:	d024                	sw	s1,96(s0)
8000e67e:	ffff                	0xffff
8000e680:	d088                	sw	a0,32(s1)
8000e682:	ffff                	0xffff
8000e684:	d110                	sw	a2,32(a0)
8000e686:	ffff                	0xffff
8000e688:	d170                	sw	a2,100(a0)
8000e68a:	ffff                	0xffff
8000e68c:	d138                	sw	a4,96(a0)
8000e68e:	ffff                	0xffff
8000e690:	d2b8                	sw	a4,96(a3)
8000e692:	ffff                	0xffff
8000e694:	d2a0                	sw	s0,96(a3)
8000e696:	ffff                	0xffff
8000e698:	d220                	sw	s0,96(a2)
8000e69a:	ffff                	0xffff
8000e69c:	d220                	sw	s0,96(a2)
8000e69e:	ffff                	0xffff
8000e6a0:	d220                	sw	s0,96(a2)
8000e6a2:	ffff                	0xffff
8000e6a4:	d2b0                	sw	a2,96(a3)
8000e6a6:	ffff                	0xffff
8000e6a8:	d220                	sw	s0,96(a2)
8000e6aa:	ffff                	0xffff
8000e6ac:	d220                	sw	s0,96(a2)
8000e6ae:	ffff                	0xffff
8000e6b0:	d220                	sw	s0,96(a2)
8000e6b2:	ffff                	0xffff
8000e6b4:	d220                	sw	s0,96(a2)
8000e6b6:	ffff                	0xffff
8000e6b8:	d220                	sw	s0,96(a2)
8000e6ba:	ffff                	0xffff
8000e6bc:	d220                	sw	s0,96(a2)
8000e6be:	ffff                	0xffff
8000e6c0:	d220                	sw	s0,96(a2)
8000e6c2:	ffff                	0xffff
8000e6c4:	d33c                	sw	a5,96(a4)
8000e6c6:	ffff                	0xffff
8000e6c8:	d220                	sw	s0,96(a2)
8000e6ca:	ffff                	0xffff
8000e6cc:	d220                	sw	s0,96(a2)
8000e6ce:	ffff                	0xffff
8000e6d0:	d220                	sw	s0,96(a2)
8000e6d2:	ffff                	0xffff
8000e6d4:	d2a8                	sw	a0,96(a3)
8000e6d6:	ffff                	0xffff
8000e6d8:	d220                	sw	s0,96(a2)
8000e6da:	ffff                	0xffff
8000e6dc:	d25c                	sw	a5,36(a2)
8000e6de:	ffff                	0xffff
8000e6e0:	d220                	sw	s0,96(a2)
8000e6e2:	ffff                	0xffff
8000e6e4:	d298                	sw	a4,32(a3)
8000e6e6:	ffff                	0xffff
8000e6e8:	d220                	sw	s0,96(a2)
8000e6ea:	ffff                	0xffff
8000e6ec:	d2c0                	sw	s0,36(a3)
8000e6ee:	ffff                	0xffff
8000e6f0:	6f76                	flw	ft10,92(sp)
8000e6f2:	6469                	lui	s0,0x1a
8000e6f4:	0000                	unimp
8000e6f6:	0000                	unimp
8000e6f8:	72616863          	bltu	sp,t1,8000ee28 <__fini_array_end+0x348>
8000e6fc:	0000                	unimp
8000e6fe:	0000                	unimp
8000e700:	726f6873          	csrrsi	a6,0x726,30
8000e704:	0074                	addi	a3,sp,12
8000e706:	0000                	unimp
8000e708:	6e69                	lui	t3,0x1a
8000e70a:	0074                	addi	a3,sp,12
8000e70c:	6f6c                	flw	fa1,92(a4)
8000e70e:	676e                	flw	fa4,216(sp)
8000e710:	0000                	unimp
8000e712:	0000                	unimp
8000e714:	6e75                	lui	t3,0x1d
8000e716:	6e676973          	csrrsi	s2,0x6e6,14
8000e71a:	6465                	lui	s0,0x19
8000e71c:	0000                	unimp
8000e71e:	0000                	unimp
8000e720:	756e                	flw	fa0,248(sp)
8000e722:	6c6c                	flw	fa1,92(s0)
8000e724:	0000                	unimp
	...

8000e728 <finsh_name_table>:
8000e728:	e6f0                	fsw	fa2,76(a3)
8000e72a:	8000                	0x8000
8000e72c:	0014                	0x14
8000e72e:	0000                	unimp
8000e730:	e6f8                	fsw	fa4,76(a3)
8000e732:	8000                	0x8000
8000e734:	0015                	c.nop	5
8000e736:	0000                	unimp
8000e738:	e700                	fsw	fs0,8(a4)
8000e73a:	8000                	0x8000
8000e73c:	0016                	c.slli	zero,0x5
8000e73e:	0000                	unimp
8000e740:	e708                	fsw	fa0,8(a4)
8000e742:	8000                	0x8000
8000e744:	00000017          	auipc	zero,0x0
8000e748:	e70c                	fsw	fa1,8(a4)
8000e74a:	8000                	0x8000
8000e74c:	0018                	0x18
8000e74e:	0000                	unimp
8000e750:	e714                	fsw	fa3,8(a4)
8000e752:	8000                	0x8000
8000e754:	0019                	c.nop	6
8000e756:	0000                	unimp
8000e758:	d59c                	sw	a5,40(a1)
8000e75a:	8000                	0x8000
8000e75c:	001e                	c.slli	zero,0x7
8000e75e:	0000                	unimp
8000e760:	e720                	fsw	fs0,72(a4)
8000e762:	8000                	0x8000
8000e764:	001e                	c.slli	zero,0x7
	...

8000e768 <__rti_libc_system_init_name>:
8000e768:	696c                	flw	fa1,84(a0)
8000e76a:	6362                	flw	ft6,24(sp)
8000e76c:	735f 7379 6574      	0x65747379735f
8000e772:	5f6d                	li	t5,-5
8000e774:	6e69                	lui	t3,0x1a
8000e776:	7469                	lui	s0,0xffffa
8000e778:	0000                	unimp
	...

8000e77c <__sf_fake_stderr>:
	...

8000e79c <__sf_fake_stdin>:
	...

8000e7bc <__sf_fake_stdout>:
	...
8000e7dc:	00000043          	fmadd.s	ft0,ft0,ft0,ft0,rne
8000e7e0:	4f50                	lw	a2,28(a4)
8000e7e2:	00584953          	fadd.s	fs2,fa6,ft5,rmm
8000e7e6:	0000                	unimp
8000e7e8:	002e                	c.slli	zero,0xb
	...

8000e7ec <_ctype_>:
8000e7ec:	2000                	fld	fs0,0(s0)
8000e7ee:	2020                	fld	fs0,64(s0)
8000e7f0:	2020                	fld	fs0,64(s0)
8000e7f2:	2020                	fld	fs0,64(s0)
8000e7f4:	2020                	fld	fs0,64(s0)
8000e7f6:	2828                	fld	fa0,80(s0)
8000e7f8:	2828                	fld	fa0,80(s0)
8000e7fa:	2028                	fld	fa0,64(s0)
8000e7fc:	2020                	fld	fs0,64(s0)
8000e7fe:	2020                	fld	fs0,64(s0)
8000e800:	2020                	fld	fs0,64(s0)
8000e802:	2020                	fld	fs0,64(s0)
8000e804:	2020                	fld	fs0,64(s0)
8000e806:	2020                	fld	fs0,64(s0)
8000e808:	2020                	fld	fs0,64(s0)
8000e80a:	2020                	fld	fs0,64(s0)
8000e80c:	8820                	0x8820
8000e80e:	1010                	addi	a2,sp,32
8000e810:	1010                	addi	a2,sp,32
8000e812:	1010                	addi	a2,sp,32
8000e814:	1010                	addi	a2,sp,32
8000e816:	1010                	addi	a2,sp,32
8000e818:	1010                	addi	a2,sp,32
8000e81a:	1010                	addi	a2,sp,32
8000e81c:	0410                	addi	a2,sp,512
8000e81e:	0404                	addi	s1,sp,512
8000e820:	0404                	addi	s1,sp,512
8000e822:	0404                	addi	s1,sp,512
8000e824:	0404                	addi	s1,sp,512
8000e826:	1004                	addi	s1,sp,32
8000e828:	1010                	addi	a2,sp,32
8000e82a:	1010                	addi	a2,sp,32
8000e82c:	1010                	addi	a2,sp,32
8000e82e:	4141                	li	sp,16
8000e830:	4141                	li	sp,16
8000e832:	4141                	li	sp,16
8000e834:	0101                	addi	sp,sp,0
8000e836:	0101                	addi	sp,sp,0
8000e838:	0101                	addi	sp,sp,0
8000e83a:	0101                	addi	sp,sp,0
8000e83c:	0101                	addi	sp,sp,0
8000e83e:	0101                	addi	sp,sp,0
8000e840:	0101                	addi	sp,sp,0
8000e842:	0101                	addi	sp,sp,0
8000e844:	0101                	addi	sp,sp,0
8000e846:	0101                	addi	sp,sp,0
8000e848:	1010                	addi	a2,sp,32
8000e84a:	1010                	addi	a2,sp,32
8000e84c:	1010                	addi	a2,sp,32
8000e84e:	4242                	lw	tp,16(sp)
8000e850:	4242                	lw	tp,16(sp)
8000e852:	4242                	lw	tp,16(sp)
8000e854:	0202                	c.slli64	tp
8000e856:	0202                	c.slli64	tp
8000e858:	0202                	c.slli64	tp
8000e85a:	0202                	c.slli64	tp
8000e85c:	0202                	c.slli64	tp
8000e85e:	0202                	c.slli64	tp
8000e860:	0202                	c.slli64	tp
8000e862:	0202                	c.slli64	tp
8000e864:	0202                	c.slli64	tp
8000e866:	0202                	c.slli64	tp
8000e868:	1010                	addi	a2,sp,32
8000e86a:	1010                	addi	a2,sp,32
8000e86c:	0020                	addi	s0,sp,8
	...

8000e8f0 <__rt_init_desc_rti_start>:
8000e8f0:	c63c                	sw	a5,72(a2)
8000e8f2:	8000                	0x8000
8000e8f4:	0894                	addi	a3,sp,80
8000e8f6:	8000                	0x8000

8000e8f8 <__rt_init_desc_rti_board_start>:
8000e8f8:	c62c                	sw	a1,72(a2)
8000e8fa:	8000                	0x8000
8000e8fc:	08a4                	addi	s1,sp,88
8000e8fe:	8000                	0x8000

8000e900 <__rt_init_desc_rti_board_end>:
8000e900:	c61c                	sw	a5,8(a2)
8000e902:	8000                	0x8000
8000e904:	08ac                	addi	a1,sp,88
8000e906:	8000                	0x8000

8000e908 <__rt_init_desc_rt_work_sys_workqueue_init>:
8000e908:	d5d0                	sw	a2,44(a1)
8000e90a:	8000                	0x8000
8000e90c:	567c                	lw	a5,108(a2)
8000e90e:	8000                	0x8000

8000e910 <__rt_init_desc_libc_system_init>:
8000e910:	e768                	fsw	fa0,76(a4)
8000e912:	8000                	0x8000
8000e914:	bbd0                	fsd	fa2,176(a5)
8000e916:	8000                	0x8000

8000e918 <__rt_init_desc_finsh_system_init>:
8000e918:	d6f4                	sw	a3,108(a3)
8000e91a:	8000                	0x8000
8000e91c:	5844                	lw	s1,52(s0)
8000e91e:	8000                	0x8000

8000e920 <__rt_init_desc_rti_end>:
8000e920:	0260                	addi	s0,sp,268
8000e922:	8002                	0x8002
8000e924:	089c                	addi	a5,sp,80
8000e926:	8000                	0x8000

8000e928 <__fsym___cmd_testapp>:
8000e928:	c45c                	sw	a5,12(s0)
8000e92a:	8000                	0x8000
8000e92c:	c454                	sw	a3,12(s0)
8000e92e:	8000                	0x8000
8000e930:	0260                	addi	s0,sp,268
8000e932:	8000                	0x8000

8000e934 <__fsym_list_mem>:
8000e934:	ce10                	sw	a2,24(a2)
8000e936:	8000                	0x8000
8000e938:	cdf0                	sw	a2,92(a1)
8000e93a:	8000                	0x8000
8000e93c:	223c                	fld	fa5,64(a2)
8000e93e:	8000                	0x8000

8000e940 <__fsym_pinGet>:
8000e940:	d330                	sw	a2,96(a4)
8000e942:	8000                	0x8000
8000e944:	d30c                	sw	a1,32(a4)
8000e946:	8000                	0x8000
8000e948:	4780                	lw	s0,8(a5)
8000e94a:	8000                	0x8000

8000e94c <__fsym_pinRead>:
8000e94c:	d358                	sw	a4,36(a4)
8000e94e:	8000                	0x8000
8000e950:	d338                	sw	a4,96(a4)
8000e952:	8000                	0x8000
8000e954:	4720                	lw	s0,72(a4)
8000e956:	8000                	0x8000

8000e958 <__fsym_pinWrite>:
8000e958:	d37c                	sw	a5,100(a4)
8000e95a:	8000                	0x8000
8000e95c:	d360                	sw	s0,100(a4)
8000e95e:	8000                	0x8000
8000e960:	46b0                	lw	a2,72(a3)
8000e962:	8000                	0x8000

8000e964 <__fsym_pinMode>:
8000e964:	d3a0                	sw	s0,96(a5)
8000e966:	8000                	0x8000
8000e968:	d388                	sw	a0,32(a5)
8000e96a:	8000                	0x8000
8000e96c:	4640                	lw	s0,12(a2)
8000e96e:	8000                	0x8000

8000e970 <__fsym_list>:
8000e970:	de10                	sw	a2,56(a2)
8000e972:	8000                	0x8000
8000e974:	ddf4                	sw	a3,124(a1)
8000e976:	8000                	0x8000
8000e978:	6268                	flw	fa0,68(a2)
8000e97a:	8000                	0x8000

8000e97c <__fsym___cmd_list_device>:
8000e97c:	de30                	sw	a2,120(a2)
8000e97e:	8000                	0x8000
8000e980:	de18                	sw	a4,56(a2)
8000e982:	8000                	0x8000
8000e984:	6698                	flw	fa4,8(a3)
8000e986:	8000                	0x8000

8000e988 <__fsym_list_device>:
8000e988:	de5c                	sw	a5,60(a2)
8000e98a:	8000                	0x8000
8000e98c:	de44                	sw	s1,60(a2)
8000e98e:	8000                	0x8000
8000e990:	6698                	flw	fa4,8(a3)
8000e992:	8000                	0x8000

8000e994 <__fsym___cmd_list_timer>:
8000e994:	de80                	sw	s0,56(a3)
8000e996:	8000                	0x8000
8000e998:	de68                	sw	a0,124(a2)
8000e99a:	8000                	0x8000
8000e99c:	6910                	flw	fa2,16(a0)
8000e99e:	8000                	0x8000

8000e9a0 <__fsym_list_timer>:
8000e9a0:	deac                	sw	a1,120(a3)
8000e9a2:	8000                	0x8000
8000e9a4:	de94                	sw	a3,56(a3)
8000e9a6:	8000                	0x8000
8000e9a8:	6910                	flw	fa2,16(a0)
8000e9aa:	8000                	0x8000

8000e9ac <__fsym___cmd_list_mempool>:
8000e9ac:	ded4                	sw	a3,60(a3)
8000e9ae:	8000                	0x8000
8000e9b0:	deb8                	sw	a4,120(a3)
8000e9b2:	8000                	0x8000
8000e9b4:	7088                	flw	fa0,32(s1)
8000e9b6:	8000                	0x8000

8000e9b8 <__fsym_list_mempool>:
8000e9b8:	df04                	sw	s1,56(a4)
8000e9ba:	8000                	0x8000
8000e9bc:	dee8                	sw	a0,124(a3)
8000e9be:	8000                	0x8000
8000e9c0:	7088                	flw	fa0,32(s1)
8000e9c2:	8000                	0x8000

8000e9c4 <__fsym___cmd_list_msgqueue>:
8000e9c4:	df34                	sw	a3,120(a4)
8000e9c6:	8000                	0x8000
8000e9c8:	df14                	sw	a3,56(a4)
8000e9ca:	8000                	0x8000
8000e9cc:	6be8                	flw	fa0,84(a5)
8000e9ce:	8000                	0x8000

8000e9d0 <__fsym_list_msgqueue>:
8000e9d0:	df68                	sw	a0,124(a4)
8000e9d2:	8000                	0x8000
8000e9d4:	df48                	sw	a0,60(a4)
8000e9d6:	8000                	0x8000
8000e9d8:	6be8                	flw	fa0,84(a5)
8000e9da:	8000                	0x8000

8000e9dc <__fsym___cmd_list_mailbox>:
8000e9dc:	df90                	sw	a2,56(a5)
8000e9de:	8000                	0x8000
8000e9e0:	df78                	sw	a4,124(a4)
8000e9e2:	8000                	0x8000
8000e9e4:	6ef8                	flw	fa4,92(a3)
8000e9e6:	8000                	0x8000

8000e9e8 <__fsym_list_mailbox>:
8000e9e8:	dfbc                	sw	a5,120(a5)
8000e9ea:	8000                	0x8000
8000e9ec:	dfa4                	sw	s1,120(a5)
8000e9ee:	8000                	0x8000
8000e9f0:	6ef8                	flw	fa4,92(a3)
8000e9f2:	8000                	0x8000

8000e9f4 <__fsym___cmd_list_mutex>:
8000e9f4:	dfe4                	sw	s1,124(a5)
8000e9f6:	8000                	0x8000
8000e9f8:	dfcc                	sw	a1,60(a5)
8000e9fa:	8000                	0x8000
8000e9fc:	67e8                	flw	fa0,76(a5)
8000e9fe:	8000                	0x8000

8000ea00 <__fsym_list_mutex>:
8000ea00:	e010                	fsw	fa2,0(s0)
8000ea02:	8000                	0x8000
8000ea04:	dff8                	sw	a4,124(a5)
8000ea06:	8000                	0x8000
8000ea08:	67e8                	flw	fa0,76(a5)
8000ea0a:	8000                	0x8000

8000ea0c <__fsym___cmd_list_event>:
8000ea0c:	e034                	fsw	fa3,64(s0)
8000ea0e:	8000                	0x8000
8000ea10:	e01c                	fsw	fa5,0(s0)
8000ea12:	8000                	0x8000
8000ea14:	6a6c                	flw	fa1,84(a2)
8000ea16:	8000                	0x8000

8000ea18 <__fsym_list_event>:
8000ea18:	e060                	fsw	fs0,68(s0)
8000ea1a:	8000                	0x8000
8000ea1c:	e048                	fsw	fa0,4(s0)
8000ea1e:	8000                	0x8000
8000ea20:	6a6c                	flw	fa1,84(a2)
8000ea22:	8000                	0x8000

8000ea24 <__fsym___cmd_list_sem>:
8000ea24:	e088                	fsw	fa0,0(s1)
8000ea26:	8000                	0x8000
8000ea28:	e06c                	fsw	fa1,68(s0)
8000ea2a:	8000                	0x8000
8000ea2c:	6d70                	flw	fa2,92(a0)
8000ea2e:	8000                	0x8000

8000ea30 <__fsym_list_sem>:
8000ea30:	e0b4                	fsw	fa3,64(s1)
8000ea32:	8000                	0x8000
8000ea34:	e098                	fsw	fa4,0(s1)
8000ea36:	8000                	0x8000
8000ea38:	6d70                	flw	fa2,92(a0)
8000ea3a:	8000                	0x8000

8000ea3c <__fsym___cmd_list_thread>:
8000ea3c:	e0cc                	fsw	fa1,4(s1)
8000ea3e:	8000                	0x8000
8000ea40:	e0c0                	fsw	fs0,4(s1)
8000ea42:	8000                	0x8000
8000ea44:	64a8                	flw	fa0,72(s1)
8000ea46:	8000                	0x8000

8000ea48 <__fsym_list_thread>:
8000ea48:	e0ec                	fsw	fa1,68(s1)
8000ea4a:	8000                	0x8000
8000ea4c:	e0e0                	fsw	fs0,68(s1)
8000ea4e:	8000                	0x8000
8000ea50:	64a8                	flw	fa0,72(s1)
8000ea52:	8000                	0x8000

8000ea54 <__fsym___cmd_version>:
8000ea54:	e11c                	fsw	fa5,0(a0)
8000ea56:	8000                	0x8000
8000ea58:	e0f8                	fsw	fa4,68(s1)
8000ea5a:	8000                	0x8000
8000ea5c:	624c                	flw	fa1,4(a2)
8000ea5e:	8000                	0x8000

8000ea60 <__fsym_version>:
8000ea60:	e150                	fsw	fa2,4(a0)
8000ea62:	8000                	0x8000
8000ea64:	e12c                	fsw	fa1,64(a0)
8000ea66:	8000                	0x8000
8000ea68:	624c                	flw	fa1,4(a2)
8000ea6a:	8000                	0x8000

8000ea6c <__fsym___cmd_clear>:
8000ea6c:	e174                	fsw	fa3,68(a0)
8000ea6e:	8000                	0x8000
8000ea70:	e158                	fsw	fa4,4(a0)
8000ea72:	8000                	0x8000
8000ea74:	61b4                	flw	fa3,64(a1)
8000ea76:	8000                	0x8000

8000ea78 <__fsym_clear>:
8000ea78:	e19c                	fsw	fa5,0(a1)
8000ea7a:	8000                	0x8000
8000ea7c:	e180                	fsw	fs0,0(a1)
8000ea7e:	8000                	0x8000
8000ea80:	61b4                	flw	fa3,64(a1)
8000ea82:	8000                	0x8000

8000ea84 <__fsym_hello>:
8000ea84:	e1b4                	fsw	fa3,64(a1)
8000ea86:	8000                	0x8000
8000ea88:	e1a4                	fsw	fs1,64(a1)
8000ea8a:	8000                	0x8000
8000ea8c:	6190                	flw	fa2,0(a1)
8000ea8e:	8000                	0x8000

8000ea90 <__fsym___cmd_free>:
8000ea90:	e250                	fsw	fa2,4(a2)
8000ea92:	8000                	0x8000
8000ea94:	e228                	fsw	fa0,64(a2)
8000ea96:	8000                	0x8000
8000ea98:	760c                	flw	fa1,40(a2)
8000ea9a:	8000                	0x8000

8000ea9c <__fsym___cmd_ps>:
8000ea9c:	e278                	fsw	fa4,68(a2)
8000ea9e:	8000                	0x8000
8000eaa0:	e25c                	fsw	fa5,4(a2)
8000eaa2:	8000                	0x8000
8000eaa4:	75f0                	flw	fa2,108(a1)
8000eaa6:	8000                	0x8000

8000eaa8 <__fsym___cmd_help>:
8000eaa8:	e29c                	fsw	fa5,0(a3)
8000eaaa:	8000                	0x8000
8000eaac:	e284                	fsw	fs1,0(a3)
8000eaae:	8000                	0x8000
8000eab0:	7548                	flw	fa0,44(a0)
8000eab2:	8000                	0x8000

8000eab4 <__fsym_msh>:
8000eab4:	e2bc                	fsw	fa5,64(a3)
8000eab6:	8000                	0x8000
8000eab8:	e2a8                	fsw	fa0,64(a3)
8000eaba:	8000                	0x8000
8000eabc:	7538                	flw	fa4,104(a0)
8000eabe:	8000                	0x8000

8000eac0 <__fsym___cmd_exit>:
8000eac0:	e2e0                	fsw	fs0,68(a3)
8000eac2:	8000                	0x8000
8000eac4:	e2c0                	fsw	fs0,4(a3)
8000eac6:	8000                	0x8000
8000eac8:	752c                	flw	fa1,104(a0)
8000eaca:	8000                	0x8000

8000eacc <__vsym_dummy>:
8000eacc:	ddec                	sw	a1,124(a1)
8000eace:	8000                	0x8000
8000ead0:	ddd0                	sw	a2,60(a1)
8000ead2:	8000                	0x8000
8000ead4:	0009                	c.nop	2
8000ead6:	0000                	unimp
8000ead8:	0348                	addi	a0,sp,388
8000eada:	8002                	0x8002

8000eadc <__vsymtab_end>:
8000eadc:	0000                	unimp
	...

Disassembly of section .data:

80020000 <rt_object_container>:
80020000:	0001                	nop
80020002:	0000                	unimp
80020004:	0004                	0x4
80020006:	8002                	0x8002
80020008:	0004                	0x4
8002000a:	8002                	0x8002
8002000c:	0098                	addi	a4,sp,64
8002000e:	0000                	unimp
80020010:	0002                	c.slli64	zero
80020012:	0000                	unimp
80020014:	0014                	0x14
80020016:	8002                	0x8002
80020018:	0014                	0x14
8002001a:	8002                	0x8002
8002001c:	002c                	addi	a1,sp,8
8002001e:	0000                	unimp
80020020:	00000003          	lb	zero,0(zero) # 0 <__HEAP_SIZE-0x2000>
80020024:	0024                	addi	s1,sp,8
80020026:	8002                	0x8002
80020028:	0024                	addi	s1,sp,8
8002002a:	8002                	0x8002
8002002c:	0030                	addi	a2,sp,8
8002002e:	0000                	unimp
80020030:	0004                	0x4
80020032:	0000                	unimp
80020034:	0034                	addi	a3,sp,8
80020036:	8002                	0x8002
80020038:	0034                	addi	a3,sp,8
8002003a:	8002                	0x8002
8002003c:	002c                	addi	a1,sp,8
8002003e:	0000                	unimp
80020040:	0005                	c.nop	1
80020042:	0000                	unimp
80020044:	0044                	addi	s1,sp,4
80020046:	8002                	0x8002
80020048:	0044                	addi	s1,sp,4
8002004a:	8002                	0x8002
8002004c:	003c                	addi	a5,sp,8
8002004e:	0000                	unimp
80020050:	0006                	c.slli	zero,0x1
80020052:	0000                	unimp
80020054:	0054                	addi	a3,sp,4
80020056:	8002                	0x8002
80020058:	0054                	addi	a3,sp,4
8002005a:	8002                	0x8002
8002005c:	0048                	addi	a0,sp,4
8002005e:	0000                	unimp
80020060:	0008                	0x8
80020062:	0000                	unimp
80020064:	0064                	addi	s1,sp,12
80020066:	8002                	0x8002
80020068:	0064                	addi	s1,sp,12
8002006a:	8002                	0x8002
8002006c:	0040                	addi	s0,sp,4
8002006e:	0000                	unimp
80020070:	0009                	c.nop	2
80020072:	0000                	unimp
80020074:	0074                	addi	a3,sp,12
80020076:	8002                	0x8002
80020078:	0074                	addi	a3,sp,12
8002007a:	8002                	0x8002
8002007c:	0050                	addi	a2,sp,4
8002007e:	0000                	unimp
80020080:	000a                	c.slli	zero,0x2
80020082:	0000                	unimp
80020084:	0084                	addi	s1,sp,64
80020086:	8002                	0x8002
80020088:	0084                	addi	s1,sp,64
8002008a:	8002                	0x8002
8002008c:	0038                	addi	a4,sp,8
	...

80020090 <impure_data>:
80020090:	0000                	unimp
80020092:	0000                	unimp
80020094:	e79c                	fsw	fa5,8(a5)
80020096:	8000                	0x8000
80020098:	e7bc                	fsw	fa5,72(a5)
8002009a:	8000                	0x8000
8002009c:	e77c                	fsw	fa5,76(a4)
8002009e:	8000                	0x8000
	...

800200f0 <__global_locale>:
800200f0:	00000043          	fmadd.s	ft0,ft0,ft0,ft0,rne
	...
80020110:	00000043          	fmadd.s	ft0,ft0,ft0,ft0,rne
	...
80020130:	00000043          	fmadd.s	ft0,ft0,ft0,ft0,rne
	...
80020150:	00000043          	fmadd.s	ft0,ft0,ft0,ft0,rne
	...
80020170:	00000043          	fmadd.s	ft0,ft0,ft0,ft0,rne
	...
80020190:	00000043          	fmadd.s	ft0,ft0,ft0,ft0,rne
	...
800201b0:	00000043          	fmadd.s	ft0,ft0,ft0,ft0,rne
	...
800201d0:	c3b8                	sw	a4,64(a5)
800201d2:	8000                	0x8000
800201d4:	c35c                	sw	a5,4(a4)
800201d6:	8000                	0x8000
800201d8:	0000                	unimp
800201da:	0000                	unimp
800201dc:	e7ec                	fsw	fa1,76(a5)
800201de:	8000                	0x8000
800201e0:	e7e8                	fsw	fa0,76(a5)
800201e2:	8000                	0x8000
800201e4:	d238                	sw	a4,96(a2)
800201e6:	8000                	0x8000
800201e8:	d238                	sw	a4,96(a2)
800201ea:	8000                	0x8000
800201ec:	d238                	sw	a4,96(a2)
800201ee:	8000                	0x8000
800201f0:	d238                	sw	a4,96(a2)
800201f2:	8000                	0x8000
800201f4:	d238                	sw	a4,96(a2)
800201f6:	8000                	0x8000
800201f8:	d238                	sw	a4,96(a2)
800201fa:	8000                	0x8000
800201fc:	d238                	sw	a4,96(a2)
800201fe:	8000                	0x8000
80020200:	d238                	sw	a4,96(a2)
80020202:	8000                	0x8000
80020204:	d238                	sw	a4,96(a2)
80020206:	8000                	0x8000
80020208:	ffff                	0xffff
8002020a:	ffff                	0xffff
8002020c:	ffff                	0xffff
8002020e:	ffff                	0xffff
80020210:	ffff                	0xffff
80020212:	ffff                	0xffff
80020214:	ffff                	0xffff
80020216:	0000                	unimp
80020218:	0001                	nop
8002021a:	5341                	li	t1,-16
8002021c:	00494943          	fmadd.s	fs2,fs2,ft4,ft0,rmm
	...
80020238:	0000                	unimp
8002023a:	5341                	li	t1,-16
8002023c:	00494943          	fmadd.s	fs2,fs2,ft4,ft0,rmm
	...

80020260 <__rti_rti_end_name>:
80020260:	7472                	flw	fs0,60(sp)
80020262:	5f69                	li	t5,-6
80020264:	6e65                	lui	t3,0x19
80020266:	0064                	addi	s1,sp,12

80020268 <__FUNCTION__.3098>:
80020268:	7472                	flw	fs0,60(sp)
8002026a:	665f 6572 0065      	0x656572665f

80020270 <soft_timer_status>:
80020270:	0001                	nop
	...

80020274 <__msh_state>:
80020274:	0001                	nop
	...

80020278 <_impure_ptr>:
80020278:	0090                	addi	a2,sp,64
8002027a:	8002                	0x8002

Disassembly of section .bss:

8002027c <__bss_start>:
8002027c:	0000                	unimp
	...

80020280 <thread_b>:
80020280:	0000                	unimp
	...

80020284 <thread_c>:
80020284:	0000                	unimp
	...

80020288 <rt_tick>:
80020288:	0000                	unimp
	...

8002028c <rt_interrupt_enter_hook>:
8002028c:	0000                	unimp
	...

80020290 <rt_interrupt_leave_hook>:
80020290:	0000                	unimp
	...

80020294 <rt_interrupt_nest>:
80020294:	0000                	unimp
	...

80020298 <__rt_errno>:
80020298:	0000                	unimp
	...

8002029c <_console_device>:
8002029c:	0000                	unimp
	...

800202a0 <rt_assert_hook>:
800202a0:	0000                	unimp
	...

800202a4 <heap_end>:
800202a4:	0000                	unimp
	...

800202a8 <heap_ptr>:
800202a8:	0000                	unimp
	...

800202ac <lfree>:
800202ac:	0000                	unimp
	...

800202b0 <max_mem>:
800202b0:	0000                	unimp
	...

800202b4 <mem_size_aligned>:
800202b4:	0000                	unimp
	...

800202b8 <rt_free_hook>:
800202b8:	0000                	unimp
	...

800202bc <rt_malloc_hook>:
800202bc:	0000                	unimp
	...

800202c0 <used_mem>:
800202c0:	0000                	unimp
	...

800202c4 <rt_object_attach_hook>:
800202c4:	0000                	unimp
	...

800202c8 <rt_object_detach_hook>:
800202c8:	0000                	unimp
	...

800202cc <rt_object_put_hook>:
800202cc:	0000                	unimp
	...

800202d0 <rt_object_take_hook>:
800202d0:	0000                	unimp
	...

800202d4 <rt_object_trytake_hook>:
800202d4:	0000                	unimp
	...

800202d8 <rt_current_priority>:
800202d8:	0000                	unimp
	...

800202dc <rt_current_thread>:
800202dc:	0000                	unimp
	...

800202e0 <rt_scheduler_hook>:
800202e0:	0000                	unimp
	...

800202e4 <rt_scheduler_lock_nest>:
800202e4:	0000                	unimp
	...

800202e8 <rt_thread_defunct>:
	...

800202f0 <rt_thread_ready_priority_group>:
800202f0:	0000                	unimp
	...

800202f4 <rt_thread_inited_hook>:
800202f4:	0000                	unimp
	...

800202f8 <rt_thread_resume_hook>:
800202f8:	0000                	unimp
	...

800202fc <rt_thread_suspend_hook>:
800202fc:	0000                	unimp
	...

80020300 <random_nr.3103>:
80020300:	0000                	unimp
	...

80020304 <rt_soft_timer_list>:
	...

8002030c <rt_timer_enter_hook>:
8002030c:	0000                	unimp
	...

80020310 <rt_timer_exit_hook>:
80020310:	0000                	unimp
	...

80020314 <rt_timer_list>:
	...

8002031c <rt_interrupt_from_thread>:
8002031c:	0000                	unimp
	...

80020320 <rt_interrupt_to_thread>:
80020320:	0000                	unimp
	...

80020324 <rt_thread_switch_interrupt_flag>:
80020324:	0000                	unimp
	...

80020328 <already_output.3469>:
80020328:	0000                	unimp
	...

8002032c <sys_workq>:
8002032c:	0000                	unimp
	...

80020330 <_syscall_table_begin>:
80020330:	0000                	unimp
	...

80020334 <_syscall_table_end>:
80020334:	0000                	unimp
	...

80020338 <_sysvar_table_begin>:
80020338:	0000                	unimp
	...

8002033c <_sysvar_table_end>:
8002033c:	0000                	unimp
	...

80020340 <finsh_prompt_custom>:
80020340:	0000                	unimp
	...

80020344 <shell>:
80020344:	0000                	unimp
	...

80020348 <dummy>:
80020348:	0000                	unimp
	...

8002034c <finsh_compile_pc>:
8002034c:	0000                	unimp
	...

80020350 <finsh_compile_sp>:
80020350:	0000                	unimp
	...

80020354 <global_errno>:
80020354:	0000                	unimp
	...

80020358 <allocate_list>:
80020358:	0000                	unimp
	...

8002035c <free_list>:
8002035c:	0000                	unimp
	...

80020360 <global_sysvar_list>:
80020360:	0000                	unimp
	...

80020364 <finsh_pc>:
80020364:	0000                	unimp
	...

80020368 <finsh_sp>:
80020368:	0000                	unimp
	...

8002036c <global_syscall_list>:
8002036c:	0000                	unimp
	...

80020370 <_global_atexit>:
80020370:	0000                	unimp
	...

80020374 <uart_device>:
	...

800203dc <idle>:
	...

80020474 <idle_hook_list>:
	...

80020484 <rt_thread_stack>:
	...

80020610 <rt_log_buf.3304>:
	...

80020690 <heap_sem>:
	...

800206bc <rt_thread_priority_table>:
	...

800207bc <timer_thread>:
	...

80020854 <timer_thread_stack>:
	...

80020a54 <riscv_trap_exc_handler>:
	...

80020a84 <riscv_trap_int_handler>:
	...

80020ab4 <_hw_pin>:
	...

80020b08 <finsh_prompt.4605>:
	...

80020b8c <finsh_heap>:
	...

80020c0c <global_node_table>:
	...

80020d4c <global_variable>:
	...

80020e0c <finsh_vm_stack>:
	...

80020f0c <text_segment>:
	...

80020f8c <_global_atexit0>:
	...

Disassembly of section .stack:

8003e000 <_heap_end>:
	...

Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347          	fmsub.d	ft6,ft6,ft4,ft7,rmm
   4:	2820                	fld	fs0,80(s0)
   6:	29554e47          	fmsub.s	ft8,fa0,fs5,ft5,rmm
   a:	3920                	fld	fs0,112(a0)
   c:	322e                	fld	ft4,232(sp)
   e:	302e                	fld	ft0,232(sp)
	...

Disassembly of section .riscv.attributes:

00000000 <.riscv.attributes>:
   0:	2041                	jal	80 <__HEAP_SIZE-0x1f80>
   2:	0000                	unimp
   4:	7200                	flw	fs0,32(a2)
   6:	7369                	lui	t1,0xffffa
   8:	01007663          	bgeu	zero,a6,14 <__HEAP_SIZE-0x1fec>
   c:	0016                	c.slli	zero,0x5
   e:	0000                	unimp
  10:	1004                	addi	s1,sp,32
  12:	7205                	lui	tp,0xfffe1
  14:	3376                	fld	ft6,376(sp)
  16:	6932                	flw	fs2,12(sp)
  18:	7032                	flw	ft0,44(sp)
  1a:	5f30                	lw	a2,120(a4)
  1c:	326d                	jal	fffff9c6 <_sp+0x7ffbf9c6>
  1e:	3070                	fld	fa2,224(s0)
	...
