# Makefile

# defaults
SIM ?= ghdl
TOPLEVEL_LANG ?= vhdl
EXTRA_ARGS += --std=08

VHDL_SOURCES += $(PWD)/sources/*.vhd
 #use VHDL_SOURCES for VHDL files

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = mcd_machine

# MODULE is the basename of the Python test file
MODULE = tbcoco_mcd_machine

# Explicitly set the PYTHONPATH to include the current directory
export PYTHONPATH := $(PWD):$(PYTHONPATH)

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim