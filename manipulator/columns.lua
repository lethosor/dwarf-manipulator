--[[ Lua manipulator column definitions
By default, columns are ordered in the order they appear here

Valid parameters to Column{}:
- id (required): A unique (and meaningful) column id
- callback (required): A function taking a unit and returning an appropriate
         value to be displayed. See note below.
- color (required): Either a color ID (e.g. COLOR_WHITE) or a function
        taking a unit and returning an appropriate color.
    NOTE: Use wrap() when using an existing function (e.g. dfhack.units.getProfessionColor)
        to ensure that only the unit is passed to the function.
        When calling a native function that takes a unit, "unit._native" must be used.
- title (required): The column title.
- desc: An extended description. Defaults to the value of `title`.
- default: Whether to display the column by default. Defaults to false.
- highlight: Whether to highlight the corresponding row in this column when a
        unit is selected. Defaults to false.
- right_align: Defaults to false.
- max_width: Column maximum width. Defaults to 0 (no maximum width).
- disable_cache: If true, values returned by callback() will never be cached.
    Defaults to false.
- disable_color_cache: If true, values returned by color() will never be cached.
    Defaults to false.
- on_click: A function called when a column value is clicked.
    Arguments:
        - unit: The unit corresponding to the row where the click occurred
        - buttons: {right = true|false, left = true|false}
        - mods: {ctrl = true|false, alt = true|false, shift = true|false}
- compare_units|compare_values: A function that takes either two units or two
    values returned from callback(), respectively, and returns 0 if the values
    should be considered equal, anything less than 0 if the first should be
    considered smaller, and anything greater than 0 if the first should be
    considered larger.
    If these functions are omitted or return nil, the standard comparison
    operators (< and >) are used.
    If two values are returned, they will be compared with the standard
    comparison operators.

Useful alternatives to Column:
- CheckColumn: a read-only checkbox
    callback should return a boolean value
    implements color and compare_units
]]

if not Column then
    qerror('Must be invoked from manipulator')
end

Column{
    id = 'stress',
    title = 'Stress',
    spec = 'st',
    callback = function(unit)
        return unit.status.current_soul and unit.status.current_soul.personality.stress_level or 0
    end,
    color = function(unit, stress)
        stress = tonumber(stress)
        if stress >= 500000 then return COLOR_LIGHTMAGENTA
        elseif stress >= 250000 then return COLOR_LIGHTRED
        elseif stress >= 100000 then return COLOR_YELLOW
        elseif stress >= 0 then return COLOR_GREEN
        else return COLOR_LIGHTGREEN
        end
    end,
    default = true,
    right_align = true,
    on_click = function(unit, buttons, mods)
        manipulator.view_unit(unit)
        local scr = dfhack.gui.getCurViewscreen()
        gui.simulateInput(scr, 'SELECT')
        dfhack.screen.dismiss(scr)
    end,
    compare_values = function(a, b)
        return tonumber(a) - tonumber(b)
    end
}

Column{
    id = 'selected',
    title = string.char(251),
    desc = 'Selected',
    default = true,
    max_width = 1,
    callback = function(unit)
        if unit.selected then
            return string.char(251)
        else
            return '-'
        end
    end,
    color = function(unit)
        if not unit.allow_edit then
            return unit.selected and COLOR_YELLOW or COLOR_RED
        elseif unit.selected then
            return COLOR_LIGHTGREEN
        else
            return COLOR_DARKGREY
        end
    end,
    on_click = function(unit, buttons, mods)
        if not unit.allow_edit then return end
        if buttons.right or mods.shift then
            manipulator.selection.extend(unit)
        else
            manipulator.selection.start(unit)
        end
    end,
    compare_units = function(u1, u2)
        return (u2.selected and 1 or 0) - (u1.selected and 1 or 0)
    end
}

Column{
    id = 'name',
    spec = 'n',
    callback = function(unit)
        return dfhack.TranslateName(unit.name)
    end,
    color = COLOR_WHITE,
    title = 'Name',
    default = true,
    highlight = true,
    on_click = function(unit, buttons, mods)
        if buttons.left then
            manipulator.view_unit(unit)
        elseif buttons.right then
            manipulator.zoom_unit(unit)
        end
    end
}

Column{
    id = 'engname',
    title = 'English name',
    spec = 'en',
    base = 'name',
    callback = function(unit)
        return dfhack.TranslateName(unit.name, true)
    end,
}

Column{
    id = 'civ',
    title = 'Civilization',
    desc = 'Civilization name',
    spec = 'c',
    callback = function(unit)
        local ent = df.historical_entity.find(unit.civ_id)
        if ent then
            return dfhack.TranslateName(ent.name)
        end
        return ''
    end,
    color = COLOR_GREY,
}

Column{
    id = 'profession',
    title = 'Profession',
    desc = 'Displayed profession',
    spec = 'p',
    callback = wrap(dfhack.units.getProfessionName),
    color = function(unit)
        if unit.on_fire then
            return math.random() < 0.5 and COLOR_LIGHTRED or COLOR_YELLOW
        end
        local color = dfhack.units.getProfessionColor(unit._native)
        if manipulator.blink_state() and unit.legendary and dfhack.units.isCitizen(unit._native) then
            color = (color + 8) % 16
            if color == COLOR_BLACK then color = COLOR_GREY end
        end
        return color
    end,
    disable_color_cache = true,
    default = true,
    on_click = function(unit, buttons, mods)
        if buttons.left then
            manipulator.view_unit(unit)
        elseif buttons.right then
            manipulator.zoom_unit(unit)
        end
    end
}

