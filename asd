local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
end)

local LocalPlayer = game:GetService("Players").LocalPlayer

local Window = WindUI:CreateWindow({
    Title = "Fyy X Community",
    Icon = "rbxassetid://106899268176689", 
    Author = "Fyy X Fish IT | FREE SCRIPT!!!",
    Folder = "FyyConfig",
    Size = UDim2.fromOffset(530, 300),
    MinSize = Vector2.new(320, 300),
    MaxSize = Vector2.new(850, 560),
    NewElements = true,
    Transparent = true,
    HideSearchBar = true,
    SideBarWidth = 150,
    Resizable = false,
    Theme = "Dark",
    HasOutline = true,  
    BackgroundImageTransparency = 0,
    Background = "rbxassetid://78893380921225",                                                         
    OpenButton = {
        Title = "Fyy X Fish IT",
        Icon = "rbxassetid://106899268176689",
        CornerRadius = UDim.new(1,0), 
        StrokeThickness = 2,
        Enabled = false, 
        Draggable = false,
        OnlyMobile = true,
        Color = ColorSequence.new(Color3.fromHex("#00c3ff"), Color3.fromHex("#ffffff"))
    },
})

Window:SetToggleKey(Enum.KeyCode.G)

local ConfigFolder = "FyyCommunityConfig"
if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end

local ConfigObjects = {}

local function SaveConfig(name)
    local data = {}
    for key, obj in pairs(ConfigObjects) do
        local val = obj.Value
        -- Check if it's a slider value table (has Default and Min properties)
        if type(val) == "table" and val.Default and val.Min then
            data[key] = val.Default 
        -- Check if it's an array (multi-select dropdown)
        elseif type(val) == "table" and #val > 0 then
            data[key] = val
        -- Handle other table types or non-tables
        else
            data[key] = val
        end
    end
    writefile(ConfigFolder .. "/" .. name .. ".json", game:GetService("HttpService"):JSONEncode(data))
end

local function LoadConfig(name)
    if not isfile(ConfigFolder .. "/" .. name .. ".json") then return end
    local content = readfile(ConfigFolder .. "/" .. name .. ".json")
    local data = game:GetService("HttpService"):JSONDecode(content)
    
    local loadedCount = 0
    local failedCount = 0
    
    for key, val in pairs(data) do
        if ConfigObjects[key] then
            local success = pcall(function()
                local obj = ConfigObjects[key]
                if obj.Select then 
                    obj:Select(val)
                elseif obj.Set then
                    obj:Set(val)
                elseif obj.SetValue then 
                    obj:SetValue(val)
                else 
                    obj.Value = val 
                end
            end)
            if success then
                loadedCount = loadedCount + 1
            else
                failedCount = failedCount + 1
            end
        end
    end
    
    -- Debug notification
    WindUI:Notify({
        Title = "Config Loaded",
        Content = string.format("%d/%d items loaded (%d failed)", loadedCount, loadedCount + failedCount, failedCount),
        Duration = 3
    })
end

local function SetAutoLoad(name)
    writefile(ConfigFolder .. "/autoload.txt", name)
end

local function GetAutoLoad()
    if isfile(ConfigFolder .. "/autoload.txt") then
        return readfile(ConfigFolder .. "/autoload.txt")
    end
    return nil
end

local function LoadAutoConfig()
    local name = GetAutoLoad()
    WindUI:Notify({Title = "Auto-Load Check", Content = name or "No auto-load set", Duration = 2})
    if name and isfile(ConfigFolder .. "/" .. name .. ".json") then
        WindUI:Notify({Title = "Auto-Loading", Content = "Loading: " .. name, Duration = 2})
        LoadConfig(name)
        return name
    else
        if name then
            WindUI:Notify({Title = "Auto-Load Error", Content = "File not found: " .. name, Duration = 3})
        end
    end
    return nil
end

local function DeleteConfig(name)
    if isfile(ConfigFolder .. "/" .. name .. ".json") then
        delfile(ConfigFolder .. "/" .. name .. ".json")
    end
end

local function GetConfigs()
    local files = listfiles(ConfigFolder)
    local names = {}
    for _, file in ipairs(files) do
        table.insert(names, file:match("([^/\\]+)%.json$") or file)
    end
    return names
end

local function AddConfig(key, object)
    ConfigObjects[key] = object
end

WindUI:Notify({
    Title = "FyyLoader",
    Content = "Press G To Open/Close Menu!",
    Duration = 4, 
    Icon = "slack",
})

Window:SetIconSize(35) 
Window:Tag({
    Title = "1.0.6",
    Color = Color3.fromHex("#30ff6a"),
    Radius = 13, 
})


local UIS=game:GetService("UserInputService")
local PG=game.Players.LocalPlayer:WaitForChild("PlayerGui")
local uisConn=nil 
local dragging=false 
local dragInput,dragStart,startPos

local function C()
    local o=PG:FindFirstChild("CustomFloatingIcon_FyyHub")
    if o then o:Destroy()end 
    local g=Instance.new("ScreenGui")
    g.Name="CustomFloatingIcon_FyyHub"
    g.DisplayOrder=999 
    g.ResetOnSpawn=false 
    local f=Instance.new("Frame")
    f.Size=UDim2.fromOffset(45,45)
    f.Position=UDim2.new(0,50,0.4,0)
    f.AnchorPoint=Vector2.new(.5,.5)
    f.BackgroundColor3=Color3.fromRGB(20,20,20)
    f.BorderSizePixel=0 
    f.Parent=g 
    local s=Instance.new("UIStroke")
    s.Color=Color3.fromRGB(138,43,226)
    s.Thickness=2 
    s.Parent=f 
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,12)
    local i=Instance.new("ImageLabel")
    i.Image="rbxassetid://106899268176689"
    i.BackgroundTransparency=1 
    i.Size=UDim2.new(1,-4,1,-4)
    i.Position=UDim2.fromScale(.5,.5)
    i.AnchorPoint=Vector2.new(.5,.5)
    i.Parent=f 
    Instance.new("UICorner",i).CornerRadius=UDim.new(0,10)
    g.Parent=PG 
    return g,f 
end

local function S(g,f)
    if uisConn then 
        uisConn:Disconnect()
        uisConn=nil 
    end 
    local function u(i)
        local d=i.Position-dragStart 
        f.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
    end
    
    f.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then 
            dragging=true 
            dragStart=i.Position 
            startPos=f.Position 
            local m=false 
            local c1,c2 
            c1=i.Changed:Connect(function()
                if i.UserInputState==Enum.UserInputState.End then 
                    dragging=false 
                    c1:Disconnect()
                    if not m and Window and Window.Toggle then 
                        Window:Toggle()
                    end 
                end 
            end)
            c2=i.Changed:Connect(function()
                if dragging and(i.Position-dragStart).Magnitude>5 then 
                    m=true 
                    c2:Disconnect()
                end 
            end)
        end 
    end)
    
    f.InputChanged:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then 
            dragInput=i 
        end 
    end)
    
    uisConn=UIS.InputChanged:Connect(function(i)
        if i==dragInput and dragging then 
            u(i)
        end 
    end)
    
    if Window then 
        Window:OnOpen(function()
            g.Enabled=false 
        end)
        Window:OnClose(function()
            g.Enabled=true 
        end)
    end 
