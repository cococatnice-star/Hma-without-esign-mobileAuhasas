-- CocoX remote enable/disable check.
-- The Cloudflare endpoint must return the plain text "Yes" to allow this script.
local _cocoxGatePlayer = game:GetService("Players").LocalPlayer
local _cocoxGateUrl = "https://cocox.wtf/api/check"

local function _cocoxIsEnabled()
    local ok, response = pcall(function()
        return game:HttpGet(_cocoxGateUrl)
    end)
    if not ok or type(response) ~= "string" then
        return false
    end
    return response:match("^%s*[Yy][Ee][Ss]%s*$") ~= nil
end

if not _cocoxIsEnabled() then
    pcall(function()
        if _cocoxGatePlayer then
            _cocoxGatePlayer:Kick("Script Shutdown")
        end
    end)
    return
end

-- Recheck every 3 seconds; stop the script if the endpoint no longer says Yes.
task.spawn(function()
    while task.wait(3) do
        if not _cocoxIsEnabled() then
            pcall(function()
                if _cocoxGatePlayer then
                    _cocoxGatePlayer:Kick("Script Shutdown")
                end
            end)
            break
        end
    end
end)

-- CocoX Noclip UI - orange mobile-friendly edition
-- Intended for use in a Roblox experience where you have permission to run custom UI code.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Remove an older copy if the script is run again.
local oldGui = playerGui:FindFirstChild("CocoXNoclipGui")
if oldGui then oldGui:Destroy() end

local ORANGE = Color3.fromRGB(255, 125, 25)
local ORANGE_LIGHT = Color3.fromRGB(255, 174, 83)
local ORANGE_DARK = Color3.fromRGB(190, 76, 10)
local PANEL = Color3.fromRGB(24, 22, 25)
local PANEL_LIGHT = Color3.fromRGB(37, 32, 34)
local WHITE = Color3.fromRGB(255, 247, 240)
local MUTED = Color3.fromRGB(190, 178, 168)

local gui = Instance.new("ScreenGui")
gui.Name = "CocoXNoclipGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local function addCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
    return corner
end

local function addStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0
    stroke.Parent = parent
    return stroke
end

local function tween(object, duration, properties, style, direction)
    local info = TweenInfo.new(duration, style or Enum.EasingStyle.Quart, direction or Enum.EasingDirection.Out)
    local t = TweenService:Create(object, info, properties)
    t:Play()
    return t
end


-- CocoX HUD bar, based on the supplied HUD code.
local oldHUD = playerGui:FindFirstChild("CocoXHUD")
if oldHUD then oldHUD:Destroy() end

local hudGui = Instance.new("ScreenGui")
hudGui.Name = "CocoXHUD"
hudGui.IgnoreGuiInset = true
hudGui.ResetOnSpawn = false
hudGui.DisplayOrder = 100
hudGui.Parent = playerGui

local bar = Instance.new("Frame")
bar.Name = "MainBar"
bar.AnchorPoint = Vector2.new(0.5, 0)
bar.Size = UDim2.fromOffset(390, 44)
bar.Position = UDim2.new(0.5, 0, 0, 8)
bar.BackgroundColor3 = Color3.fromRGB(100, 45, 160)
bar.BorderSizePixel = 0
bar.ClipsDescendants = true
bar.Parent = hudGui
local round = Instance.new("UICorner")
round.CornerRadius = UDim.new(0, 22)
round.Parent = bar

-- Orange -> pink -> purple gradient from the supplied code.
local gradient = Instance.new("UIGradient")
gradient.Rotation = 0
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 151, 63)),
    ColorSequenceKeypoint.new(0.16, Color3.fromRGB(190, 89, 126)),
    ColorSequenceKeypoint.new(0.36, Color3.fromRGB(104, 42, 183)),
    ColorSequenceKeypoint.new(0.65, Color3.fromRGB(60, 24, 163)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(43, 20, 116))
})
gradient.Parent = bar

