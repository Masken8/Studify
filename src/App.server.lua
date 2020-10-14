local PluginFolder = script.Parent
local Players = game:GetService("Players")

local SpotifyAPI = require(PluginFolder.SpotifyAPI)
local SpotifyBar = require(PluginFolder.Components.SpotifyBar)

--@type Roact
local Roact = require(PluginFolder.Roact)

local Toolbar = plugin:CreateToolbar("Studify")
local ToggleGuiButton = Toolbar:CreateButton("Toggle Studify", "Toggle Spotify Controls", "rbxassetid://5828146566")

local WidgetInfo = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Bottom,
	false,   -- Enabled
	true,  -- override previous enabled state
	500,
	50,
	50,
	50
)

-- Create new widget GUI
local AppWidget = plugin:CreateDockWidgetPluginGui("SpotifyBar", WidgetInfo)

local handle

function OnCacheChanged()
    Roact.update(handle, Roact.createElement(SpotifyBar))
end

local CacheChangedConnection

ToggleGuiButton.Click:Connect(function()
    if AppWidget.Enabled then
        ToggleGuiButton:SetActive(false)
        AppWidget.Enabled = false
        if CacheChangedConnection then
            CacheChangedConnection:Disconnect()
        end

        if handle then
            Roact.unmount(handle)
            handle = nil
        end
    else
        ToggleGuiButton:SetActive(true)
        handle = Roact.mount(Roact.createElement(SpotifyBar), AppWidget)
        AppWidget.Enabled = true
        CacheChangedConnection = SpotifyAPI.CacheChanged.Event:Connect(OnCacheChanged)
    end
end)