local lgi = require('lgi')
local naughty = require("naughty")

return function()
	local mediaplayer = {}
	function mediaplayer:_control(func)
		local all_players = lgi.Playerctl.list_players()
		local player
		for i = 1, #all_players do
			player = lgi.Playerctl.Player.new_from_name(all_players[i])
			if func(player) then
				return
			end
		end
		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Playerctl: couldn't find any players",
			text = player['player-name']
		})
	end
	function mediaplayer:toggle_play()
		return mediaplayer:_control(function(player)
			if player['can-play'] and player['can-pause'] then
				naughty.notify({
					preset = naughty.config.presets.normal,
					title = "Playerctl: " .. player['player-name'],
					text = "Toggling Play / Pause"
				})
				return player:play_pause()
			else
				return false
			end
		end)
	end
	function mediaplayer:next()
		return mediaplayer:_control(function(player)
			if player['can-go-next'] then
				naughty.notify({
					preset = naughty.config.presets.normal,
					title = "Playerctl: " .. player['player-name'],
					text = "PLAYING next track"
				})
				return player:next()
			else
				return false
			end
		end)
	end
	function mediaplayer:previous()
		return mediaplayer:_control(function(player)
			if player['can-go-previous'] then
				naughty.notify({
					preset = naughty.config.presets.normal,
					title = "Playerctl: " .. player['player-name'],
					text = "PLAYING previous track"
				})
				return player:previous()
			else
				return false
			end
		end)
	end
	function mediaplayer:seek(step)
		return mediaplayer:_control(function(player)
			if player['can-seek'] then
				naughty.notify({
					preset = naughty.config.presets.normal,
					title = "Playerctl: " .. player['player-name'],
					text = "PLAYING next track"
				})
				return player:previous()
			else
				return false
			end
		end)
	end
	function mediaplayer:volume_up(step)
		return mediaplayer:_control(function(player)
			if player['can-control'] then
				naughty.notify({
					preset = naughty.config.presets.normal,
					title = "Playerctl: " .. player['player-name'],
					text = "Raising volume level up"
				})
				return player:set_volume(math.min(player.volume + step/100, 1))
			else
				return false
			end
		end)
	end
	function mediaplayer:volume_down(step)
		return mediaplayer:_control(function(player)
			if player['can-control'] then
				naughty.notify({
					preset = naughty.config.presets.normal,
					title = "Playerctl: " .. player['player-name'],
					text = "Lowering volume level up"
				})
				return player:set_volume(math.max(player.volume - step/100, 0.01))
			else
				return false
			end
		end)
	end
	return mediaplayer
end
