/*
             Yanzari's Mo Poly
                -By Yanzari
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-
class.lua
*/
local Classes = {}
local unpack = table.unpack or unpack
local function InjectSuper(f, supclasses)
    local fenv = getfenv(f)
	local sup = supclasses
    fenv.supercls = function(n)
		return sup[n]
	end
    setfenv(f, fenv)
end

function Classes.Create(name, class, ...)
    local ClassObject = {}
    local ClassMeta = {}
    local args = {...}
	local function inited(self,...)
		local instance = {}
        if class.__new__ then
			InjectSuper(class.__new__, args)
            instance = class.__new__(class, ...)
			if instance ~= nil then
				if type(instance) ~= "table" then
					return instance
				end
				return nil
			end
        end
		instance.__class = ClassObject
		
        local meta_instanceObj = {}
        meta_instanceObj.__call = function(t, ...)
            if class.__call__ then
                return class.__call__(instance, ...)
            end
            return nil
        end
        meta_instanceObj.__tostring = function()
            if class.__repr__ then
                return class.__repr__(instance)
            end
            return "<" .. name .. " object>"
        end
        meta_instanceObj.__index = function(t, k)
		    local v = instance[k]
			if class[k]~=nil
			and type(class[k])=="table"
			and class[k].__value__ ~= nil
			and class[k].__is_value__ == true
			and class[k].__type__ ~= nil
			and type(class[k].__type__) == "string" then
				return class[k].__value__
			end
			if k~=nil
			and type(k)=="string"
			and k:sub(1,#"___")=="___"  then
				return nil
			end
			if k~=nil
			and type(k)=="string"
			and class["___"..k]~=nil  then
				return class["___"..k]
			end
            if v ~= nil then
				return v
			end
            return class[k]
        end
        meta_instanceObj.__newindex = function(t, k, v)
			if class[k]~=nil
			and type(class[k])=="table"
			and class[k].__value__ ~= nil
			and class[k].__is_value__ == true
			and class[k].__type__ ~= nil
			and type(class[k].__type__) == "string" then
				if type(v) == class[k].__type__ then
					instance[k] = {val=v,isval=true,type=class[k].__type__}
					return
				else
					if class[k].__type__ == "class" then
						if ClassObject == v.__class then
							instance[k] = {val=nil,isval=true,isclass=true,type=class[k].__type__}
							return
						end
					end
					error("Invalid Type")
				end
			end
			local val = instance[k]
			print(k)
			if val~=nil
			and type(val)=="table"
			and val.val ~= nil
			and val.isval == true
			and val.type ~= nil
			and type(val.type) == "string" then
				if type(v) == val.type then
					instance[k] = {val=v,isval=true,type=class[k].__type__}
					return
				else
					if val.type == "class" then
						if ClassObject == v.__class then
							instance[k] = {val=nil,isval=true,isclass=true,type=class[k].__type__}
							return
						end
					end
					error("Invalid Type")
				end
			end
            instance[k] = v
			return
        end
        meta_instanceObj.__usedindex = function(t, k, v)
			if class[k]~=nil
			and type(class[k])=="table"
			and class[k].__value__ ~= nil
			and class[k].__is_value__ == true
			and class[k].__type__ ~= nil
			and type(class[k].__type__) == "string" then
				if type(v) == class[k].__type__ then
					instance[k] = {val=v,isval=true}
					return
				else
					if class[k].__type__ == "class" then
						if ClassObject ~= v.__class then
							instance[k] = {val=v,isval=true,isclass=true}
							return
						end
					end
					error("Invalid Type")
				end
			end
            instance[k] = v
			return
        end

        if class.__init__ then
			InjectSuper(class.__init__, args)
            local instnc_other = class.__init__(instance, ...)
			if instnc_other ~= nil then
				instance = instnc_other
			end
        end

        setmetatable(self, meta_instanceObj)
		return self
	end
    ClassMeta.__call = function(self, ...)
        return inited(self,...)
    end
    ClassMeta.__index = function(self, k)
		if type(k)~="string" or (type(k)=="string" and k:sub(1,#"___")~="___")  then
			return class[k]
		end
		return nil
    end

    ClassMeta.__newindex = function(self, k, v)
        class[k] = v
    end

    ClassMeta.__usedindex = function(self, k, v)
        class[k] = v
    end
	ClassMeta.__tostring = function(self)
        return "<class '"..name.."'>"
    end
    setmetatable(ClassObject, ClassMeta)
	ClassObject.Create = inited
    return ClassObject
end

setmetatable(Classes, { __call = function(self,...)
	local CreateAClass = Classes.Create(...)
	self = CreateAClass
	return CreateAClass
end})
return Classes