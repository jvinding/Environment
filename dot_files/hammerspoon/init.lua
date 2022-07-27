hyper = {"cmd", "alt", "ctrl", "shift"}

require 'app_bindings'
require 'window_resize'
require 'caffeinate'

hs.loadSpoon("MouseCircle")
spoon.MouseCircle:bindHotkeys({["show"]={hyper, "f1"}})

hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

hs.keycodes.inputSourceChanged(function() hs.reload() end)

hs.alert.show("Config Loaded")