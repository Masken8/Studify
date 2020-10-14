local PluginFolder = script.Parent.Parent

--@type Roact
local Roact = require(PluginFolder.Roact)
local t = require(PluginFolder.t)

local SkipButton = Roact.PureComponent:extend("SkipButton")
SkipButton.defaultProps = {
    Color = Color3.new(1,1,1),
    AnchorPoint = Vector2.new(),
    Size = UDim2.new(0, 50, 0, 50),
    Position = UDim2.new(),
    Text = ">"
}

SkipButton.validateProps = t.interface({
    Color = t.optional(t.Color3),
    AnchorPoint = t.optional(t.Vector2),
    Size = t.optional(t.UDim2),
    Position = t.optional(t.UDim2),
    Text = t.optional(t.string),
    Activated = t.optional(t.callback)
})

function SkipButton:render()
    return Roact.createElement("TextButton", {
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
        Text = self.props.Text,
        [Roact.Event.MouseButton1Click] = self.props.Activated
    })
end

return SkipButton