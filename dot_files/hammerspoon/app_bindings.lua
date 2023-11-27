local apps = {
    A = "Android Studio",
    B = "Brave",
    -- C = "AppCode",
    -- C = "AppCode-EAP",
    D = "DBeaver",
    E = "Rider",
    -- F = "Firefox",
    F = "Arc",
    -- G = "Google Chrome",
    -- I = "IntelliJ IDEA",
    I = "IntelliJ IDEA CE",
    J =  "Kiwi for Gmail",
    H = "Postman",
    -- J = "Postbox",
    -- J = "Airmail 3",
    K = "Skype",
    L = "Slack",
    M = "Messages",
    -- N = "Navicat Essentials for PostgreSQL",
    N = "Logseq",
    P = "1Password",
    R = "Hyper",
    -- S = "GitKraken",
    S = "Fork",
    -- S = "Sourcetree",
    -- S = "Tower",
    T = "MacVim",
    V = "Visual Studio",
    X = "Xcode",
    V = "Visual Studio Code",
    -- X = "Xcode-beta",
    Z = "Zeplin",
    space = "Todoist",
    delete = "Finder" -- I mostly use this to escape from screen sharing
}

for key, app in pairs(apps) do
    local binding = hs.hotkey.bind(hyper, key, function() hs.application.launchOrFocus(app) end)
    if "Finder" ~= app then
        local wf = hs.window.filter
        screenSharingFilter = wf.new("Screen Sharing")
        screenSharingFilter:subscribe(wf.windowFocused, function() binding:disable() end)
        screenSharingFilter:subscribe(wf.windowUnfocused, function() binding:enable() end)
    end
end

