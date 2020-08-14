--[[
	@Author: Gavin "Mullets" Rosenthal
	@Desc: Custom sound system! Uses caching and components to handle everything for you
--]]

--[[
[DOCUMENTATION]:
	https://github.com/Mullets-Gavin/--
	Listed below is a quick glance on the API, visit the link above for proper documentation

[SOUND API]:
	:Play()
	:Stop()
	:CreatePlaylist()
	:StopPlaylist()

[FEATURES]:
	- a simple and streamline fashion to load and play sounds
	- comes with a bunch of audios pre-installed, including sounds from Mullet Mafia Dev and Mad Studio!
]]--

--// services
local Services = setmetatable({}, {__index = function(cache, serviceName)
    cache[serviceName] = game:GetService(serviceName)
    return cache[serviceName]
end})

--// logic
local Sound = {}
Sound.Playing = {}
Sound.Playlists = {}
Sound.Audios = require(script.Audios)

--// functions
local function AccurateWait(playlist,clock)
	local nowTime = tick()
	repeat
		Services['RunService'].Heartbeat:Wait()
	until not Sound.Playlists[playlist]['Event'] or (tick() - nowTime >= clock)
end

local function GrabAudio(index)
	if not Sound.Playing[index] then
		Sound.Playing[index] = Instance.new('Sound')
		for property,value in pairs(Sound.Audios[index]) do
			Sound.Playing[index][property] = value
		end
		Sound.Playing[index].Name = index
		Sound.Playing[index].Parent = Services['SoundService']
		Services['ContentProvider']:PreloadAsync({Sound.Playing[index]})
	elseif Sound.Playing[index] then
		if Sound.Playing[index].Playing then
			Sound.Playing[index]:Stop()
		end
	end
	Services['RunService'].Heartbeat:Wait()
	return Sound.Playing[index]
end

function Sound:Play(audio,amt)
	for index,noise in pairs(Sound.Audios) do
		if audio == noise then
			if not amt or amt == 1 then
				local newAudio = GrabAudio(index)
				newAudio.Looped = false
				newAudio:Play()
				return newAudio.TimeLength
			elseif amt == true then
				local newAudio = GrabAudio(index)
				newAudio.Looped = true
				newAudio:Play()
				return newAudio.TimeLength
			elseif amt > 1 then
				local newAudio = GrabAudio(index)
				newAudio.Looped = false
				newAudio:Play()
				coroutine.wrap(function()
					local streams = 0
					while streams < amt do
						wait(newAudio.TimeLength)
						streams = streams + 1
						if Sound.Playing[index] == newAudio then
							newAudio:Stop()
							newAudio:Play()
						else
							break
						end
					end
					if Sound.Playing[index] then
						if Sound.Playing[index] == newAudio then
							Sound.Playing[index]:Stop()
						end
					end
				end)()
				return newAudio.TimeLength
			end
		end
	end
end

function Sound:Stop(audio)
	for index,noise in pairs(Sound.Audios) do
		if audio == noise then
			if Sound.Playing[index] then
				local storeVolume = Sound.Playing[index].Volume
				local tweenDown = Services['TweenService']:Create(Sound.Playing[index],TweenInfo.new(0.5),{Volume = 0})
				tweenDown:Play()
				Sound.Playing[index]:Stop()
				Sound.Playing[index].Volume = storeVolume
			end
		end
	end
end

function Sound:CreatePlaylist(playlist,amt)
	coroutine.wrap(function()
		if not amt or amt == 1 then
			for index,audio in ipairs(playlist) do
				for count,sounds in pairs(Sound.Audios) do
					if audio == sounds then
						local timeLength
						repeat
							timeLength = Sound:Play(audio)
						until timeLength ~= nil and timeLength ~= 0
						AccurateWait(playlist,timeLength)
						break
					end
				end
			end
		elseif amt == true then
			if Sound.Playlists[playlist] then
				Sound:StopPlaylist(playlist)
			end
			Sound.Playlists[playlist] = {
				['Event'] = nil;
				['Current'] = nil;
				['Logged'] = nil;
			}
			Sound.Playlists[playlist]['Event'] = true
			if not Sound.Playlists[playlist]['Logged'] then
				Sound.Playlists[playlist]['Logged'] = true
				while Sound.Playlists[playlist]['Event'] do
					for index,audio in ipairs(playlist) do
						local timeLength
						repeat
							timeLength = Sound:Play(audio)
						until timeLength ~= nil and timeLength ~= 0
						Sound.Playlists[playlist]['Current'] = audio
						AccurateWait(playlist,timeLength)
						if not Sound.Playlists[playlist]['Logged'] then break end
					end
					if not Sound.Playlists[playlist]['Logged'] then break end
				end
			end
		elseif amt > 1 then
			if Sound.Playlists[playlist] then
				Sound.Playlists[playlist]['Event'] = false
				Sound:Stop(Sound.Playlists[playlist]['Current'])
			end
			Sound.Playlists[playlist] = {
				['Event'] = nil;
				['Current'] = nil;
			}
			local streams = 0
			Sound.Playlists[playlist]['Event'] = true
			if not Sound.Playlists[playlist]['Logged'] then
				Sound.Playlists[playlist]['Logged'] = true
				while Sound.Playlists[playlist]['Event'] do
					if streams >= amt then Sound:StopPlaylist(playlist) end
					streams = streams + 1
					for index,audio in ipairs(playlist) do
						local timeLength
						repeat
							timeLength = Sound:Play(audio)
						until timeLength ~= nil and timeLength ~= 0
						Sound.Playlists[playlist]['Current'] = audio
						AccurateWait(playlist,timeLength)
						if not Sound.Playlists[playlist]['Logged'] then break end
					end
				end
				Sound.Playlists[playlist]['Logged'] = false
			end
		end
	end)()
end

function Sound:StopPlaylist(playlist)
	if Sound.Playlists[playlist] then
		Sound.Playlists[playlist]['Event'] = false
		for index,audio in pairs(Sound.Playing) do
			if audio.Name == Sound.Playlists[playlist]['Current'].Name then
				Sound:Stop(index)
				break
			end
		end
		Sound.Playlists[playlist] = {
			['Event'] = nil;
			['Current'] = nil;
			['Logged'] = nil;
		}
	end
end

return Sound