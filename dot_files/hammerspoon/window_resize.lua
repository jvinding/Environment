local positionTop = -1
local positionBottom = 1
local positionLeft = -1
local positionRight = 1
local positionUnchanged = 0

local sizeHalf = -1
local sizeFull = 1
local sizeUnchanged = 0

local function logFrame(f, message)
  print(message .. ": {" .. f.x .. "," .. f.y .. "," .. f.w .. "," .. f.h .. "}")
end

local function windowResize(x, y, w, h)
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen():frame()
  -- logFrame(screen, win:screen():name())

  if sizeHalf == w then
      f.w = screen.w / 2
  elseif sizeFull == w then
      f.w = screen.w
  end

  if positionLeft == x then
      f.x = screen.x
  elseif positionRight == x then
      f.x = screen.x + screen.w - f.w
  end

  if sizeHalf == h then
      f.h = screen.h / 2
  elseif sizeFull == h then
      f.h = screen.h
  end

  if positionTop == y then
      f.y = screen.y
  elseif positionBottom == y then
      f.y = screen.y + screen.h - f.h
  end

  win:setFrame(f, 0)
end

local function bind(key, x, y, w, h)
    hs.hotkey.bind(hyper, key, function() windowResize(x, y, w, h) end)
end

--   key      x                  y                  w               h
bind("pad1",  positionLeft,      positionBottom,    sizeHalf,      sizeHalf)
bind("pad2",  positionLeft,      positionBottom,    sizeFull,      sizeHalf)
bind("pad3",  positionRight,     positionBottom,    sizeHalf,      sizeHalf)
bind("pad4",  positionLeft,      positionTop,       sizeHalf,      sizeFull)
bind("pad5",  positionLeft,      positionTop,       sizeFull,      sizeFull)
bind("pad6",  positionRight,     positionTop,       sizeHalf,      sizeFull)
bind("pad7",  positionLeft,      positionTop,       sizeHalf,      sizeHalf)
bind("pad8",  positionLeft,      positionTop,       sizeFull,      sizeHalf)
bind("pad9",  positionRight,     positionTop,       sizeHalf,      sizeHalf)
bind("Up",    positionUnchanged, positionTop,       sizeUnchanged, sizeUnchanged)
bind("Right", positionRight,     positionUnchanged, sizeUnchanged, sizeUnchanged)
bind("Down",  positionUnchanged, positionBottom,    sizeUnchanged, sizeUnchanged)
bind("Left",  positionLeft,      positionUnchanged, sizeUnchanged, sizeUnchanged)
bind("pad/",  positionUnchanged, positionUnchanged, sizeUnchanged, sizeUnchanged)
