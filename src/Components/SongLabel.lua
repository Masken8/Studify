local PluginFolder = script.Parent.Parent

--@type Roact
local Roact = require(PluginFolder.Roact)
local t = require(PluginFolder.t)

local SongLabel = Roact.PureComponent:extend("SongLabel")
SongLabel.defaultProps = {
    Color = Color3.new(1,1,1),
    AnchorPoint = Vector2.new(),
    Size = UDim2.new(1, 0, 0.5, 0),
    Position = UDim2.new(),
    Text = "N/A"
}

SongLabel.validateProps = t.interface({
    Color = t.optional(t.Color3),
    AnchorPoint = t.optional(t.Vector2),
    Size = t.optional(t.UDim2),
    Position = t.optional(t.UDim2),
    Text = t.optional(t.string),
})

function SongLabel:render()
    return Roact.createElement("TextLabel", {
        BorderSizePixel = 0,
        TextScaled = true,
        TextColor3 = self.props.Color,
        BackgroundTransparency = 1,
        AnchorPoint = self.props.AnchorPoint,
        Size = self.props.Size,
        Position = self.props.Position,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextXAlignment = Enum.TextXAlignment.Center,
        Text = self.props.Text
    })
end

return SongLabel