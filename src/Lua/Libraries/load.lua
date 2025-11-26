----* Yanzari's Mo Poly
---* Lua 5.4 Load
---* By Yanzari

local M = {}

-----------------------------------------------------------
-- Utilities
-----------------------------------------------------------
local function err(msg, pos)
    error((pos and ("[pos "..pos.."] ") or "") .. msg, 0)
end

local function isalpha(ch) return ch:match("%a") ~= nil end
local function isdigit(ch) return ch:match("%d") ~= nil end
local function isalnum(ch) return ch:match("[%w_]") ~= nil end

-----------------------------------------------------------
-- chunk reading function
-----------------------------------------------------------
local function read_chunk_to_string(chunk)
    if type(chunk) == "string" then return chunk end
    if type(chunk) == "function" then
        local parts = {}
        while true do
            local piece = chunk()
            if piece == nil then break end
            if type(piece) ~= "string" then
                err("The reader function should return a string or nil.")
            end
            parts[#parts+1] = piece
        end
        return table.concat(parts)
    end
    err("chunk must be string or reader function")
end

-----------------------------------------------------------
-- Lexer
-----------------------------------------------------------
local function lexer(input)
    local i, n = 1, #input
    local tokens = {}
    local function peek() return input:sub(i,i) end
    local function nextc() local c = input:sub(i,i); i = i + 1; return c end
    local function add(type, val, pos) table.insert(tokens, {type=type, val=val, pos=pos or (i-1)}) end

    local keywords = {
        ["and"]=true, ["break"]=true, ["do"]=true, ["else"]=true, ["elseif"]=true,
        ["end"]=true, ["false"]=true, ["for"]=true, ["function"]=true, ["if"]=true,
        ["in"]=true, ["local"]=true, ["nil"]=true, ["not"]=true, ["or"]=true,
        ["repeat"]=true, ["return"]=true, ["then"]=true, ["true"]=true, ["until"]=true,
        ["while"]=true
    }

    while i <= n do
        local c = peek()

        if c == " " or c == "\t" or c == "\r" or c == "\n" then
            i = i + 1

        elseif c == "-" and input:sub(i+1,i+1) == "-" then
            i = i + 2
            if input:sub(i,i+1) == "[[" then
                i = i + 2
                local s = input:find("%]%]", i, true); i = s and (s+2) or (n+1)
            else
                while i <= n and input:sub(i,i) ~= "\n" do i = i + 1 end
            end

        elseif c == "'" or c == '"' then
            local quote = nextc()
            local pos0 = i-1
            local buf = {}
            while i <= n do
                local d = nextc()
                if d == "\\" then
                    local e = nextc()
                    if e == "n" then table.insert(buf, "\n")
                    elseif e == "r" then table.insert(buf, "\r")
                    elseif e == "t" then table.insert(buf, "\t")
                    elseif e == "\\" then table.insert(buf, "\\")
                    elseif e == quote then table.insert(buf, quote)
                    else table.insert(buf, e) end
                elseif d == quote then
                    add("string", table.concat(buf), pos0)
                    break
                else
                    table.insert(buf, d)
                end
            end
            if tokens[#tokens] == nil or tokens[#tokens].pos ~= pos0 then
                err("unterminated string", pos0)
            end

        elseif c == "[" and input:sub(i+1,i+1) == "[" then
            local pos0 = i
            i = i + 2
            local s = input:find("%]%]", i, true)
            local content
            if s then
                content = input:sub(i, s-1)
                i = s + 2
            else
                err("unterminated long string", pos0)
            end
            add("string", content, pos0)

        elseif isdigit(c) or (c == "." and isdigit(input:sub(i+1,i+1))) then
            local pos0 = i
            local start = i
            local hasDot = false
            if c == "." then hasDot = true; i = i + 1 end
            while i <= n and isdigit(input:sub(i,i)) do i = i + 1 end
            if input:sub(i,i) == "." and isdigit(input:sub(i+1,i+1)) then
                hasDot = true; i = i + 1
                while i <= n and isdigit(input:sub(i,i)) do i = i + 1 end
            end
            if input:sub(i,i):lower() == "e" then
                i = i + 1
                if input:sub(i,i) == "+" or input:sub(i,i) == "-" then i = i + 1 end
                while i <= n and isdigit(input:sub(i,i)) do i = i + 1 end
            end
            add("number", tonumber(input:sub(start, i-1)), pos0)

        elseif isalpha(c) or c == "_" then
            local pos0 = i
            local start = i
            i = i + 1
            while i <= n and isalnum(input:sub(i,i)) do i = i + 1 end
            local word = input:sub(start, i-1)
            if keywords[word] then add(word, word, pos0)
            else add("ident", word, pos0) end

        else
            local pos0 = i
            local two = input:sub(i, i+1)
            local three = input:sub(i, i+2)

            if two == ".." then add("concat", "..", pos0); i = i + 2
            elseif two == "==" then add("eq", "==", pos0); i = i + 2
            elseif two == "~=" then add("neq", "~=", pos0); i = i + 2
            elseif two == "<=" then add("le", "<=", pos0); i = i + 2
            elseif two == ">=" then add("ge", ">=", pos0); i = i + 2
            elseif three == "..." then add("vararg", "...", pos0); i = i + 3
            else
                local map = {
                    ["+"]="plus", ["-"]="minus", ["*"]="mul", ["/"]="div", ["%"]="mod", ["^"]="pow",
                    ["#"]="len", ["="]="assign", ["<"]="lt", [">"]="gt",
                    ["("]="lpar", [")"]="rpar", ["{"]="lbrace", ["}"]="rbrace",
                    ["["]="lbrack", ["]"]="rbrack", [","]="comma", [";"]="semi",
                    ["."]="dot", [":"]="colon"
                }
                local t = map[c]
                if not t then err("unexpected character: "..c, pos0) end
                add(t, c, pos0)
                i = i + 1
            end
        end
    end
    add("eof", nil, i)
    return tokens
end

-----------------------------------------------------------
-- Parser (AST)
-----------------------------------------------------------
local function parser(tokens)
    local pos = 1
    local function tk() return tokens[pos] end
    local function eat(type)
        if tk().type == type then pos = pos + 1; return tokens[pos-1]
        else err("expected "..type..", obtained "..tk().type, tk().pos) end
    end
    local function opt(type)
        if tk().type == type then return eat(type) end
    end
    local function is(type) return tk().type == type end

    local parse_block, parse_stmt, parse_exp, parse_funcbody, parse_table, parse_explist

    local function parse_primary()
        if is("number") then return {tag="num", val=eat("number").val}
        elseif is("string") then return {tag="str", val=eat("string").val}
        elseif is("true") then eat("true"); return {tag="bool", val=true}
        elseif is("false") then eat("false"); return {tag="bool", val=false}
        elseif is("nil") then eat("nil"); return {tag="nil"}
        elseif is("vararg") then eat("vararg"); return {tag="vararg"}
        elseif is("ident") then
            local id = eat("ident").val
            return {tag="name", name=id}
        elseif is("lpar") then
            eat("lpar")
            local e = parse_exp()
            eat("rpar")
            return e
        elseif is("function") then
            eat("function")
            local params, body = parse_funcbody()
            return {tag="func", params=params, body=body}
        elseif is("lbrace") then
            return parse_table()
        else
            err("invalid expression", tk().pos)
        end
    end

    local function parse_suffixed()
        local node = parse_primary()
        while true do
            if is("dot") then
                eat("dot")
                local id = eat("ident").val
                node = {tag="index", obj=node, key={tag="str", val=id}, fromdot=true}
            elseif is("lbrack") then
                eat("lbrack")
                local key = parse_exp()
                eat("rbrack")
                node = {tag="index", obj=node, key=key}
            elseif is("lpar") then
                eat("lpar")
                local args = {}
                if not is("rpar") then
                    repeat
                        args[#args+1] = parse_exp()
                    until not opt("comma")
                end
                eat("rpar")
                node = {tag="call", func=node, args=args}
            else
                break
            end
        end
        return node
    end

    local unops = { ["minus"]="neg", ["not"]="not", ["len"]="len" }
    local function parse_unary()
        if is("minus") or is("not") or is("len") then
            local op = tk().type; eat(op)
            return {tag=unops[op], exp=parse_unary()}
        else
            return parse_suffixed()
        end
    end

    local bin_levels = {
        { "pow" },                         -- right-assoc ^
        { "mul", "div", "mod" },
        { "plus", "minus" },
        { "concat" },                      -- ..
        { "lt", "le", "gt", "ge", "eq", "neq" },
        { "and" },
        { "or" }
    }

    local function parse_binlevel(level)
        if level > #bin_levels then return parse_unary() end
        if bin_levels[level][1] == "pow" then
            local left = parse_binlevel(level+1)
            while is("pow") do
                local op = eat("pow").type
                local right = parse_binlevel(level+1)
                left = {tag="bin", op=op, left=left, right=right}
            end
            return left
        else
            local left = parse_binlevel(level+1)
            local set = {}
            for _,k in ipairs(bin_levels[level]) do set[k]=true end
            while set[tk().type] do
                local op = tk().type; eat(op)
                local right = parse_binlevel(level+1)
                left = {tag="bin", op=op, left=left, right=right}
            end
            return left
        end
    end

    function parse_exp() return parse_binlevel(1) end

    function parse_table()
        eat("lbrace")
        local fields = {}
        if not is("rbrace") then
            repeat
                if is("lbrack") then
                    eat("lbrack"); local k = parse_exp(); eat("rbrack"); eat("assign"); local v = parse_exp()
                    fields[#fields+1] = {tag="kv", key=k, val=v}
                elseif is("ident") and tokens[pos+1].type == "assign" then
                    local k = eat("ident").val
                    eat("assign")
                    local v = parse_exp()
                    fields[#fields+1] = {tag="kv", key={tag="str", val=k}, val=v}
                else
                    fields[#fields+1] = {tag="list", val=parse_exp()}
                end
            until not (opt("comma") or opt("semi"))
        end
        eat("rbrace")
        return {tag="table", fields=fields}
    end

    local function parse_namechain()
        local name = eat("ident").val
        local chain = {name}
        while is("dot") do eat("dot"); chain[#chain+1] = eat("ident").val end
        local method = false
        if is("colon") then eat("colon"); chain[#chain+1] = eat("ident").val; method = true end
        return chain, method
    end

    function parse_funcbody()
        eat("lpar")
        local params = {}
        local vararg = false
        if not is("rpar") then
            repeat
                if is("vararg") then eat("vararg"); vararg = true; break
                local id = eat("ident").val
                params[#params+1] = id
            until not opt("comma")
        end
        eat("rpar")
        local body = parse_block()
        eat("end")
        return {params=params, vararg=vararg}, body
    end

    local function parse_local()
        eat("local")
        if is("function") then
            eat("function")
            local name = eat("ident").val
            local fb_params, fb_body = parse_funcbody()
            return {tag="localfunc", name=name, params=fb_params, body=fb_body}
        else
            local names = { eat("ident").val }
            while opt("comma") do names[#names+1] = eat("ident").val end
            local exps = nil
            if opt("assign") then exps = parse_explist() end
            return {tag="local", names=names, exps=exps}
        end
    end

    function parse_explist()
        local exps = { parse_exp() }
        while opt("comma") do exps[#exps+1] = parse_exp() end
        return exps
    end

    local function parse_for()
        eat("for")
        local name = eat("ident").val
        if is("assign") then
            -- for i = a,b[,c] do block end
            eat("assign")
            local e1 = parse_exp(); eat("comma")
            local e2 = parse_exp()
            local e3 = nil
            if opt("comma") then e3 = parse_exp() end
            eat("do")
            local b = parse_block(); eat("end")
            return {tag="fornum", var=name, e1=e1, e2=e2, e3=e3, block=b}
        else
            -- for a,b in explist do block end
            local names = { name }
            while opt("comma") do names[#names+1] = eat("ident").val end
            eat("in")
            local exps = parse_explist()
            eat("do")
            local b = parse_block(); eat("end")
            return {tag="forin", names=names, exps=exps, block=b}
        end
    end

    local function parse_assign_or_call()
        local first = parse_suffixed()
        if is("assign") or is("comma") then
            local lhs = { first }
            while opt("comma") do lhs[#lhs+1] = parse_suffixed() end
            eat("assign")
            local rhs = parse_explist()
            return {tag="assign", lhs=lhs, rhs=rhs}
        else
            if first.tag == "call" then
                return {tag="callstmt", call=first}
            else
                err("invalid statement", tk().pos)
            end
        end
    end

    function parse_stmt()
        if is("local") then return parse_local() end
        if is("function") then
            eat("function")
            local chain, method = parse_namechain()
            local fb_params, fb_body = parse_funcbody()
            return {tag="funcset", chain=chain, method=method, params=fb_params, body=fb_body}
        end
        if is("return") then
            eat("return")
            local exps = {}
            if not (is("eof") or is("end") or is("else") or is("elseif") or is("until")) then
                exps = parse_explist()
            end
            return {tag="return", exps=exps}
        end
        if is("break") then eat("break"); return {tag="break"} end
        if is("if") then
            eat("if")
            local cond = parse_exp(); eat("then")
            local th = parse_block()
            local elsifs = {}
            while is("elseif") do
                eat("elseif")
                local c = parse_exp(); eat("then")
                elsifs[#elsifs+1] = {cond=c, block=parse_block()}
            end
            local el = nil
            if is("else") then eat("else"); el = parse_block() end
            eat("end")
            return {tag="if", cond=cond, th=th, elsifs=elsifs, el=el}
        end
        if is("while") then
            eat("while"); local cond = parse_exp(); eat("do")
            local b = parse_block(); eat("end")
            return {tag="while", cond=cond, block=b}
        end
        if is("repeat") then
            eat("repeat"); local b = parse_block(); eat("until"); local cond = parse_exp()
            return {tag="repeat", block=b, cond=cond}
        end
        if is("for") then return parse_for() end
        return parse_assign_or_call()
    end

    function parse_block()
        local stmts = {}
        while not (is("eof") or is("end") or is("else") or is("elseif") or is("until")) do
            stmts[#stmts+1] = parse_stmt()
            opt("semi")
        end
        return {tag="block", stmts=stmts}
    end

    local ast = parse_block()
    if not is("eof") then err("remaining tokens", tk().pos) end
    return ast
end

-----------------------------------------------------------
-- Interpreter
-----------------------------------------------------------
local function new_env(base)
    local env = base or {}
    setmetatable(env, { __index = _G })
    return env
end

local function Scope(parent)
    return { vars = {}, parent = parent }
end

local function scope_get(scope, name)
    local s = scope
    while s do
        if s.vars[name] ~= nil then return s.vars[name], true end
        s = s.parent
    end
    return nil, false
end

local function scope_set(scope, name, val)
    local s = scope
    while s do
        if s.vars[name] ~= nil then s.vars[name] = val; return true end
        s = s.parent
    end
    return false
end

local function scope_define(scope, name, val)
    scope.vars[name] = val
end

local BreakSignal = {}

local function eval_exp(node, scope, env)
    local tag = node.tag

    if tag == "num" then return node.val
    elseif tag == "str" then return node.val
    elseif tag == "bool" then return node.val
    elseif tag == "nil" then return nil
    elseif tag == "name" then
        local v, found = scope_get(scope, node.name)
        if found then return v end
        return env[node.name]
    elseif tag == "vararg" then
        return scope.vars["..."]  -- table with _is_vararg
    elseif tag == "neg" then
        return -eval_exp(node.exp, scope, env)
    elseif tag == "not" then
        return not eval_exp(node.exp, scope, env)
    elseif tag == "len" then
        local x = eval_exp(node.exp, scope, env)
        return (#x)
    elseif tag == "bin" then
        local a = eval_exp(node.left, scope, env)
        local b = eval_exp(node.right, scope, env)
        local op = node.op
        if op == "plus" then return a + b
        elseif op == "minus" then return a - b
        elseif op == "mul" then return a * b
        elseif op == "div" then return a / b
        elseif op == "mod" then return a % b
        elseif op == "pow" then return a ^ b
        elseif op == "concat" then return tostring(a) .. tostring(b)
        elseif op == "lt" then return a < b
        elseif op == "le" then return a <= b
        elseif op == "gt" then return a > b
        elseif op == "ge" then return a >= b
        elseif op == "eq" then return a == b
        elseif op == "neq" then return a ~= b
        elseif op == "and" then return (a and b) or a
        elseif op == "or" then return a or b
        else err("binary op not supported") end
    elseif tag == "table" then
        local t = {}
        local arr_i = 1
        for _,f in ipairs(node.fields) do
            if f.tag == "list" then
                t[arr_i] = eval_exp(f.val, scope, env); arr_i = arr_i + 1
            else
                t[eval_exp(f.key, scope, env)] = eval_exp(f.val, scope, env)
            end
        end
        return t
    elseif tag == "index" then
        local obj = eval_exp(node.obj, scope, env)
        local key = eval_exp(node.key, scope, env)
        return obj[key]
    elseif tag == "call" then
        local fn = eval_exp(node.func, scope, env)
        local args = {}
        for i,a in ipairs(node.args) do args[i] = eval_exp(a, scope, env) end
        -- Expand vararg table if present
        local expanded = {}
        for i=1,#args do expanded[#expanded+1] = args[i] end
        local last = args[#args]
        if type(last) == "table" and last._is_vararg then
            for _,v in ipairs(last) do expanded[#expanded+1] = v end
        end
        return fn(table.unpack(expanded))
    elseif tag == "func" then
        local params = node.params.params
        local vararg = node.params.vararg
        local body = node.body
        local closure_scope = scope
        local function fn(...)
            local call_scope = Scope(closure_scope)
            local given = {...}
            for i=1,#params do scope_define(call_scope, params[i], given[i]) end
            if vararg then
                local rest = {}
                for j=#params+1,#given do rest[#rest+1] = given[j] end
                rest._is_vararg = true
                scope_define(call_scope, "...", rest)
            end
            local ret = { exec_block(body, call_scope, env) }
            return table.unpack(ret)
        end
        return fn
    else
        err("unsupported expression: "..tostring(tag))
    end
end

local function assign_target_set(target, val, scope, env)
    if target.tag == "name" then
        if not scope_set(scope, target.name, val) then
            env[target.name] = val
        end
    elseif target.tag == "index" then
        local obj = eval_exp(target.obj, scope, env)
        local key = eval_exp(target.key, scope, env)
        obj[key] = val
    else
        err("Invalid assignment target")
    end
end

function exec_block(block, scope, env)
    for _,stmt in ipairs(block.stmts) do
        local tag = stmt.tag

        if tag == "local" then
            local values = {}
            if stmt.exps then
                for i,e in ipairs(stmt.exps) do values[i] = eval_exp(e, scope, env) end
            end
            for i,name in ipairs(stmt.names) do
                scope_define(scope, name, values[i])
            end

        elseif tag == "localfunc" then
            local closure_scope = scope
            local params = stmt.params
            local body = stmt.body
            local function fn(...)
                local call_scope = Scope(closure_scope)
                local given = {...}
                for i=1,#params.params do scope_define(call_scope, params.params[i], given[i]) end
                if params.vararg then
                    local rest = {}
                    for j=#params.params+1,#given do rest[#rest+1] = given[j] end
                    rest._is_vararg = true
                    scope_define(call_scope, "...", rest)
                end
                local ret = { exec_block(body, call_scope, env) }
                return table.unpack(ret)
            end
            scope_define(scope, stmt.name, fn)

        elseif tag == "funcset" then
            local obj = env
            local baseName = stmt.chain[1]
            local baseVal, found = scope_get(scope, baseName)
            if found then obj = baseVal else obj = env[baseName] end
            if obj == nil then
                obj = {}
                if found then scope_set(scope, baseName, obj) else env[baseName] = obj end
            end
            for i=2,#stmt.chain-1 do
                local k = stmt.chain[i]
                if obj[k] == nil then obj[k] = {} end
                obj = obj[k]
            end
            local fname = stmt.chain[#stmt.chain]
            local closure_scope = scope
            local params = stmt.params
            local body = stmt.body
            local function fn(...)
                local call_scope = Scope(closure_scope)
                local given = {...}
                -- The ':' method does not inject automatically; pass it manually.
                for i=1,#params.params do scope_define(call_scope, params.params[i], given[i]) end
                if params.vararg then
                    local rest = {}
                    for j=#params.params+1,#given do rest[#rest+1] = given[j] end
                    rest._is_vararg = true
                    scope_define(call_scope, "...", rest)
                end
                local ret = { exec_block(body, call_scope, env) }
                return table.unpack(ret)
            end
            obj[fname] = fn

        elseif tag == "assign" then
            local values = {}
            for i,e in ipairs(stmt.rhs) do values[i] = eval_exp(e, scope, env) end
            for i,target in ipairs(stmt.lhs) do assign_target_set(target, values[i], scope, env) end

        elseif tag == "callstmt" then
            eval_exp(stmt.call, scope, env)

        elseif tag == "if" then
            if eval_exp(stmt.cond, scope, env) then
                local r = exec_block(stmt.th, Scope(scope), env)
                if r ~= nil then return r end
            else
                local done = false
                for _,e in ipairs(stmt.elsifs) do
                    if eval_exp(e.cond, scope, env) then
                        local r = exec_block(e.block, Scope(scope), env)
                        if r ~= nil then return r end
                        done = true; break
                    end
                end
                if not done and stmt.el then
                    local r = exec_block(stmt.el, Scope(scope), env)
                    if r ~= nil then return r end
                end
            end

        elseif tag == "while" then
            while eval_exp(stmt.cond, scope, env) do
                local r = exec_block(stmt.block, Scope(scope), env)
                if r == BreakSignal then break end
                if r ~= nil and r ~= BreakSignal then return r end
            end

        elseif tag == "repeat" then
            repeat
                local r = exec_block(stmt.block, Scope(scope), env)
                if r == BreakSignal then break end
                if r ~= nil and r ~= BreakSignal then return r end
            until eval_exp(stmt.cond, scope, env)

        elseif tag == "fornum" then
            local i0 = eval_exp(stmt.e1, scope, env)
            local i1 = eval_exp(stmt.e2, scope, env)
            local step = stmt.e3 and eval_exp(stmt.e3, scope, env) or 1
            local loop_scope = Scope(scope)
            for i=i0, i1, step do
                scope_define(loop_scope, stmt.var, i)
                local r = exec_block(stmt.block, loop_scope, env)
                if r == BreakSignal then break end
                if r ~= nil and r ~= BreakSignal then return r end
            end

        elseif tag == "forin" then
            local exps = {}
            for i,e in ipairs(stmt.exps) do exps[i] = eval_exp(e, scope, env) end
            local iter, state, ctrl = exps[1], exps[2], exps[3]
            local loop_scope = Scope(scope)
            while true do
                local values = { iter(state, ctrl) }
                if values[1] == nil then break end
                ctrl = values[1]
                for i,name in ipairs(stmt.names) do scope_define(loop_scope, name, values[i]) end
                local r = exec_block(stmt.block, loop_scope, env)
                if r == BreakSignal then break end
                if r ~= nil and r ~= BreakSignal then return r end
            end

        elseif tag == "break" then
            return BreakSignal

        elseif tag == "return" then
            local vals = {}
            for i,e in ipairs(stmt.exps) do vals[i] = eval_exp(e, scope, env) end
            return table.unpack(vals)

        else
            err("statement not supported: "..tostring(tag))
        end
    end
    return nil
end

-----------------------------------------------------------
-- load(chunk, chunkname?, mode?, env?)
-----------------------------------------------------------
function M:load(chunk, chunkname, mode, env)
    local code = read_chunk_to_string(chunk)
    local ast = parser(lexer(code))
    local myenv = new_env(env or _G)

    local function compiled(...)
        local scope = Scope(nil)
        local given = {...}
        if #given > 0 then
            local rest = {}
            for i=1,#given do rest[i] = given[i] end
            rest._is_vararg = true
            scope_define(scope, "...", rest)
        end
        return exec_block(ast, scope, myenv)
    end

    return compiled
end

return M