local border = Instance.new("UIStroke")
border.Color = Color3.fromRGB(255, 164, 85)
border.Transparency = 0.4
border.Thickness = 1
border.Parent = bar

local function makeLabel(name, text, x, width, color, size, font)
    local label = Instance.new("TextLabel")
    label.Name = name
    label.BackgroundTransparency = 1
    label.Position = UDim2.fromOffset(x, 0)
    label.Size = UDim2.fromOffset(width, 44)
    label.Font = font or Enum.Font.GothamMedium
    label.Text = text
    label.TextSize = size or 11
    label.TextColor3 = color
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Parent = bar
    return label
end

makeLabel("Brand", "CocoX", 7, 68, Color3.fromRGB(255, 183, 111), 12, Enum.Font.GothamBold)
makeLabel("Separator", "•", 73, 10, Color3.fromRGB(226, 202, 255), 11)

local version = Instance.new("Frame")
version.Name = "VersionBadge"
version.Position = UDim2.fromOffset(83, 5)
version.Size = UDim2.fromOffset(47, 34)
version.BackgroundColor3 = Color3.fromRGB(137, 61, 202)
version.BackgroundTransparency = 0.05
version.BorderSizePixel = 0
version.Parent = bar
local versionCorner = Instance.new("UICorner")
versionCorner.CornerRadius = UDim.new(1, 0)
versionCorner.Parent = version
local versionText = Instance.new("TextLabel")
versionText.Name = "VersionText"
versionText.BackgroundTransparency = 1
versionText.Size = UDim2.fromScale(1, 1)
versionText.Font = Enum.Font.GothamBold
versionText.Text = "v2.00"
versionText.TextSize = 10
versionText.TextColor3 = Color3.fromRGB(255, 220, 190)
versionText.Parent = version

makeLabel("Website", "• cocox.wtf", 134, 99, Color3.fromRGB(255, 190, 150), 11)

local function makeBadge(name, x, width, initial, color)
    local badge = Instance.new("Frame")
    badge.Name = name
    badge.Position = UDim2.fromOffset(x, 5)
    badge.Size = UDim2.fromOffset(width, 34)
    badge.BackgroundColor3 = Color3.fromRGB(27, 22, 41)
    badge.BorderSizePixel = 0
    badge.Parent = bar
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = badge
    local text = Instance.new("TextLabel")
    text.Name = "Value"
    text.BackgroundTransparency = 1
    text.Size = UDim2.fromScale(1, 1)
    text.Font = Enum.Font.GothamBold
    text.TextSize = 10
    text.Text = initial
    text.TextColor3 = color
    text.Parent = badge
    return text
end

local fpsText = makeBadge("FPSBadge", 241, 61, "60 fps", Color3.fromRGB(255, 191, 117))
local pingText = makeBadge("PingBadge", 304, 57, "28ms", Color3.fromRGB(102, 255, 184))

local frames = 0
local elapsed = 0
RunService.RenderStepped:Connect(function(dt)
    if not hudGui.Parent then return end
    frames += 1
    elapsed += dt
    if elapsed >= 0.5 then
        fpsText.Text = tostring(math.floor(frames / elapsed + 0.5)) .. " fps"
        frames = 0
        elapsed = 0
    end
end)

task.spawn(function()
    while hudGui.Parent do
        local success, ping = pcall(function()
            return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
        end)
        pingText.Text = success and (tostring(math.floor(ping + 0.5)) .. "ms") or "--ms"
        task.wait(1)
    end
end)

