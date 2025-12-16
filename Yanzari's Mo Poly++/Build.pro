#--------------------------------------------------------------------------------------------
#---*Build.pro
#---*A Build.pro so you can compile the Mod
#--*It was designed to be used with qmake.
#--*
#--*By ヤンザリ(Yanzari)
#--------------------------------------------------------------------------------------------
#--*Start*--*Build.pro*--

#--*Comment*--*We will not use C/C++ code, only execute build commands*
TEMPLATE = aux
CONFIG += release

#--*Comment*--*Directories*--
SRC_DIR  = src  
BUILD_DIR = build  
TEMP_DIR = $$BUILD_DIR/temp

#--*Comment*--*Name, Version, and Output*--
MOD_NAME    = SMRFCL_Yanzaris-Mo-Poly-PlusPlus  
VERSION     = v0.0.1  
OUTPUT      = $$MOD_NAME_$$VERSION.pk3

ZIP  = zip  
RM   = rm -rf
MKDIR = mkdir -p
ECHO = echo

#--*Comment*--*defining extra target*--
QMAKE_EXTRA_TARGETS += prepare_build copy_src create_build_note create_maketype_lua create_zip clean_temp clean distclean

#--*Comment*--*Functions*--
# RULE: prepare_build  
prepare_build.commands = $$MKDIR $$BUILD_DIR $$TEMP_DIR  
prepare_build.depends =  
prepare_build.target = prepare_build

# RULE: copy_src  
copy_src.commands = $$ECHO Copying source files... && cp -r $$SRC_DIR/* $$TEMP_DIR/ 2>/dev/null || true && $$MKDIR $$TEMP_DIR/Lua  
copy_src.depends = prepare_build  
copy_src.target = copy_src

# RULE: create_build_note  
create_build_note.commands = $$ECHO Creating .build-note... && ( echo "Thank you for building the mod via qmake, yanzari appreciates it." > $$TEMP_DIR/.build-note )  
create_build_note.depends = copy_src  
create_build_note.target = create_build_note

# RULE: create_maketype_lua  
#--*Comment*--*Restricted to Release and Debug*--
isDebug = $$contains(CONFIG, debug)  
create_maketype_lua.commands = $$ECHO Creating Maketype.lua... && ( \
    if [ \"$${isDebug}\" = \"1\" ]; then \
       echo 'local YMP = YanzMoPolyPlusPlus' > $$TEMP_DIR/Lua/Maketype.lua; \
       echo 'YMP.BuildType = {build=\"Debug\",compmod=\"qmake\"}' >> $$TEMP_DIR/Lua/Maketype.lua; \
    else \
       echo 'local YMP = YanzMoPolyPlusPlus' > $$TEMP_DIR/Lua/Maketype.lua; \
       echo 'YMP.BuildType = {build=\"Release\",compmod=\"qmake\"}' >> $$TEMP_DIR/Lua/Maketype.lua; \
    fi )  
create_maketype_lua.depends = create_build_note  
create_maketype_lua.target = create_maketype_lua

# RULE: create_zip  
create_zip.commands = $$ECHO Creating PK3 archive... && cd $$TEMP_DIR && $$ZIP -qr ../../$$OUTPUT . && $$ECHO Created $$OUTPUT  
create_zip.depends = create_maketype_lua  
create_zip.target = create_zip

# RULE: clean_temp  
clean_temp.commands = $$ECHO Cleaning temporary files... && $$RM $$TEMP_DIR  
clean_temp.depends = create_zip  
clean_temp.target = clean_temp

# RULE: clean (Remove .pk3 file)  
clean.commands = $$ECHO Cleaning build artifacts... && $$RM $$OUTPUT  
clean.target = clean

# RULE: distclean (Clean Everything)  
distclean.commands = $$ECHO Deep cleaning... && $$RM $$BUILD_DIR  
distclean.target = distclean

#--*Comment*--*It must be a complete build*--
build_all.commands = $$MAKEFILE_TARGETS_COPY = prepare_build copy_src create_build_note create_maketype_lua create_zip clean_temp  
build_all.depends =  
build_all.target = all

#--*Note*--*It generates a Makefile*--
#--*End*--*Build.pro*--