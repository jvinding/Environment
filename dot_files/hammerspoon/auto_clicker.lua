local clickCoordinates = nil
local clickTimer = nil
local clickDelay = 3.0

function toggleClicker()
    if isAutoClickerEnabled() then
        stopClicker()
    else
        startClicker()
    end
end

function isAutoClickerEnabled()
    return clickTimer ~= nil
end

function stopClicker()
    hs.alert.show("Stopping clicker for " .. coordinateString())
    clickTimer:stop()
    clickTimer = nil
    clickCoordinates = nil
end

function startClicker()
    clickCoordinates = hs.mouse.getAbsolutePosition()
    clickTimer = hs.timer.doEvery(clickDelay, mouseClick)
    hs.alert.show("Clicking " .. coordinateString() .. " every " .. tostring(clickDelay) .. " seconds")
end

function coordinateString()
    return tostring(math.floor(clickCoordinates.x)) .. "," .. tostring(math.floor(clickCoordinates.y))
end

function mouseClick()
    hs.eventtap.leftClick(clickCoordinates)
end

hs.hotkey.bind({"cmd","alt","shift"}, "A", toggleClicker)