-- Small floating launcher, kept on the right edge for mobile users.
local launcher = Instance.new("ImageButton")
launcher.Name = "CocoXMiniButton"
launcher.AnchorPoint = Vector2.new(1, 0.5)
launcher.Position = UDim2.new(1, -12, 0.5, 0)
launcher.Size = UDim2.fromOffset(48, 48)
launcher.BackgroundColor3 = Color3.fromRGB(39, 24, 17)
launcher.BorderSizePixel = 0
launcher.Image = "rbxthumb://type=Asset&id=128967998275627&w=150&h=150"
launcher.ScaleType = Enum.ScaleType.Fit
launcher.ImageColor3 = Color3.new(1, 1, 1)
launcher.AutoButtonColor = false
launcher.Parent = gui
addCorner(launcher, 15)
addStroke(launcher, ORANGE_LIGHT, 1.7, 0.05)

-- Text fallback stays visible if the supplied image is not permitted or is not an image asset.
local launcherFallback = Instance.new("TextLabel")
launcherFallback.Name = "ImageFallback"
launcherFallback.BackgroundTransparency = 1
launcherFallback.Size = UDim2.fromScale(1, 1)
launcherFallback.Text = "CX"
launcherFallback.Visible = true
launcherFallback.TextColor3 = WHITE
launcherFallback.TextSize = 17
launcherFallback.Font = Enum.Font.GothamBlack
launcherFallback.ZIndex = launcher.ZIndex + 1
launcherFallback.Parent = launcher

local launcherScale = Instance.new("UIScale")
launcherScale.Scale = 1
launcherScale.Parent = launcher

-- Main panel.
local shadow = Instance.new("Frame")
shadow.Name = "PanelShadow"
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.Position = UDim2.new(0.5, 3, 0.5, 5)
shadow.Size = UDim2.fromOffset(340, 330)
shadow.BackgroundColor3 = Color3.new(0, 0, 0)
shadow.BackgroundTransparency = 0.48
shadow.BorderSizePixel = 0
shadow.Visible = false
shadow.Parent = gui
addCorner(shadow, 14)

local panel = Instance.new("Frame")
panel.Name = "MainPanel"
panel.AnchorPoint = Vector2.new(0.5, 0.5)
panel.Position = UDim2.new(0.5, 0, 0.5, 0)
panel.Size = UDim2.fromOffset(340, 330)
panel.BackgroundColor3 = PANEL
panel.BorderSizePixel = 0
panel.Visible = false
panel.ClipsDescendants = true
panel.Parent = gui
addCorner(panel, 14)
addStroke(panel, Color3.fromRGB(255, 125, 25), 1.3, 0.1)

local panelScale = Instance.new("UIScale")
panelScale.Scale = 0.88
panelScale.Parent = panel

local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 66)
topBar.BackgroundColor3 = PANEL_LIGHT
topBar.BorderSizePixel = 0
topBar.Parent = panel
addCorner(topBar, 14)
local topFill = Instance.new("Frame")
topFill.Position = UDim2.new(0, 0, 1, -14)
topFill.Size = UDim2.new(1, 0, 0, 14)
topFill.BackgroundColor3 = PANEL_LIGHT
topFill.BorderSizePixel = 0
topFill.Parent = topBar

local accent = Instance.new("Frame")
accent.Position = UDim2.new(0, 11, 0, 11)
accent.Size = UDim2.new(0, 4, 1, -22)
accent.BackgroundColor3 = ORANGE
accent.BorderSizePixel = 0
accent.Parent = topBar
addCorner(accent, 4)

-- Requested image asset beside the title.
local logo = Instance.new("ImageLabel")
logo.Name = "CocoXLogo"
logo.BackgroundTransparency = 1
logo.Position = UDim2.new(0, 24, 0, 12)
logo.Size = UDim2.fromOffset(40, 40)
logo.Image = "rbxthumb://type=Asset&id=128967998275627&w=150&h=150"
logo.ScaleType = Enum.ScaleType.Fit
logo.Parent = topBar
local logoFallback = Instance.new("TextLabel")
logoFallback.Name = "LogoFallback"
logoFallback.BackgroundTransparency = 1
logoFallback.Position = logo.Position
logoFallback.Size = logo.Size
logoFallback.Text = "CX"
logoFallback.Visible = true
logoFallback.TextColor3 = ORANGE_LIGHT
logoFallback.TextSize = 13
logoFallback.Font = Enum.Font.GothamBlack
logoFallback.Parent = topBar

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 72, 0, 12)
title.Size = UDim2.new(1, -120, 0, 24)
title.Font = Enum.Font.GothamBlack
title.Text = "CocoX Noclip"
title.TextColor3 = WHITE
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

