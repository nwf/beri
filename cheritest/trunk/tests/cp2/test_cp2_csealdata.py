#
# Copyright (c) 2012 Michael Roe
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
from nose.plugins.attrib import attr

#
# Test csealdata
#

class test_cp2_csealdata(BaseBERITestCase):
    @attr('capabilities')
    def test_cp2_csealdata1(self):
        '''Test that cseal sets the sealed bit'''
        self.assertRegisterEqual(self.MIPS.a0, 1,
            "cseal did not set the sealed bit")

    @attr('capabilities')
    def test_cp2_sealdata2(self):
        '''Test that cseal sets the otype field'''
        self.assertRegisterEqual(self.MIPS.a1, 0x1234,
            "cseal did not set the otype field correctly")

    @attr('capabilities')
    def test_cp2_sealdata3(self):
        '''Test that cseal sets the base field'''
        self.assertRegisterEqual(self.MIPS.a2, self.MIPS.s2,
            "cseal did not set the base field correctly")

    @attr('capabilities')
    def test_cp2_sealdata4(self):
        '''Test that cseal sets the length field'''
        self.assertRegisterEqual(self.MIPS.a3, self.MIPS.s3,
            "cseal did not set the length field correctly")

    @attr('capabilities')
    def test_cp2_sealdata5(self):
        '''Test that cseal sets the perms field'''
        self.assertRegisterEqual(self.MIPS.a4, 0xd,
            "cseal did not set the perms field correctly")

