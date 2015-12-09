if not manipulator_module then qerror('Only usable from within manipulator') end

storage = storage or {}

function if_nil(v, default)
    if v == nil then return default else return v end
end

function check_nil(v, msg, traceback)
    if v == nil then
        (traceback and error or qerror)(msg ~= nil and msg or 'nil value', 2)
    end
    return v
end

function clone_table(tbl)
    local out = {}
    for k, v in pairs(tbl) do
        out[k] = v
    end
    return out
end

function clear_table(tbl)
    for k, v in pairs(tbl) do tbl[k] = nil end
end

function irange(a, b)
    local i = math.min(a, b) - 1
    local max = math.max(a, b)
    return function()
        i = i + 1
        if i <= max then
            return i
        end
    end
end

function strict_open(path, mode, on_fail)
    local function fail(msg)
        (on_fail or error)(('Could not open %s: %s'):format(path, msg))
    end
    if not mode then fail('No mode specified') end
    local f, err, code = io.open(path, mode)
    if not f then
        fail(tostring(code) .. ': ' .. tostring(err))
    end
    return f
end

function strip_whitespace(str)
    return str:gsub('^%s+', ''):gsub('%s+$', '')
end

function join_pairs(...)
    -- Returns a generator with all key/value pairs from multiple tables
    -- DFHack-generated userdata does not support next(), so it is necessary to
    -- generate all key/value pairs beforehand
    local data = {}
    for _, tbl in pairs({...}) do
        for k, v in pairs(tbl) do
            -- Ensure that the original order returned by pairs() is preserved
            table.insert(data, {k, v})
        end
    end
    local k = nil
    local v = nil
    return function()
        k, v = next(data, k)
        if k == nil then
            return
        end
        return table.unpack(v)
    end
end

function scroll_index(index, delta, min, max, opts)
    if not opts then opts = {} end
    if opts.wrap == nil then opts.wrap = true end
    index = index + delta
    if delta < 0 and index < min then
        if index <= min + delta and opts.wrap then
            index = max
        else
            index = min
        end
    elseif delta > 0 and index > max then
        if index >= max + delta and opts.wrap then
            index = min
        else
            index = max
        end
    end
    return index
end

