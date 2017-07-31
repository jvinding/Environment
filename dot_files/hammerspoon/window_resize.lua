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

  win:setFrame(f, 0)
end

local function bind(key, x, y, w, h)
    hs.hotkey.bind(hyper, key, function() windowResize(x, y, w, h) end)
end

--   key      x                  y                  w               h
bind("pad1",  positionLeft,      positionBottom,    widthHalf,      heightHalf)
bind("pad2",  positionLeft,      positionBottom,    widthFull,      heightHalf)
bind("pad3",  positionRight,     positionBottom,    widthHalf,      heightHalf)
bind("pad4",  positionLeft,      positionTop,       widthHalf,      heightFull)
bind("pad5",  positionLeft,      positionTop,       widthFull,      heightFull)
bind("pad6",  positionRight,     positionTop,       widthHalf,      heightFull)
bind("pad7",  positionLeft,      positionTop,       widthHalf,      heightHalf)
bind("pad8",  positionLeft,      positionTop,       widthFull,      heightHalf)
bind("pad9",  positionRight,     positionTop,       widthHalf,      heightHalf)
bind("Up",    positionUnchanged, positionTop,       widthUnchanged, heightUnchanged)
bind("Right", positionRight,     positionUnchanged, widthUnchanged, heightUnchanged)
bind("Down",  positionUnchanged, positionBottom,    widthUnchanged, heightUnchanged)
bind("Left",  positionLeft,      positionUnchanged, widthUnchanged, heightUnchanged)
