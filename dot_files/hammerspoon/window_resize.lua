local positionStart = -1
local positionEnd = 1
local positionUnchanged = 0
local positionCenter = 5

local sizeThird = 3
local sizeHalf = 2
local sizeTwoThirds = 6
local sizeFull = 1
local sizeUnchanged = 0

local function logFrame(f, message)
  print(message .. ": {" .. f.x .. "," .. f.y .. "," .. f.w .. "," .. f.h .. "}")
end

local function windowResize(big_axis, small_axis, big_dimension, small_dimension)
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen():frame()
  -- logFrame(screen, win:screen():name())

  local x
  local y
  local w
  local h

  if screen.w > screen.h then
    x = big_axis
    w = big_dimension
    y = small_axis
    h = small_dimension
  else
    x = small_axis
    w = small_dimension
    y = big_axis
    h = big_dimension
  end

  if sizeThird == w then
      f.w = screen.w / 3
  elseif sizeHalf == w then
      f.w = screen.w / 2
  elseif sizeTwoThirds == w then
      f.w = 2 * screen.w / 3
  elseif sizeFull == w then
      f.w = screen.w
  end

  if positionStart == x then
      f.x = screen.x
  elseif positionEnd == x then
      f.x = screen.x + screen.w - f.w
  elseif positionCenter == x then
      f.x = (screen.x + (screen.w / 2)) - (f.w / 2)
  end

  if f.x2 > screen.x2 then
      f.x = f.x - (f.x2 - screen.x2)
  end

  if sizeThird == h then
      f.h = screen.h / 3
  elseif sizeHalf == h then
      f.h = screen.h / 2
  elseif sizeTwoThirds == h then
      f.h = 2 * screen.h / 3
  elseif sizeFull == h then
      f.h = screen.h
  end

  if positionStart == y then
      f.y = screen.y
  elseif positionEnd == y then
      f.y = screen.y + screen.h - f.h
  elseif positionCenter == y then
      f.y = (screen.y + (screen.h / 2)) - (f.h / 2)
  end

  if f.y2 > screen.y2 then
      f.y = f.y - (f.y2 - screen.y2)
  end

  win:setFrame(f, 0)
end

local function bind(key, x, y, w, h)
    local binding = hs.hotkey.bind(hyper, key, function() windowResize(x, y, w, h) end)
    local wf = hs.window.filter
    screenSharingFilter = wf.new("Screen Sharing")
    screenSharingFilter:subscribe(wf.windowFocused, function() binding:disable() end)
    screenSharingFilter:subscribe(wf.windowUnfocused, function() binding:enable() end)
end

-- Do not Bind / as it does the mac os sysdiag thing -- "pad/"
--   key         big_axis            small_axis           big_dimension  small_dimension
bind("pad1",     positionStart,      positionEnd,         sizeHalf,      sizeHalf)
bind("pad2",     positionStart,      positionEnd,         sizeFull,      sizeHalf)
bind("pad3",     positionEnd,        positionEnd,         sizeHalf,      sizeHalf)
bind("pad4",     positionStart,      positionStart,       sizeHalf,      sizeFull)
bind("pad5",     positionStart,      positionStart,       sizeFull,      sizeFull)
bind("pad6",     positionEnd,        positionStart,       sizeHalf,      sizeFull)
bind("pad7",     positionStart,      positionStart,       sizeHalf,      sizeHalf)
bind("pad8",     positionStart,      positionStart,       sizeFull,      sizeHalf)
bind("pad9",     positionEnd,        positionStart,       sizeHalf,      sizeHalf)
bind("Up",       positionUnchanged,  positionStart,       sizeUnchanged, sizeUnchanged)
bind("Right",    positionEnd,        positionUnchanged,   sizeUnchanged, sizeUnchanged)
bind("Down",     positionUnchanged,  positionEnd,         sizeUnchanged, sizeUnchanged)
bind("Left",     positionStart,      positionUnchanged,   sizeUnchanged, sizeUnchanged)
bind("pad*",     positionUnchanged,  positionUnchanged,   sizeThird,     sizeUnchanged)
bind("pad-",     positionUnchanged,  positionUnchanged,   sizeTwoThirds, sizeUnchanged)
bind("pad+",     positionUnchanged,  positionUnchanged,   sizeUnchanged, sizeThird)
bind("padenter", positionUnchanged,  positionUnchanged,   sizeUnchanged, sizeTwoThirds)
bind("f1",       positionStart,      positionStart,       sizeThird,     sizeFull)
bind("f2",       positionCenter,     positionStart,       sizeThird,     sizeFull)
bind("f3",       positionEnd,        positionStart,       sizeThird,     sizeFull)
bind("f4",       positionStart,      positionStart,       sizeTwoThirds, sizeFull)
bind("f5",       positionCenter,     positionStart,       sizeTwoThirds, sizeFull)
bind("f6",       positionEnd,        positionStart,       sizeTwoThirds, sizeFull)
bind("f7",       positionStart,      positionStart,       sizeUnchanged, sizeFull)
bind("f8",       positionCenter,     positionStart,       sizeUnchanged, sizeFull)
bind("f9",       positionEnd,        positionStart,       sizeUnchanged, sizeFull)
