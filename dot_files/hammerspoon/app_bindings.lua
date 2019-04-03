local apps = {
    A = "Android Studio",
    B = "Brave",
    C = "AppCode",
    -- C = "AppCode-EAP",
    E = "Messages",
    F = "Firefox",
    G = "Google Chrome",
    -- I = "IntelliJ IDEA",
    I = "IntelliJ IDEA 2019.1 EAP",
    J =  "Kiwi for Gmail",
    -- J = "Postbox",
    -- J = "Airmail",
    K = "Skype",
    L = "Slack",
    M = "Simulator",
    N = "Navicat Essentials for PostgreSQL",
    P = "1Password 7",
    R = "iTerm",
    S = "Sublime Merge",
    -- S = "Sourcetree",
    -- S = "Tower",
    T = "MacVim",
    V = "Visual Studio Code",
    X = "Xcode",
    -- X = "Xcode-beta",
    Z = "Zeplin"
}

for key, app in pairs(apps) do
    local binding = hs.hotkey.bind(hyper, key, function() hs.application.launchOrFocus(app) end)
    local wf = hs.window.filter
    screenSharingFilter = wf.new("Screen Sharing")
    screenSharingFilter:subscribe(wf.windowFocused, function() binding:disable() end)
    screenSharingFilter:subscribe(wf.windowUnfocused, function() binding:enable() end)
end

