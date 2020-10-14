local PluginFolder = script.Parent.Parent

--@type Roact
local Roact = require(PluginFolder.Roact)
local t = require(PluginFolder.t)

local MuteButton = Roact.Component:extend("MuteButton")
MuteButton.defaultProps = {
    AnchorPoint = Vector2.new(),
    Size = UDim2.new(0, 50, 0, 50),
    Position = UDim2.new(),
    Muted = false
}

MuteButton.validateProps = t.interface({
    AnchorPoint = t.optional(t.Vector2),
    Size = t.optional(t.UDim2),
    Position = t.optional(t.UDim2),
    Muted = t.optional(t.boolean),
    Activated = t.optional(t.callback)
})

local AudioIcon = "rbxassetid://5821953345"
local MutedIcon = "rbxassetid://5821899191"

function MuteButton:init(props)
    self:setState({
        Muted = props.Muted
    })
end

function MuteButton:render()
    return Roact.createElement("ImageButton", {
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        AnchorPoint = self.props.AnchorPoint,
        Size = self.props.Size,
        Position = self.props.Position,
        Image = self.state.Muted and MutedIcon or AudioIcon,
        [Roact.Event.MouseButton1Click] = function(rbx, ...)
            self:setState(function(state)
                return {
                    Muted = not state.Muted
                }
            end)
            self.props.Activated(self.state.Muted, rbx, ...)
        end
    })
end

return MuteButton