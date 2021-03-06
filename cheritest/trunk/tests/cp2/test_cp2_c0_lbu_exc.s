#-
# Copyright (c) 2011 Robert N. M. Watson
# All rights reserved.
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

.include "macros.s"
.set mips64
.set noreorder
.set nobopt
.set noat

#
# Test lbu (load byte unsigned) indirected via a constrained c0.
#

		.global test
test:		.ent test
		daddu 	$sp, $sp, -32
		sd	$ra, 24($sp)
		sd	$fp, 16($sp)
		daddu	$fp, $sp, 32
		li	$s2, 0

		#
		# Set up 'handler' as the RAM exception handler.
		#

		dla	$a0, exception_handler
		jal	bev0_handler_install
		nop

		jal	bev_clear
		nop

		#
		# Set up $c1 to point at data.
		# We want $c1.length to be 8.
		#

		cgetdefault $c1
		dla	$t0, data
		csetoffset $c1, $c1, $t0
		dli	$t1, 8
		csetbounds $c1, $c1, $t1

		#
		# Install new $c0
		#

		csetdefault $c1

		dli	$t0, 0
		lbu	$a0, 0($t0)		# 64-bit aligned
		lbu	$a1, 4($t0)		# 32-bit aligned
		lbu	$a2, 6($t0)		# 16-bit aligned
		lbu	$a3, 7($t0)		# 8-bit aligned

		#
		# Restore privileged c0 for test termination.
		#

		csetdefault $c30

		ld	$fp, 16($sp)
		ld	$ra, 24($sp)
		daddu	$sp, $sp, 32
		jr	$ra
		nop			# branch-delay slot
		.end	test

		.data
		.align 3
data:		.dword	0x0011223344556677
		.dword	0x8899aabbccddeeff


#
# Exception handler, which relies on the installation of KCC into PCC in order
# to run.  This code assumes that the trap was not in a branch delay slot.
#
		.ent exception_handler
exception_handler:
		# Capture cause register so we can make sure that an
		# exception was thrown for the right reason!
		mfc0	$s1, $13	# Get cause register
		daddiu	$s2, $s2, 1	# Increment trap counter
		dmfc0	$k1, $14	# EPC
		daddiu	$k0, $a5, 4	# EPC += 4 to bump PC forward on ERET
		dmtc0	$k0, $14
		b	exception_done
		nop

exception_done:
		nop			# Avoid CP0 hazards with ERET
		nop			# XXXRW: How many are actually
		nop			# required here?
		nop
		nop
		nop
		nop
		eret
		.end exception_handler
