--// BYRECYCLE|RAGE - NO WAIT TELEPORT
local P=game:GetService("Players").LocalPlayer
local U=game:GetService("UserInputService")
local Active=true
local Holding=false
local CurrentTarget=nil
local Busy=false

local GUI=Instance.new("ScreenGui")
GUI.Name="BR"
GUI.ResetOnSpawn=false
GUI.Parent=P:WaitForChild("PlayerGui")

local MainFrame=Instance.new("Frame")
MainFrame.Size=UDim2.new(0,130,0,26)
MainFrame.Position=UDim2.new(0.5,-65,1,-30)
MainFrame.BackgroundColor3=Color3.new(0,0,0)
MainFrame.BorderSizePixel=2
MainFrame.BorderColor3=Color3.new(0.5,0,1)
MainFrame.Parent=GUI

local Title=Instance.new("TextLabel")
Title.Size=UDim2.new(1,0,1,0)
Title.BackgroundTransparency=1
Title.Text="ByreCycle|Rage"
Title.TextColor3=Color3.new(1,1,1)
Title.TextSize=11
Title.Font=Enum.Font.GothamBold
Title.Parent=MainFrame

local KillFrame=Instance.new("Frame")
KillFrame.Size=UDim2.new(0,80,0,26)
KillFrame.Position=UDim2.new(0.5,-40,0,5)
KillFrame.BackgroundColor3=Color3.new(0,0,0)
KillFrame.BorderSizePixel=2
KillFrame.BorderColor3=Color3.new(0.5,0,1)
KillFrame.Parent=GUI

local KillButton=Instance.new("TextButton")
KillButton.Size=UDim2.new(1,0,1,0)
KillButton.BackgroundTransparency=1
KillButton.Text="killtest"
KillButton.TextColor3=Color3.new(1,1,1)
KillButton.TextSize=11
KillButton.Font=Enum.Font.GothamBold
KillButton.Parent=KillFrame

local function IsAlive(target)
    if not target then return false end
    local char=target.Character
    if not char then return false end
    local hrp=char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local hum=char:FindFirstChild("Humanoid")
    if not hum then return false end
    return hum.Health>0
end

local function IsDead(target)
    if not target then return true end
    local char=target.Character
    if not char then return true end
    local hum=char:FindFirstChild("Humanoid")
    if not hum then return true end
    return hum.Health<=0
end

local function GetNearest()
    local char=P.Character
    if not char then return nil end
    local hrp=char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local pos=hrp.Position
    local closest,closestDist=nil,1e3
    for _,v in pairs(game:GetService("Players"):GetPlayers())do
        if v~=P and v.Character and IsAlive(v) then
            local t=v.Character:FindFirstChild("HumanoidRootPart")
            if t then
                local dist=(pos-t.Position).Magnitude
                if dist<closestDist then
                    closestDist=dist
                    closest=v
                end
            end
        end
    end
    return closest
end

local function GetTargetPos(target)
    if not target then return nil end
    local char=target.Character
    if not char then return nil end
    local hrp=char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    return hrp.Position + Vector3.new(0, 1, 0)
end

local function SimulateClick()
    local mouse=P:GetMouse()
    if mouse then pcall(function() mouse1click(mouse.X,mouse.Y) end) end
    pcall(function()
        local VI=game:GetService("VirtualInputManager")
        VI:SendMouseButtonEvent(0,0,0,true,game,0)
        VI:SendMouseButtonEvent(0,0,0,false,game,0)
    end)
end

local function DoCycle()
    local char=P.Character
    if not char then return end
    local hrp=char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if IsDead(CurrentTarget) then
        CurrentTarget=GetNearest()
        if not CurrentTarget then return end
    end
    
    if not IsAlive(CurrentTarget) then
        CurrentTarget=GetNearest()
        if not CurrentTarget then return end
    end
    
    local targetPos=GetTargetPos(CurrentTarget)
    if not targetPos then return end
    
    local original=hrp.CFrame
    hrp.CFrame=CFrame.new(targetPos)  -- INSTANT, no wait
    SimulateClick()
    task.wait(0.000001)  -- 1 microsecond click delay
    hrp.CFrame=original  -- INSTANT, no wait
end

local function Loop()
    while Holding and Active do
        if not Busy then
            Busy=true
            DoCycle()
            Busy=false
        end
        task.wait(0.00001)  -- 0.01ms interval
    end
end

local KeyStart,KeyStop
KeyStart=U.InputBegan:Connect(function(i,g)
    if g or not Active then return end
    if i.KeyCode==Enum.KeyCode.Q and not Holding then
        Holding=true
        CurrentTarget=GetNearest()
        task.spawn(Loop)
    end
end)

KeyStop=U.InputEnded:Connect(function(i,g)
    if g then return end
    if i.KeyCode==Enum.KeyCode.Q then Holding=false end
end)

KillButton.MouseButton1Click:Connect(function()
    Holding=false
    Active=false
    if KeyStart then KeyStart:Disconnect() end
    if KeyStop then KeyStop:Disconnect() end
    GUI:Destroy()
end)

print("ByreCycle|Rage - NO WAIT TELEPORT")
print("Hold Q - INSTANT teleport to 1 stud above enemy")
print("1μs click delay only")
print("INSTANT teleport back (no delay)")
print("0.01ms interval between cycles")
print("Auto-switches target when current dies")
print("Click killtest to destroy everything")
