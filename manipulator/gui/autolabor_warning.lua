if not manipulator_module then qerror('Only usable from within manipulator') end

autolabor_warning = defclass(autolabor_warning, dialogs.MessageBox)
autolabor_warning.ATTRS = {
    frame_title = 'autolabor active',
    focus_path = 'manipulator/autolabor_warning',
}

local msg = {
    'Labors cannot be changed when autolabor is enabled.', NEWLINE,
    'Press ', {text=dfhack.screen.getKeyDisplay(df.interface_key.CUSTOM_D), pen=COLOR_LIGHTGREEN},
    ' to disable autolabor, or any other key to close this window.',
}

function autolabor_warning:preinit(opts)
    opts.text = msg
    opts.text_pen = COLOR_LIGHTRED
    self.on_disable = opts.on_disable or function() end
end

function autolabor_warning:onInput(keys)
    if keys.CUSTOM_D then
        dfhack.run_command('disable autolabor')  -- not silent
        self.on_disable()
    end
    for key in pairs(keys) do
        if df.interface_key[key] ~= nil then
            self:dismiss()
            return
        end
    end
end
