local apps = {
	A = "Android Studio",
	-- D = "DBeaver",
	E = "Rider",
	-- F = "Firefox",
	F = "Arc",
	I = "IntelliJ IDEA CE",
	J = "Spark",
	K = "Skype",
	L = "Slack",
	M = "Messages",
	N = "Logseq",
	P = "1Password",
	R = "Warp",
	S = "Fork",
	X = "Xcode",
	V = "Neovide",
	Z = "Zeplin",
	space = "Todoist",
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

