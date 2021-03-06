#-
# Copyright (c) 2012 Ben Thorner
# Copyright (c) 2013 Colin Rothwell
# All rights reserved.
#
# This software was developed by Ben Thorner as part of his summer internship
# and Colin Rothwell as part of his final year undergraduate project.
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
# Tests to exercise the multiplication ALU instruction.
#

		.text
		.global start
		.ent start
start:     
		# First enable CP1 
		mfc0 $at, $12
		dli $t1, 1 << 29	# Enable CP1
		or $at, $at, $t1
		dli $t1, 1 << 26        # Put FPU into 64 bit mode
		or $at, $at, $t1
		mtc0 $at, $12 
		nop
		nop
		nop
		nop
		nop

		# Individual tests
		
		# START TEST
		# MUL.D
		lui $t3, 0x4000
		dsll $t3, $t3, 32   # 2.0
		dmtc1 $t3, $f29
		mul.D $f27, $f29, $f29
		dmfc1 $s0, $f27
 
		# MUL.S
		lui $t2, 0x4080     # 4.0
		mtc1 $t2, $f20
		mul.S $f20, $f20, $f20

		# MUL.S (Denorm)
		lui $t0, 0x0100
		mtc1 $t0, $f31      # Enable flush to zero on denorm.
		lui $t1, 0x1
		dmtc1 $t1, $f22
		mul.S $f22, $f22, $f22
		dmfc1 $s4, $f22        
		dmfc1 $s1, $f20

		# MUL.D (regression test)
		add $t0, $zero, $zero
		ori $t0, $t0, 0xbfd1
		dsll $t0, $t0, 16
		ori $t0, $t0, 0xb257
		dsll $t0, $t0, 16
		ori $t0, $t0, 0x47d1
		dsll $t0, $t0, 16
		ori $t0, $t0, 0x4462
		dmtc1 $t0, $f0
		add $t0, $zero, $zero
		ori $t0, $t0, 0x3fd1
		dsll $t0, $t0, 16
		ori $t0, $t0, 0x89e6
		dsll $t0, $t0, 16
		ori $t0, $t0, 0x3d5e
		dsll $t0, $t0, 16
		ori $t0, $t0, 0x384c
		dmtc1 $t0, $f1
		mul.d $f0, $f0, $f1
		dmfc1 $a0, $f0
		# END TEST
		
		# Dump registers on the simulator (gxemul dumps regs on exit)
		mtc0 $at, $26
		nop
		nop

		# Terminate the simulator
		mtc0 $at, $23
end:
		b end
		nop
		.end start
