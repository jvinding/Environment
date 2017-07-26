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
-- Window moving/resizing
--
local positionTop = -1
local positionBottom = 1
local positionLeft = -1
local positionRight = 1
local positionUnchanged = 0

local widthHalf = -1
local widthFull = 1
local widthUnchanged = 0
local heightHalf = -1
local heightFull = 1
local heightUnchanged = 0

function windowResize(x, y, w, h)
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen():frame()

  -- hs.alert.show("Before: {" .. f.x .. "," .. f.y .. "," .. f.w .. "," .. f.h .. "}")
  if -1 == w then
      f.w = screen.w / 2
  elseif 1 == w then
      f.w = screen.w
  end

  if -1 == x then
      f.x = 0
  elseif 1 == x then
      f.x = screen.w - f.w
  end

  if -1 == h then
      f.h = screen.h / 2
  elseif 1 == h then
      f.h = screen.h
  end

  if -1 == y then
      f.y = 0
  elseif 1 == y then
      f.y = screen.h - f.h
  end
  -- hs.alert.show("After: {" .. f.x .. "," .. f.y .. "," .. f.w .. "," .. f.h .. "}")

  win:setFrame(f, 0)
end

hs.hotkey.bind(hyper, "pad1", function() windowResize(positionLeft, positionBottom, widthHalf, heightHalf) end)
hs.hotkey.bind(hyper, "pad2", function() windowResize(positionLeft, positionBottom, widthFull, heightHalf) end)
hs.hotkey.bind(hyper, "pad3", function() windowResize(positionRight, positionBottom, widthHalf, heightHalf) end)
hs.hotkey.bind(hyper, "pad4", function() windowResize(positionLeft, positionTop, widthHalf, heightFull) end)
hs.hotkey.bind(hyper, "pad5", function() windowResize(positionLeft, positionTop, widthFull, heightFull) end)
hs.hotkey.bind(hyper, "pad6", function() windowResize(positionRight, positionTop, widthHalf, heightFull) end)
hs.hotkey.bind(hyper, "pad7", function() windowResize(positionLeft, positionTop, widthHalf, heightHalf) end)
hs.hotkey.bind(hyper, "pad8", function() windowResize(positionLeft, positionTop, widthFull, heightHalf) end)
hs.hotkey.bind(hyper, "pad9", function() windowResize(positionRight, positionTop, widthHalf, heightHalf) end)
hs.hotkey.bind(hyper, "Up", function() windowResize(positionUnchanged, positionTop, widthUnchanged, heightUnchanged) end)
hs.hotkey.bind(hyper, "Right", function() windowResize(positionRight, positionUnchanged, widthUnchanged, heightUnchanged) end)
hs.hotkey.bind(hyper, "Down", function() windowResize(positionUnchanged, positionBottom, widthUnchanged, heightUnchanged) end)
hs.hotkey.bind(hyper, "Left", function() windowResize(positionLeft, positionUnchanged, widthUnchanged, heightUnchanged) end)
--
-- /Window moving/resizing
--
--
