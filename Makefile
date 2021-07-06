# Makefile - builds and runs Ipopt example
#
# To build a target, enter:
#
#   make <target>
#
# Targets:
#
#   all	  - clean any existing build and output files then build and run application
#   clean - deletes all files in build and output directoroes
#   app   - build application
#   run	  - run application

# Clear any implicit suffix rules
.SUFFIXES:

# Define variables pointing to relevant directories
SRC_DIR = src
OUTPUT_DIR = output
BUILD_DIR = build

# Name to use for built application
APP_NAME = run_optimization

# Fortran compiler
FC = gfortran

# Libraries to link against
LIBS = -lipopt

# Compiler flags
FFLAGS = -fcheck=bounds -ffree-line-length-0 -fimplicit-none -m64

.PHONY: all clean run app

all: clean app run

run: $(BUILD_DIR)/$(APP_NAME) $(OUTPUT_DIR)
	./$(BUILD_DIR)/$(APP_NAME)

app: $(BUILD_DIR) $(BUILD_DIR)/$(APP_NAME)

# Dependencies
$(BUILD_DIR)/problem71.o: $(SRC_DIR)/problem71.f90 | $(BUILD_DIR)
$(BUILD_DIR)/main.o: $(SRC_DIR)/main.f90 $(BUILD_DIR)/problem71.o | $(BUILD_DIR)
$(BUILD_DIR)/$(APP_NAME): $(BUILD_DIR)/main.o $(BUILD_DIR)/problem71.o

# Define recipe for building object files
$(BUILD_DIR)/%.o:
	$(FC) -c $(FFLAGS) -J $(BUILD_DIR) $< -o $@

# Define recipe for linking application
$(BUILD_DIR)/$(APP_NAME):
	$(FC) -o $@ $(FFLAGS) $^ $(LIBS)

# Create directories if not present
$(BUILD_DIR) $(OUTPUT_DIR):
	mkdir -p $@

clean:
	rm -rf $(BUILD_DIR) $(OUTPUT_DIR)
