#-
# Copyright (c) 2011 William M. Morland
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
# Tests the Shift Right Logical instruction which is a 32-bit instruction.
# Any extra padding added on the left should be zero rather than sign extended
# There should be sign extension in the 32-bit result for the upper 32 bits.
#

		.global start
start:
		dli	$a0, 0xfedcba9876543210
		srl	$a1, $a0, 0
		srl	$a2, $a0, 1
		srl	$a3, $a0, 16
		srl	$a4, $a0, 31

		dli	$a5, 0x00000000ffffffff
		srl	$a6, $a5, 0

		# Dump registers in the simulator
		mtc0 $v0, $26
		nop
		nop

		# Terminate the simulator
	        mtc0 $v0, $23
end:
		b end
		nop