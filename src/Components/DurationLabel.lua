local PluginFolder = script.Parent.Parent

--@type Roact
local Roact = require(PluginFolder.Roact)
local t = require(PluginFolder.t)

local DurationLabel = Roact.PureComponent:extend("DurationLabel")
DurationLabel.defaultProps = {
    Color = Color3.new(1,1,1),
    AnchorPoint = Vector2.new(),
    Size = UDim2.new(1, 0, 0.5, 0),
    Position = UDim2.new(),
    Progress = 0,
    Duration = 0
}

DurationLabel.validateProps = t.interface({
    Color = t.optional(t.Color3),
    AnchorPoint = t.optional(t.Vector2),
    Size = t.optional(t.UDim2),
    Position = t.optional(t.UDim2),
    Progress = t.optional(t.number),
    Duration = t.optional(t.number)
})

local function SecondsToMMSS(num)
	local m = math.floor(num % 3600 / 60)
	local s = math.floor(num % 3600 % 60)
	
	if m < 10 then m = "0"..m end
	if s < 10 then s = "0"..s end
	
	return m..":"..s
end

function DurationLabel:render()
    return Roact.createElement("TextLabel", {
        BorderSizePixel = 0,
        TextScaled = true,
        TextColor3 = self.props.Color,
        BackgroundTransparency = 1,
        AnchorPoint = self.props.AnchorPoint,
        Size = self.props.Size,
        Position = self.props.Position,
        SizeConstraint = Enum.SizeConstraint.RelativeYY,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextXAlignment = Enum.TextXAlignment.Center,
        Text = SecondsToMMSS(self.props.Progress).." / "..SecondsToMMSS(self.props.Duration)
    })
end

return DurationLabel