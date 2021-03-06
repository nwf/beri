#-
# Copyright (c) 2011 Steven J. Murdoch
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

from beritest_tools import BaseBERITestCase

class test_raw_sd(BaseBERITestCase):
    def test_a0(self):
        '''Test load of stored double word'''
        self.assertRegisterEqual(self.MIPS.a0, 0xfedcba9876543210, "Load of stored double word failed")

    def test_a1(self):
        '''Test signed load of stored positive double word'''
        self.assertRegisterEqual(self.MIPS.a1, 1, "Signed load of positive double word failed")

    def test_a2(self):
        '''Test signed load of stored negative double word'''
        self.assertRegisterEqual(self.MIPS.a2, 0xffffffffffffffff, "Signed load of negative double word failed")

    def test_pos_offset(self):
        '''Test double word store, load at positive offset'''
        self.assertRegisterEqual(self.MIPS.a3, 2, "Double word store, load at positive offset failed")

    def test_neg_offset(self):
        '''Test double word store, load at negative offset'''
        self.assertRegisterEqual(self.MIPS.a4, 1, "Double word store, load at negative offset failed")

    def test_dram(self):
        '''Test load of stored double word from DRAM'''
        self.assertRegisterEqual(self.MIPS.s0, 0xfedcba9876543210, "Load from DRAM failed")
