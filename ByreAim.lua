game:GetService('UserInputService')

local _call7 = game:GetService('ReplicatedStorage')

game:GetService('RunService')

local _ = workspace.CurrentCamera
local _ = game:GetService('Players').LocalPlayer
local _req14 = require(_call7.Modules.Utility)

_req14.Raycast = function(...)
    local _16_vararg1, _16_vararg2, _16_vararg3, _16_vararg4, _16_vararg5, _16_vararg6 = ...

    checkcaller()

    return _req14.Raycast(_16_vararg1, _16_vararg2, _16_vararg3, _16_vararg4, _16_vararg5, _16_vararg6)
end

local _req21 = require(_call7.Modules.GameplayUtility)
local _ = _req21.Raycast

_req21.Raycast = function(...)
    local _24_vararg1, _24_vararg2, _24_vararg3, _24_vararg4, _24_vararg5 = ...

    checkcaller()

    return _req21.Raycast(_24_vararg1, _24_vararg2, _24_vararg3, _24_vararg4, _24_vararg5)
end

return {
    TargetPart = 'Head',
    MaxDistance = 5000,
    TeamCheck = true,
    HitChance = 100,
    Enabled = true,
    WallCheck = true,
}