local subtitle = Instance.new("TextLabel")
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.new(0, 73, 0, 36)
subtitle.Size = UDim2.new(1, -120, 0, 15)
subtitle.Font = Enum.Font.GothamMedium
subtitle.Text = "ORANGE EDITION"
subtitle.TextColor3 = ORANGE_LIGHT
subtitle.TextSize = 9
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = topBar

local closeButton = Instance.new("TextButton")
closeButton.Name = "HideButton"
closeButton.Position = UDim2.new(1, -34, 0, 13)
closeButton.Size = UDim2.fromOffset(22, 22)
closeButton.BackgroundColor3 = Color3.fromRGB(77, 44, 32)
closeButton.BorderSizePixel = 0
closeButton.Text = "×"
closeButton.TextColor3 = WHITE
closeButton.TextSize = 20
closeButton.Font = Enum.Font.GothamBold
closeButton.AutoButtonColor = false
closeButton.Parent = topBar
addCorner(closeButton, 7)

local status = Instance.new("TextLabel")
status.Name = "Status"
status.BackgroundTransparency = 1
status.Position = UDim2.new(0, 18, 0, 76)
status.Size = UDim2.new(1, -36, 0, 20)
status.Font = Enum.Font.GothamMedium
status.Text = "Ready • Choose an action"
status.TextColor3 = MUTED
status.TextSize = 11
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = panel

-- Smooth tab strip: Home, Settings, and a clearly marked Soon page.
local tabBar = Instance.new("Frame")
tabBar.Name = "TabBar"
tabBar.BackgroundColor3 = PANEL_LIGHT
tabBar.BorderSizePixel = 0
tabBar.Position = UDim2.new(0, 14, 0, 101)
tabBar.Size = UDim2.new(1, -28, 0, 34)
tabBar.Parent = panel
addCorner(tabBar, 9)

local pages = {}
local tabButtons = {}
local activeTab = "Home"
local function makePage(name)
    local page = Instance.new("Frame")
    page.Name = name .. "Page"
    page.BackgroundTransparency = 1
    page.Position = UDim2.new(0, 0, 0, 140)
    page.Size = UDim2.new(1, 0, 1, -168)
    page.Visible = false
    page.Parent = panel
    pages[name] = page
    return page
end
local homePage = makePage("Home")
local settingsPage = makePage("Settings")
local soonPage = makePage("Soon")

local function showTab(name)
    activeTab = name
    for pageName, page in pairs(pages) do
        local shouldShow = pageName == name
        page.Visible = shouldShow
        if shouldShow then
            page.BackgroundTransparency = 1
            page.Position = UDim2.new(0, 0, 0, 144)
            tween(page, 0.18, {Position = UDim2.new(0, 0, 0, 140)})
        end
    end
    for tabName, tab in pairs(tabButtons) do
        local selected = tabName == name
        tween(tab, 0.14, {BackgroundColor3 = selected and ORANGE or PANEL_LIGHT})
        tab.TextColor3 = selected and WHITE or MUTED
    end
end

for index, tabName in ipairs({"Home", "Settings", "Soon"}) do
    local tab = Instance.new("TextButton")
    tab.Name = tabName .. "Tab"
    tab.Position = UDim2.new((index - 1) / 3, 3, 0, 3)
    tab.Size = UDim2.new(1 / 3, -4, 1, -6)
    tab.BackgroundColor3 = tabName == "Home" and ORANGE or PANEL_LIGHT
    tab.BorderSizePixel = 0
    tab.Text = tabName == "Soon" and "Soon" or tabName
    tab.TextColor3 = tabName == "Home" and WHITE or MUTED
    tab.TextSize = 11
    tab.Font = Enum.Font.GothamBold
    tab.AutoButtonColor = false
    tab.Parent = tabBar
    addCorner(tab, 7)
    tabButtons[tabName] = tab
    tab.Activated:Connect(function() showTab(tabName) end)