Column{
    id = 'real_profession',
    title = 'Real profession',
    desc = 'Real profession (non-customized)',
    spec = 'P',
    base = 'profession',
    callback = function(unit)
        local tmp = unit.custom_profession
        unit.custom_profession = ''
        local ret = dfhack.units.getProfessionName(unit._native)
        unit.custom_profession = tmp
        return ret
    end,
}

Column{
    id = 'base_profession',
    title = 'Base profession',
    desc = 'Base profession (excluding nobles & other positions)',
    spec = 'bp',
    base = 'profession',
    callback = function(unit)
        return df.profession.attrs[unit.profession].caption
    end,
    color = function(unit)
        return df.profession.attrs[unit.profession].color
    end,
}

Column{
    id = 'profession_group',
    title = 'Profession group',
    desc = 'Profession group (e.g. Stoneworker, Fishery Worker)',
    spec = 'pg',
    base = 'base_profession',
    callback = function(unit)
        local p = unit.profession
        while df.profession.attrs[p].parent ~= -1 do
            p = df.profession.attrs[p].parent
        end
        return df.profession.attrs[p].caption
    end,
}

Column{
    id = 'short_profession',
    title = 'Short profession name',
    desc = 'Short (base) profession abbreviation, from grid headers',
    header = 'Prf',
    spec = 'sp',
    base = 'base_profession',
    callback = function(unit)
        for _, c in pairs(SKILL_COLUMNS) do
            if c.profession == unit.profession then
                return c.label
            end
        end
        return df.profession.attrs[unit.profession].caption:sub(1, 2)
    end,
    max_width = 3,
}

Column{
    id = 'squad',
    title = 'Squad',
    desc = 'Squad name, if applicable',
    spec = 's',
    callback = wrap(dfhack.units.getSquadName),
    color = COLOR_LIGHTCYAN,
    compare_values = function(a, b)
        if a ~= '' and b == '' then
            return -1
        elseif b ~= '' and a == '' then
            return 1
        end
    end,
}

Column{
    id = 'job',
    title = 'Job',
    desc = 'Current job, or "No Job"',
    spec = 'j',
    callback = function(unit)
        if unit.job.current_job then
            return dfhack.job.getName(unit.job.current_job)
        elseif #unit.social_activities > 0 then
            local activity = df.activity_entry.find(unit.social_activities[#unit.social_activities - 1])
            local event = activity.events[#activity.events - 1]
            local tmp = df.new('string')
            event:getName(unit.id, tmp)
            local name = tmp.value
            df.delete(tmp)
            return name
        else
            return 'No Job'
        end
    end,
    color = function(unit)
        if unit.job.current_job then
            return COLOR_LIGHTCYAN
        elseif #unit.social_activities > 0 then
            return COLOR_LIGHTGREEN
        else
            return COLOR_YELLOW
        end
    end,
    compare_units = function(a, b)
        if a.job.current_job and not b.job.current_job then
            return -1
        elseif b.job.current_job and not a.job.current_job then
            return 1
        end
    end,
}

Column{
    id = 'age',
    title = 'Age',
    desc = 'Age, in years',
    spec = 'a',
    callback = function(unit)
        return math.floor(dfhack.units.getAge(unit._native))
    end,
    color = COLOR_GREY,
}

Column{
    id = 'kills',
    title = 'Kills',
    desc = 'Number of kills',
    spec = 'k',
    callback = wrap(dfhack.units.getKillCount),
    color = COLOR_GREY,
}

Column{
    id = 'speed',
    title = 'Speed',
    spec = 'spd',
    callback = wrap(dfhack.units.computeMovementSpeed),
    color = COLOR_GREY,
}

Column{
    id = 'list_id',
    title = 'List position',
    desc = 'Position in list',
    header = 'Pos',
    spec = 'i',
    callback = function(unit) return unit.list_ids.all end,
    color = COLOR_GREY,
    disable_cache = true,
}

Column{
    id = 'prof_id',
    title = 'List position - profession',
    desc = 'Position in list, among dwarves with same profession',
    header = 'PPos',
    spec = 'pi',
    callback = function(unit) return unit.list_ids.profession end,
    color = COLOR_GREY,
    disable_cache = true,
}

Column{
    id = 'group_id',
    title = 'List position - group',
    desc = 'Position in list, among dwarves in same profession group',
    header = 'GPos',
    spec = 'gi',
    callback = function(unit) return unit.list_ids.group end,
    color = COLOR_GREY,
    disable_cache = true,
}

Column{
    id = 'raw_id',
    title = 'ID',
    desc = 'Raw unit ID',
    spec = 'ri',
    callback = function(unit) return unit.id end,
    color = COLOR_GREY,
}

CheckColumn{
    id = 'is_citizen',
    title = 'Is citizen',
    header = 'Cit',
    callback = wrap(dfhack.units.isCitizen),
}
