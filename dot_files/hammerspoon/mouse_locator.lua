local mouseTimers = {}

local function getColor(red, green, blue, alpha)
    return {
        red = red,
        green = green,
        blue = blue,
        alpha = alpha
    }
end

local function drawMouseCircle(x, y, diameter, strokeColor, strokeWidth)
    local radius = diameter / 2
    local circle = hs.drawing.circle(hs.geometry.rect(x - radius, y - radius, diameter, diameter))
    circle:setFill(false)
    circle:setStrokeColor(strokeColor)
    circle:setStrokeWidth(strokeWidth)
    circle:show()

    return circle
end

local function mouseHighlight()
  local size = 150
  local stroke = 6
    for circle, timer in pairs(mouseTimers) do
        circle:delete()
        timer:stop()
    end
    local mousepoint = hs.mouse.getAbsolutePosition()
    for _, divisor in ipairs({1, 2, 4}) do
        hs.timer.doAfter(.1 * divisor, function()
            local circle = drawMouseCircle(mousepoint.x, mousepoint.y, size / divisor, getColor(1, 0, 0, 1), stroke / divisor)
            local timer = hs.timer.doAfter(1, function() circle:delete(); mouseTimers.remove(circle) end)
            mouseTimers[circle] = timer
        end)
    end
end
hs.hotkey.bind(hyper, "f1", mouseHighlight)