end

local function makeButton(name, label, y, parent)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Position = UDim2.new(0, 16, 0, y)
    button.Size = UDim2.new(1, -32, 0, 43)
    button.BackgroundColor3 = ORANGE
    button.BorderSizePixel = 0
    button.Text = ""
    button.AutoButtonColor = false
    button.Parent = parent or homePage
    addCorner(button, 9)
    addStroke(button, ORANGE_LIGHT, 1, 0.28)

    local emoji = Instance.new("TextLabel")
    emoji.BackgroundTransparency = 1
    emoji.Position = UDim2.new(0, 12, 0, 0)
    emoji.Size = UDim2.new(0, 30, 1, 0)
    emoji.Font = Enum.Font.GothamBold
    emoji.Text = "🐱"
    emoji.TextSize = 17
    emoji.TextColor3 = WHITE
    emoji.Parent = button

    local textLabel = Instance.new("TextLabel")
    textLabel.BackgroundTransparency = 1
    textLabel.Position = UDim2.new(0, 48, 0, 0)
    textLabel.Size = UDim2.new(1, -60, 1, 0)
    textLabel.Font = Enum.Font.GothamBold
    textLabel.Text = label
    textLabel.TextColor3 = WHITE
    textLabel.TextSize = 13
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = button

    button.MouseEnter:Connect(function()
        tween(button, 0.14, {BackgroundColor3 = Color3.fromRGB(255, 151, 53)})
    end)
    button.MouseLeave:Connect(function()
        tween(button, 0.14, {BackgroundColor3 = ORANGE})
    end)
    button.MouseButton1Down:Connect(function()
        tween(button, 0.07, {BackgroundColor3 = ORANGE_DARK})
    end)
    button.MouseButton1Up:Connect(function()
        tween(button, 0.12, {BackgroundColor3 = Color3.fromRGB(255, 151, 53)})
    end)
    return button, textLabel
end

local toggleV2Button, toggleV2Label = makeButton("ToggleNoclipV2", "Enable Noclip V2", 7, homePage)
toggleV2Button.BackgroundColor3 = PANEL_LIGHT

local footer = Instance.new("TextLabel")
footer.BackgroundTransparency = 1
footer.Position = UDim2.new(0, 16, 1, -22)
footer.Size = UDim2.new(1, -32, 0, 14)
footer.Font = Enum.Font.Gotham
footer.Text = "COCOX  •  MOBILE READY"
footer.TextColor3 = Color3.fromRGB(135, 119, 107)
footer.TextSize = 9
footer.TextXAlignment = Enum.TextXAlignment.Right
footer.Parent = panel

local function makeInfoLabel(parent, name, text, y, height, color, size)
    local label = Instance.new("TextLabel")
    label.Name = name
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 18, 0, y)
    label.Size = UDim2.new(1, -36, 0, height)
    label.Font = Enum.Font.GothamMedium
    label.Text = text
    label.TextColor3 = color or MUTED
    label.TextSize = size or 11
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    return label
end
makeInfoLabel(settingsPage, "SettingsHeading", "INTERFACE SETTINGS", 8, 18, ORANGE_LIGHT, 10).Font = Enum.Font.GothamBold
makeInfoLabel(settingsPage, "SettingsDescription", "Orange theme enabled\nMobile launcher: right edge\nUse the tabs to explore CocoX.", 33, 65, WHITE, 11)
makeInfoLabel(soonPage, "SoonHeading", "MORE COCOX FEATURES", 18, 25, ORANGE_LIGHT, 12).Font = Enum.Font.GothamBlack
local soonText = makeInfoLabel(soonPage, "SoonDescription", "More features are coming soon.", 49, 35, WHITE, 11)
soonText.TextXAlignment = Enum.TextXAlignment.Center
showTab("Home")

