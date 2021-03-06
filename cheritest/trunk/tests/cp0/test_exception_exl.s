#-
# Copyright (c) 2015 Michael Roe
# All rights reserved.
#
# This software was developed by the University of Cambridge Computer
# Laboratory as part of the Rigorous Engineering of Mainstream Systems (REMS)
# project, funded by EPSRC grant EP/K008528/1.
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
# Test that an exception does not set EPC if CP0.Status.EXL is true
# (i.e. it's an exception within an exception handler).
#

		.global test
test:		.ent test
		daddu 	$sp, $sp, -32
		sd	$ra, 24($sp)
		sd	$fp, 16($sp)
		daddu	$fp, $sp, 32


		#
		# Set up exception handler.
		#

		jal	bev_clear
		nop
		dla	$a0, bev0_handler
		jal	bev0_handler_install
		nop

		#
		# Set CP0.Status.EXL so it looks like we're already in
		# an exception handler.
		#

		mfc0	$t0, $12	# CP0.Status
		li	$t1, 0x2	# EXL bit
		or	$t0, $t0, $t1
		mtc0	$t0, $12	# CP0.Status

		#
		# Set CP0.EPC to something recognizable
		#

		dmtc0	$zero, $14

		nop
		nop
		nop
		nop
		nop

		li	$t0, 0x7fffffff
		li	$t1, 1
		add	$t0, $t0, $t1	# Raises an exception

exit:
		ld	$fp, 16($sp)
		ld	$ra, 24($sp)
		daddu	$sp, $sp, 32
		jr	$ra
		nop			# branch-delay slot
		.end	test

		.ent bev0_handler
bev0_handler:
		dmfc0	$a0, $14	# EPC
		dla	$k0, exit
		dmtc0	$k0, $14	# EPC
		nop
		nop
		nop
		nop
		nop
		eret
		.end bev0_handler

