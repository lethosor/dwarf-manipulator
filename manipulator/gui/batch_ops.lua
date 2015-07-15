if not manipulator_module then qerror('Only usable from within manipulator') end
local gui = require 'gui'

NICKNAME = {}
PROFNAME = {}

function draw_names(units)
    local p = gui.Painter.new_xy(2, 2, gps.dimx - 3, 2)
    p:string(tostring(#units), COLOR_LIGHTGREEN)
    p:string((' %s selected: '):format(#units == 1 and 'dwarf' or 'dwarves'))
    local last = 1
    for i, u in pairs(units) do
        local name = dfhack.TranslateName(u.name)
        if #name + p.x + 12 >= gps.dimx - 2 then
            break
        end
        last = i
        p:string(name, COLOR_WHITE)
        if i ~= #units then
            p:string(', ', COLOR_WHITE)
        end
    end
    if last ~= #units then
        p:string(('and %i more'):format(#units - last))
    end
end

name_callbacks = {
    [NICKNAME] = function(unit, func)
        dfhack.units.setNickname(unit._native, func(unit))
    end,
    [PROFNAME] = function(unit, func)
        unit.custom_profession = func(unit)
    end,
}

function apply_batch(units, func, ...)
    p_start('apply_batch')
    for _, u in pairs(units) do
        func(u, ...)
        u.dirty = true
    end
    p_end('apply_batch')
end

batch_ops = defclass(batch_ops, gui.FramedScreen)
batch_ops.ATTRS = {
    focus_path = 'manipulator/batch',
    options = {
        {'Change nickname', 'edit_nickname'},
        {'Change profession name', 'edit_profname'},
        {'Enable all labors', 'enable_all'},
        {'Disable all labors', 'disable_all'},
        {'Revert labor changes', 'revert_changes'},
    },
    selection_pen = {fg = COLOR_WHITE, bg = COLOR_GREEN},
    frame_style = gui.BOUNDARY_FRAME,
    frame_title = 'Dwarf Manipulator - Batch Operations',
    frame_inset = 1,
}

function batch_ops:init(args)
    self.units = check_nil(args.units)
    self.parent = check_nil(args.parent)
    if self.parent.focus_path ~= 'manipulator' then error('Invalid context') end
    self.columns = {}
    for _, col in pairs(self.parent.all_columns) do
        if col.allow_format then
            table.insert(self.columns, col)
        end
    end
    self.sel_idx = 1
end

function batch_ops:onShow()
    if #self.units == 0 then
        self:dismiss()
        derror('Empty selection', 'No units selected')
    end
end

function batch_ops:onRenderBody(p)
    draw_names(self.units)
    for i = 1, #self.options do
        p:seek(0, i + 1):string(self.options[i][1], i == self.sel_idx and self.selection_pen or nil)
    end
end

function batch_ops:onInput(keys)
    if keys.LEAVESCREEN then
        self:dismiss()
        return
    end
    process_keys(keys)
    if keys.SELECT then
        self:callback(self.options[self.sel_idx][2])()
        self:dismiss()
    elseif keys.CURSOR_UP or keys.CURSOR_DOWN then
        self.sel_idx = scroll_index(self.sel_idx, keys.CURSOR_UP and -1 or 1, 1, #self.options)
    elseif keys._MOUSE_L then
        local mx = gps.mouse_x
        local my = gps.mouse_y
        local startx = self.frame_inset + 1
        local starty = self.frame_inset + 3
        if my >= starty and my < starty + #self.options then
            local sel_idx = my - starty + 1
            if mx >= startx and mx < startx + #self.options[sel_idx][1] then
                self.sel_idx = sel_idx
                self:onInput{SELECT = true}
            end
        end
    end
end

function batch_ops:edit_nickname()
    name_editor({parent = self, units = self.units, name = NICKNAME}):show()
end

function batch_ops:edit_profname()
    name_editor({parent = self, units = self.units, name = PROFNAME}):show()
end

function batch_ops:handle_labors(callback)
    if not callback then return end
    for _, u in pairs(self.units) do
        for _, col in pairs(SKILL_COLUMNS) do
            callback(u, col.labor)
        end
    end
end

function batch_ops:set_all_labors(state)
    local function cb(unit, labor)
        if state and labors.special(labor) then
            return
        end
        labors.set(unit, labor, state)
        unit.labors_dirty = true
    end
    self:handle_labors(cb)
end

function batch_ops:enable_all()
    self:set_all_labors(true)
end

function batch_ops:disable_all()
    self:set_all_labors(false)
end

function batch_ops:revert_changes()
    local function cb(unit, labor)
        labors.set(unit, labor, labors.get_orig(unit, labor))
        unit.labors_dirty = true
    end
    self:handle_labors(cb)
end

name_editor = defclass(name_editor, gui.FramedScreen)
name_editor.ATTRS = {
    focus_path = 'manipulator/batch/name',
    frame_style = gui.BOUNDARY_FRAME,
    frame_inset = 1,
    help_text = ([[
\7 Format options (or format specifiers) are colored in cyan and will be
  replaced by their corresponding attributes of each unit selected.
\7 Use "%%" to include a literal "%" symbol.
\7 Use "$" to end options in ambiguous situations. For example, if "%x" and
  "%xy" are valid options and you want to use "%x" followed by a literal "y",
  use "%x$y". ($ symbols that will be treated in this way will be cyan - if
  you want to use literal $ symbols, keep in mind that only characters
  displayed in white will be used verbatim and add additional $ symbols as
  necessary.)
]]):gsub('\\7', '\7')
}

function name_editor:init(opts)
    self.formatter = StringFormatter()
    for _, col in pairs(opts.parent.columns) do
        self.formatter:add_option(col.spec, col.desc, col.callback)
    end
    self.units = opts.units
    self.name = opts.name
    self.name_desc = opts.name == NICKNAME and 'Nickname' or 'Profession Name'
    self.frame_title = 'Dwarf Manipulator - Edit ' .. self.name_desc
    self.entry = ''
end

function name_editor:onRenderBody(p)
    local max_width = p.clip_x2 - p.clip_x1
    p.clip_x1 = p.clip_x1 - 1
    p.clip_x2 = p.clip_x2 + 1
    draw_names(self.units)
    p:seek(0, 2):string('Custom ' .. self.name_desc .. ':')
    p:newline()
    local start = 1
    if #self.entry > max_width + 1 then
        start = #self.entry - max_width
        p:seek(-1):string('<', COLOR_LIGHTCYAN)
    end
    p:seek(0)
    local tokens = self.formatter:tokenize(self.entry)
    local pos = 0
    for _, t in pairs(tokens) do
        for i = 1, #t.text do
            pos = pos + 1
            if pos >= start then
                p:string(t.text:sub(i, i), {fg = t.opt and COLOR_LIGHTCYAN or COLOR_WHITE})
            end
        end
    end
    p:string('_', COLOR_LIGHTCYAN)
    p:newline():newline()
    p:seek(0):string('(Leave blank to use original name)', COLOR_DARKGREY)
    p:newline():newline()
    p:pen(COLOR_WHITE):string('Format options: ('):key('CUSTOM_ALT_H'):string(' for help)'):newline()
    for _, opt in pairs(self.formatter.options) do
        p:string('%' .. opt.spec, {fg = COLOR_LIGHTCYAN}):string(': ' .. opt.desc):newline()
    end
end

function name_editor:onInput(keys)
    if keys.LEAVESCREEN then
        self:dismiss()
        return
    end
    if keys.SELECT then
        apply_batch(self.units, name_callbacks[self.name], function(unit)
            return self.formatter:format(unit, self.entry)
        end)
        self:dismiss()
    elseif keys.CUSTOM_ALT_H then
        dialogs.showMessage('Formatting help', self.help_text)
    elseif keys.STRING_A000 then
        self.entry = self.entry:sub(1, -2)
    elseif keys._STRING then
        self.entry = self.entry .. string.char(keys._STRING)
    end
end
