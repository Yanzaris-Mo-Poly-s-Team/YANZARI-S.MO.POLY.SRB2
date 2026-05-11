/*
             Yanzari's Mo Poly
                -By Yanzari
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-
init.lua
*/

local unpack = table.unpack or unpack
local function pack(...)
    return {n=select("#", ...),...}
end
local Logger = {}
local ModuleCache = {}
local FuncModuleCache = {}
local CurrentPath = ""
local CurrentLoadedPath = ""
local ThisAmbient = _G

function Logger:Log(title, msg)
    print("[" .. title .. "] " .. msg)
end

function Logger:Error(msg)
    error("[x] " .. msg, 2)
end

local function normalize_path(path)
    local parts = {}
    for part in path:gmatch("[^/]+") do
        if part == ".." then
            if #parts > 0 then
                table.remove(parts)
            end
		elseif part == ".root." then
            parts = {}
        elseif part ~= "." then
            table.insert(parts, part)
        end
    end
    return table.concat(parts, "/")
end

local function get_path(path)
    local parts = {}
    for part in path:gmatch("[^/]+") do
		table.insert(parts, part)
    end
	table.remove(parts,#parts)
    return table.concat(parts, "/")
end

local function reget_path(path)
    local parts = {}
    for part in path:gmatch("[^/]+") do
		table.insert(parts, part)
    end
	local part = parts[#parts]
	if part:match("%.lua$") then
		parts[#parts] = part:sub(1,#part-#".lua")
	end
    return table.concat(parts, "/")
end

local function get_file(path)
	local parts = {}
    for part in path:gmatch("[^/]+") do
		table.insert(parts, part)
    end
	local part = parts[#parts]
	if part:match("%.lua$") then
		return part:sub(1,#part-#".lua")
	end
	return ""
end

local function try_load(path)
	local dirs = get_path(path)
	local file = get_file(path) .. ".lua"
	local sucess, chunk, err, berr
	if dirs ~= "" then
		sucess, chunk, err, berr = pcall(loadfile,dirs.."/"..file)
	else
		sucess, chunk, err, berr = pcall(loadfile,file)
	end
	if not (chunk ~= nil and type(chunk)=="function") then
		local dirs = get_path(path)
		local file = get_file(path) .. "/init.lua"
		if dirs ~= "" then
			sucess, chunk, err, berr = pcall(loadfile,dirs.."/"..file)
		else
			sucess, chunk, err, berr = pcall(loadfile,file)
		end
	end
	if not (chunk ~= nil and type(chunk)=="function") then
		local dirs = reget_path(path)
		local file = get_file(path) .. ".lua"
		if dirs ~= "" then
			sucess, chunk, err, berr = pcall(loadfile,dirs.."/"..file)
		else
			sucess, chunk, err, berr = pcall(loadfile,file)
		end
	end
	if not (chunk ~= nil and type(chunk)=="function") then
		local dirs = reget_path(path)
		local file = get_file(path) .. "/init.lua"
		if dirs ~= "" then
			sucess, chunk, err, berr = pcall(loadfile,dirs.."/"..file)
		else
			sucess, chunk, err, berr = pcall(loadfile,file)
		end
	end
	return chunk, err or berr
end

local function require(path)
    if not path:match("%.lua$") then
        path = path .. ".lua"
    end

	if CurrentPath:sub(1,#"lua/") == "lua/" then
		CurrentPath = CurrentPath:sub(#"lua/"+1,#CurrentPath)
	end
	if path:sub(1,#"lua/") == "lua/" then
		path = path:sub(#"lua/"+1,#path)
	end
	
    local full_path = CurrentPath .. path
    full_path = normalize_path(full_path)
	CurrentLoadedPath = full_path
	
    if ModuleCache[full_path]~=nil then
		return unpack(ModuleCache[full_path])
    end
	
	Logger:Log("+", "compiling \"" .. full_path .. "\"!")
    local chunk, err = try_load(full_path)
    if not chunk then
        full_path = normalize_path(path)
		CurrentLoadedPath = full_path
        if ModuleCache[full_path]~=nil then
			return unpack(ModuleCache[full_path])
		end
        chunk, err = try_load(full_path)
    end

    if chunk==nil then
        Logger:Error("Failed to load module '" .. path .. "': " .. (err or "not found"))
        return nil
    end
	
	if type(berr)=="string" then
		Logger:Error("Failed to load module '" .. path .. "': "..berr.."!")
        return nil
    end
	
	if type(chunk)=="string" then
		Logger:Error("Failed to load module '" .. path .. "'!")
        return nil
    end

    local old_path = CurrentPath
    local dir = full_path:match("(.*[/\\])") or ""
    CurrentPath = dir
	
    local env = setmetatable({
        require = require,
		package = {loaded = ModuleCache,loadedfunc = function() return FuncModuleCache end,now = function() return CurrentLoadedPath end,this = full_path}
    }, {__index = _G})
    setfenv(chunk, env)
	
    Logger:Log("+", "loading \"" .. full_path .. "\"!")
    local loadedchunk = pack(pcall(chunk))
    CurrentPath = old_path

    if not loadedchunk[1] then
        Logger:Error("Failed to execute module '"..full_path.."': " .. (loadedchunk[2] or "unknown error"))
        return nil
    end
	
	FuncModuleCache[full_path] = function()
		return unpack(ModuleCache[full_path])
	end
    ModuleCache[full_path] = {unpack(loadedchunk,2,loadedchunk.n)}
    return unpack(ModuleCache[full_path])
end

require("lua/init.lua")
return