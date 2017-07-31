local apps = {
    ['1'] = "1Password 6",
    A = "Android Studio",
    B = "Brave",
    C = "AppCode",
    -- C = "AppCode-EAP",
    E = "Messages",
    G = "Google Chrome",
    I = "IntelliJ IDEA",
    -- I = "IntelliJ IDEA-EAP",
    J =  "Kiwi for Gmail",
    -- J = "Postbox",
    -- J = "Airmail",
    K = "Skype",
    L = "Slack",
    N = "Navicat Essentials for PostgreSQL",
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