-- Load the requested asset as a thumbnail and keep a visible CX fallback until it loads.
task.spawn(function()
    local ContentProvider = game:GetService("ContentProvider")
    pcall(function() ContentProvider:PreloadAsync({logo, launcher}) end)
    task.wait(1)
    if launcher.Parent then launcherFallback.Visible = not launcher.IsLoaded end
    if logo.Parent then logoFallback.Visible = not logo.IsLoaded end
end)
launcher:GetPropertyChangedSignal("IsLoaded"):Connect(function()
    launcherFallback.Visible = not launcher.IsLoaded
end)
logo:GetPropertyChangedSignal("IsLoaded"):Connect(function()
    logoFallback.Visible = not logo.IsLoaded
end)

-- This floating action appears only while Noclip V2 is enabled.
local v2Floating = Instance.new("TextButton")
v2Floating.Name = "NoclipV2FloatingButton"
v2Floating.AnchorPoint = Vector2.new(1, 1)
v2Floating.Position = UDim2.new(1, -14, 1, -18)
v2Floating.Size = UDim2.fromOffset(94, 42)
v2Floating.BackgroundColor3 = ORANGE
v2Floating.BorderSizePixel = 0
v2Floating.Text = "🐱  V2"
v2Floating.TextColor3 = WHITE
v2Floating.TextSize = 13
v2Floating.Font = Enum.Font.GothamBlack
v2Floating.AutoButtonColor = false
v2Floating.Visible = false
v2Floating.Parent = gui
addCorner(v2Floating, 12)
addStroke(v2Floating, ORANGE_LIGHT, 1.4, 0.1)
v2Floating.MouseEnter:Connect(function() tween(v2Floating, 0.12, {BackgroundColor3 = Color3.fromRGB(255, 151, 53)}) end)
v2Floating.MouseLeave:Connect(function() tween(v2Floating, 0.12, {BackgroundColor3 = ORANGE}) end)

-- Make the floating Noclip V2 button draggable with mouse or touch.
local v2Dragging = false
local v2DragInput = nil
local v2DragStart = nil
local v2StartPosition = nil

v2Floating.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        v2Dragging = true
        v2DragInput = input
        v2DragStart = input.Position
        v2StartPosition = v2Floating.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not v2Dragging then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - v2DragStart
        v2Floating.Position = UDim2.new(
            v2StartPosition.X.Scale,
            v2StartPosition.X.Offset + delta.X,
            v2StartPosition.Y.Scale,
            v2StartPosition.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input == v2DragInput
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
        v2Dragging = false
        v2DragInput = nil
    end
end)

-- Original actions retained from the supplied script.
local function teleportTo(pos)
    local character = player.Character or player.CharacterAdded:Wait()
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local cam = workspace.CurrentCamera
    local savedCFrame = cam.CFrame
    cam.CameraType = Enum.CameraType.Scriptable
    cam.CFrame = savedCFrame
    root.CFrame = CFrame.new(pos)
    task.wait(0.1)
    cam.CFrame = savedCFrame
    task.wait(0.3)
    cam.CameraType = Enum.CameraType.Custom
    local hum = character:FindFirstChildOfClass("Humanoid")
    if hum then cam.CameraSubject = hum end
end

local function teleportWithSit(pos)
    local character = player.Character or player.CharacterAdded:Wait()
    local root = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid then return end
    local cam = workspace.CurrentCamera
    local savedCFrame = cam.CFrame
    cam.CameraType = Enum.CameraType.Scriptable
    cam.CFrame = savedCFrame
    humanoid.Sit = true
    task.wait(0.05)
    root.CFrame = CFrame.new(pos)
    task.wait(0.05)
    humanoid.Sit = false
    cam.CFrame = savedCFrame
    task.wait(0.3)
    cam.CameraType = Enum.CameraType.Custom
    cam.CameraSubject = humanoid
