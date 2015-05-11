#-
# Copyright (c) 2013 Michael Roe
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
# Test the inital value of CP0.config1
#

		.global test
test:		.ent test
		daddu 	$sp, $sp, -32
		sd	$ra, 24($sp)
		sd	$fp, 16($sp)
		daddu	$fp, $sp, 32

		
		dli	$a0, 0
		dli	$a1, 0
		dli	$a2, 0
		dli	$a3, 0
		dli	$a4, 0

		dmfc0	$a0, $16, 0
		dsrl	$t0, $a0, 31
		andi	$t0, $t0, 0x1
		beq	$t0, $zero, end
		nop	# branch delay slot

		addi	$a4, $a4, 1
		dmfc0	$a1, $16, 1
		dsrl	$t0, $a1, 31
		andi	$t0, $t0, 0x1
		beq	$t0, $zero, end
		nop	# branch delay slot

		addi	$a4, $a4, 1
		dmfc0	$a2, $16, 2
		dsrl	$t0, $a1, 31
		andi	$t0, $t0, 0x1
		beq	$t0, $zero, end
		nop	# branch delay slot

		addi	$a4, $a4, 1
		dmfc0	$a3, $16, 3		

end:

		ld	$fp, 16($sp)
		ld	$ra, 24($sp)
		daddu	$sp, $sp, 32
		jr	$ra
		nop			# branch-delay slot
		.end	test