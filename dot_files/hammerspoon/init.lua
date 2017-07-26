local application = require "hs.application"
local hotkey = require "hs.hotkey"

local hyper = {"cmd", "alt", "ctrl", "shift"}

--
-- Open Applications
--
local appEmailClient = "Kiwi for Gmail"
-- local appEmailClient = "Postbox"
-- local appEmailClient = "Airmail"
local appIdeIos = "AppCode"
-- local appIdeIos = "AppCode-EAP"
local appIdeJava = "IntelliJ IDEA"
-- local appIdeJava = "IntelliJ IDEA-EAP"
local appIdeApple = 'Xcode'
-- local appIdeApple = 'Xcode-beta'

-- bind w:${hyper} layout workLayout

hotkey.bind(hyper, '1', function() application.launchOrFocus("1Password 6") end)
hotkey.bind(hyper, 'A', function() application.launchOrFocus("Android Studio") end)
hotkey.bind(hyper, 'B', function() application.launchOrFocus("Brave") end)
hotkey.bind(hyper, 'C', function() application.launchOrFocus(appIdeIos) end)
hotkey.bind(hyper, 'E', function() application.launchOrFocus("Messages") end)
hotkey.bind(hyper, 'G', function() application.launchOrFocus("Google Chrome") end)
hotkey.bind(hyper, 'I', function() application.launchOrFocus(appIdeJava) end)
hotkey.bind(hyper, 'J', function() application.launchOrFocus(appEmailClient) end)
hotkey.bind(hyper, 'K', function() application.launchOrFocus("Skype") end)
hotkey.bind(hyper, 'L', function() application.launchOrFocus("Slack") end)
hotkey.bind(hyper, 'N', function() application.launchOrFocus("Navicat Essentials for PostgreSQL") end)
hotkey.bind(hyper, 'R', function() application.launchOrFocus("iTerm") end)
hotkey.bind(hyper, 'S', function() application.launchOrFocus("Tower") end)
hotkey.bind(hyper, 'T', function() application.launchOrFocus("MacVim") end)
hotkey.bind(hyper, 'X', function() application.launchOrFocus(appIdeApple) end)
hotkey.bind(hyper, 'Z', function() application.launchOrFocus("Zeplin") end)

--
-- /Open Applications
--

