local PluginFolder = script.Parent.Parent

--@type Roact
local Roact = require(PluginFolder.Roact)
local t = require(PluginFolder.t)

local PauseButton = Roact.Component:extend("PauseButton")
PauseButton.defaultProps = {
    AnchorPoint = Vector2.new(),
    Size = UDim2.new(0, 50, 0, 50),
    Position = UDim2.new(),
    IsPlaying = true
}

PauseButton.validateProps = t.interface({
    AnchorPoint = t.optional(t.Vector2),
    Size = t.optional(t.UDim2),
    Position = t.optional(t.UDim2),
    IsPlaying = t.optional(t.boolean),
    Activated = t.optional(t.callback)
})

local PauseIcon = "rbxassetid://5821297817"
local PlayIcon = "rbxassetid://5821296412"

function PauseButton:init(props)
    self:setState({
        IsPlaying = props.IsPlaying
    })
end

function PauseButton:render()
    return Roact.createElement("ImageButton", {
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        AnchorPoint = self.props.AnchorPoint,
        Size = self.props.Size,
        Position = self.props.Position,
        Image = self.state.IsPlaying and PauseIcon or PlayIcon,
        [Roact.Event.MouseButton1Click] = function(rbx, ...)
            self:setState(function(state)
                return {
                    IsPlaying = not state.IsPlaying
                }
            end)
            self.props.Activated(self.state.IsPlaying, rbx, ...)
        end
    })
end

return PauseButton