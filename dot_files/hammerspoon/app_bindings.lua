local apps = {
    A = "Android Studio",
    B = "Brave",
    C = "AppCode",
    -- C = "AppCode-EAP",
    E = "Messages",
    F = "Firefox",
    G = "Google Chrome",
    I = "IntelliJ IDEA",
    -- I = "IntelliJ IDEA-EAP",
    J =  "Kiwi for Gmail",
    -- J = "Postbox",
    -- J = "Airmail",
    K = "Skype",
    L = "Slack",
    N = "Navicat Essentials for PostgreSQL",
    P = "1Password 7",
    R = "iTerm",
    S = "Tower",
    T = "MacVim",
    X = "Xcode",
    -- X = "Xcode-beta",
    Z = "Zeplin"
}

for key, app in pairs(apps) do
  hs.hotkey.bind(hyper, key, function() hs.application.launchOrFocus(app) end)
end
