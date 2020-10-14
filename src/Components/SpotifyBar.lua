local PluginFolder = script.Parent.Parent

local SpotifyAPI = require(PluginFolder.SpotifyAPI)

--@type Roact
local Roact = require(PluginFolder.Roact)
local Components = PluginFolder.Components

local PauseButton = require(Components.PauseButton)
local MuteButton = require(Components.MuteButton)
local SkipButton = require(Components.SkipButton)
local DurationLabel = require(Components.DurationLabel)
local SongLabel = require(Components.SongLabel)

local SpotifyBar = Roact.Component:extend("SpotifyBar")

print(SpotifyAPI:GetProgress())
print(SpotifyAPI:GetDuration())

function SpotifyBar:render()
    return Roact.createElement("Frame", {
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(),
        BackgroundColor3 = Color3.new(0.129412, 0.129412, 0.129412)
    }, {
        PauseButton = Roact.createElement(PauseButton, {
            AnchorPoint = Vector2.new(0,0.5),
            Size = UDim2.new(0,50,1,0),
            Position = UDim2.new(0,50,0.5,0),
            IsPlaying = SpotifyAPI:GetIsPlaying(),
            Activated = function(IsPlaying)
                SpotifyAPI:SetPlaying(IsPlaying)
            end
        }),
        MuteButton = Roact.createElement(MuteButton, {
            AnchorPoint = Vector2.new(0, 0.5),
            Size = UDim2.new(0, 50, 1, 0),
            Position = UDim2.new(0, 100, 0.5, 0),
            Muted = SpotifyAPI:GetIsMuted(),
            Activated = function(Muted)
                SpotifyAPI:SetMuted(Muted)
            end
        }),
        SkipBackward = Roact.createElement(SkipButton, {
            AnchorPoint = Vector2.new(0, 0.5),
            Size = UDim2.new(0, 50, 1, 0),
            Position = UDim2.new(0, 0, 0.5, 0),
            Text = "<",
            Activated = function()
                SpotifyAPI:Previous()
            end
        }),
        DurationLabel = Roact.createElement(DurationLabel, {
            AnchorPoint = Vector2.new(1, 0.5),
            Size = UDim2.new(0,100,1,0),
            Position = UDim2.new(1,-50,0.5,0),
            Progress = SpotifyAPI:GetProgress(),
            Duration = SpotifyAPI:GetDuration()
        }),
        SkipForward = Roact.createElement(SkipButton, {
            AnchorPoint = Vector2.new(0, 0.5),
            Size = UDim2.new(0, 50, 1, 0),
            Position = UDim2.new(1,-50,0.5,0),
            Activated = function()
                SpotifyAPI:Next()
            end
        }),
        TitleLabel = Roact.createElement(SongLabel, {
            AnchorPoint = Vector2.new(0, 0.5),
            Size = UDim2.new(1, -150, .5, 0),
            Position = UDim2.new(0,100,0.25,0),
            Text = SpotifyAPI:GetSongName()
        }),
        ArtistsLabel = Roact.createElement(SongLabel, {
            AnchorPoint = Vector2.new(0, 0.5),
            Size = UDim2.new(1, -150, .5, 0),
            Position = UDim2.new(0,100,0.75,0),
            Text = table.concat(SpotifyAPI:GetArtists(), ", ")
        })
    })
end

return SpotifyBar