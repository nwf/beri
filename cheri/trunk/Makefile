#-
# Copyright (c) 2010 Gregory A. Chadwick
# Copyright (c) 2010-2014 Jonathan Woodruff
# Copyright (c) 2010-2011 Steven J. Murdoch
# Copyright (c) 2012 SRI International
# Copyright (c) 2011 Robert N. M. Watson
# Copyright (c) 2011 Wojciech A. Koszek
# Copyright (c) 2011 Jonathan Anderson
# Copyright (c) 2011 Philip Paeps
# Copyright (c) 2012 Simon W. Moore
# Copyright (c) 2012-2013 Robert M. Norton
# Copyright (c) 2012 Ben Thorner
# Copyright (c) 2013-2014 Theo Markettos
# Copyright (c) 2013 Philip Withnall
# Copyright (c) 2013 Michael Roe
# Copyright (c) 2013-2014 Colin Rothwell
# Copyright (c) 2013 Bjoern A. Zeeb
# Copyright (c) 2013 Alan A. Mujumdar
# Copyright (c) 2014-2016 Alexandre Joannou
# Copyright (c) 2015 Paul Fox
# All rights reserved.
#
# This software was developed by SRI International and the University of
# Cambridge Computer Laboratory under DARPA/AFRL contract FA8750-10-C-0237
# ("CTSRD"), as part of the DARPA CRASH research programme.
#
# This software was developed by SRI International and the University of
# Cambridge Computer Laboratory under DARPA/AFRL contract FA8750-11-C-0249
# ("MRC2"), as part of the DARPA MRC research programme.
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

CHERILIBS_DIR   ?= ../../cherilibs/trunk
MINIBOOT_DIR    ?= ../../cheribsd/trunk/miniboot
TOOLS_DIR       = $(CHERILIBS_DIR)/tools
PERIPHERALS_DIR = $(CHERILIBS_DIR)/peripherals
INCLUDE_DIR     = $(CHERILIBS_DIR)/include
BUILD_DIR       = ./build
IP_DIR          = ./ip/

OSNAME		:= $(shell uname -s)

