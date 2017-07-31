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

local function logFrame(f, message)
  print(message .. ": {" .. f.x .. "," .. f.y .. "," .. f.w .. "," .. f.h .. "}")
end

local function windowResize(x, y, w, h)
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen():frame()
  -- logFrame(screen, win:screen():name())

  if -1 == w then
      f.w = screen.w / 2
  elseif 1 == w then
      f.w = screen.w
  end

  if -1 == x then
      f.x = screen.x
  elseif 1 == x then
      f.x = screen.x + screen.w - f.w
  end

  if -1 == h then
      f.h = screen.h / 2
  elseif 1 == h then
      f.h = screen.h
  end

  if -1 == y then
      f.y = screen.y
  elseif 1 == y then
      f.y = screen.y + screen.h - f.h
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
