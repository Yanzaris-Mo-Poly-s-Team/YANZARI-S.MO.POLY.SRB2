--------------------------------------------------------------------------------------------
---*Build.lua
---*A Build.lua so you can compile the Mod
--* This is a method in case you prefer to compile using Lua, since srb2 uses Lua
--* I made this in reference to SRB2.
--*Usage: lua Build.lua [release|debug|clean|distclean|info]
--*
--*By Yanzari
--------------------------------------------------------------------------------------------
--*Start*--*Build.lua*--

local function saferequire(lib)
local ok,lib = pcall(require,lib)
if ok then
return lib
end
return nil
end

local lfs = saferequire("lfs")  --$ This is our only dependency.
if lfs == nil then
print("Install the Lua File System on LuaRocks to be able to compile Yanzari Mo Poly using Lua.")
print("Install using: luarocks install luafilesystem")
return
end
--$ Download the dependency so you can use the script.

--$ Project Configuration
local MOD_NAME = "SMRFCL_Yanzaris-Mo-Poly"
local VERSION  = "v0.0.1"
local OUTPUT   = string.format("%s_%s.pk3", MOD_NAME, VERSION)

local SRC_DIR  = "src"
local LUA_DIR  = SRC_DIR .. "/Lua"
local BUILD_DIR = "build"
local TEMP_DIR  = BUILD_DIR .. "/temp"

--$ Commands
local is_windows = package.config:sub(1,1) == '\\'

local function F_CreateDirectory(path)
    if is_windows then
        os.execute(string.format('mkdir "%s" 2>nul', path))
    else
        os.execute(string.format('mkdir -p "%s"', path))
    end
end

local function F_RemoveDirectory(path)
    if is_windows then
        os.execute(string.format('rmdir /s /q "%s" 2>nul', path))
    else
        os.execute(string.format('rm -rf "%s"', path))
    end
end

local function F_CopyDirectory(src, dest)
    if is_windows then
        os.execute(string.format('xcopy "%s" "%s" /E /I /Y >nul', src, dest))
    else
        os.execute(string.format('cp -r "%s" "%s"', src, dest))
    end
end

local function F_Echo(msg, color)
    print(msg)
end

local function F_Usage()
    F_Echo("Usage: lua Build.lua [release|debug|clean|distclean|info]")
end

local function F_CreateCompilationNote(tempdir)
    local f = io.open(tempdir .. "/.build-note", "w")
    f:write("Thank you for building the mod via Build.lua, yanzari appreciates it.\n\n—Yanzari\n")
    f:close()
end

local function F_CreateBuildIdentificationFile(tempdir, build_type)
    local lua_dir = tempdir .. "/Lua"
    F_CreateDirectory(lua_dir)
    local f = io.open(lua_dir .. "/Maketype.lua", "w")
    f:write("local YMP = YanzMoPoly\n")
    if build_type == "debug" then
        f:write('YMP.BuildType = { build = "Debug", compmod = "Build.lua" }\n')
    else
        f:write('YMP.BuildType = { build = "Release", compmod = "Build.lua" }\n')
    end
    f:close()
end

local function F_CreateZip(tempdir, output)
    if is_windows then
        local cmd = string.format(
            'powershell -Command "Compress-Archive -Path \\"%s\\*\\*\\" -DestinationPath \\"%s\\""',
            tempdir, output
        )
        os.execute(cmd)
    else
        local cwd = lfs.currentdir()
        os.execute(string.format('cd "%s" && zip -qr "../%s" .', tempdir, output))
        lfs.chdir(cwd)
    end
end

local function F_CopySrc()
    F_Echo("Copying source files...", "")
    F_CopyDirectory(SRC_DIR, TEMP_DIR)
    F_CreateDirectory(TEMP_DIR .. "/Lua")
end

local function F_CleanTemp()
    F_Echo("Cleaning temporary files...", "")
    F_RemoveDirectory(TEMP_DIR)
end

local function F_TargetRelease()
    F_CreateDirectory(BUILD_DIR)
    F_CreateDirectory(TEMP_DIR)
    F_CopySrc()
    F_CreateCompilationNote(TEMP_DIR)
    F_CreateBuildIdentificationFile(TEMP_DIR, "release")
    F_CreateZip(TEMP_DIR, OUTPUT)
    F_CleanTemp()
    F_Echo("✓ The compilation was completed successfully.", "")
    F_Echo("Output: " .. OUTPUT, "")
    F_Echo("Build Type: release", "")
    F_Echo("Build Tool: Build.lua", "")
    F_Echo("File Made By Yanzari", "")
end

local function F_TargetDebug()
    F_CreateDirectory(BUILD_DIR)
    F_CreateDirectory(TEMP_DIR)
    F_CopySrc()
    F_CreateCompilationNote(TEMP_DIR)
    F_CreateBuildIdentificationFile(TEMP_DIR, "debug")
    F_CreateZip(TEMP_DIR, OUTPUT)
    F_CleanTemp()
    F_Echo("✓ The compilation was completed successfully.", "")
    F_Echo("Output: " .. OUTPUT, "")
    F_Echo("Build Type: debug", "")
    F_Echo("Build Tool: Build.lua", "")
    F_Echo("File Made By Yanzari", "")
end

local function F_Clean()
    F_Echo("Cleaning build artifacts...", "")
    if os.rename(OUTPUT, OUTPUT) then
        os.remove(OUTPUT)
    end
    F_Echo("✓ Clean completed", "")
end

local function F_DistClean()
    F_Clean()
    F_RemoveDirectory(BUILD_DIR)
    F_Echo("✓ All build files removed", "")
end

local function F_Info()
    print("A Tool for Compiling Yanzari's Mo Poly with Lua")
    print("")
    print("Available Commands: ")
    print("  release   - Build in release mode (default)")
    print("  debug     - Build in debug mode")
    print("  clean     - Remove PK3 file")
    print("  distclean - Remove all build files")
    print("  info      - Show this information")
end

--$ Main
local arg = arg or {}
local cmd = arg[1] or "release"

if cmd == "release" then
    F_TargetRelease()
elseif cmd == "debug" then
    F_TargetDebug()
elseif cmd == "clean" then
    F_Clean()
elseif cmd == "distclean" then
    F_DistClean()
elseif cmd == "info" then
    F_Info()
else
    F_Usage()
end

--*End*--*Build.lua*--