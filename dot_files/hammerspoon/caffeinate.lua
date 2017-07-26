-- icons from https://github.com/BrianGilbert/.hammerspoon
local caffeine = hs.menubar.new()
local caffeineTimer = nil

local function updateDisplay()
    if hs.caffeinate.get("displayIdle") then
        caffeine:setIcon("caffeine-on.pdf")
        if caffeineTimer then
            caffeine:setTooltip(os.date("Active until %X", os.time() + math.floor(caffeineTimer:nextTrigger())))
        else
            caffeine:setTooltip("Active until disabled")
        end
    else
        caffeine:setIcon("caffeine-off.pdf")
        caffeine:setTooltip("Inactive")
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
    updateDisplay()
end

if caffeine then
    caffeine:setClickCallback(caffeineClicked)
    updateDisplay()
end

hs.hotkey.bind(hyper, "\\", function() caffeineClicked() end)
