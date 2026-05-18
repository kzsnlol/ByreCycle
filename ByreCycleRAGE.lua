--// BYRECYCLE|RAGE - WITH DEATH NOTIFICATION
local P=game:GetService("Players").LocalPlayer
local U=game:GetService("UserInputService")
local Active=true
local Holding=false
local CurrentTarget=nil
local Busy=false
local LastHealth=100
local DiedNotified=false

local GUI=Instance.new("ScreenGui")
GUI.Name="BR"
GUI.ResetOnSpawn=false
GUI.Parent=P:WaitForChild("PlayerGui")

-- Main UI
local MainFrame=Instance.new("Frame")
MainFrame.Size=UDim2.new(0,130,0,26)
MainFrame.Position=UDim2.new(0.5,-65,1,-30)
MainFrame.BackgroundColor3=Color3.new(0,0,0)
MainFrame.BackgroundTransparency=0
MainFrame.BorderSizePixel=1
MainFrame.BorderColor3=Color3.new(0.5,0,1)
MainFrame.Parent=GUI

local Title=Instance.new("TextLabel")
Title.Size=UDim2.new(1,0,1,0)
Title.BackgroundTransparency=1
Title.Text="ByreCycle|Rage"
Title.TextColor3=Color3.new(1,1,1)
Title.TextSize=12
Title.Font=Enum.Font.Gotham
Title.TextStrokeTransparency=1
Title.Parent=MainFrame

-- Notification Frame (bigger text)
local NotifyFrame=Instance.new("Frame")
NotifyFrame.Size=UDim2.new(0,280,0,35)
NotifyFrame.Position=UDim2.new(0.5,-140,1,-65)
NotifyFrame.BackgroundColor3=Color3.new(0,0,0)
NotifyFrame.BackgroundTransparency=0
NotifyFrame.BorderSizePixel=1
NotifyFrame.BorderColor3=Color3.new(0.5,0,1)
NotifyFrame.Visible=false
NotifyFrame.Parent=GUI

local NotifyText=Instance.new("TextLabel")
NotifyText.Size=UDim2.new(1,0,1,0)
NotifyText.BackgroundTransparency=1
NotifyText.Text=""
NotifyText.TextColor3=Color3.new(1,1,1)
NotifyText.TextSize=16
NotifyText.Font=Enum.Font.Gotham
NotifyText.TextStrokeTransparency=1
NotifyText.Parent=NotifyFrame

-- Kill Button
local KillFrame=Instance.new("Frame")
KillFrame.Size=UDim2.new(0,80,0,26)
KillFrame.Position=UDim2.new(0.5,-40,0,5)
KillFrame.BackgroundColor3=Color3.new(0,0,0)
KillFrame.BackgroundTransparency=0
KillFrame.BorderSizePixel=1
KillFrame.BorderColor3=Color3.new(0.5,0,1)
KillFrame.Parent=GUI

local KillButton=Instance.new("TextButton")
KillButton.Size=UDim2.new(1,0,1,0)
KillButton.BackgroundTransparency=1
KillButton.Text="killtest"
KillButton.TextColor3=Color3.new(1,1,1)
KillButton.TextSize=12
KillButton.Font=Enum.Font.Gotham
KillButton.TextStrokeTransparency=1
KillButton.Parent=KillFrame

local function ShowNotification(msg, isDeath)
    NotifyText.Text=msg
    NotifyFrame.Visible=true
    
    if isDeath then
        NotifyFrame.BorderColor3=Color3.new(0.5,0,1)
        NotifyText.TextColor3=Color3.new(0.8,0.4,1)
    else
        NotifyFrame.BorderColor3=Color3.new(0.5,0,1)
        NotifyText.TextColor3=Color3.new(1,1,1)
    end
    
    task.spawn(function()
        local duration = isDeath and 3 or 1
        task.wait(duration)
        NotifyFrame.Visible=false
    end)
end

-- Check for player death
local function CheckDeath()
    local char=P.Character
    if not char then return end
    local hum=char:FindFirstChild("Humanoid")
    if not hum then return end
    local currentHealth=hum.Health
    
    if currentHealth<=0 and not DiedNotified and LastHealth>0 then
        ShowNotification("while cheating? u buns", true)
        DiedNotified=true
    elseif currentHealth>0 then
        DiedNotified=false
    end
    
    LastHealth=currentHealth
end

-- Death check loop
task.spawn(function()
    while Active do
        CheckDeath()
        task.wait(0.5)
    end
end)

local function GetHealth(target)
    if not target then return 0 end
    local char=target.Character
    if not char then return 0 end
    local hum=char:FindFirstChild("Humanoid")
    if not hum then return 0 end
    return hum.Health
end

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
    return hrp.Position
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
    
    local wasDead=false
    if IsDead(CurrentTarget) then
        wasDead=true
        CurrentTarget=GetNearest()
        if not CurrentTarget then return end
    end
    
    if not IsAlive(CurrentTarget) then
        CurrentTarget=GetNearest()
        if not CurrentTarget then return end
    end
    
    local healthBefore=GetHealth(CurrentTarget)
    local targetPos=GetTargetPos(CurrentTarget)
    if not targetPos then return end
    
    local original=hrp.CFrame
    
    hrp.CFrame=CFrame.new(targetPos)
    task.wait(0.025)
    SimulateClick()
    task.wait(0.005)
    hrp.CFrame=original
    
    local healthAfter=GetHealth(CurrentTarget)
    
    if healthAfter>0 and healthAfter<healthBefore then
        ShowNotification("hit tat nga", false)
    end
    
    if wasDead or healthAfter<=0 then
        ShowNotification("yeah he dead lol", false)
    end
end

local function Loop()
    while Holding and Active do
        if not Busy then
            Busy=true
            DoCycle()
            Busy=false
        end
        task.wait(0.1)
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
    if i.KeyCode==Enum.KeyCode.Q then
        Holding=false
    end
end)

KillButton.MouseButton1Click:Connect(function()
    Holding=false
    Active=false
    if KeyStart then KeyStart:Disconnect() end
    if KeyStop then KeyStop:Disconnect() end
    GUI:Destroy()
end)

print("ByreCycle|Rage - PURPLE DEATH NOTIFICATION")
print("Hold Q - Teleport, click, return")
print("Death message: 'while cheating? u buns' - 3 seconds, purple theme")
print("Bigger font (16) - NOT BOLD")
print("Click killtest to destroy everything")
