#--------------------------------------------------------------------------------------------
#---*Build.pro
#--*A QMake build system so you can compile the Mod
#--*
#--*By ヤンザリ (Yanzari)
#--------------------------------------------------------------------------------------------

TEMPLATE = aux
CONFIG += no_link

#--$ Project Configuration
MOD_NAME = SMRFCL_Yanzaris-Mo-Poly
VERSION = v0.0.1
OUTPUT = $$MOD_NAME\_$${VERSION}.pk3

#--$ Directory Structure
SRC_DIR = src
LUA_DIR = $$SRC_DIR/Lua
BUILD_DIR = build
TEMP_DIR = $$BUILD_DIR/temp

#--$ Build Type
CONFIG(debug, debug|release) {
    BUILD_TYPE = debug
} else {
    BUILD_TYPE = release
}

#--$ Colors
GREEN = "\\033[0;32m"
YELLOW = "\\033[1;33m"
RED = "\\033[0;31m"
BLUE = "\\033[0;34m"
CYAN = "\\033[0;36m"
NC = "\\033[0m"

#--------------------------------------------------------------------------------------------
#--*Prepare Build
#--------------------------------------------------------------------------------------------

prepare_build.target = prepare-build
prepare_build.commands = \
    echo "$$CYAN Creating build directories... $$NC" && \
    mkdir -p $$BUILD_DIR $$TEMP_DIR

QMAKE_EXTRA_TARGETS += prepare_build

#--------------------------------------------------------------------------------------------
#--*Copy Source Files
#--------------------------------------------------------------------------------------------

copy_src.target = copy-src
copy_src.depends = prepare-build
copy_src.commands = \
    echo "$$BLUE Copying source files... $$NC" && \
    cp -r $$SRC_DIR/* $$TEMP_DIR/ 2>/dev/null || true && \
    mkdir -p $$TEMP_DIR/Lua

QMAKE_EXTRA_TARGETS += copy_src

#--------------------------------------------------------------------------------------------
#--*Compile LAUX
#--------------------------------------------------------------------------------------------

build_laux.target = build-laux
build_laux.depends = copy-src
build_laux.commands = \
    echo "$$CYAN Compiling recursive .laux files... $$NC" && \
    lauxc workspace && \
    find $$TEMP_DIR -type f -name "*.laux" -delete

QMAKE_EXTRA_TARGETS += build_laux

#--------------------------------------------------------------------------------------------
#--*Create Build Note
#--------------------------------------------------------------------------------------------

create_build_note.target = create-build-note
create_build_note.depends = build-laux
create_build_note.commands = \
    echo "$$BLUE Creating .build-note... $$NC" && \
    echo "Thank you for building the mod via qmake, yanzari appreciates it." > $$TEMP_DIR/.build-note && \
    echo "" >> $$TEMP_DIR/.build-note && \
    echo "—Yanzari" >> $$TEMP_DIR/.build-note

QMAKE_EXTRA_TARGETS += create_build_note

#--------------------------------------------------------------------------------------------
#--*Create Maketype.lua
#--------------------------------------------------------------------------------------------

create_maketype.target = create-maketype-lua
create_maketype.depends = create-build-note

CONFIG(debug, debug|release) {

create_maketype.commands = \
    echo "$$BLUE Creating Maketype.lua (debug)... $$NC" && \
    echo 'local YMP = YanzMoPoly' > $$TEMP_DIR/Lua/Maketype.lua && \
    echo 'YMP.BuildType = {build="Debug",compmod="qmake"}' >> $$TEMP_DIR/Lua/Maketype.lua

} else {

create_maketype.commands = \
    echo "$$BLUE Creating Maketype.lua (release)... $$NC" && \
    echo 'local YMP = YanzMoPoly' > $$TEMP_DIR/Lua/Maketype.lua && \
    echo 'YMP.BuildType = {build="Release",compmod="qmake"}' >> $$TEMP_DIR/Lua/Maketype.lua

}

QMAKE_EXTRA_TARGETS += create_maketype

#--------------------------------------------------------------------------------------------
#--*Create PK3
#--------------------------------------------------------------------------------------------

create_zip.target = create-zip
create_zip.depends = create-maketype-lua
create_zip.commands = \
    echo "$$BLUE Creating PK3 archive... $$NC" && \
    cd $$TEMP_DIR && zip -qr ../../$$OUTPUT . && \
    echo "$$GREEN ✓ Created $$OUTPUT $$NC"

QMAKE_EXTRA_TARGETS += create_zip

#--------------------------------------------------------------------------------------------
#--*Clean Temp
#--------------------------------------------------------------------------------------------

clean_temp.target = clean-temp
clean_temp.depends = create-zip
clean_temp.commands = \
    echo "$$BLUE Cleaning temporary files... $$NC" && \
    rm -rf $$TEMP_DIR

QMAKE_EXTRA_TARGETS += clean_temp

#--------------------------------------------------------------------------------------------
#--*Main Build
#--------------------------------------------------------------------------------------------

build_mod.target = all
build_mod.depends = clean-temp
build_mod.commands = \
    echo "$$GREEN ✓ The compilation was completed successfully. $$NC" && \
    echo "$$YELLOW Output: $$OUTPUT $$NC" && \
    echo "$$BLUE Build Type: $$BUILD_TYPE $$NC" && \
    echo "$$BLUE Build Tool: qmake $$NC" && \
    echo "$$BLUE File Made By Yanzari $$NC"

QMAKE_EXTRA_TARGETS += build_mod

#--------------------------------------------------------------------------------------------
#--*Clean
#--------------------------------------------------------------------------------------------

QMAKE_CLEAN += $$OUTPUT
QMAKE_CLEAN += $$BUILD_DIR

#--------------------------------------------------------------------------------------------
#--*Info
#--------------------------------------------------------------------------------------------

message("========================================")
message("$$MOD_NAME Build System")
message("========================================")
message("Version: $$VERSION")
message("Default Output: $$OUTPUT")
message("Source Directory: $$SRC_DIR")
message("Build Directory: $$BUILD_DIR")
message("Build Tool: qmake")

#--------------------------------------------------------------------------------------------
#--*End*--*Build.pro
#--------------------------------------------------------------------------------------------