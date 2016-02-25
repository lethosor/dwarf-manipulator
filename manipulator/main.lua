-- manipulator

gui = require 'gui'
widgets = require 'gui.widgets'
dialogs = require 'gui.dialogs'
utils = require 'utils'
enabler = df.global.enabler
gps = df.global.gps

args = {...}
iargs = utils.invert(args)
if iargs['--profile'] then
    PROFILE = true
elseif iargs['--no-profile'] then
    PROFILE = false
end

VERSION = '0.7.4'
PROFILE = PROFILE or false

if PROFILE then
    p_data = {}
    p_depth = 0
    function p_start(name)
        p_data[name] = os.clock()
        p_depth = p_depth + 1
    end
    function p_end(name)
        local t = os.clock()
        if p_data[name] then
            p_depth = p_depth - 1
            print(('%s%.5f secs [%s]'):format(('  '):rep(p_depth), t - p_data[name], name))
        end
    end
    function p_call(name, func, ...)
        p_start(name)
        local ret = {func(...)}
        p_end(name)
        return table.unpack(ret)
    end
else
    function p_start() end
    function p_end() end
    function p_call(name, func, ...) return func(...) end
end
p_start('parse')

m_module = m_module or {cache = {}, default_env = {}}

function m_module.clean_name(name)
    if name:sub(-4) == '.lua' then
        name = name:sub(1, -5)
    end
    return 'manipulator/' .. name
end

function m_module.load(name, opts)
    if not opts then opts = {} end
    name = m_module.clean_name(name)
    p_start('load ' .. name)
    local path = dfhack.findScript(name)
    if not path and not opts.optional then
        error('Could not find script: ' .. name)
    end
    local env = opts.env
    if not env then
        env = m_module.default_env
        clear_table(env)
        setmetatable(env, {__index = _ENV})
    end
    env.manipulator_module = true
    local f
    local cache = m_module.cache[name]
    if cache and path == cache.path and env == cache.env and cache.mtime == dfhack.filesystem.mtime(path) then
        f = cache.callback
    else
        f, err = loadfile(path, 't', env)
        if not f then
            error(('Could not load script "%s": %s'):format(name, err))
        end
        m_module.cache[name] = {
            path = path,
            mtime = dfhack.filesystem.mtime(path),
            callback = f,
            env = env
        }
    end
    f()
    p_end('load ' .. name)
    return env
end

function m_module.autoloader(module_pattern, name_pattern)
    local stub = {}
    if not module_pattern then
        module_pattern = '%s'
    end
    if not name_pattern then
        name_pattern = '%s'
    end
    local function index(self, key)
        local mod = module_pattern
        local name = name_pattern
        if type(mod) == 'function' then
            mod = mod(key)
        else
            mod = mod:format(key)
        end
        if type(name) == 'function' then
            name = name(key)
        else
            name = name:format(key)
        end
        return m_module.load(mod)[name]
    end
    local function tostring(self)
        return '<m_module.autoloader>'
    end
    setmetatable(stub, {__index = index, __tostring = tostring})
    return stub
end

m_module.load('utils', {env = _ENV})
mgui = m_module.autoloader('gui/%s')

penarray = dfhack.penarray
if not penarray or iargs['--lua-penarray'] then
    penarray = m_module.load('penarray').penarray
end

grid_cache = grid_cache or {}
function load_grid()
    local cache = m_module.cache[m_module.clean_name('grid-config')]
    if cache and dfhack.filesystem.mtime(cache.path) == cache.mtime and grid_cache.columns and grid_cache.levels then
        return grid_cache.columns, grid_cache.levels
    end
    local columns = {}
    local levels = {}

    local function check_enum(enum, value, name, location)
        local ret = enum[value]
        if not ret then
            dfhack.printerr(('%s: skipping unrecognized %s: %s'):format(location, name, value))
        end
        return ret
    end

    local function add_column(col)
        local location = ('%s: line %i'):format(debug.getinfo(2).short_src, debug.getinfo(2).currentline)
        check_nil(tonumber(col.group), ('%s: Invalid group ID: %s'):format(location, col.group))
        check_nil(tonumber(col.color), ('%s: Invalid color ID: %s'):format(location, col.color))
        col.profession = check_enum(df.profession, col.profession, 'profession', location)
        col.labor = check_enum(df.unit_labor, col.labor, 'labor', location)
        col.skill = check_enum(df.job_skill, col.skill, 'skill', location)
        if not col.profession or not col.labor or not col.skill then
            return
        end
        if col.label == nil or type(col.label) ~= 'string' or #tostring(col.label) ~= 2 then
            qerror(('%s: Invalid label: %s'):format(location, col.label))
        end
        if col.special == nil then col.special = false end
        table.insert(columns, col)
    end

    local function add_level(lvl)
        local location = ('grid-config: line %i'):format(debug.getinfo(2).currentline)
        check_nil(lvl.name, ('%s: Missing name'):format(location))
        check_nil(tonumber(lvl.points), ('%s: Invalid points: %s'):format(location, lvl.points))
        lvl.abbr = tostring(check_nil(lvl.abbr, ('%s: Missing abbreviation'):format(location))):sub(0, 1)
        table.insert(levels, lvl)
    end

    m_module.load('grid-config', {env = {column = add_column, level = add_level}})
    grid_cache.columns = columns
    grid_cache.levels = levels
    return columns, levels
end
load_grid = fwrap.no_gc(load_grid)

SKILL_COLUMNS, SKILL_LEVELS = p_call('load grid', load_grid)

function mkscreen(parent, opts)
    opts = opts or {}
    opts.units = parent.units[parent.page]
    if #opts.units == 0 then
        derror('No units', 'No units to view')
        return
    end
    opts.selected = parent.units[parent.page][parent.cursor_pos[parent.page]]
    local scr = mgui.manipulator(opts)
    scr:show()
    return scr
end

function main()
    local scr = dfhack.gui.getCurViewscreen()
    if df.viewscreen_unitlistst:is_instance(scr) then
        cur = mkscreen(scr)
    elseif dfhack.gui.getCurFocus() == 'dwarfmode/Default' then
        gui.simulateInput(scr, 'D_UNITLIST')
        cur = mkscreen(dfhack.gui.getCurViewscreen(), {dismiss_parent = true})
    else
        dfhack.printerr('Invalid context')
    end
end
main = fwrap.no_gc(main)

p_end('parse')
p_call('main', main)
