#--------------------------------------------------------------------------------------------
#---*Makefile
#--*A Makefile so you can compile the Mod
#--*
#--*By ヤンザリ (Yanzari)
#--------------------------------------------------------------------------------------------
#--*Start*--*Makefile*--

#--$ Project Configuration
MOD_NAME = SMRFCL_Yanzaris-Mo-Poly-PlusPlus
VERSION = v0.0.1
OUTPUT = $(MOD_NAME)_$(VERSION).pk3

#--$ Directory Structure
SRC_DIR = src
LUA_DIR = $(SRC_DIR)/Lua
BUILD_DIR = build
TEMP_DIR = $(BUILD_DIR)/temp

#--$ Tools
ZIP = zip
RM = rm -rf
MKDIR = mkdir -p
ECHO = echo

#--$ Build Type (default to release)
BUILD_TYPE ?= release

#--$ Colors for pretty output
GREEN = \033[0;32m
YELLOW = \033[1;33m
RED = \033[0;31m
BLUE = \033[0;34m
CYAN = \033[0;36m
NC = \033[0m

#--*Category*-- 
#--*Main Targets
#--*Category*-- 

.PHONY: all debug release clean help distclean info

#--$ Default target
all: release

#--$ Debug build
debug: BUILD_TYPE = debug
debug: prepare-build
	@$(ECHO) "$(CYAN)Building in DEBUG mode...$(NC)"
	@$(MAKE) --no-print-directory $(OUTPUT)

#--$ Release build
release: BUILD_TYPE = release
release: prepare-build
	@$(ECHO) "$(GREEN)Building in RELEASE mode...$(NC)"
	@$(MAKE) --no-print-directory $(OUTPUT)

#--$ Create output directory and prepare for build
prepare-build:
	@$(MKDIR) $(BUILD_DIR) $(TEMP_DIR)

#--$ Build the PK3 file
$(OUTPUT): copy-src create-build-note create-maketype-lua create-zip clean-temp
	@$(ECHO) "$(GREEN)✓ The compilation was completed successfully.$(NC)"
	@$(ECHO) "$(YELLOW)Output: $(OUTPUT)$(NC)"
	@$(ECHO) "$(BLUE)Build Type: $(BUILD_TYPE)$(NC)"
	@$(ECHO) "$(BLUE)Build Tool: make$(NC)"
	@$(ECHO) "$(BLUE)File Made By Yanzari"

#--*Category*-- 
#--*Build Steps
#--*Category*-- 

#--$ Copy source files to temp directory
copy-src:
	@$(ECHO) "$(BLUE)Copying source files...$(NC)"
	@cp -r $(SRC_DIR)/* $(TEMP_DIR)/ 2>/dev/null || true
	@$(MKDIR) $(TEMP_DIR)/Lua

#--$ Create build note
create-build-note:
	@$(ECHO) "$(BLUE)Creating .build-note...$(NC)"
	@$(ECHO) "Thank you for building the mod via make, yanzari appreciates it." > $(TEMP_DIR)/.build-note
	@$(ECHO) "" >> $(TEMP_DIR)/.build-note
	@$(ECHO) "—Yanzari" >> $(TEMP_DIR)/.build-note

#--$ Create Maketype.lua based on build type
create-maketype-lua:
	@$(ECHO) "$(BLUE)Creating Maketype.lua ($(BUILD_TYPE))...$(NC)"
ifeq ($(BUILD_TYPE),debug)
	@$(ECHO) 'local YMP = YanzMoPolyPlusPlus' > $(TEMP_DIR)/Lua/Maketype.lua
	@$(ECHO) 'YMP.BuildType = {build="Debug",compmod="make"}' >> $(TEMP_DIR)/Lua/Maketype.lua
else
	@$(ECHO) 'local YMP = YanzMoPolyPlusPlus' > $(TEMP_DIR)/Lua/Maketype.lua
	@$(ECHO) 'YMP.BuildType = {build="Release",compmod="make"}' >> $(TEMP_DIR)/Lua/Maketype.lua
endif

#--$ Create the ZIP/PK3 file
create-zip:
	@$(ECHO) "$(BLUE)Creating PK3 archive...$(NC)"
	@cd $(TEMP_DIR) && $(ZIP) -qr ../../$(OUTPUT) .
	@$(ECHO) "$(GREEN)✓ Created $(OUTPUT)$(NC)"

#--$ Clean temporary directory
clean-temp:
	@$(ECHO) "$(BLUE)Cleaning temporary files...$(NC)"
	@$(RM) $(TEMP_DIR)

#--*Category*-- 
#--*Utility Targets
#--*Category*-- 

#--$ Clean build artifacts
clean:
	@$(ECHO) "$(YELLOW)Cleaning build artifacts...$(NC)"
	@$(RM) $(OUTPUT)
	@$(ECHO) "$(GREEN)✓ Clean completed$(NC)"

#--$ Deep clean (removes everything)
distclean: clean
	@$(ECHO) "$(YELLOW)Deep cleaning...$(NC)"
	@$(RM) $(BUILD_DIR)
	@$(ECHO) "$(GREEN)✓ All build files removed$(NC)"

#--$ Show build information
info:
	@$(ECHO) "$(GREEN)========================================$(NC)"
	@$(ECHO) "$(YELLOW)$(MOD_NAME) Build System$(NC)"
	@$(ECHO) "$(GREEN)========================================$(NC)"
	@$(ECHO) "$(BLUE)Version:$(NC) $(VERSION)"
	@$(ECHO) "$(BLUE)Default Output:$(NC) $(OUTPUT)"
	@$(ECHO) "$(BLUE)Source Directory:$(NC) $(SRC_DIR)"
	@$(ECHO) "$(BLUE)Build Directory:$(NC) $(BUILD_DIR)"
	@$(ECHO) "$(BLUE)Build Tool:$(NC) make"
	@$(ECHO) ""
	@$(ECHO) "$(YELLOW)Available targets:$(NC)"
	@$(ECHO) "  make release   - Build in release mode (default)"
	@$(ECHO) "  make debug     - Build in debug mode"
	@$(ECHO) "  make clean     - Remove PK3 file"
	@$(ECHO) "  make distclean - Remove all build files"
	@$(ECHO) "  make info      - Show this information"
	@$(ECHO) "  make help      - Show help message"

#--$ Help message
help: info

#--*Category*-- 
#--*Validation
#--*Category*-- 

#--$ Check if source directory exists
$(SRC_DIR):
	@$(ECHO) "$(RED)Error: Source directory '$(SRC_DIR)' not found!$(NC)"
	@exit 1

#--$ Ensure source exists before building
$(OUTPUT): $(SRC_DIR)

#--*Category*-- 
#--*Test Targets
#--*Category*-- 

.PHONY: test-build test-clean

#--$ Test the build process
test-build: debug release
	@$(ECHO) "$(GREEN)✓ Test build completed$(NC)"
	@$(ECHO) "$(YELLOW)Checking generated files...$(NC)"
	@if [ -f $(OUTPUT) ]; then $(ECHO) "$(GREEN)✓ PK3 file exists$(NC)"; else $(ECHO) "$(RED)✗ PK3 file missing$(NC)"; fi
	@$(ZIP) -T $(OUTPUT) && $(ECHO) "$(GREEN)✓ PK3 file is valid$(NC)" || $(ECHO) "$(RED)✗ PK3 file is corrupt$(NC)"

#--$ Test clean process
test-clean: test-build
	@$(MAKE) clean
	@if [ ! -f $(OUTPUT) ]; then $(ECHO) "$(GREEN)✓ Clean test passed$(NC)"; else $(ECHO) "$(RED)✗ Clean test failed$(NC)"; fi
	
#--*End*--*Makefile*--