-- icons from https://github.com/BrianGilbert/.hammerspoon
local caffeine = hs.menubar.new()
local caffeineTimer = nil

local function getStatusString()
    local string
    if hs.caffeinate.get("displayIdle") then
        if caffeineTimer then
            string = os.date("Active until %X", os.time() + math.floor(caffeineTimer:nextTrigger()))
        else
            string = "Active until disabled"
        end
    else
        string = "Inactive"
    end

    return string
end

local function updateDisplay()
    caffeine:setTooltip(getStatusString())
    if hs.caffeinate.get("displayIdle") then
        caffeine:setIcon("caffeine-on.pdf")
    else
        caffeine:setIcon("caffeine-off.pdf")
    end
end

local function caffeineClicked(event)
    if caffeineTimer then
        caffeineTimer:stop()
    end
    local enabled = hs.caffeinate.toggle("displayIdle")
    if enabled then
        local time = 7200
        if event then
            if event["shift"] then
                time = 18000
            elseif event["ctrl"] then
                time = 0
            end
        end
        if 0 == time then
            caffeineTime = nil
        else
            caffeineTimer = hs.timer.doAfter(time, function()
                hs.caffeinate.set("displayIdle", false)
                updateDisplay()
            end)
        end
    else
        caffeineTimer = nil
    end
    hs.alert.show(getStatusString())
    updateDisplay()
end

if caffeine then
    caffeine:setClickCallback(caffeineClicked)
    updateDisplay()
end

hs.hotkey.bind(hyper, "\\", function() caffeineClicked() end)
