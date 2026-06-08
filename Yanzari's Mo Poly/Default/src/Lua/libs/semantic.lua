local Semantic = {}
Semantic.__index = Semantic
function Semantic.new()
	local self = setmetatable({},Semantic)
	self.scope = {}
	self.scope[0] = {}
	self.depth = 0
	return self
end
function Semantic:PushScope()
    self.depth = self.depth + 1
    self.scope[self.depth] = {}
end
function Semantic:PopScope()
	if self.depth == 0 then return end
    self.scope[self.depth] = nil
    self.depth = self.depth - 1
end
function Semantic:Scope()
	local scope = self.scope[self.depth]
	if not scope then return nil end
	return scope
end
function Semantic:AddSymbol(name,data)
	local scope = self.scope[self.depth]
	if not scope then return nil end
	if scope[name] then return nil end
	scope[name] = data
	return true
end
function Semantic:UpdateSymbol(name, data)
    for i = self.depth, 0, -1 do
        local scope = self.scope[i]
        if scope and scope[name] then
            scope[name] = data
            return true
        end
    end
    return false
end
function Semantic:GetSymbol(name)
    for i = self.depth, 0, -1 do
        local scope = self.scope[i]
        if scope and scope[name] then
            return scope[name]
        end
    end
    return nil
end
return Semantic