end

local function setStatus(message, color)
    status.Text = message
    status.TextColor3 = color or MUTED
end

local function openPanel()
    if panel.Visible then return end
    panel.Visible = true
    shadow.Visible = true
    panel.Size = UDim2.fromOffset(320, 312)
    shadow.Size = UDim2.fromOffset(323, 317)
    panel.BackgroundTransparency = 0.12
    panelScale.Scale = 0.88
    tween(panel, 0.24, {Size = UDim2.fromOffset(340, 330)})
    tween(shadow, 0.24, {Size = UDim2.fromOffset(343, 335)})
    tween(panelScale, 0.24, {Scale = 1}, Enum.EasingStyle.Back)
    tween(launcherScale, 0.12, {Scale = 0.9})
    task.delay(0.12, function()
        if launcher and launcher.Parent then tween(launcherScale, 0.16, {Scale = 1}) end
    end)
end

local function closePanel()
    if not panel.Visible then return end
    tween(panelScale, 0.16, {Scale = 0.88}, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    tween(panel, 0.16, {Size = UDim2.fromOffset(320, 312)})
    tween(shadow, 0.16, {Size = UDim2.fromOffset(323, 317)})
    task.delay(0.17, function()
        if panel and panel.Parent then panel.Visible = false end
        if shadow and shadow.Parent then shadow.Visible = false end
    end)
end

local v2Enabled = false
local function setV2Enabled(enabled)
    v2Enabled = enabled
    v2Floating.Visible = enabled
    if enabled then
        toggleV2Button.BackgroundColor3 = ORANGE
        toggleV2Label.Text = "Disable Noclip V2"
        setStatus("Noclip V2 enabled • floating button ready", ORANGE_LIGHT)
    else
        toggleV2Button.BackgroundColor3 = PANEL_LIGHT
        toggleV2Label.Text = "Enable Noclip V2"
        setStatus("Noclip V2 disabled", MUTED)
    end
end

launcher.Activated:Connect(function()
    if panel.Visible then closePanel() else openPanel() end
end)
closeButton.Activated:Connect(closePanel)
toggleV2Button.Activated:Connect(function()
    setV2Enabled(not v2Enabled)
end)
v2Floating.Activated:Connect(function()
    if v2Enabled then
        setStatus("Noclip V2 action selected", ORANGE_LIGHT)
        teleportWithSit(Vector3.new(-99999, -99999, -99999))
    end
end)

-- Drag the main window by its header (mouse and touch).
local dragging = false
local dragStart, panelStart
local function inputPosition(input)
    return Vector2.new(input.Position.X, input.Position.Y)
end

topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = inputPosition(input)
        panelStart = panel.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = inputPosition(input) - dragStart
        panel.Position = UDim2.new(panelStart.X.Scale, panelStart.X.Offset + delta.X, panelStart.Y.Scale, panelStart.Y.Offset + delta.Y)
        shadow.Position = UDim2.new(panel.Position.X.Scale, panel.Position.X.Offset + 3, panel.Position.Y.Scale, panel.Position.Y.Offset + 5)
    end
end)

-- Responsive sizing for narrow mobile screens.
local function updateForViewport()
    local camera = workspace.CurrentCamera
    if not camera then return end
    local viewport = camera.ViewportSize
    if viewport.X < 370 then
        panelScale.Scale = panel.Visible and 0.9 or 0.88
        panel.Size = UDim2.fromOffset(310, 330)
        shadow.Size = UDim2.fromOffset(313, 335)
    else
        panel.Size = UDim2.fromOffset(340, 330)
        shadow.Size = UDim2.fromOffset(343, 335)
    end
end
if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateForViewport)
end
updateForViewport()

-- Start minimized: the small orange CX button opens the complete UI.
setV2Enabled(false)
return gui