end

local function I()
    if not game.Players.LocalPlayer.Character then 
        game.Players.LocalPlayer.CharacterAdded:Wait()
    end 
    local g,f=C()
    if g and f then 
        S(g,f)
    end 
end

game.Players.LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    I()
end)
I()


local Info = Window:Tab({Title = "Info", Icon = "info"})
local PlayerTab = Window:Tab({Title = "Player", Icon = "user"})
local Main = Window:Tab({Title = "Main", Icon = "play"})
local Shop = Window:Tab({Title = "Shop", Icon = "shopping-cart"})
local Teleport = Window:Tab({Title = "Teleport", Icon = "map-pin"})
local Auto = Window:Tab({Title = "Automatic", Icon = "fast-forward"})
local Quest = Window:Tab({Title = "Quest", Icon = "loader"})
local Event = Window:Tab({Title = "Event", Icon = "gift"})
local Animation = Window:Tab({Title = "Animation", Icon = "gem"})
local Discord = Window:Tab({Title = "Webhook", Icon = "megaphone"})
local SettingTab = Window:Tab({Title = "Settings", Icon = "settings"})
local MiscTab = Window:Tab({Title = "Misc", Icon = "globe"})
local ConfigTab = Window:Tab({Title = "Config", Icon = "folder"})

local function InfoTabFunction()
    local InfoSection = Info:Section({Title = "Have Problem / Need Help? Join Server Now", Box = true, TextTransparency = 0.05, TextXAlignment = "Center", TextSize = 17, Opened = true})
    Info:Select()
    local InviteCode = "77nEeYeFRp"
    local DiscordAPI = "https://discord.com/api/v10/invites/"..InviteCode.."?with_counts=true&with_expiration=true"
    
    local Response, ErrorMessage = nil, nil
    
    xpcall(function()
        Response = game:GetService("HttpService"):JSONDecode(WindUI.Creator.Request({Url = DiscordAPI, Method = "GET", Headers = {["Accept"] = "application/json"}}).Body)
    end, function(e)
        ErrorMessage = tostring(e)
        Response = nil
    end)

    if Response and Response.guild then
        local paragraphConfig = {
            Title = Response.guild.name,
            Desc = ' <font color="#52525b">•</font> Member Count: '..tostring(Response.approximate_member_count)..'\n <font color="#16a34a">•</font> Online Count: '..tostring(Response.approximate_presence_count),
            Image = "https://cdn.discordapp.com/icons/"..Response.guild.id.."/"..Response.guild.icon..".png?size=256",
            ImageSize = 42,
            Buttons = {{
                Icon = "link",
                Title = "Copy Discord Invite",
                Callback = function() pcall(function() setclipboard("https://discord.gg/"..InviteCode) end) end
            },{
                Icon = "refresh-cw",
                Title = "Update Info",
                Callback = function()
                    xpcall(function()
                        local Updated = game:GetService("HttpService"):JSONDecode(WindUI.Creator.Request({Url = DiscordAPI, Method = "GET"}).Body)
                        if Updated and Updated.guild then
                            DiscordInfo:SetDesc(' <font color="#52525b">•</font> Member Count: '..tostring(Updated.approximate_member_count)..'\n <font color="#16a34a">•</font> Online Count: '..tostring(Updated.approximate_presence_count))
                        end
                    end, function(e) end)
                end
            }}
        }
        
        if Response.guild.banner then
            paragraphConfig.Thumbnail = "https://cdn.discordapp.com/banners/"..Response.guild.id.."/"..Response.guild.banner..".png?size=256"
            paragraphConfig.ThumbnailSize = 80
        end
        
        local DiscordInfo = Info:Paragraph(paragraphConfig)
    else
        Info:Paragraph({Title = "Error when receiving information about the Discord server", Desc = ErrorMessage or "Unknown error occurred", Image = "triangle-alert", ImageSize = 26, Color = "Red"})
    end
end

local function PlayerTabFunction()
    if not PlayerTab then return end
    
    local PlayerSection = PlayerTab:Section({Title = "Player Feature", Box = true, Opened = true})
    local wsValue = 16
    
    local wsToggle = PlayerSection:Toggle({
        Title = "WalkSpeed",
        Desc = "Enable custom walkspeed",
        Icon = "footprints",
        Value = false,
        Callback = function(state)
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = state and wsValue or 16
            end
        end
    })
    AddConfig("WalkSpeedToggle", wsToggle)

    local wsInput = PlayerSection:Input({
        Title = "Set WalkSpeed",
        Desc = "Enter speed amount",
        Value = "16",
        Placeholder = "e.g. 50",
        Callback = function(val)
            wsValue = tonumber(val) or 16
            if wsToggle.Value then
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid.WalkSpeed = wsValue
                end
            end
        end
    })
    AddConfig("WalkSpeedInput", wsInput)

    local IJC
    local infJumpToggle = PlayerSection:Toggle({
        Title = "Infinite Jump",
        Desc = "Jump in mid-air",
        Icon = "arrow-up",
        Value = false,
        Callback = function(state)
            local UIS = game:GetService("UserInputService")
            if state then
                if not IJC then
                    IJC = UIS.JumpRequest:Connect(function()
                        local char = LocalPlayer.Character
                        if char and char:FindFirstChild("Humanoid") then
                            char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                        end
                    end)
                end
            else
                if IJC then IJC:Disconnect() IJC = nil end
            end
        end
    })
    AddConfig("InfiniteJumpToggle", infJumpToggle)

    local NCC
    local noclipToggle = PlayerSection:Toggle({
        Title = "NoClip",
        Desc = "Walk through walls",
        Icon = "ghost",
        Value = false,
        Callback = function(state)
            if state then
                if not NCC then
                    NCC = game:GetService("RunService").Stepped:Connect(function()
                        local char = LocalPlayer.Character
                        if char then
                            for _, part in ipairs(char:GetChildren()) do
                                if part:IsA("BasePart") then part.CanCollide = false end
                            end
                        end
                    end)
                end
            else
                if NCC then NCC:Disconnect() NCC = nil end
                local char = LocalPlayer.Character
                if char then
                    for _, part in ipairs(char:GetChildren()) do
                        if part:IsA("BasePart") then part.CanCollide = true end
                    end
                end
            end
        end
    })
    AddConfig("NoClipToggle", noclipToggle)

    local wow, waterPart = false, nil
    local waterWalkToggle = PlayerSection:Toggle({
        Title = "Walk On Water",
        Desc = "Create platform on water level",
        Icon = "waves",
        Value = false,
        Callback = function(state)
            wow = state
            local char = LocalPlayer.Character
            if state and char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if waterPart then waterPart:Destroy() end
                    waterPart = Instance.new("Part")
                    waterPart.Anchored = true
                    waterPart.CanCollide = true
                    waterPart.Size = Vector3.new(20, 1, 20)
                    waterPart.Transparency = 1
                    waterPart.Position = Vector3.new(hrp.Position.X, 0, hrp.Position.Z)
                    waterPart.Parent = workspace
                end
            elseif waterPart then
                waterPart:Destroy()
                waterPart = nil
            end
        end
    })
    AddConfig("WalkOnWaterToggle", waterWalkToggle)

    game:GetService("RunService").Heartbeat:Connect(function()
        if wow and waterPart then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local pos = char.HumanoidRootPart.Position
                waterPart.Position = Vector3.new(pos.X, 0, pos.Z)
            end
        end
    end)

    local ox = false
    local RS = game:GetService("ReplicatedStorage")
    local net = RS.Packages._Index["sleitnick_net@0.2.0"].net
    local RF_E = net["RF/EquipOxygenTank"]
    local RF_U = net["RF/UnequipOxygenTank"]

    local oxygenToggle = PlayerSection:Toggle({
        Title = "Equip Oxygen Tank",
        Desc = "Auto equip oxygen tank",
        Icon = "cylinder",
        Value = false,
        Callback = function(state)
            ox = state
            if ox then RF_E:InvokeServer(105) else RF_U:InvokeServer() end
        end
    })
    AddConfig("EquipOxygenTankToggle", oxygenToggle)

    local RF_R = net["RF/UpdateFishingRadar"]
    local radarToggle = PlayerSection:Toggle({
        Title = "Bypass Fishing Radar",
        Desc = "Show fish on radar",
        Icon = "radar",
        Value = false,
        Callback = function(state)
            RF_R:InvokeServer(state and true or false)
        end
    })
    AddConfig("BypassFishingRadarToggle", radarToggle)

    local savedCF = nil
    LocalPlayer.CharacterAdded:Connect(function(char)
        if not savedCF then return end
        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        if hrp then
            task.wait(0.3)
            hrp.CFrame = savedCF
        end
    end)

    PlayerSection:Button({
        Title = "Respawn at Current Position",
        Desc = "Reset character but keep position",
        Icon = "refresh-ccw",
        Callback = function()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChild("Humanoid")
            if hrp and hum then
                savedCF = hrp.CFrame
                hum.Health = 0
            end
        end
    })

    local GuiSection = PlayerTab:Section({Title = "Gui External", Box = true, Opened = true})

    GuiSection:Button({
        Title = "Fly GUI",
        Desc = "Load Fly GUI V3",
        Icon = "plane",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
            WindUI:Notify({Title = "Fly", Content = "Fly GUI berhasil dijalankan", Duration = 3})
        end
    })

