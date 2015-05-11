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

.set mips64
.set noreorder
.set nobopt
.set noat

#
# Test that cmove can move a register even if its unsealed bit is cleared.
#

sandbox:
		creturn

		.global test
test:		.ent test
		daddu 	$sp, $sp, -32
		sd	$ra, 24($sp)
		sd	$fp, 16($sp)
		daddu	$fp, $sp, 32

		# Put a non-zero value in c1.base, so we can tell when
		# c2 has been changed.
		dli		$t0, 0x100
		cincbase	$c1, $c0, $t0
		# Need to remove execute permission before we seal it
		dli		$t0, 0x5
		candperm 	$c1, $c1, $t0

		cmove		$c3, $c0
		dla		$t0, sandbox
		csettype	$c3, $c3, $t0

		csealdata	$c1, $c1, $c3

		# Move should copy c1 (base=0x100) into c2.
		cmove		$c2, $c1

		cgetunsealed 	$a0, $c2 	# Should be 0
		cgetbase 	$a1, $c2     	# Should be 0x100

		ld	$fp, 16($sp)
		ld	$ra, 24($sp)
		daddu	$sp, $sp, 32
		jr	$ra
		nop			# branch-delay slot
		.end	test