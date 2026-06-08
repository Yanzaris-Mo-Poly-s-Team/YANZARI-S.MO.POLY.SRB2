local Lists = {}
function Lists.new()
	local List = {}
	local ObjList = {}
	function ObjList.add(k,v)
		assert(List[k]==nil)
		table.insert(List,k,v)
	end
	function ObjList.update(k,v)
		assert(List[k]~=nil)
		List[k] = v
	end
	function ObjList.get(k)
		assert(List[k]~=nil)
		return List[k]
	end
	function ObjList.delete(k)
		assert(List[k]~=nil)
		table.remove(List,k)
	end
	return ObjList
end
return Lists