local SG, SL = nil, nil
local notificationConnection = nil

local function countNotifications()
    local notificationCount = 0
    pcall(function()
        local PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui
        local notificationsFrame = PlayerGui:FindFirstChild("Text Notifications")
        
        if notificationsFrame then
            notificationsFrame = notificationsFrame:FindFirstChild("Frame")
            if notificationsFrame then
                for _, child in ipairs(notificationsFrame:GetChildren()) do
                    if child:IsA("GuiObject") and child.Visible then
                        notificationCount = notificationCount + 1
                    end
                end
            end
        end
    end)
    return notificationCount
end

local function setupNotificationMonitoring()
    if notificationConnection then
        notificationConnection:Disconnect()
        notificationConnection = nil
    end
    
    pcall(function()
        local PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui
        local notificationsFrame = PlayerGui:WaitForChild("Text Notifications", 1):WaitForChild("Frame", 1)
        
        if notificationsFrame then
            notificationConnection = notificationsFrame.ChildAdded:Connect(function() end)
        end
    end)
end

local function createStatsOverlay()
    local gui = Instance.new("ScreenGui", game.CoreGui)
    gui.Name = "RockHub_Stats"
    gui.IgnoreGuiInset = true
    
    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.fromOffset(360, 40)
    frame.AnchorPoint = Vector2.new(0.5, 0)
    frame.Position = UDim2.new(0.5, 0, 0.06, 0)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Selectable = true
    
    Instance.new("UICorner", frame).CornerRadius = UDim.new(1, 0)
    
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromHex("8B5CF6")
    stroke.Thickness = 2
    stroke.Transparency = 0.1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    local dragBar = Instance.new("Frame")
    dragBar.Name = "DragBar"
    dragBar.Size = UDim2.new(0.6, 0, 0, 6)
    dragBar.Position = UDim2.new(0.2, 0, 1, 8)
    dragBar.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    dragBar.BorderSizePixel = 0
    dragBar.Active = true
    dragBar.Selectable = true
    dragBar.Parent = frame
    
    Instance.new("UICorner", dragBar).CornerRadius = UDim.new(1, 0)
    
    local dragStroke = Instance.new("UIStroke", dragBar)
    dragStroke.Color = Color3.fromHex("8B5CF6")
    dragStroke.Thickness = 1
    
    dragBar.MouseEnter:Connect(function()
        dragBar.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    end)
    
    dragBar.MouseLeave:Connect(function()
        dragBar.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    end)
    
    local container = Instance.new("Frame")
    container.Name = "StatsContainer"
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Parent = frame
    
    local layout = Instance.new("UIListLayout", container)
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.Padding = UDim.new(0, 12)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    
    local function CreateLabel()
        local label = Instance.new("TextLabel", container)
        label.AutomaticSize = Enum.AutomaticSize.X
        label.Size = UDim2.new(0, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamBold
        label.TextSize = 13
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Text = "..."
        return label
    end
    
    local fpsLabel = CreateLabel()
    local cpuLabel = CreateLabel()
    local pingLabel = CreateLabel()
    local notifLabel = CreateLabel()
    
    local UIS = game:GetService("UserInputService")
    local CAS = game:GetService("ContextActionService")
    local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
    local dragAction = "StatsDragBlocker"
    
    local function updatePosition(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    local function startDragging(input)
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        CAS:BindActionAtPriority(dragAction, function()
            return Enum.ContextActionResult.Sink
        end, false, Enum.ContextActionPriority.High.Value + 50, Enum.UserInputType.Touch, Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseMovement)
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                CAS:UnbindAction(dragAction)
            end
        end)
    end
    
    local function connectDragging(object)
        object.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                startDragging(input)
            end
        end)
        
        object.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
    end
    
    connectDragging(frame)
    connectDragging(dragBar)
    
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updatePosition(input)
        end
    end)
    
    local RunService = game:GetService("RunService")
    local Stats = game:GetService("Stats")
    
    SL = RunService.RenderStepped:Connect(function(deltaTime)
        if not gui then return end
        
        local fps = math.floor(workspace:GetRealPhysicsFPS())
        local cpu = math.floor(deltaTime * 1000)
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        local notifications = countNotifications()
        
        fpsLabel.Text = "FPS: " .. fps
        fpsLabel.TextColor3 = fps >= 50 and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(255, 65, 65)
        
        cpuLabel.Text = "CPU: " .. cpu .. "ms"
        cpuLabel.TextColor3 = cpu <= 20 and Color3.fromRGB(0, 255, 127) or (cpu <= 50 and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(255, 65, 65))
        
        pingLabel.Text = "Ping: " .. ping .. "ms"
        pingLabel.TextColor3 = ping < 100 and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(255, 65, 65)
        
        notifLabel.Text = "Notif: " .. notifications
        notifLabel.TextColor3 = notifications == 0 and Color3.fromRGB(150, 150, 150) or Color3.fromRGB(0, 200, 255)
    end)
    
    setupNotificationMonitoring()
    
    return gui
