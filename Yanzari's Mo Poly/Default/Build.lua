----------------------------------------------------------------------------------------------
---*Build.lua
--*A Lua build system so you can compile the Mod
--*
--*By ヤンザリ (Yanzari)
----------------------------------------------------------------------------------------------

local lfs = require("lfs")

--$ Project Configuration
local MOD_NAME = "SMRFCL_Yanzaris-Mo-Poly"
local VERSION = "v0.0.1"
local OUTPUT = MOD_NAME .. "_" .. VERSION .. ".pk3"

--$ Directory Structure
local SRC_DIR = "src"
local LUA_DIR = SRC_DIR .. "/Lua"
local BUILD_DIR = "build"
local TEMP_DIR = BUILD_DIR .. "/temp"

--$ Build Type
local BUILD_TYPE = arg[1] or "release"

--$ Colors
local GREEN  = "\27[0;32m"
local YELLOW = "\27[1;33m"
local RED    = "\27[0;31m"
local BLUE   = "\27[0;34m"
local CYAN   = "\27[0;36m"
local NC     = "\27[0m"

----------------------------------------------------------------------------------------------
--* Utility Functions
----------------------------------------------------------------------------------------------

local function echo(color, text)
	print(color .. text .. NC)
end

local function exists(path)
	return lfs.attributes(path) ~= nil
end

local function mkdir(path)
	if not exists(path) then
		lfs.mkdir(path)
	end
end

local function recursive_mkdir(path)
	local current = ""

	for part in path:gmatch("[^/]+") do
		current = current == "" and part or (current .. "/" .. part)
		mkdir(current)
	end
end

local function recursive_copy(src, dst)
	recursive_mkdir(dst)

	for file in lfs.dir(src) do
		if file ~= "." and file ~= ".." then
			local srcpath = src .. "/" .. file
			local dstpath = dst .. "/" .. file

			local attr = lfs.attributes(srcpath)

			if attr.mode == "directory" then
				recursive_copy(srcpath, dstpath)
			else
				local infile = io.open(srcpath, "rb")

				if infile then
					local data = infile:read("*a")
					infile:close()

					local outfile = io.open(dstpath, "wb")

					if outfile then
						outfile:write(data)
						outfile:close()
					end
				end
			end
		end
	end
end

local function recursive_delete_laux(path)
	for file in lfs.dir(path) do
		if file ~= "." and file ~= ".." then
			local fullpath = path .. "/" .. file
			local attr = lfs.attributes(fullpath)

			if attr.mode == "directory" then
				recursive_delete_laux(fullpath)
			else
				if fullpath:match("%.laux$") then
					echo(BLUE, "Removing " .. fullpath)
					os.remove(fullpath)
				end
			end
		end
	end
end

----------------------------------------------------------------------------------------------
--* Validation
----------------------------------------------------------------------------------------------

if not exists(SRC_DIR) then
	echo(RED, "Error: Source directory '" .. SRC_DIR .. "' not found!")
	os.exit(1)
end

----------------------------------------------------------------------------------------------
--* Prepare Build
----------------------------------------------------------------------------------------------

echo(CYAN, "Preparing build directories...")

recursive_mkdir(BUILD_DIR)
recursive_mkdir(TEMP_DIR)

----------------------------------------------------------------------------------------------
--* Copy Source Files
----------------------------------------------------------------------------------------------

echo(BLUE, "Copying source files...")

recursive_copy(SRC_DIR, TEMP_DIR)

recursive_mkdir(TEMP_DIR .. "/Lua")

----------------------------------------------------------------------------------------------
--* Compile LAUX
----------------------------------------------------------------------------------------------

echo(CYAN, "Compiling recursive .laux files...")

local laux_result = os.execute("lauxc workspace")

if laux_result ~= 0 and laux_result ~= true then
	echo(RED, "LAUX compilation failed!")
	os.exit(1)
end

----------------------------------------------------------------------------------------------
--* Remove .laux Files
----------------------------------------------------------------------------------------------

echo(BLUE, "Removing .laux files...")

recursive_delete_laux(TEMP_DIR)

----------------------------------------------------------------------------------------------
--* Create .build-note
----------------------------------------------------------------------------------------------

echo(BLUE, "Creating .build-note...")

do
	local file = io.open(TEMP_DIR .. "/.build-note", "w")

	file:write("Thank you for building the mod via lua, yanzari appreciates it.\n\n")
	file:write("—Yanzari\n")

	file:close()
end

----------------------------------------------------------------------------------------------
--* Create Maketype.lua
----------------------------------------------------------------------------------------------

echo(BLUE, "Creating Maketype.lua (" .. BUILD_TYPE .. ")...")

do
	local file = io.open(TEMP_DIR .. "/Lua/Maketype.lua", "w")

	file:write("local YMP = YanzMoPoly\n")

	if BUILD_TYPE == "debug" then
		file:write('YMP.BuildType = {build="Debug",compmod="lua"}\n')
	else
		file:write('YMP.BuildType = {build="Release",compmod="lua"}\n')
	end

	file:close()
end

----------------------------------------------------------------------------------------------
--* Create PK3
----------------------------------------------------------------------------------------------

echo(BLUE, "Creating PK3 archive...")

local zip_command =
	string.format(
		'cd "%s" && zip -qr "../../%s" .',
		TEMP_DIR,
		OUTPUT
	)

local zip_result = os.execute(zip_command)

if zip_result ~= 0 and zip_result ~= true then
	echo(RED, "Failed to create PK3!")
	os.exit(1)
end

echo(GREEN, "✓ Created " .. OUTPUT)

----------------------------------------------------------------------------------------------
--* Clean Temp
----------------------------------------------------------------------------------------------

echo(BLUE, "Cleaning temporary files...")

local function recursive_delete(path)
	for file in lfs.dir(path) do
		if file ~= "." and file ~= ".." then
			local fullpath = path .. "/" .. file
			local attr = lfs.attributes(fullpath)

			if attr.mode == "directory" then
				recursive_delete(fullpath)
				lfs.rmdir(fullpath)
			else
				os.remove(fullpath)
			end
		end
	end
end

recursive_delete(TEMP_DIR)
lfs.rmdir(TEMP_DIR)

----------------------------------------------------------------------------------------------
--* Final Output
----------------------------------------------------------------------------------------------

echo(GREEN, "✓ The compilation was completed successfully.")
echo(YELLOW, "Output: " .. OUTPUT)
echo(BLUE, "Build Type: " .. BUILD_TYPE)
echo(BLUE, "Build Tool: lua")
echo(BLUE, "File Made By Yanzari")

----------------------------------------------------------------------------------------------
--* End*--*Build.lua
----------------------------------------------------------------------------------------------