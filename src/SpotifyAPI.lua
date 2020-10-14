local HttpService = game:GetService("HttpService")

local SpotifyAPI = {}

SpotifyAPI.URL = "http://localhost:8080/"

local Http = {}

function Http.Get(endpoint)
    return HttpService:GetAsync(SpotifyAPI.URL..endpoint)
end

function Http.Post(endpoint, tbl)
    return HttpService:PostAsync(
        SpotifyAPI.URL..endpoint,
        HttpService:JSONEncode(tbl),
        Enum.HttpContentType.ApplicationJson
    )
end

SpotifyAPI.InfoCache = nil
SpotifyAPI.RetryIn = 3

SpotifyAPI.TrackChanged = Instance.new("BindableEvent")
SpotifyAPI.CacheChanged = Instance.new("BindableEvent")

function FastSpawn(func, ...)
	assert(type(func) == "function")
	
	local args = {...}
	local count = select("#", ...)
	
	local bindable = Instance.new("BindableEvent")
	bindable.Event:Connect(function()
		func(unpack(args, 1, count))
	end)
	
	bindable:Fire()
	bindable:Destroy()
end

function SpotifyAPI:_GetInfo()
    local response
    local data

    local function Try_GetInfo()
        response = Http.Get("GetInfo")
        data = HttpService:JSONDecode(response)
    end
    
    local status, err

    status, err = pcall(Try_GetInfo)

    if err then
        warn(status, err)
    end

    while not data do
        wait(self.RetryIn)
        status, err = pcall(Try_GetInfo)
        warn(status, err)
    end
    
    self.InfoCache = data
    self.CacheChanged:Fire()

    return data
end

function SpotifyAPI:GetInfo()
    if self.InfoCache then
        return self.InfoCache
    end
    return self:_GetInfo()
end

function SpotifyAPI:Previous()
    Http.Get("Previous")
end

function SpotifyAPI:Next()
    Http.Get("Next")
end

function SpotifyAPI:SetPlaying(play)
    if play then
        Http.Get("Resume")
    else
        Http.Get("Pause")
    end
end

function SpotifyAPI:GetIsPlaying()
    return self:GetInfo()["is_playing"]
end

function SpotifyAPI:SetMuted(muted)
    assert(type(muted) == "boolean")

    local function TrySetMuted()
        Http.Post("SetMuted", {
            mute = muted
        })
    end

    local status, err

    status, err = pcall(TrySetMuted)

    if err then
        warn(status, err)
    end

    while err do
        wait(self.RetryIn)
        status, err = pcall(TrySetMuted)
        warn(status, err)
    end
end

function SpotifyAPI:GetIsMuted()
    local response
    local data

    local function TryGetMuted()
        response = Http.Get("GetMuted")
        data = HttpService:JSONDecode(response)
    end
    
    local status, err

    status, err = pcall(TryGetMuted)

    if err then
        warn(status, err)
    end

    while not data do
        wait(self.RetryIn)
        status, err = pcall(TryGetMuted)
        warn(status, err)
    end

    return data["muted"]
end

function SpotifyAPI:GetProgress()
    return tonumber(self:GetInfo()["progress_ms"]) / 1000
end

function SpotifyAPI:GetDuration()
    return tonumber(self:GetInfo()["item"]["duration_ms"]) / 1000
end

function SpotifyAPI:GetSongName()
    return self:GetInfo()["item"]["name"]
end

function SpotifyAPI:GetArtists()
    local Info = self:GetInfo()
    local ArtistNames = Info["item"]["artists"]
	local Artists = {}
	for _,Artist in pairs(ArtistNames) do
		table.insert(Artists, #Artists+1, Artist.name)
	end
	return Artists
end

FastSpawn(function()
    print("Started thread")
	while true do
		local oldId
		if SpotifyAPI.InfoCache then
			oldId = SpotifyAPI.InfoCache["item"]["id"]
		end
		
		SpotifyAPI:_GetInfo()

		if SpotifyAPI.InfoCache and oldId then
			if not SpotifyAPI.InfoCache["item"]["id"] == oldId then
				SpotifyAPI.TrackChanged:Fire()
			end
		elseif not oldId then
			SpotifyAPI.TrackChanged:Fire()
		end

		wait(1)
	end
	print("Thread terminated")
end)

return SpotifyAPI