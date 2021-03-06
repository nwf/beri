#-
# Copyright (c) 2015 Michael Roe
# Copyright (c) 2015 SRI International
# All rights reserved.
#
# This software was developed by the University of Cambridge Computer
# Laboratory as part of the Rigorous Engineering of Mainstream Systems (REMS)
# project, funded by EPSRC grant EP/K008528/1.
#
# This software was developed by SRI International and the University of
# Cambridge Computer Laboratory under DARPA/AFRL contract FA8750-10-C-0237
# ("CTSRD"), as part of the DARPA CRASH research programme.
#
# @BERI_LICENSE_HEADER_START@
#
# Licensed to BERI Open Systems C.I.C. (BERI) under one or more contributor
# license agreements.  See the NOTICE file distributed with this work for
# additional information regarding copyright ownership.  BERI licenses this
# file to you under the BERI Hardware-Software License, Version 1.0 (the
# "License"); you may not use this file except in compliance with the
# License.  You may obtain a copy of the License at:
#
#   http://www.beri-open-systems.org/legal/license-1-0.txt
#
# Unless required by applicable law or agreed to in writing, Work distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations under the License.
#
# @BERI_LICENSE_HEADER_END@
#

.set mips64
.set noreorder
.set nobopt
.set noat

#
# Test that (some) CP2 instructions raise an exception if the tag bit is not
# set. Note that some CP2 operations are defined to succeed even if the
# tag is not set.
#

		.global test
test:		.ent test
		daddu 	$sp, $sp, -32
		sd	$ra, 24($sp)
		sd	$fp, 16($sp)
		daddu	$fp, $sp, 32

		#
		# Clear the BEV flag
		#

		jal	bev_clear
		nop

		#
		# Set up exception handler
		#

		dla	$a0, bev0_handler
		jal	bev0_handler_install
		nop

		#
		# $a1 will be set non-zero if get an unexpected exception
		#

		dli	$a1, 0

		#
		# Count of number of exceptions
		#

		dli	$a2, 0

		cgetdefault $c1
		cgetdefault $c3

		#
		# Clear the tag on $c1
		#

		ccleartag $c1, $c1
		
		#
		# Try some CP2 instructions
		#

		candperm $c2, $c1, $zero
		ccheckperm $c1, $zero
		# cchecktype expects a sealed capability, so don't test
		# it here
		# ccleartag doesn't check the tag bit, so don't test it here
		# cfromptr don't check the tag bit if rt=0
		dli $t0, 1
		cfromptr $c2, $c1, $t0
		# cgetbase  doesn't check the tag bit
		# cgetlen doesn't check the tag bit
		# cgetoffset doesn't check the tag bit
		# cgetperm doesn't check the tag bit
		# cgetsealed doesn't check the tag bit
		# cgettag doesn't check the tag bit
		# cgettype doesn't check the tag bit
		# cincbase doesn't check the tag bit if rt=0
		dli $t0, 1
		# cincoffset is complicated
		cseal $c2, $c1, $c3
		cseal $c2, $c3, $c1
		csetbounds $c2, $c1, $zero
		# csetoffset is complicated
		# ctoptr only checks the tag on the third argument; it returns
		# zero (i.e. the NULL pointer) if its second argument has the
		# tag bit clear.
		ctoptr $t0, $c2, $c1
		# cunseal requires a sealed capability, so don't test
		# it here

		#
		# Capability comparisons do not throw an exception if
		# the tag bit is not set
		#

		#
		# Loads and stores
		#


		dla	$t1, data
		clcr	$c2, $t1($c1)
		cscr	$c1, $t1($c1)
		clbr	$t0, $t1($c1)
		csbr	$t0, $t1($c1)
		clhr	$t0, $t1($c1)
		cshr	$t0, $t1($c1)
		clwr	$t0, $t1($c1)
		cswr	$t0, $t1($c1)
		cldr	$t0, $t1($c1)
		csdr	$t0, $t1($c1)
		csetoffset $c1, $c1, $t1
		cllc	$c2, $c1
		cscc	$t0, $c1, $c1
		cllb	$t0, $c1
		cscb	$t0, $t0, $c1
		cllh	$t0, $c1
		csch	$t0, $t0, $c1
		cllw	$t0, $c1
		cscw	$t0, $t0, $c1
		clld	$t0, $c1
		cscd	$t0, $t0, $c1

		ld	$fp, 16($sp)
		ld	$ra, 24($sp)
		daddu	$sp, $sp, 32
		jr	$ra
		nop			# branch-delay slot
		.end	test

		.ent bev0_handler
bev0_handler:
		daddiu	$a2, $a2, 1

		mfc0	$k0, $13	# Cause register
		srl	$k0, $k0, 2
		andi	$k0, $k0, 0x1f
		addi	$k0, $k0, -18	# Coprocessor 2 exception
		beqz	$k0, expected_exception
		nop			# Branch delay slot

		#
		# If we get an exception we didn't expected, mark the
		# test as failed by setting $a1
		#

		dli	$a1, 1

expected_exception:
		cgetcause $k0
		xori	$k0, $k0, 0x0201
		beqz	$k0, expected_cause
		nop

		#
		# If we get a cause code we didn't expect, mark the test
		# as failed by setting $a1
		#

		dli	$a1, 1

expected_cause:
		dmfc0	$a5, $14	# EPC
		daddiu	$k0, $a5, 4	# EPC += 4 to bump PC forward on ERET
		dmtc0	$k0, $14
		nop
		nop
		nop
		nop
		eret
		.end bev0_handler


		.data
		.align	5
data:		.dword	0x0123456789abcdef
		.dword  0x0123456789abcdef
		.dword  0x0123456789abcdef
		.dword  0x0123456789abcdef