end

GuiSection:Toggle({
    Title = "Show Stats Overlay",
    Desc = "Show FPS, CPU, Ping (Draggable)",
    Icon = "activity",
    Value = false,
    Callback = function(state)
        if state then
            if SG then SG:Destroy() end
            SG = createStatsOverlay()
        else
            if SL then
                SL:Disconnect()
                SL = nil
            end
            
            if notificationConnection then
                notificationConnection:Disconnect()
                notificationConnection = nil
            end
            
            if SG then
                SG:Destroy()
                SG = nil
            end
        end
    end
})
end

--// Main Tab

local function MainTab()
    if not Main then return end

    -- Instant Fishing
    local BlatantV2Section = Main:Section({Title = "Blatant V2", Box = true, TextXAlignment = "Center",TextSize = 16})
    local RS = game:GetService("ReplicatedStorage")
    local P = game:GetService("Players").LocalPlayer
    local net = RS.Packages._Index["sleitnick_net@0.2.0"].net
    local REE = net["RE/EquipToolFromHotbar"]
    local RFC = net["RF/ChargeFishingRod"]
    local RFU2 =net["RF/UpdateAutoFishingState"]
    local RFS = net["RF/RequestFishingMinigameStarted"]
    local REF = net["RF/CatchFishCompleted"]
    local RFK = net["RF/CancelFishingInputs"]
    
    local run = false
    local eq = false
    local lastCatch = tick()
    local v2ExclaimDetected = false
    local v2Casting = false
    local v2Connection = nil
    -- User directed path for event listener (Specific RemoteEvent)
    local ReplicateTextEffect = RS:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RE/ReplicateTextEffect") 
    
    local BlatantConfig = {
        Spam_Count = 20,
        Spam_Delay = 0.001,
        Total_Stages = 1,
        Delay_Complete = 0.26,
        Delay_Cancel = 0.12
    }
    
    local Settings = {
        Active = false
    }
    
    local Events = {
        Charge = RFC,
        Minigame = RFS,
        Fishing = REF,
        Cancel = RFK
    }

    local function safeFire(func)
        task.spawn(function() pcall(func) end)
    end

    local function setupV2ExclaimDetection()
        if v2Connection then v2Connection:Disconnect() v2Connection = nil end
        if not ReplicateTextEffect then 
            warn("Blatant V2: ReplicateTextEffect (Net Event) not found!")
            return 
        end
        
        v2Connection = ReplicateTextEffect.OnClientEvent:Connect(function(data)
            local char = P.Character
            if not char or not data.TextData or not data.TextData.AttachTo then return end

            if data.TextData.AttachTo:IsDescendantOf(char)
                and data.TextData.Text == "!" 
                and Settings.Active
                and v2Casting then
                
         
                task.wait(BlatantConfig.Delay_Complete) -- Wait delay sebelum complete
                
                safeFire(function() 
                    REF:InvokeServer() 
                end)
                
                
                v2Casting = false 
            end
        end)
    end

    local function equip()
        while Settings.Active do
            if not eq then
                safeFire(function() REE:FireServer(1) end)
                eq = true
            end
            task.wait(2)
        end
        eq = false
    end

    local function cycle()
        while Settings.Active do
            v2Casting = true -- Set status casting
            
            -- Spam Charge & Minigame
            for stage = 1, BlatantConfig.Total_Stages do
                for i = 1, BlatantConfig.Spam_Count do
                    if not Settings.Active then break end
                    
                    local t1 = tick()
                    safeFire(function() 
                        Events.Charge:InvokeServer() 
                    end)
                    
                    local t2 = tick()
                    safeFire(function() 
                        Events.Minigame:InvokeServer(-139.630452165, 0.99647927980797, t2) 
                    end)
                    
                    task.wait(BlatantConfig.Spam_Delay)
                end
            end
            
                safeFire(function() 
                    RFK:InvokeServer() 
                end)
            task.wait(BlatantConfig.Delay_Cancel)
        end
    end



 local function Autofish()
   safeFire(function() 
           RFU2:InvokeServer(true) 
    end)
 end

 local function AutoFishStop()
    safeFire(function() 
           RFU2:InvokeServer(false) 
    end)
 end


    local function start()
        Settings.Active = true
        pcall(function() LocalPlayer:SetAttribute("InCutscene", true) end)
        setupV2ExclaimDetection() -- Init listener
        task.spawn(equip)
        task.spawn(Autofish)
        task.wait(0.5)
        task.spawn(cycle)
    end
    
    local function stop()
        Settings.Active = false
        pcall(function() LocalPlayer:SetAttribute("InCutscene", false) end)
        task.spawn(AutoFishStop)
        safeFire(function() RFK:InvokeServer() end)
        
        -- Cleanup listener
        if v2Connection then v2Connection:Disconnect() v2Connection = nil end
        
        eq = false
    end

    local BlatantV2 = BlatantV2Section:Toggle({
        Title = "Blatant V2",
        Desc = "Auto fishing with instant completion",
        Icon = "fish",
        Value = false,
        Callback = function(state)
            if state then
                start()
            else
                stop()
            end
        end
    })
    AddConfig("BlatantV2", BlatantV2)

    local completeBlatant = BlatantV2Section:Input({
        Title = "Talon",
        Value = "0.26",
        Placeholder = "0.26",
        Callback = function(v)
            local n = tonumber(v)
            if n then BlatantConfig.Delay_Complete = n end
        end
    })
    AddConfig("BlatantV2Complete", completeBlatant)
    
    local BlatantV2Cancel = BlatantV2Section:Input({
        Title = "Jokowi",
        Value = "0.12",
        Placeholder = "0.12",
        Callback = function(v)
            local n = tonumber(v)
            if n then BlatantConfig.Delay_Cancel = n end
        end
    })
    AddConfig("BlatantV2Cancel", BlatantV2Cancel)
    




    Main:Space()
    
    local Autosell = Main:Section({Title = "Auto Sell Feature", Box = true, TextXAlignment = "Center",TextSize = 16})
    local RS = game:GetService("ReplicatedStorage")
    local P = game:GetService("Players").LocalPlayer
    local net = RS.Packages._Index["sleitnick_net@0.2.0"].net
    local RF = net["RF/SellAllItems"]
    local RE = net["RE/ObtainedNewFishNotification"]
    
    local on = false
    local mode = "Delay"
    local val = 50
    local loop = nil
    local cnt = 0
    local conn = nil

    local function sell()
        if not RF then return false end
        return pcall(function() RF:InvokeServer() end)
    end

    local function listen()
        if not RE then return false end
        if conn then conn:Disconnect() conn = nil end
        conn = RE.OnClientEvent:Connect(function()
            cnt = cnt + 1
            if mode == "Count" and on and cnt >= val then
                if sell() then cnt = 0 end
            end
        end)
        return true
    end

    local function start()
        if loop then task.cancel(loop) end
        loop = task.spawn(function()
            while on do
                if mode == "Delay" then
                    sell()
                    for _ = 1, val do if not on then break end task.wait(1) end
                else task.wait(1) end
            end
        end)
    end

    local sellModeDropdown = Autosell:Dropdown({
        Title = "Sell Mode",
        Desc = "Select selling mode",
        Values = {"Delay", "Count"},
        Value = "Delay",
        Callback = function(v)
            mode = v
            cnt = 0
            if on then
                if v == "Count" then listen() else start() end
            end
        end
    })
    AddConfig("AutoSell_Mode", sellModeDropdown)

    local sellValueInput = Autosell:Input({
        Title = "Value",
        Desc = "Delay in seconds or fish count",
        Value = "50",
        Placeholder = "50",
        Callback = function(t)
            local n = tonumber(t)
            if n and n > 0 then val = n end
        end
    })
    AddConfig("AutoSell_Value", sellValueInput)

    local autoSellToggle = Autosell:Toggle({
        Title = "Enable Auto Sell",
        Desc = "Automatically sell items",
        Icon = "dollar-sign",
        Value = false,
        Callback = function(s)
            on = s
            if s then
                if mode == "Count" then
                    listen()
                else
                    start()
                end
            else
                if conn then conn:Disconnect() conn = nil end
                cnt = 0
                if loop then task.cancel(loop) loop = nil end
            end
        end
    })
    AddConfig("AutoSell_Toggle", autoSellToggle)

    Autosell:Button({
        Title = "Sell Now",
        Desc = "Sell all items immediately",
        Icon = "dollar-sign",
        Callback = function() sell() end
    })
	end


    

