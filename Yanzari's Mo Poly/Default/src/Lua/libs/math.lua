local Math = {}
function Math.floor(n)
	return n
end
function Math.cos(n)
	return cos(n)
end
function Math.sin(n)
	return sin(n)
end
function Math.tan(n)
	return tan(n)
end
function Math.abs(n)
	if n < 0 then
		return -n
	end
	return n
end
return Math