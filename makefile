# originating https://github.com/TheNetAdmin/Makefile-Templates
# tool marcros
CC := g++
CCFLAG := -std=c++11
DBGFLAG := -g
CCOBJFLAG := $(CCFLAG) -c
LIBFLAG := -L
INCFLAG := -I

# path marcros
BIN_PATH := bin
OBJ_PATH := obj
SRC_PATH := src
LIB_PATH := ./lib
INC_PATH := ./inc
DBG_PATH := debug

LIBFLAG := $(LIBFLAG)$(LIB_PATH)/gtest

# compile marcros
TARGET_NAME := main
ifeq ($(OS),Windows_NT)
	TARGET_NAME := $(addsuffix .exe,$(TARGET_NAME))
endif
TARGET := $(BIN_PATH)/$(TARGET_NAME)
TARGET_DEBUG := $(DBG_PATH)/$(TARGET_NAME)
MAIN_SRC := src/main.cpp

# src files & obj files
SRC := $(foreach x, $(SRC_PATH), $(wildcard $(addprefix $(x)/*,.c*)))
OBJ := $(addprefix $(OBJ_PATH)/, $(addsuffix .o, $(notdir $(basename $(SRC)))))
OBJ_DEBUG := $(addprefix $(DBG_PATH)/, $(addsuffix .o, $(notdir $(basename $(SRC)))))

# clean files list
DISTCLEAN_LIST := $(OBJ) \
                  $(OBJ_DEBUG)
CLEAN_LIST := $(TARGET) \
			  $(TARGET_DEBUG) \
			  $(DISTCLEAN_LIST)

# default rule
default: all

# non-phony targets
$(TARGET): $(OBJ)
	$(CC) $(CCFLAG) $(LIBFLAG) -o $@ $^

$(OBJ_PATH)/%.o: $(SRC_PATH)/%.c*
	$(CC) $(CCOBJFLAG) $(INCFLAG)$(INC_PATH) -o $@ $<

$(DBG_PATH)/%.o: $(SRC_PATH)/%.c*
	$(CC) $(CCOBJFLAG) $(DBGFLAG) $(INCFLAG)$(INC_PATH) -o $@ $<

$(TARGET_DEBUG): $(OBJ_DEBUG)
	$(CC) $(CCFLAG) $(DBGFLAG) $(LIBFLAG) $^ -o $@

# phony rules
.PHONY: all
all: $(TARGET)

.PHONY: debug
debug: $(TARGET_DEBUG)

.PHONY: clean
clean:
	@echo CLEAN $(CLEAN_LIST)
	@rm -f $(CLEAN_LIST)

.PHONY: distclean
distclean:
	@echo CLEAN $(CLEAN_LIST)
	@rm -f $(DISTCLEAN_LIST)