if dfhack.units.getSquadName == nil then
    function dfhack.units.getSquadName(unit)
        if (unit.military.squad_id == -1) then return "" end
        local squad = df.squad.find(unit.military.squad_id);
        if not squad then return "" end
        if (#squad.alias > 0) then return squad.alias end
        return dfhack.TranslateName(squad.name, true)
    end
end

if dfhack.units.getKillCount == nil then
    function dfhack.units.getKillCount(unit)
        local histfig = df.historical_figure.find(unit.hist_figure_id)
        local count = 0
        if histfig and histfig.info.kills then
            for _, v in pairs(histfig.info.kills.killed_count) do
                count = count + v
            end
        end
        return count
    end
end

function colored_dialog(color, default_title)
    return function(title, desc)
        if desc == nil then
            desc = title
            title = default_title or 'Error'
        end
        require('gui.dialogs').showMessage(title, desc, COLOR_LIGHTRED)
    end
end
dwarn = colored_dialog(COLOR_YELLOW, 'Warning')
derror = colored_dialog(COLOR_LIGHTRED, 'Error')

skills = {}
function skills.experience(unit, skill)
    return dfhack.units.getExperience(unit._native, skill)
end

function skills.rating(unit, skill)
    local rating = dfhack.units.getNominalSkill(unit._native, skill) + 1
    local exp = skills.experience(unit, skill)
    if exp == 0 and rating == 1 then
        return 0
    end
    return math.min(rating, #SKILL_LEVELS)
end

OutputString = dfhack.screen.paintString

function OutputKeyString(pen, x, y, key, str)
    if df.interface_key[key] ~= nil then key = df.interface_key[key] end
    local disp = dfhack.screen.getKeyDisplay(key)
    OutputString(COLOR_LIGHTGREEN, x, y, disp)
    OutputString(pen, x + #disp, y, ': ' .. str)
end

function process_keys(keys)
    if keys.CURSOR_UPLEFT then
        keys.CURSOR_UP = true
        keys.CURSOR_LEFT = true
        keys.STANDARDSCROLL_PAGEUP = false
    end
    if keys.CURSOR_UPRIGHT then
        keys.CURSOR_UP = true
        keys.CURSOR_RIGHT = true
        keys.STANDARDSCROLL_PAGEUP = false
    end
    if keys.CURSOR_DOWNRIGHT then
        keys.CURSOR_DOWN = true
        keys.CURSOR_RIGHT = true
        keys.STANDARDSCROLL_PAGEDOWN = false
    end
    if keys.CURSOR_DOWNLEFT then
        keys.CURSOR_DOWN = true
        keys.CURSOR_LEFT = true
        keys.STANDARDSCROLL_PAGEDOWN = false
    end
    if keys.CURSOR_UPLEFT_FAST then
        keys.CURSOR_UP_FAST = true
        keys.CURSOR_LEFT_FAST = true
    end
    if keys.CURSOR_UPRIGHT_FAST then
        keys.CURSOR_UP_FAST = true
        keys.CURSOR_RIGHT_FAST = true
    end
    if keys.CURSOR_DOWNRIGHT_FAST then
        keys.CURSOR_DOWN_FAST = true
        keys.CURSOR_RIGHT_FAST = true
    end
    if keys.CURSOR_DOWNLEFT_FAST then
        keys.CURSOR_DOWN_FAST = true
        keys.CURSOR_LEFT_FAST = true
    end
    if keys.STANDARDSCROLL_UP then keys.CURSOR_UP = true end
    if keys.STANDARDSCROLL_DOWN then keys.CURSOR_DOWN = true end
    if keys.STANDARDSCROLL_RIGHT then keys.CURSOR_RIGHT = true end
    if keys.STANDARDSCROLL_LEFT then keys.CURSOR_LEFT = true end
    if keys.STANDARDSCROLL_PAGEUP then keys.CURSOR_UP_FAST = true end
    if keys.STANDARDSCROLL_PAGEDOWN then keys.CURSOR_DOWN_FAST = true end
end

function in_bounds(x, y, coords)
    return x >= coords[1] and x <= coords[3] and y >= coords[2] and y <= coords[4]
end

function merge_sort(tbl, cmp)
    if not cmp then cmp = function(a, b) return a < b end end
    if #tbl <= 1 then return tbl end
    local left = {}
    local right = {}
    local middle = math.floor(#tbl / 2)
    for i = 1, middle do
        table.insert(left, tbl[i])
    end
    for i = middle + 1, #tbl do
        table.insert(right, tbl[i])
    end
    left = merge_sort(left, cmp)
    right = merge_sort(right, cmp)
    return merge_sort_merge(left, right, cmp)
end

function merge_sort_merge(left, right, cmp)
    local tbl = {}
    while #left > 0 and #right > 0 do
        if cmp(left[1], right[1]) then
            table.insert(tbl, table.remove(left, 1))
        else
            table.insert(tbl, table.remove(right, 1))
        end
    end
    for i = 1, #left do
        table.insert(tbl, left[i])
    end
    for i = 1, #right do
        table.insert(tbl, right[i])
    end
    return tbl
end

function make_sort_order(func, descending, ...)
    local args = {...}
    return function(a, b)
        local ret = func(a, b, table.unpack(args))
        if descending then return ret >= 0
        else return ret <= 0 end
    end
end

UnitAttrCache = defclass(UnitAttrCache)

function UnitAttrCache:init()
    self:clear()
end

function UnitAttrCache:get(unit, item)
    if self.cache[unit] == nil then self.cache[unit] = {} end
    if self.cache[unit][item] == nil then
        self.cache[unit][item] = self:lookup(unit, item)
    end
    return self.cache[unit][item]
end

function UnitAttrCache:clear()
    self.cache = {}
end

sort = {}
function sort.skill(u1, u2, skill)
    local level_diff = skills.rating(u1, skill) - skills.rating(u2, skill)
    if level_diff ~= 0 then return level_diff end
    return skills.experience(u1, skill) - skills.experience(u2, skill)
end

function sort.column(u1, u2, column)
    return column:compare(u1, u2)
end

function basic_compare(a, b)
    if a > b then return 1
    elseif a < b then return -1
    else return 0
    end
end

Column = defclass(Column)

function Column:init(args)
    if args.base ~= nil then
        self.base = check_nil(find_column(args._columns or {}, args.base), 'Base column not found: ' .. tostring(args.base))
    end
    local base = self.base or {}
    local function field(name)
        return args[name] or base[name]
    end
    self.id = check_nil(args.id, 'No column ID given', true)
    self.callback = check_nil(field('callback'), 'Column ' .. self.id .. ': No callback given', true)
    self.color = check_nil(field('color'), 'Column ' .. self.id .. ': No color or color callback given', true)
    if type(self.color) ~= 'function' then
        local _c = self.color
        self.color = function() return _c end
    end
    self.title = check_nil(field('title'), 'No title given', true)
    self.desc = args.desc or self.title
    self.header = args.header or self.title
    self.allow_display = if_nil(field('allow_display'), true)
    self.allow_format = if_nil(field('allow_format'), true) and type(args.spec) == 'string'
    self.spec = args.spec
    self.default = if_nil(args.default, false)
    self.highlight = if_nil(field('highlight'), false)
    self.right_align = if_nil(field('right_align'), false)
    self.max_width = if_nil(field('max_width'), 0)
    self.cache = {}
    self.color_cache = {}
    self.disable_cache = if_nil(field('disable_cache'), false)
    self.disable_color_cache = if_nil(field('disable_color_cache'), false)
    self.width = #self.header
    self.on_click = if_nil(field('on_click'), function() end)
    self.cmp_units = field('compare_units')
    self.cmp_values = field('compare_values')
end

function Column:lookup(unit)
    if self.cache[unit] == nil or unit.dirty or self.disable_cache then
        self.cache[unit] = tostring(self.callback(unit))
        self.width = math.max(self.width, #self.cache[unit])
        if self.max_width > 0 then
            self.width = math.min(self.width, self.max_width)
            self.cache[unit] = self.cache[unit]:sub(0, self.max_width)
        end
    end
    return (self.right_align and (' '):rep(self.width - #self.cache[unit]) or '') .. self.cache[unit]
end

function Column:lookup_color(unit)
    if self.color_cache[unit] == nil or unit.dirty or self.disable_color_cache then
        self.color_cache[unit] = self.color(unit, self:lookup(unit))
    end
    return self.color_cache[unit]
end

function Column:populate(units)
    for _, u in pairs(units) do
        self:lookup(u)
        self:lookup_color(u)
    end
end

function Column:compare(u1, u2)
    local ret = nil
    if self.cmp_units then
        ret = self.cmp_units(u1, u2)
    elseif self.cmp_values then
        ret = self.cmp_values(self:lookup(u1), self:lookup(u2))
    end
    if ret ~= nil then
        return ret
    else
        return basic_compare(self:lookup(u1), self:lookup(u2))
    end
end

function Column:clear_cache()
    self.cache = {}
end

function column_wrap_func(func)
    return function(unit)
        return func(unit._native)
    end
end

function find_column(columns, id)
    for _, col in pairs(columns) do
        if col.id == id then
            return col
        end
    end
end

function load_columns(scr)
    local columns = {}
    local env = {
        Column = function(args)
            args._columns = columns
            table.insert(columns, Column(args))
        end,
        wrap = column_wrap_func,
        manipulator = {
            view_unit = scr:callback('view_unit'),
            zoom_unit = scr:callback('zoom_unit'),
            blink_state = function() return scr.blink_state end,
            selection = {
                start = scr:callback('selection_start'),
                extend = scr:callback('selection_extend'),
            }
        }
    }
    setmetatable(env, {__index = _ENV})
    m_module.load('columns', {env = env})
    if #columns < 1 then qerror('No columns found') end
    return columns
end

function get_column_ids(columns)
    local t = {}
    for _, col in pairs(columns) do
        table.insert(t, col.id)
    end
    return t
end

function get_columns(columns, ids)
    local t = {}
    for _, id in pairs(ids) do
        for _, col in pairs(columns) do
            if col.id == id then
                table.insert(t, col)
                break
            end
        end
    end
    return t
end

if not unit_fields then
    unit_fields = {}
    local dummy_unit = df.unit:new()
    for k, v in pairs(dummy_unit) do
        unit_fields[k] = true
    end
end

function unit_wrapper(u)
    local t = {}
    local custom = {}

    local function __index(self, key)
        if key == '_native' then
            return u
        elseif unit_fields[key] then
            return u[key]
        else
            return custom[key]
        end
    end

    local function __newindex(self, key, value)
        if key == '_native' then
            error('Cannot set unit_wrapper._native')
        elseif unit_fields[key] then
            u[key] = value
        else
            custom[key] = value
        end
    end

    local function __tostring(self)
        return ('<unit wrapper: %s>'):format(u)
    end

    local function __pairs(self)
        return join_pairs(u, custom)--, self
    end

    setmetatable(t, {__index = __index, __newindex = __newindex, __tostring = __tostring, __pairs = __pairs})
    return t
end

StringFormatter = defclass(StringFormatter)
function StringFormatter:init()
    self.options = {}
    self.callback_map = {}
end

function StringFormatter:add_option(spec, desc, callback)
    if self.callback_map[spec] then
        error('Duplicate option: ' .. spec)
    end
    self.callback_map[spec] = callback
    table.insert(self.options, {spec = spec, desc = desc, callback = callback})
end

function StringFormatter:grab_opt(str)
    local candidate = ''
    for _, opt in pairs(self.options) do
        if opt.spec == str:sub(1, #opt.spec) and #opt.spec > #candidate then
            candidate = opt.spec
        end
    end
    if #candidate > 0 then
        return candidate
    end
end

function StringFormatter:tokenize(format)
    local ret = {{text='', opt=false}}
    local in_opt = false
    local last_ops_pos = 1
    local i = 1
    while i <= #format do
        local ch = format:sub(i, i)
        if in_opt then
            if ch == '%' then
                -- escape: %% -> %
                in_opt = false
                table.insert(ret, {text='%%', opt='%'})
                table.insert(ret, {text=''})
                i = i + 1
            else
                local opt = self:grab_opt(format:sub(i))
                if opt then
                    table.insert(ret, {text='%'..opt, opt=opt})
                    table.insert(ret, {text=''})
                    i = i + #opt
                    in_opt = false
                    if i <= #format and format:sub(i, i) == '$' then
                        -- Allow $ to terminate format options
                        i = i + 1
                        ret[#ret - 1].text = ret[#ret - 1].text .. '$'
                    end
                else
                    -- Unrecognized format option; replace with original text
                    ret[#ret].text = ret[#ret].text .. '%'
                    in_opt = false
                end
            end
        else
            if ch == '%' then
                in_opt = true
                last_ops_pos = i
            else
                ret[#ret].text = ret[#ret].text .. ch
            end
            i = i + 1
        end
    end
    if in_opt then
        table.insert(ret, {text=format:sub(last_ops_pos), opt=false})
    end
    return ret
end

function StringFormatter:format(object, format)
    local tokens = self:tokenize(format)
    local ret = ''
    for _, t in pairs(tokens) do
        if t.opt == '%' then
            print('%')
            ret = ret .. '%'
        elseif t.opt then
            ret = ret .. tostring(self.callback_map[t.opt](object))
        else
            ret = ret .. t.text
        end
    end
    return ret
end

function enum(values, cur)
    values = utils.invert(values)
    if cur and not values[cur] then
        error('invalid initial enum value: ' .. tostring(cur))
    end
    local t = {}
    local function eq(self, v)
        if cur == nil then
            error('enum value not set')
        end
        if not values[v] then
            error('invalid enum value: ' .. tostring(v))
        end
        return cur == v
    end
    local function set(self, v)
        if values[v] then
            cur = v
        else
            error('invalid enum value: ' .. tostring(v))
        end
    end
    setmetatable(t, {
        __index = eq,
        __call = set,
        __newindex = set,
        __tostring = function() return tostring(cur) end,
        __pairs = function()
            local k, v
            return function()
                k, v = next(values, k)
                if v ~= nil then return k, cur == k end
            end
        end,
    })
    return t
end

labors = labors or {}
local function update_labor_column_cache()
    if SKILL_COLUMNS and not labors.column_cache then
        labors.column_cache = {}
        for i, col in pairs(SKILL_COLUMNS) do
            labors.column_cache[col.labor] = {col = col, index = i}
        end
    end
end

function labors.get_column(labor)
    update_labor_column_cache()
    return labors.column_cache[labor].col
end

function labors.get_column_index(labor)
    update_labor_column_cache()
    return labors.column_cache[labor].index
end

function labors.valid(unit, labor)
    if labor == df.unit_labor.NONE then return false end
    local ent = df.historical_entity.find(unit.civ_id)
    if ent and ent.entity_raw and not ent.entity_raw.jobs.permitted_labor[labor] then
        return false
    end
    return true
end

function labors.get(unit, labor)
    return unit.status.labors[labor]
end

function labors.get_orig(unit, labor)
    return unit.orig_labors[labor]
end

function labors.set(unit, labor, state, callback)
    -- calls callback(unit, labor, state) after setting labor(s)
    if not unit.allow_edit then return end
    if not labors.valid(unit, labor) then return end
    local col = labors.get_column(labor) or error(('Unrecognized labor: %s'):format(labor))
    if col.special then
        if state then
            for i, c in pairs(SKILL_COLUMNS) do
                if c.special and c.labor ~= labor then
                    labors.set(unit, c.labor, false, callback)
                end
            end
        end
        unit.military.pickup_flags.update = true
    end
    if unit.status.labors[labor] ~= state then
        unit.status.labors[labor] = state
        if callback then
            callback(unit, labor, state)
        end
    end
end

function labors.special(labor)
    return labors.get_column(labor).special
end

fwrap = fwrap or {}
function fwrap.wrapper(before, after)
    if not before then before = function() end end
    if not after then after = function() end end
    return function(func)
        return function(...)
            before(...)
            local result = {dfhack.pcall(func, ...)}
            after(...)
            local ok = table.remove(result, 1)
            if not ok then
                error(result[1])
            else
                return table.unpack(result)
            end
        end
    end
end

local no_gc_count = 0
fwrap.no_gc = fwrap.wrapper(
    function()
        no_gc_count = no_gc_count + 1
        collectgarbage('stop')
    end,
    function()
        no_gc_count = math.max(0, no_gc_count - 1)
        if no_gc_count == 0 then
            collectgarbage('restart')
        end
    end
)

function KeyBindingMap()
    local t = {}
    local m = {}
    function m.__call(self, k, ...)
        if #{...} < 1 then
            return m.__index(self, k)
        end
        for _, v in pairs({...}) do
            if df.interface_key[v] then
                rawset(t, k, df.interface_key[v])
                return
            end
        end
        error('No valid keys for binding: ' .. k)
    end
    function m.__index(self, k)
        return rawget(t, k) or error('Binding not set: ' .. k)
    end
    function m.__newindex(self, k, v)
        if type(v) == 'table' then
            m.__call(self, k, table.unpack(v))
        else
            m.__call(self, k, v)
        end
    end
    setmetatable(t, m)
    return t
end