BSV_FILES=			\
	Branch.bsv        \
	BranchSimple.bsv  \
	$(CHERILIBS_DIR)/BeriBootMem.bsv		\
	Merge.bsv	        \
	$(CHERILIBS_DIR)/L2Cache.bsv        \
	$(CHERILIBS_DIR)/CoherenceController.bsv        \
	$(CHERILIBS_DIR)/MemTypes.bsv        \
	$(CHERILIBS_DIR)/MEM.bsv             \
	$(CHERILIBS_DIR)/MasterSlave.bsv     \
	$(CHERILIBS_DIR)/Processor.bsv        \
	$(CHERILIBS_DIR)/TopAxi.bsv        \
	$(CHERILIBS_DIR)/TopSimAxi.bsv			\
	$(CHERILIBS_DIR)/Interconnect.bsv		\
	$(CHERILIBS_DIR)/InternalToAxi.bsv		\
	$(CHERILIBS_DIR)/InflightCounter.bsv		\
	$(CHERILIBS_DIR)/TwoWritePortRegFile.bsv	\
	$(CHERILIBS_DIR)/InternalPeriphBridge.bsv\
	$(CHERILIBS_DIR)/Peripheral.bsv      \
	$(CHERILIBS_DIR)/OrderingLimiter.bsv      \
	$(CHERILIBS_DIR)/TagLookup.bsv      \
	$(CHERILIBS_DIR)/MultiLevelTagLookup.bsv      \
	$(CHERILIBS_DIR)/TagController.bsv      \
	$(CHERILIBS_DIR)/TraceTypes.bsv      \
	$(CHERILIBS_DIR)/AsymmetricBRAM/AsymmetricBRAM.bsv  \
	$(CHERILIBS_DIR)/PIC.bsv			\
	$(CHERILIBS_DIR)/Burst.bsv          \
	$(CHERILIBS_DIR)/Bag.bsv        \
	$(CHERILIBS_DIR)/CacheCore.bsv	\
	$(CHERILIBS_DIR)/CacheCoreSpeculative.bsv \
	$(CHERILIBS_DIR)/CacheCoreTypes.bsv  \
	$(CHERILIBS_DIR)/CacheCoreWriteback.bsv  \
	$(CHERILIBS_DIR)/CacheCoreFill.bsv  \
        $(CHERILIBS_DIR)/CacheCoreServe.bsv  \
	$(CHERILIBS_DIR)/CheriTLM.defines  \
        $(CHERILIBS_DIR)/Debug.bsv \
	$(CHERILIBS_DIR)/FF.bsv	\
	$(CHERILIBS_DIR)/Capability128Libs.bsv        \
	$(CHERILIBS_DIR)/Capability64c1Libs.bsv        \
	ICache.bsv  \
	ICacheClassic.bsv  \
	DCache.bsv  \
	DCacheClassic.bsv  \
	CP0.bsv			\
	CapCop.bsv 	   \
	CapCop128.bsv \
	CapCop64.bsv \
        FPU/*.bsv     \
	Decode.bsv		\
	Execute.bsv		\
	MemAccess.bsv		\
	Memory.bsv		\
	MIPS.bsv		\
	Proc.bsv    \
	ForwardingPipelinedRegFile.bsv		\
	ForwardingPipelinedRegFileHighFrequency.bsv	\
	MIPSTop.bsv		\
	MIPSTopIfc.bsv		\
	ResetBuffer.bsv \
	Scheduler.bsv		\
	TLB.bsv			\
	Writeback.bsv			\
	DebugUnit.bsv		\
	Multicore.bsv		\
	$(PERIPHERALS_DIR)/DMA/*.bsv

C_HEADERS=$(INCLUDE_DIR)/parameters.h

PISM_LIB= $(PERIPHERALS_DIR)/libpism.so

EXTRA_LINK=				\
	$(PERIPHERALS_DIR)/pismdev/debug_stream/debug_stream.c	\
	$(CHERILIBS_DIR)/AsymmetricBRAM/mem_model.c

ifeq ($(OSNAME), Linux)
NCPU:=	$(shell nproc)
else
ifeq ($(OSNAME), FreeBSD)
NCPU:=  $(shell sysctl -n hw.ncpu)
endif
endif
ifdef NCPU
ifeq ($(NCPU), "")
NCPU:=	1
endif
else
$(error GNU make logic error, NCPU not defined)
endif

all: sim vsim

.PHONY: FORCE
FORCE:

$(PISM_LIB): FORCE
	$(MAKE) -C $(PERIPHERALS_DIR) pism

CFLAGS=-g
BSVPATH=+:%/Libraries/TLM3:%/Libraries/Axi:%/Libraries/Contrib/NonPipelinedMath
BSVPATH:=$(BSVPATH):$(PERIPHERALS_DIR)/LoopbackUART:$(PERIPHERALS_DIR)/DMA
BSVPATH:=$(BSVPATH):$(PERIPHERALS_DIR)/PixelStream:$(PERIPHERALS_DIR)/Compositor
BSVPATH:=$(BSVPATH):FPU:FPU/megafunctions:$(CHERILIBS_DIR)
BSVPATH:=$(BSVPATH):$(CHERILIBS_DIR)/debugging
BSVPATH:=$(BSVPATH):$(CHERILIBS_DIR)/AsymmetricBRAM
BSVPATH:=$(BSVPATH):Test/Mem
BSVPATH:=$(BSVPATH):$(CHERILIBS_DIR)/BlueCheck
BSC_SIM_LIBS=
BSCFLAGS=-p $(BSVPATH) +RTS -K4000M -RTS -check-assert
BSCFLAGS+= -no-warn-action-shadowing -show-schedule -parallel-sim-link $(NCPU)

ifdef NOT_FLAT
BSCFLAGS+=-D NOT_FLAT
IP_DIR := $(IP_DIR)notflat
BUILD_DIR := $(BUILD_DIR)_notflat
endif

ifdef WITH_COMPOSITOR
# FIXME: aggressive-conditions is needed for flow control between the processor
# and compositor to work correctly. The compositor needs rewriting to work
# without aggressive-conditions.
BSCFLAGS+=-D CHERI_COMPOSITOR -aggressive-conditions

ifdef WITH_COMPOSITOR_STATISTICS
# Enable statistics collection in the compositor. This doesn't affect timing,
# but does add register overhead.
BSCFLAGS+=-D CHERI_COMPOSITOR_STATISTICS
endif # WITH_COMPOSITOR_STATISTICS

ifdef WITH_COMPOSITOR_NO_OUTPUT
# Disable pixel output from the compositor, and drain all output pixels from it
# as fast as possible. This is for performance measurement purposes only. It
# certainly doesn’t make the screen look interesting.
BSCFLAGS+=-D CHERI_COMPOSITOR_NO_OUTPUT
endif # WITH_COMPOSITOR_NO_OUTPUT
endif # WITH_COMPOSITOR

BSC = bsc $(BSCFLAGS)
YACC = bison
YFLAGS = -yd

.PHONY: all debug sw pism_modules clean vsim synth test verilog print-versions version.hex megawizard

# Default to terasic_de4 for now.
BOARD_NAME=terasic_de4
ifdef BOARD
BOARD_NAME=$(BOARD)
endif

print-versions:
	$(BSC) -print-expiration | head -n1
	cd sw && $(MAKE) print-versions
	cd ../../cheritest/trunk && $(MAKE) print-versions

EXTRACTINFO=$(TOOLS_DIR)/cheri_genfiles.py

ifdef NOPRINTS
BLUESPEC_FLAGS += -D NOPRINTS
endif

export TAGS_STRUCT= 0
export TAGS_ALIGN=32
# it looks like this is the only way to get make to understand about whitespaces...
EMPTY :=
SPACE := $(EMPTY) $(EMPTY)
TSTRUCT = $(subst $(SPACE),_,$(strip $(TAGS_STRUCT)))
ifdef CAP
export CAPSIZE=256
BLUESPEC_FLAGS += -D CAP
IP_DIR := $(IP_DIR)cheri
BUILD_DIR := $(BUILD_DIR)_cap_tags_$(TSTRUCT:"%"=%)
else
ifdef CAP128
export CAPSIZE=128
BLUESPEC_FLAGS += -D CAP128
IP_DIR := $(IP_DIR)cheri128
BUILD_DIR := $(BUILD_DIR)_cap128_tags_$(TSTRUCT:"%"=%)
else
ifdef CAP64
export CAPSIZE=64
BLUESPEC_FLAGS += -D CAP64
IP_DIR := $(IP_DIR)cheri64
BUILD_DIR := $(BUILD_DIR)_cap64_tags_$(TSTRUCT:"%"=%)
else
IP_DIR := $(IP_DIR)beri
endif
endif
endif

ifdef CANDIDATE1
BLUESPEC_FLAGS += -D CANDIDATE1
IP_DIR := $(IP_DIR)_can1
BUILD_DIR := $(BUILD_DIR)_can1
endif

ifdef PREFETCH
ifeq ($(PREFETCH), L2CACHE)
BLUESPEC_FLAGS += -D PFTCH -D L2_PFTCH
BSV_FILES += Prefetcher.bsv
else ifeq ($(PREFETCH), DCACHE)
BLUESPEC_FLAGS += -D PFTCH -D DCACHE_PFTCH
BSV_FILES += Prefetcher.bsv
else ifeq ($(PREFETCH), CAP_L2CACHE)
BLUESPEC_FLAGS += -D PFTCH  -D CAPPFTCH -D L2_PFTCH
BSV_FILES += Prefetcher.bsv
else ifeq ($(PREFETCH), CAP_DCACHE)
BLUESPEC_FLAGS += -D PFTCH  -D CAPPFTCH -D DCACHE_PFTCH
BSV_FILES += Prefetcher.bsv
endif
endif

ifndef NOSTATCOUNTERS
BLUESPEC_FLAGS += -D STATCOUNTERS
BSV_FILES += $(CHERILIBS_DIR)/StatCounters.bsv
endif

ifdef MEM64
BSCFLAGS+=-D MEM64
BUILD_DIR := $(BUILD_DIR)_mem64
IP_DIR := $(IP_DIR)_mem64
else 
ifdef MEM128
BSCFLAGS+=-D MEM128
BUILD_DIR := $(BUILD_DIR)_mem128
IP_DIR := $(IP_DIR)_mem128
else
BSCFLAGS+=-D MEM256
endif
endif

ifdef WRITEBACK_DCACHE
BLUESPEC_FLAGS += -D WRITEBACK_DCACHE
IP_DIR := $(IP_DIR)_writeback
BUILD_DIR := $(BUILD_DIR)_writeback
endif

ifdef ALIGNEDMEMORY
BUILD_DIR := $(BUILD_DIR)_aligned
else
BLUESPEC_FLAGS += -D UNALIGNEDMEMORY
endif

ifdef MICRO
BLUESPEC_FLAGS += -D MICRO -D MULTI -D CORE_COUNT_IN=1
BUILD_DIR := $(BUILD_DIR)_micro
IP_DIR := $(IP_DIR)_micro
endif

ifdef BIG_DEBUG_BUF
BLUESPEC_FLAGS += -D BIG_DEBUG_BUF
BUILD_DIR := $(BUILD_DIR)_bigbuf
IP_DIR := $(IP_DIR)_bigbuf
endif

ifdef CHERIOS
BLUESPEC_FLAGS += -D CHERIOS
BUILD_DIR := $(BUILD_DIR)_cherios
IP_DIR := $(IP_DIR)_cherios
endif

ifdef MULTI
ifdef TIMEBASED
BLUESPEC_FLAGS += -D MULTI -D TIMEBASED -D CORE_COUNT_IN=$(MULTI)
BUILD_DIR := $(BUILD_DIR)_multi_timebased_$(MULTI)
IP_DIR := $(IP_DIR)_multi_timebased_$(MULTI)
DTS_CPP_FLAGS += -DMULTI=$(MULTI)
else
BLUESPEC_FLAGS += -D MULTI -D CORE_COUNT_IN=$(MULTI)
BUILD_DIR := $(BUILD_DIR)_multi_$(MULTI)
IP_DIR := $(IP_DIR)_multi_$(MULTI)
DTS_CPP_FLAGS += -DMULTI=$(MULTI)
endif
endif

ifdef RMA
BSVPATH:=$(BSVPATH):$(PERIPHERALS_DIR)/BlueLink/components/MemorySystem/common/bluespec
BSVPATH:=$(BSVPATH):$(PERIPHERALS_DIR)/BlueLink/components/MemorySystem/cheri/bluespec
BSVPATH:=$(BSVPATH):$(PERIPHERALS_DIR)/BlueLink/components/ReliableLinkLayer/bluespec
BSVPATH:=$(BSVPATH):$(PERIPHERALS_DIR)/BlueLink/components/MeshSystem/common/bluespec
BSVPATH:=$(BSVPATH):$(PERIPHERALS_DIR)/BlueLink/components/BluespecAvalon/bluespec
BLUESPEC_FLAGS += -D MULTI -D CORE_COUNT_IN=1 -D RMA
BUILD_DIR := $(BUILD_DIR)_rma_1
IP_DIR := $(IP_DIR)_rma_1
DTS_CPP_FLAGS += -DMULTI=1
endif

ifdef DMA
BLUESPEC_FLAGS += -D DMA
BUILD_DIR := $(BUILD_DIR)_dma
endif

ifdef DMA_VIRT
BLUESPEC_FLAGS += -D DMA_VIRT
BUILD_DIR := $(BUILD_DIR)_vdma
endif

ifdef WITH_NOCACHE
BLUESPEC_FLAGS += -D NOCACHE
BUILD_DIR := $(BUILD_DIR)_noCache
endif

ifdef NOBRANCH
BLUESPEC_FLAGS += -D NOBRANCHPREDICTION
BUILD_DIR := $(BUILD_DIR)_noBranch
endif

ifdef NOTAG
BLUESPEC_FLAGS += -D NOTAG
BUILD_DIR := $(BUILD_DIR)_noTag
endif

ifdef HARDCALL
BLUESPEC_FLAGS += -D HARDCALL
BUILD_DIR := $(BUILD_DIR)_hardCall
IP_DIR := $(IP_DIR)_hardCall
endif

# FPU is an alias for COP1 being defined
ifdef FPU
COP1=1
endif

ifdef COP1
BLUESPEC_FLAGS += -D COP1
BSC_SIM_LIBS += -l mpfr -l gmp
BUILD_DIR := $(BUILD_DIR)_fpu
IP_DIR := $(IP_DIR)_fpu
endif

ifdef NOWATCH
BLUESPEC_FLAGS += -D NOWATCH
BUILD_DIR := $(BUILD_DIR)_nowatch
endif

ifdef TRACE
BLUESPEC_FLAGS += -D TRACE
BUILD_DIR := $(BUILD_DIR)_trace
IP_DIR := $(IP_DIR)_trace
endif

ifdef TEST_MEM
BLUESPEC_FLAGS += -D TEST_MEM -suppress-warnings G0043
BUILD_DIR := $(BUILD_DIR)_testmem
BSV_FILES += \
	$(CHERILIBS_DIR)/BlueCheck/BlueCheck.bsv  \
	Test/Mem/TestMemTop.bsv                   \
	Test/Mem/MIPSTop_TestMem.bsv              \
	Test/Mem/MemoryClient.bsv                 \
	Test/Mem/TestEquiv.bsv                    \
	Test/Mem/ModelDRAM.bsv                    \
	Test/Mem/RegFileAssoc.bsv
EXTRA_LINK += Test/Mem/Hash.c Test/Mem/Axe.c
endif

ifdef TEST_MEM_ISA
BLUESPEC_FLAGS += -D TEST_MEM_ISA
BUILD_DIR := $(BUILD_DIR)_testmem_isa
endif

IP_NAME := $(shell echo $$(basename $(IP_DIR)) | tr '[:lower:]' '[:upper:]')

ifdef CAPSIZE
BSVPATH:=$(BSVPATH):$(BUILD_DIR)
BSV_FILES+=$(BUILD_DIR)/TagTableStructure.bsv
endif

verilog: BUILD_DIR := $(BUILD_DIR)_verilog

BLUESPEC_SIM_FLAGS += -D BLUESIM -D DEBUG_INST
BSC_SIM_FLAGS += -Xl -Wl,-rpath=$(PERIPHERALS_DIR) -L $(PERIPHERALS_DIR) -l pism -parallel-sim-link 4

# Avalon Case Variable Names
PHYS_TOPLEVEL = TopAxi
PHYS_VERILOG_TOPLEVEL = $(IP_DIR)/mk$(PHYS_TOPLEVEL).v
PHYS_BA_TOPLEVEL = $(BUILD_DIR)/mk$(PHYS_TOPLEVEL).ba
PHYS_BSV_TOPLEVEL = $(CHERILIBS_DIR)/$(PHYS_TOPLEVEL).bsv
PHYS_TOPLEVEL_MODULE = mk$(PHYS_TOPLEVEL)
# Simulation Case Variable Names
ifdef TEST_MEM
SIM_TOPLEVEL = TestMemTop
SIM_BA_TOPLEVEL = $(BUILD_DIR)/mk$(SIM_TOPLEVEL).ba
SIM_BSV_TOPLEVEL = Test/Mem/$(SIM_TOPLEVEL).bsv
SIM_TOPLEVEL_MODULE = mk$(SIM_TOPLEVEL)
else
SIM_TOPLEVEL = TopSimAxi
SIM_BA_TOPLEVEL = $(BUILD_DIR)/mk$(SIM_TOPLEVEL).ba
SIM_BSV_TOPLEVEL = $(CHERILIBS_DIR)/$(SIM_TOPLEVEL).bsv
SIM_TOPLEVEL_MODULE = mk$(SIM_TOPLEVEL)
endif

$(PHYS_VERILOG_TOPLEVEL): $(PHYS_BSV_TOPLEVEL) $(BSV_FILES) megawizard
	mkdir -p $(BUILD_DIR)
	mkdir -p $(IP_DIR)	
	$(BSC) -unspecified-to X -opt-undetermined-vals -vdir $(IP_DIR) -simdir $(BUILD_DIR) -bdir $(BUILD_DIR) -u -verilog $(BLUESPEC_FLAGS) $(PHYS_BSV_TOPLEVEL)
	cp $(CHERILIBS_DIR)/BRAM2Load.v $(IP_DIR)/
	cp $(CHERILIBS_DIR)/AltMEM.v $(IP_DIR)/
ifdef MEM64
	cp ip_include/hw64.tcl $(IP_DIR)/$(IP_NAME)_hw.tcl
else 
ifdef MEM128
	cp ip_include/hw128.tcl $(IP_DIR)/$(IP_NAME)_hw.tcl
else
	cp ip_include/hw.tcl $(IP_DIR)/$(IP_NAME)_hw.tcl
endif
endif
ifdef COP1
	cp FPU/QuartusProject/*.* $(IP_DIR)/
#	cp ip_include/fpu/* $(IP_DIR)/
endif
ifdef GENERICL1
	cp $(CHERILIBS_DIR)/AsymmetricBRAM/*.v $(IP_DIR)/ 
endif
	# make a note of the name of the toplevel module so Qsys can be adjusted to match
	echo "$(IP_NAME)" > ip_name.txt

$(PHYS_BA_TOPLEVEL): $(BSV_FILES)
	mkdir -p $(BUILD_DIR)
	$(BSC) -opt-undetermined-vals -unspecified-to X -simdir $(BUILD_DIR) -bdir $(BUILD_DIR) -u -sim $(BLUESPEC_FLAGS) -show-schedule $(PHYS_BSV_TOPLEVEL)

mem64.hex: sw

BUILD_DIR_SIM = $(BUILD_DIR)_sim

$(BUILD_DIR_SIM)/sim.dts.cpp: $(PERIPHERALS_DIR)/sim.dts.in
	mkdir -p $(BUILD_DIR_SIM)
	cpp $(DTS_CPP_FLAGS) -x assembler-with-cpp -include $< /dev/null | \
	    grep -v '^# [0-9]* "' > $@

.PHONY: $(QUARTUS_PROJECT).dts
$(BUILD_DIR_SIM)/sim.dts: $(BUILD_DIR_SIM)/sim.dts.cpp
	@echo "**********************************************************************"
	@echo "* Generate Simulation DTS file"
	@echo "**********************************************************************"
	$(TOOLS_DIR)/process-dts.sh $< $@

$(BUILD_DIR_SIM)/sim.dtb: $(BUILD_DIR_SIM)/sim.dts
	dtc -O dtb -o $@ -b 0 $<

sim sim.dtb sim.so: $(BUILD_DIR_SIM)/sim $(BUILD_DIR_SIM)/sim.so $(BUILD_DIR_SIM)/sim.dtb FORCE
	rm -f sim sim.dtb sim.so
	ln -s $(BUILD_DIR_SIM)/sim sim
	ln -s $(BUILD_DIR_SIM)/sim.dtb sim.dtb
	ln -s $(BUILD_DIR_SIM)/sim.so sim.so

sim.tar.gz : sim sim.so sim.dtb memoryconfig $(PERIPHERALS_DIR)/dram.so $(PERIPHERALS_DIR)/ethercap.so $(PERIPHERALS_DIR)/fb.so $(PERIPHERALS_DIR)/libpism.so $(PERIPHERALS_DIR)/sdcard.so $(PERIPHERALS_DIR)/uart.so $(PERIPHERALS_DIR)/virtio_block.so
	mkdir -p tarball_files/
	cp $^ tarball_files/.
	cd tarball_files/ && tar -cvzf $@ * && cp $@ ../ &&	cd ../
	rm -rf tarball_files/

clean_sim.tar.gz :
	rm -f sim.tar.gz

$(BUILD_DIR_SIM)/sim $(BUILD_DIR_SIM)/sim.so: $(BSV_FILES) $(PISM_LIB) $(EXTRA_LINK)
	rm -f $(CHERILIBS_DIR)/MEM.bo
	mkdir -p $(BUILD_DIR_SIM)
	CXXFLAGS=-D_GLIBCXX_USE_CXX11_ABI=0 MAKEFLAGS= $(BSC) $(BSC_SIM_FLAGS) $(BSC_SIM_LIBS) -simdir $(BUILD_DIR_SIM) -bdir $(BUILD_DIR_SIM) -u -sim $(BLUESPEC_FLAGS) $(BLUESPEC_SIM_FLAGS)-show-schedule $(SIM_BSV_TOPLEVEL)
	CXXFLAGS=-D_GLIBCXX_USE_CXX11_ABI=0 MAKEFLAGS= $(BSC) $(BSC_SIM_FLAGS) $(BSC_SIM_LIBS) -sim -e $(SIM_TOPLEVEL_MODULE) -simdir $(BUILD_DIR_SIM) -bdir $(BUILD_DIR_SIM) -o $(BUILD_DIR_SIM)/sim $(BUILD_DIR_SIM)/*.ba $(EXTRA_LINK)

test: sim
	cd ../../cheritest/trunk && $(MAKE) CHERIROOT=../../cheri/trunk test

jenkins_test: print-versions run
	cd ../../cheritest/trunk && \
            $(MAKE) nosetest CHERIROOT=../../cheri/trunk NOSEFLAGS="--with-xunit --xunit-file=nosetests.xml" && \
            $(MAKE) nosetest_cached CHERIROOT=../../cheri/trunk NOSEFLAGS="--with-xunit --xunit-file=nosetests_cached.xml" 

GXEMUL_BINDIR=/usr/groups/ctsrd/gxemul/CTSRD-CHERI-gxemul-testversion
jenkins_test_gxemul: print-versions
	cd ../../cheritest/trunk && \
            $(MAKE) gxemul-nosetest GXEMUL_BINDIR=$(GXEMUL_BINDIR) CHERIROOT=../../cheri/trunk NOSEFLAGS="--with-xunit --xunit-file=nosetests.xml" && \
            $(MAKE) gxemul-nosetest_cached GXEMUL_BINDIR=$(GXEMUL_BINDIR) CHERIROOT=../../cheri/trunk NOSEFLAGS="--with-xunit --xunit-file=nosetests.xml"

verilog: $(PHYS_VERILOG_TOPLEVEL) miniboot version.hex

sw: $(C_HEADERS)
	$(MAKE) -C sw/helloworld

miniboot: $(MINIBOOT_DIR)/miniboot.S
ifdef CHERIOS
	$(MAKE) -C $(MINIBOOT_DIR) CHERIOS=cherios
	cp $(MINIBOOT_DIR)/mem64.hex $(IP_DIR)/
	$(MAKE) -C $(MINIBOOT_DIR) clean
	$(MAKE) -C $(MINIBOOT_DIR) CHERIOS=cherios ALWAYS_WAIT=yesplease
	cp $(MINIBOOT_DIR)/mem64.hex $(IP_DIR)/mem64-nodip.hex
else
	$(MAKE) -C $(MINIBOOT_DIR)
	cp $(MINIBOOT_DIR)/mem64.hex $(IP_DIR)/
	$(MAKE) -C $(MINIBOOT_DIR) clean
	$(MAKE) -C $(MINIBOOT_DIR) ALWAYS_WAIT=yesplease
	cp $(MINIBOOT_DIR)/mem64.hex $(IP_DIR)/mem64-nodip.hex
endif

synth: $(PHYS_VERILOG_TOPLEVEL)
	(cd boards/$(BOARD_NAME) && make synth)
program:
	(cd boards/$(BOARD_NAME) && make program)
run:
	bash -c 'time echo -n "LADQ" | PISM_MODULES_PATH=../../cherilibs/trunk/peripherals ./sim -m 300000 2>&1'

megawizard:
ifdef COP1
	$(MAKE) -C FPU/QuartusProject megawizard
else
	# don't need to build Megawizard files since no FPU used
endif

#
# Developer section and development targets for testing
#
pism:	$(PISM_C_FILES) $(CHERICONF_FILES) $(PERIPHERALS_DIR)/pism.h
	$(CC) $(CFLAGS) -DPISM_TEST_PROG -std=c99 -Wall -pedantic -I $(INCLUDE_DIR) -o pism $(PISM_C_FILES) $(CHERICONF_FILES)

ifdef GENERICL1
$(CHERILIBS_DIR)/AsymmetricBRAM/mem_model.o: $(CHERILIBS_DIR)/AsymmetricBRAM/mem_model.c
	$(CC) -fPIC -c $< -o $@
endif

$(BUILD_DIR)/TagTableStructure.bsv: $(CHERILIBS_DIR)/tagsparams.py
	mkdir -p $(BUILD_DIR)
	$^ -c $(CAPSIZE) -s $(TAGS_STRUCT:"%"=%) -a $(TAGS_ALIGN) -b $(BUILD_DIR)/TagTableStructure.bsv

peripherals: pism_modules
pism_modules:
	$(MAKE) -C $(PERIPHERALS_DIR)

version.hex:
	tclsh $(TOOLS_DIR)/versionHexGenerate.tcl	
	cp version.hex boards/terasic_de4/version.hex	
clean:
	rm -rf ./build*
	rm -f *.sched
	rm -f Test/Mem/*.sched
	rm -f Test/Mem/*.o
	rm -f .vcsmx_rebuild
	rm -f sim
	rm -f sim.dtb
	rm -f sim.so
	rm -f sim.tar.gz
	rm -f sim.out
	rm -f mem.bin
	rm -rf ./csrc/
	rm -rf ./ip/*
	rm -f $(CHERILIBS_DIR)/*.bo
	rm -f $(CHERILIBS_DIR)/*.bi
	rm -f $(BUILD_DIR)/TagTableStructure.bsv
	rm -f *.o
	rm -f *.hex
	rm -f mkRegFile.v
	rm -f rename_qsys.py
	rm -f pism
	rm -f $(CHERILIBS_DIR)/AsymmetricBRAM/mem_model.o
	rm -f ip_name.txt
	$(MAKE) -C $(PERIPHERALS_DIR) clean
	$(MAKE) -C $(MINIBOOT_DIR) clean
	$(MAKE) -C FPU/QuartusProject clean
	cd sw && $(MAKE) clean
