APP_NAME = 

TARGET = XCORE-AI-EXPLORER

#Run if file doesn't exist
$(shell [ ! -f monty1.h ] && python3 images/anigif_to_raw.py -j images/monty240x240_1.jpeg monty1.h)
$(shell [ ! -f monty2.h ] && python3 images/anigif_to_raw.py -j images/monty_240x240_2.jpeg monty2.h)

# The flags passed to xcc when building the application
XCC_FLAGS	= -fcomment-asm -Xmapper --map -Xmapper MAPFILE -Os -report -save-temps -g -fxscope 
			  
#-DSDA_HIGH=2 -DSCL_HIGH=1 -fxscope

# The USED_MODULES variable lists other module used by the application. These
# modules will extend the SOURCE_DIRS, INCLUDE_DIRS and LIB_DIRS variables.
# Modules are expected to be in the directory above the BASE_DIR directory.
USED_MODULES = ST7789

#=============================================================================
# The following part of the Makefile includes the common build infrastructure
# for compiling XMOS applications. You should not need to edit below here.

XMOS_MAKE_PATH ?= ../../..
include $(XMOS_MAKE_PATH)/xcommon/module_xcommon/build/Makefile.common

