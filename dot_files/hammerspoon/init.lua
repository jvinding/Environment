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

--
-- Window resizing
--
function windowResize(x, y)
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen():frame()

  -- hs.alert.show("Before: {" .. f.x .. "," .. f.y .. "," .. f.w .. "," .. f.h .. "}")
  if -1 == x then
      f.x = 0
      f.w = screen.w / 2
  elseif 0 == x then
      f.x = 0
      f.w = screen.w
  else
      f.x = screen.w / 2
      f.w = screen.w / 2
  end

  if -1 == y then
      f.y = 0
      f.h = screen.h / 2
  elseif 0 == y then
      f.y = 0
      f.h = screen.h
  else
      f.y = screen.h / 2
      f.h = screen.h / 2
  end
  -- hs.alert.show("After: {" .. f.x .. "," .. f.y .. "," .. f.w .. "," .. f.h .. "}")

  win:setFrame(f, 0)
end

hs.hotkey.bind(hyper, "pad1", function() windowResize(-1, 1) end)
hs.hotkey.bind(hyper, "pad2", function() windowResize(0, 1) end)
hs.hotkey.bind(hyper, "pad3", function() windowResize(1, 1) end)
hs.hotkey.bind(hyper, "pad4", function() windowResize(-1, 0) end)
hs.hotkey.bind(hyper, "pad5", function() windowResize(0, 0) end)
hs.hotkey.bind(hyper, "pad6", function() windowResize(1, 0) end)
hs.hotkey.bind(hyper, "pad7", function() windowResize(-1, -1) end)
hs.hotkey.bind(hyper, "pad8", function() windowResize(0, -1) end)
hs.hotkey.bind(hyper, "pad9", function() windowResize(1, -1) end)
--
-- /Window resizing
--