local function SettingTab2()
    if not SettingTab then return end
    
    local section = SettingTab:Section({Title = "Hide Identifier", Box = true, TextXAlignment = "Center", TextSize = 16})
    
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local StarterGui = game:GetService("StarterGui")
    local plrMask_Active = false
    local plrMask_Loop = nil
    local plrMask_Name = "Fyy Community"
    local plrMask_Level = "Lvl. 999"
    local plrMask_NameCache = {}
    local plrMask_TextCache = {}
    
    local fakeDisplayNameInput = section:Input({
        Title = "Fake Display Name",
        Description = "",
        Default = plrMask_Name,
        Placeholder = "Hidden User",
        Callback = function(v)
            if v and v ~= "" then 
                plrMask_Name = v 
            end
        end
    })
    
    local fakeDisplayLevelInput = section:Input({
        Title = "Fake Display Level",
        Description = "",
        Default = plrMask_Level,
        Placeholder = "Lvl. 999",
        Callback = function(v)
            if v and v ~= "" then 
                plrMask_Level = v 
            end
        end
    })
    
    local hideUsernameToggle = section:Toggle({
        Title = "Hide Username / Level",
        Description = "Hide your username and level from other players",
        Type = "Checkbox",
        Value = false,
        Callback = function(state)
            plrMask_Active = state
            pcall(function()
                StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, not state)
            end)
            
            if state then
                if plrMask_Loop then plrMask_Loop:Disconnect() end
                plrMask_Loop = RunService.RenderStepped:Connect(function()
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p.Character then
                            local h = p.Character:FindFirstChild("Humanoid")
                            if h then
                                if not plrMask_NameCache[p] then
                                    plrMask_NameCache[p] = h.DisplayName
                                end
                                h.DisplayName = plrMask_Name
                            end
                            
                            for _, g in ipairs(p.Character:GetDescendants()) do
                                if g:IsA("BillboardGui") then
                                    for _, t in ipairs(g:GetDescendants()) do
                                        if (t:IsA("TextLabel") or t:IsA("TextButton")) and t.Visible then
                                            plrMask_TextCache[t] = plrMask_TextCache[t] or t.Text
                                            local low = t.Text:lower()
                                            if t.Text:find(p.Name) or t.Text:find(p.DisplayName) then
                                                t.Text = plrMask_Name
                                            elseif low:match("^lvl") or low:match("^level") then
                                                t.Text = plrMask_Level
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
            else
                if plrMask_Loop then
                    plrMask_Loop:Disconnect()
                    plrMask_Loop = nil
                end
                
                for p, n in pairs(plrMask_NameCache) do
                    if p.Character then
                        local h = p.Character:FindFirstChild("Humanoid")
                        if h then h.DisplayName = n end
                    end
                end
                plrMask_NameCache = {}
                
                for t, txt in pairs(plrMask_TextCache) do
                    if t and t.Parent then t.Text = txt end
                end
                plrMask_TextCache = {}
            end
        end
    })AddConfig("HideIdentifier", hideIdentifier)
    
    local optSection = SettingTab:Section({Title = "Game Optimization", Box = true, TextXAlignment = "Center", TextSize = 16})  
    
    local localPlayer = game.Players.LocalPlayer
    local playerName = localPlayer.Name
    local originalAnimator = nil
    local animatorRemoved = false
    
    local removeAnimToggle = optSection:Toggle({
        Title = "Remove Animasi Catch Fishing",
        Description = "Remove fishing catch animation",
        Type = "Checkbox",
        Value = false,
        Callback = function(state)
            local character = workspace.Characters:FindFirstChild(playerName)
            if state then
                if character then
                    local humanoid = character:FindFirstChild("Humanoid")
                    if humanoid then
                        local animator = humanoid:FindFirstChildOfClass("Animator")
                        if animator then
                            originalAnimator = animator:Clone()
                            animator:Destroy()
                            animatorRemoved = true
                        end
                    end
                end
            else
                if character and animatorRemoved then
                    local humanoid = character:FindFirstChild("Humanoid")
                    if humanoid and originalAnimator then
                        local currentAnimator = humanoid:FindFirstChildOfClass("Animator")
                        if not currentAnimator then
                            local newAnimator = originalAnimator:Clone()
                            newAnimator.Parent = humanoid
                        end
                        animatorRemoved = false
                    end
                end
            end
        end
    })AddConfig("RemoveAnimasiCatchFishing", removeAnimToggle)
    
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local originalSmallNotification = nil
    
    local removeNotifToggle = optSection:Toggle({
        Title = "Remove Notification",
        Description = "Remove game notifications",
        Type = "Checkbox",
        Value = false,
        Callback = function(state)
            local playerGui = player:WaitForChild("PlayerGui")
            local smallNotification = playerGui:FindFirstChild("Small Notification")
            if state then
                if smallNotification then
                    originalSmallNotification = smallNotification:Clone()
                    smallNotification:Destroy()
                end
            else
                if originalSmallNotification then
                    smallNotification = originalSmallNotification:Clone()
                    smallNotification.Parent = playerGui
                    originalSmallNotification = nil
                end
            end
        end
    })AddConfig("RemoveNotification", removeNotifToggle)

    local VFXControllerModule = require(game:GetService("ReplicatedStorage"):WaitForChild("Controllers").VFXController)
    local originalVFXHandle = VFXControllerModule.Handle
    local isVFXDisabled = false
    
    local removeSkinEffectToggle = optSection:Toggle({
        Title = "Remove Skin Effect",
        Description = "Remove skin visual effects",
        Type = "Checkbox",
        Value = false,
        Callback = function(state)
            isVFXDisabled = state
            if state then
                VFXControllerModule.Handle = function(...) end
                VFXControllerModule.RenderAtPoint = function(...) end
                VFXControllerModule.RenderInstance = function(...) end
                local cosmeticFolder = workspace:FindFirstChild("CosmeticFolder")
                if cosmeticFolder then 
                    pcall(function() cosmeticFolder:ClearAllChildren() end) 
                end
                WindUI:Notify({
                    Title = "No Skin Effect ON",
                    Content = "Skin effects have been disabled",
                    Duration = 3,
                    Icon = "eye-off"
                })
            else
                VFXControllerModule.Handle = originalVFXHandle
                WindUI:Notify({
                    Title = "No Skin Effect OFF",
                    Content = "Skin effects restored",
                    Duration = 3,
                    Icon = "eye"
                })
            end
        end
    })AddConfig("RemoveSkinEffect", removeSkinEffectToggle)
    
    local CutsceneController = nil
    local OldPlayCutscene = nil
    local isNoCutsceneActive = false
    
    pcall(function()
        CutsceneController = require(game:GetService("ReplicatedStorage"):WaitForChild("Controllers"):WaitForChild("CutsceneController"))
        if CutsceneController and CutsceneController.Play then
            OldPlayCutscene = CutsceneController.Play
            CutsceneController.Play = function(self, ...)
                if isNoCutsceneActive then return end
                return OldPlayCutscene(self, ...)
            end
        end
    end)
    
    local noCutsceneToggle = optSection:Toggle({
        Title = "No Cutscene",
        Description = "Skip cutscene animations",
        Type = "Checkbox",
        Value = false,
        Callback = function(state)
            isNoCutsceneActive = state
            if not CutsceneController then
                WindUI:Notify({
                    Title = "Gagal Hook",
                    Content = "Module CutsceneController tidak ditemukan.",
                    Duration = 3,
                    Icon = "alert-circle"
                })
                return
            end
            
            if state then
                WindUI:Notify({
                    Title = "No Cutscene ON",
                    Content = "Animasi tangkapan dimatikan.",
                    Duration = 3,
                    Icon = "film"
                })
            else
                WindUI:Notify({
                    Title = "No Cutscene OFF",
                    Content = "Animasi kembali normal.",
                    Duration = 3,
                    Icon = "film"
                })
            end
        end
    })AddConfig("NoCutscene", noCutsceneToggle)
    
    local disable3DRenderingToggle = optSection:Toggle({
        Title = "Disable 3D Rendering",
        Description = "Enable Saver Mode (Black screen)",
        Type = "Checkbox",
        Value = false,
        Callback = function(state)
            local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
            local Camera = workspace.CurrentCamera
            local LocalPlayer = game.Players.LocalPlayer
            
            if state then
                if not _G.BlackScreenGUI then
                    _G.BlackScreenGUI = Instance.new("ScreenGui")
                    _G.BlackScreenGUI.Name = "Fyy"
                    _G.BlackScreenGUI.IgnoreGuiInset = true
                    _G.BlackScreenGUI.DisplayOrder = -999
                    _G.BlackScreenGUI.Parent = PlayerGui
                    
                    local Frame = Instance.new("Frame")
                    Frame.Size = UDim2.new(1, 0, 1, 0)
                    Frame.BackgroundColor3 = Color3.new(0, 0, 0)
                    Frame.BorderSizePixel = 0
                    Frame.Parent = _G.BlackScreenGUI
                    
                    local Label = Instance.new("TextLabel")
                    Label.Size = UDim2.new(1, 0, 0.1, 0)
                    Label.Position = UDim2.new(0, 0, 0.1, 0)
                    Label.BackgroundTransparency = 1
                    Label.Text = "Saver Mode Active"
                    Label.TextColor3 = Color3.fromRGB(60, 60, 60)
                    Label.TextSize = 16
                    Label.Font = Enum.Font.GothamBold
                    Label.Parent = Frame
                end
                _G.BlackScreenGUI.Enabled = true
                _G.OldCamType = Camera.CameraType
                Camera.CameraType = Enum.CameraType.Scriptable
                Camera.CFrame = CFrame.new(0, 100000, 0)
                
                WindUI:Notify({
                    Title = "Saver Mode ON",
                    Content = "3D rendering disabled",
                    Duration = 3,
                    Icon = "monitor"
                })
            else
                if _G.OldCamType then
                    Camera.CameraType = _G.OldCamType
                else
                    Camera.CameraType = Enum.CameraType.Custom
                end
                
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    Camera.CameraSubject = LocalPlayer.Character.Humanoid
                end
                
                if _G.BlackScreenGUI then 
                    _G.BlackScreenGUI.Enabled = false 
                end
                
                WindUI:Notify({
                    Title = "Saver Mode OFF",
                    Content = "Visual kembali normal.",
                    Duration = 3,
                    Icon = "monitor"
                })
            end
        end
    })AddConfig("Disable3DRendering", disable3DRenderingToggle)

    local perfCache = {} -- Cache untuk restore
    local perfOptActive = false

    local perfOptToggle = optSection:Toggle({
        Title = "Performance Optimization (EXTREME)",
        Description = "Maximum performance mode",
        Type = "Checkbox",
        Value = false,
        Callback = function(state)
            local Lighting = game:GetService("Lighting")
            local Workspace = game:GetService("Workspace")
            local player = game.Players.LocalPlayer
            local Terrain = Workspace:FindFirstChildOfClass("Terrain")

            perfOptActive = state

            if state then
                -- Cache & Apply Material Simplification
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and not obj:IsDescendantOf(player.Character) then
                        if not perfCache[obj] then
                            perfCache[obj] = {mat = obj.Material, col = obj.Color}
                        end
                        obj.Material = Enum.Material.Plastic
                        obj.Color = Color3.fromRGB(220, 220, 220)
                    end
                end

                -- Disable VFX
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Trail") or 
                       obj:IsA("Sparkles") or obj:IsA("Smoke") or obj:IsA("Fire") then
                        if not perfCache[obj] then
                            perfCache[obj] = obj.Enabled
                        end
                        obj.Enabled = false
                    end
                end

                -- Disable Post-Processing
                for _, obj in ipairs(Lighting:GetChildren()) do
                    if obj:IsA("BloomEffect") or obj:IsA("BlurEffect") or obj:IsA("ColorCorrectionEffect") or 
                       obj:IsA("DepthOfFieldEffect") or obj:IsA("SunRaysEffect") or obj:IsA("Atmosphere") then
                        if not perfCache[obj] then
                            perfCache[obj] = obj.Enabled
                        end
                        obj.Enabled = false
                    end
                end

                -- Camera Effects
                local camera = Workspace.CurrentCamera
                for _, obj in ipairs(camera:GetChildren()) do
                    if obj:IsA("BlurEffect") then
                        if not perfCache[obj] then perfCache[obj] = obj.Enabled end
                        obj.Enabled = false
                    end
                end

                -- Sky Optimization
                local sky = Lighting:FindFirstChildOfClass("Sky")
                if sky then
                    if not perfCache[sky] then
                        perfCache[sky] = {bodies = sky.CelestialBodiesShown, stars = sky.StarCount}
                    end
                    sky.CelestialBodiesShown = false
                    sky.StarCount = 0
                end

                -- Lighting Settings
                if not perfCache.Lighting then
                    perfCache.Lighting = {
                        shadows = Lighting.GlobalShadows,
                        tech = Lighting.Technology,
                        fogEnd = Lighting.FogEnd,
                        fogStart = Lighting.FogStart,
                        diffuse = Lighting.EnvironmentDiffuseScale,
                        specular = Lighting.EnvironmentSpecularScale,
                        brightness = Lighting.Brightness,
                        ambient = Lighting.OutdoorAmbient,
                        amb2 = Lighting.Ambient
                    }
                end

                Lighting.GlobalShadows = false
                Lighting.Technology = Enum.Technology.Compatibility
                Lighting.FogEnd = 999999
                Lighting.FogStart = 0
                Lighting.EnvironmentDiffuseScale = 0
                Lighting.EnvironmentSpecularScale = 0
                Lighting.Brightness = 2
                Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
                Lighting.Ambient = Color3.fromRGB(128, 128, 128)

                -- Disable Lights
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
                        if not perfCache[obj] then perfCache[obj] = obj.Enabled end
                        obj.Enabled = false
                    end
                end

                -- Disable Sounds
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("Sound") then
                        if not perfCache[obj] then perfCache[obj] = obj.Playing end
                        obj.Playing = false
                    end
                end

                -- EXTREME: Terrain Optimization
                if Terrain then
                    if not perfCache.Terrain then
                        perfCache.Terrain = {
                            waveSize = pcall(function() return Terrain.WaterWaveSize end) and Terrain.WaterWaveSize or 0.05,
                            waveSpeed = pcall(function() return Terrain.WaterWaveSpeed end) and Terrain.WaterWaveSpeed or 10,
                            reflectance = pcall(function() return Terrain.WaterReflectance end) and Terrain.WaterReflectance or 1,
                            transparency = pcall(function() return Terrain.WaterTransparency end) and Terrain.WaterTransparency or 0.3,
                            decoration = pcall(function() return Terrain.Decoration end) and Terrain.Decoration or true
                        }
                    end
                    pcall(function() Terrain.WaterWaveSize = 0 end)
                    pcall(function() Terrain.WaterWaveSpeed = 0 end)
                    pcall(function() Terrain.WaterReflectance = 0 end)
                    pcall(function() Terrain.WaterTransparency = 0.8 end)
                    pcall(function() Terrain.Decoration = false end)
                end

                -- EXTREME: Mesh & Texture Optimization
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("MeshPart") then
                        if not perfCache[obj] then
                            perfCache[obj] = {fidelity = obj.RenderFidelity}
                        end
                        obj.RenderFidelity = Enum.RenderFidelity.Performance
                    end
                    if obj:IsA("Decal") or obj:IsA("Texture") then
                        if not perfCache[obj] then
                            perfCache[obj] = {transparency = obj.Transparency}
                        end
                        obj.Transparency = 1
                    end
                end

                -- EXTREME: Render Quality
                if not perfCache.RenderQuality then
                    perfCache.RenderQuality = settings().Rendering.QualityLevel
                end
                settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

                WindUI:Notify({
                    Title = "EXTREME Optimization ON",
                    Content = "⚡ Maximum performance mode activated!",
                    Duration = 3,
                    Icon = "zap"
                })
            else
                -- RESTORE ALL
                for obj, cache in pairs(perfCache) do
                    if obj and obj.Parent then
                        if type(cache) == "table" then
                            if cache.mat then
                                pcall(function() obj.Material = cache.mat end)
                                pcall(function() obj.Color = cache.col end)
                            elseif cache.fidelity then
                                pcall(function() obj.RenderFidelity = cache.fidelity end)
                            elseif cache.transparency ~= nil then
                                pcall(function() obj.Transparency = cache.transparency end)
                            elseif cache.bodies then
                                pcall(function() obj.CelestialBodiesShown = cache.bodies end)
                                pcall(function() obj.StarCount = cache.stars end)
                            end
                        else
                            pcall(function() obj.Enabled = cache end)
                            pcall(function() obj.Playing = cache end)
                        end
                    end
                end

                -- Restore Lighting
                if perfCache.Lighting then
                    local l = perfCache.Lighting
                    Lighting.GlobalShadows = l.shadows
                    Lighting.Technology = l.tech
                    Lighting.FogEnd = l.fogEnd
                    Lighting.FogStart = l.fogStart
                    Lighting.EnvironmentDiffuseScale = l.diffuse
                    Lighting.EnvironmentSpecularScale = l.specular
                    Lighting.Brightness = l.brightness
                    Lighting.OutdoorAmbient = l.ambient
                    Lighting.Ambient = l.amb2
                end

                -- Restore Terrain
                if perfCache.Terrain and Terrain then
                    local t = perfCache.Terrain
                    pcall(function() Terrain.WaterWaveSize = t.waveSize end)
                    pcall(function() Terrain.WaterWaveSpeed = t.waveSpeed end)
                    pcall(function() Terrain.WaterReflectance = t.reflectance end)
                    pcall(function() Terrain.WaterTransparency = t.transparency end)
                    pcall(function() Terrain.Decoration = t.decoration end)
                end

                -- Restore Render Quality
                if perfCache.RenderQuality then
                    settings().Rendering.QualityLevel = perfCache.RenderQuality
                end

                perfCache = {}
                WindUI:Notify({
                    Title = "Optimization OFF",
                    Content = "🎨 Graphics restored to normal",
                    Duration = 3,
                    Icon = "palette"
                })
            end
        end
    })AddConfig("PerformanceOptimization", perfOptToggle)

    -- ANTI STAFF
    local P = game:GetService("Players")
    local T = game:GetService("TeleportService")
    local LP = P.LocalPlayer
    local PID = game.PlaceId
    local AS_ON = true

    local BL = {
        [75974130]=1,[40397833]=1,[187190686]=1,[33372493]=1,[889918695]=1,
        [33679472]=1,[30944240]=1,[25050357]=1,[8462585751]=1,[8811129148]=1,
        [192821024]=1,[4509801805]=1,[124505170]=1,[108397209]=1
    }

    local antiStaffSection = SettingTab:Section({Title = "Anti Staff", Box = true, TextXAlignment = "Center", TextSize = 16})
    
    antiStaffSection:Toggle({
        Title = "Anti Staff",
        Description = "Auto Server Hop if Staff Detected",
        Type = "Checkbox",
        Value = true,
        Callback = function(s)
            AS_ON = s
        end
    })

    local function hop()
        task.wait(6)
        local d = game.HttpService:JSONDecode(
            game:HttpGet("https://games.roblox.com/v1/games/"..PID.."/servers/Public?sortOrder=Asc&limit=100")
        ).data
        for _, v in ipairs(d) do
            if v.playing < v.maxPlayers and v.id ~= game.JobId then
                T:TeleportToPlaceInstance(PID, v.id, LP)
                break
            end
        end
    end

    P.PlayerAdded:Connect(function(plr)
        if AS_ON and plr ~= LP and BL[plr.UserId] then
            WindUI:Notify({
                Title = "ANTI STAFF",
                Content = plr.Name.." detected! Hopping in 6s...",
                Duration = 5,
                Icon = "shield-alert"
            })
            hop()
        end
    end)

    task.spawn(function()
        while task.wait(2) do
            if AS_ON then
                for _, plr in ipairs(P:GetPlayers()) do
                    if plr ~= LP and BL[plr.UserId] then
                        WindUI:Notify({
                            Title = "ANTI STAFF",
                            Content = plr.Name.." detected! Hopping in 6s...",
                            Duration = 5,
                            Icon = "shield-alert"
                        })
                        hop()
                        break
                    end
                end
            end
        end
    end)

    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local StarterGui = game:GetService("StarterGui")
    local Workspace = game:GetService("Workspace")
    local LocalPlayer = Players.LocalPlayer
    local freeCamSpeed = 1.5
    local freeCamFov = 70
    local isFreeCamActive = false
    local camera = Workspace.CurrentCamera
    local camPos = camera.CFrame.Position
    local camRot = Vector2.new(0, 0)
    local lastMousePos = Vector2.new(0, 0)
    local renderConn = nil
    local touchConn = nil
    local touchDelta = Vector2.new(0, 0)
    local oldWalkSpeed = 16
    local oldJumpPower = 50
    
    local FreeCam = SettingTab:Section({Title = "Free Cam", Box = true, TextXAlignment = "Center", TextSize = 16})
    
    local freeCamToggle = FreeCam:Toggle({
        Title = "Enable Free Cam",
        Desc = "Enable free camera movement",
        Type = "Checkbox",
        Value = false,
        Callback = function(state)
            isFreeCamActive = state
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChild("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            
            if state then
                camera.CameraType = Enum.CameraType.Scriptable
                camPos = camera.CFrame.Position
                local rx, ry, _ = camera.CFrame:ToEulerAnglesYXZ()
                camRot = Vector2.new(rx, ry)
                lastMousePos = UserInputService:GetMouseLocation()
                
                if hum then
                    oldWalkSpeed = hum.WalkSpeed
                    oldJumpPower = hum.JumpPower
                    hum.WalkSpeed = 0
                    hum.JumpPower = 0
                    hum.PlatformStand = true
                end
                
                if hrp then hrp.Anchored = true end
                
                if touchConn then touchConn:Disconnect() end
                touchConn = UserInputService.TouchMoved:Connect(function(input, processed)
                    if not processed then touchDelta = input.Delta end
                end)
                
                local ControlModule = require(LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
                
                if renderConn then renderConn:Disconnect() end
                renderConn = RunService.RenderStepped:Connect(function()
                    if not isFreeCamActive then return end
                    
                    local currentMousePos = UserInputService:GetMouseLocation()
                    if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                        local deltaX = currentMousePos.X - lastMousePos.X
                        local deltaY = currentMousePos.Y - lastMousePos.Y
                        local sens = 0.003
                        camRot = camRot - Vector2.new(deltaY * sens, deltaX * sens)
                        camRot = Vector2.new(math.clamp(camRot.X, -1.55, 1.55), camRot.Y)
                    end
                    
                    if UserInputService.TouchEnabled then
                        camRot = camRot - Vector2.new(touchDelta.Y * 0.005 * 2.0, touchDelta.X * 0.005 * 2.0)
                        camRot = Vector2.new(math.clamp(camRot.X, -1.55, 1.55), camRot.Y)
                        touchDelta = Vector2.new(0, 0)
                    end
                    
                    lastMousePos = currentMousePos
                    local rotCFrame = CFrame.fromEulerAnglesYXZ(camRot.X, camRot.Y, 0)
                    local moveVector = Vector3.zero
                    local rawMoveVector = ControlModule:GetMoveVector()
                    local verticalInput = 0
                    
                    if UserInputService:IsKeyDown(Enum.KeyCode.E) then verticalInput = 1 end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Q) then verticalInput = -1 end
                    
                    if rawMoveVector.Magnitude > 0 then
                        moveVector = (rotCFrame.RightVector * rawMoveVector.X) + (rotCFrame.LookVector * rawMoveVector.Z * -1)
                    end
                    moveVector = moveVector + Vector3.new(0, verticalInput, 0)
                    
                    local speedMultiplier = (UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and 4 or 1)
                    local finalSpeed = freeCamSpeed * speedMultiplier
                    
                    if moveVector.Magnitude > 0 then
                        camPos = camPos + (moveVector * finalSpeed)
                    end
                    
                    camera.CFrame = CFrame.new(camPos) * rotCFrame
                    camera.FieldOfView = freeCamFov
                end)
            else
                if renderConn then 
                    renderConn:Disconnect()
                    renderConn = nil 
                end
                if touchConn then 
                    touchConn:Disconnect()
                    touchConn = nil 
                end
                
                camera.CameraType = Enum.CameraType.Custom
                UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                camera.FieldOfView = 70
                
                if hum then
                    hum.WalkSpeed = oldWalkSpeed
                    hum.JumpPower = oldJumpPower
                    hum.PlatformStand = false
                end
                if hrp then hrp.Anchored = false end
            end
        end
    })
    
    local camSpeedSlider = FreeCam:Slider({
        Title = "Camera Speed",
        Desc = "Adjust free camera speed",
        Step = 0.1,
        Value = {
            Min = 0.1,
            Max = 10.0,
            Default = 1.5,
        },
        Callback = function(value)
            freeCamSpeed = tonumber(value)
        end
    })

    local fovSlider = FreeCam:Slider({
        Title = "Field of View (FOV)",
        Desc = "Zoom In/Out Lens",
        Step = 1,
        Value = {
            Min = 10,
            Max = 120,
            Default = 70,
        },
        Callback = function(value)
            freeCamFov = tonumber(value)
            if isFreeCamActive then 
                camera.FieldOfView = freeCamFov 
            end
        end
    })    
    local hideAllUIToggle = FreeCam:Toggle({
        Title = "Hide All UI",
        Desc = "Hide all UI elements",
        Type = "Checkbox",
        Value = false,
        Callback = function(state)
            local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
            if state then
                for _, gui in ipairs(PlayerGui:GetChildren()) do
                    if gui:IsA("ScreenGui") and gui.Name ~= "RenderStepHandler" and gui.Name ~= "CustomFloatingIcon_FyyHub" then
                        gui:SetAttribute("OriginalState", gui.Enabled)
                        gui.Enabled = false
                    end
                end
                pcall(function() StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false) end)
            else
                for _, gui in ipairs(PlayerGui:GetChildren()) do
                    if gui:IsA("ScreenGui") then
                        local originalState = gui:GetAttribute("OriginalState")
                        if originalState ~= nil then
                            gui.Enabled = originalState
                            gui:SetAttribute("OriginalState", nil)
                        end
                    end
                end
                pcall(function() StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true) end)
            end
        end
    })
end










    task.spawn(SettingTab2)
	task.spawn (MainTab)
    task.spawn (PlayerTabFunction)

                
