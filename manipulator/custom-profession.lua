if not manipulator_module then qerror('Only usable from within manipulator') end

fs = dfhack.filesystem
PATH = dfhack.getDFPath() .. '/manipulator-lua/'

CustomProfession = defclass(CustomProfession)
function CustomProfession:init()
    self.metadata = {
        name = '(Unnamed profession)',
        format_version = 1,
    }
    self.professions = {}
    self.errors = {}
end

function CustomProfession:good()
    return #self.errors == 0
end

function CustomProfession:error(msg, ...)
    table.insert(self.errors, tostring(msg):format(...))
end

function CustomProfession:load(path)
    local f = strict_open(path, 'r')
    local seen_attrs = {}
    local lines = {}
    for line in f:lines() do
        if line:sub(1, 1) == '#' then
            local key, value = line:match('#%s*([^=]-)%s*=%s*(.+)')
            if not key or not value then
                self:error('Could not parse metadata line: "%s"', line)
            elseif seen_attrs[key] then
                self:error('Duplicate metadata attribute: %s', key)
            elseif self.metadata[key] then
                self.metadata[key] = value
                seen_attrs[key] = true
            else
                self:error('Unknown metadata attribute: %s', key)
            end
        else
            line = strip_whitespace(line)
            if #line > 0 then
                table.insert(lines, line)
            end
        end
    end
    local ver = tonumber(self.metadata.format_version)
    if ver == 1 then
        for _, line in pairs(lines) do
            local p = df.profession[line:gsub('%s', ''):upper()]
            if not p then
                self:error('Invalid profession: %s', line)
            else
                table.insert(self.professions, p)
            end
        end
    else
        self:error('Unknown format version: %s', tostring(self.metadata.format_version))
    end
end

function CustomProfession:load_legacy(path)
    -- load format from manipulator plugin
    local f = strict_open(path, 'r')
    for line in f:lines() do
        line = strip_whitespace(line)
        if line:sub(1, 5) == 'NAME ' then
            self.metadata.name = line:sub(6)
        else
            local p = df.profession[line:upper()]
            if not p then
                self:error('Invalid profession: %s', line)
            else
                table.insert(self.professions, p)
            end
        end
    end
end
