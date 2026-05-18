local Service = {}
local ColorEnum = {
	White = "\x80",
	Magenta = "\x81",
	Yellow = "\x82",
	Green = "\x83",
	Blue = "\x84",
	Red = "\x85",
	Gray = "\x86",
	Orange = "\x87",
	Sky = "\x88",
	Purple = "\x89",
	Aqua = "\x8A",
	Peridot = "\x8B",
	Azure = "\x8C",
	Brown = "\x8D",
	Rosy = "\x8E",
	Black = "\x8F"
}
function Service.Print(color,...)
	local msg = ...
	print(ColorEnum[color]..msg)
	return
end
return Service