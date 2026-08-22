# =============================================================================
# MSP430 MAKEFILE
# =============================================================================

# MODIFY FOR YOUR PLATFORM: -----------
PLATFORM = linux
MCU = msp430fr2153
EXCLUDE =
WARNFLAGS = -Wall
# -------------------------------------

# FILES & DIRECTORIES -----------------
INCDIR = mcu/include
SRCDIR = mcu/src
TEST_SRCDIR = mcu/test
# -------------------------------------

# BUILD CONFIGURATION ---------------------------------------------------------

TARGET = firmware

# COMPILER & TOOLCHAIN ------------------------------------
CC = msp430-elf-gcc
TOOLDIR = /opt/msp430-gcc
# ---------------------------------------------------------

# COMPILER FLAGS ------------------------------------------
CCFLAGS =	-mmcu=$(MCU) \
			-Os \
			-fdiagnostics-color=always \
			$(WARNFLAGS) \
			-I $(INCDIR) \
			-I $(TOOLDIR)/include \
			-I $(TOOLDIR)/msp430-elf/include
# ---------------------------------------------------------

# LINKER FLAGS --------------------------------------------
LDFLAGS = 	-mmcu=$(MCU) \
			-L $(TOOLDIR)/msp430-elf/lib \
			-T $(TOOLDIR)/msp430-elf/lib/$(MCU).ld
# ---------------------------------------------------------

# SOURCE CODE SEARCH ------------------
SRCS =		$(filter-out $(EXCLUDE), \
			$(shell find $(SRCDIR) -name '*.c'))
# -------------------------------------

# -----------------------------------------------------------------------------

# USBIPD (FOR WSL ONLY) ---------------
ifeq ($(PLATFORM), wsl)
USBIPD = usbipd.exe
MSP_VIDPID = 2047:0013
BUSID := $(shell \
			$(USBIPD) list 2>/dev/null \
			| grep '$(MSP_VIDPID)' \
			| awk '{print $$1}')
ATTACH = attach-fet
else
ATTACH = 
endif
# -------------------------------------

# COMPILE! ================================================
all: $(TARGET).out
$(TARGET).out: $(SRCS)
	$(CC) $(CCFLAGS) $(LDFLAGS) -o $@ $(SRCS)
# =========================================================

# USBIPD ATTACH FET ---------------------------------------
attach-fet:
	@if [ -z "$(BUSID)" ]; then \
		echo "usbipd: no MSP430 eZ-FET found."; \
		exit 1; \
	fi
	@echo "usbipd: found MSP430 eZ-FET at bus ID: $(BUSID)"
	$(USBIPD) attach --wsl --busid $(BUSID) 2>/dev/null || true
	@sleep 1
# ---------------------------------------------------------

# TEST ------------------------------------------------------------------------
test:
	@$(MAKE) SRCDIR=$(TEST_SRCDIR) TARGET=test
# -----------------------------------------------------------------------------

# FLASH -----------------------------------------------------------------------
flash: $(TARGET).out $(ATTACH)
	mspdebug tilib "prog $(TARGET).out"
# -----------------------------------------------------------------------------

# TEST FLASH ------------------------------------------------------------------
test-flash:
	@$(MAKE) flash SRCDIR=$(TEST_SRCDIR) TARGET=test
# -----------------------------------------------------------------------------

# DEBUG -----------------------------------------------------------------------
debug: $(TARGET).out $(ATTACH)
	mspdebug tilib
# -----------------------------------------------------------------------------

# CLEAN -----------------------------------------------------------------------
clean:
	rm -f *.out
# -----------------------------------------------------------------------------

.PHONY: all test flash test-flash debug clean attach-fet
