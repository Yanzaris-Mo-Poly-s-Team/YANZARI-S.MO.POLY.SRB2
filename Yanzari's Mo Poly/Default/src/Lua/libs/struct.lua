local struct = {}

local function to_u8(val, bits)
  local max = 2 ^ (bits or 1)
  return val % max
end

local function from_u8(v)
  if v >= 128 then return v - 256 end
  return v
end

local function read_int(stream, i, n, signed)
  local val = 0
  for j = 0, n - 1 do
    val = val + stream:byte(i + j) * (2 ^ (8 * j))
  end

  if signed then
    local limit = 2 ^ (n * 8 - 1)
    if val >= limit then
      val = val - 2 ^ (n * 8)
    end
  end

  return val, i + n
end

local function write_int(val, n)
  local bytes = {}
  local max = 2 ^ (n * 8)

  if val < 0 then
    val = max + val
  end

  for i = 1, n do
    bytes[i] = string.char(val % 256)
    val = (val / 256)
  end

  return table.concat(bytes)
end

function struct.new(fmt)
  local types = {}

  for token in fmt:gmatch("%S+") do
    table.insert(types, token)
  end

  local obj = {}

  function obj.pack(...)
    local args = {...}
    local out = {}

    for i, t in ipairs(types) do
      local v = args[i]

      if t == "u8" then
        out[#out+1] = string.char(to_u8(v))

      elseif t == "i8" then
        out[#out+1] = string.char(to_u8(v))

      elseif t == "u16" then
        out[#out+1] = write_int(v, 2)

      elseif t == "i16" then
        out[#out+1] = write_int(v, 2)

      elseif t == "i32" then
        out[#out+1] = write_int(v, 4)

      elseif t == "s" then
        out[#out+1] = tostring(v) .. string.char(0)

      elseif t:sub(1,1) == "c" then
        local size = tonumber(t:sub(2))
        local str = tostring(v)
        if #str < size then
          str = str .. string.rep(" ", size - #str)
        end
        out[#out+1] = str:sub(1, size)
      end
    end

    return table.concat(out)
  end

  function obj.unpack(stream)
    local res = {}
    local i = 1

    for _, t in ipairs(types) do
      if t == "u8" then
        res[#res+1] = stream:byte(i)
        i = i + 1

      elseif t == "i8" then
        res[#res+1] = from_u8(stream:byte(i))
        i = i + 1

      elseif t == "u16" then
        local v
        v, i = read_int(stream, i, 2, false)
        res[#res+1] = v

      elseif t == "i16" then
        local v
        v, i = read_int(stream, i, 2, true)
        res[#res+1] = v

      elseif t == "i32" then
        local v
        v, i = read_int(stream, i, 4, true)
        res[#res+1] = v

      elseif t == "s" then
        local start = i
        while stream:byte(i) ~= 0 and i <= #stream do
          i = i + 1
        end
        res[#res+1] = stream:sub(start, i - 1)
        i = i + 1

      elseif t:sub(1,1) == "c" then
        local size = tonumber(t:sub(2))
        res[#res+1] = stream:sub(i, i + size - 1)
        i = i + size
      end
    end

    return unpack(res)
  end

  return obj
end

return struct