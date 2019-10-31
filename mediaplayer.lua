local lgi = require('lgi')
local naughty = require("naughty")
local gears = require("gears")

return function()
	local mediaplayer = {}
	-- Init sort of
	local player
	gears.timer({
		timeout = 3,
		single_shot = true,
		callback = function()
			local all_players = lgi.Playerctl.list_players()
			for i = 1, #all_players do
				player = lgi.Playerctl.Player.new_from_name(all_players[i])
				mediaplayer.current_name = player['player-name']
				if player['can-play'] and player['can-pause'] then
					-- Stop iterating players once we have found a player we can at least play/pause
					return
				end
			end
		end,
	}):start()
	function mediaplayer:cycle_players()
		local all_players = lgi.Playerctl.list_players()
		local player
		for i = 1, #all_players do
			player = lgi.Playerctl.Player.new_from_name(all_players[i])
			if mediaplayer.current_name ~= player['player-name'] then
				mediaplayer.current_name = player['player-name']
				naughty.notify({
					preset = naughty.config.presets.normal,
					title = "Playerctl: player changed to:",
					text = player['player-name']
				})
				return
			end
		end
	end
	function mediaplayer:_control(condition_func, action_func, notification_message_text)
		local all_players = lgi.Playerctl.list_players()
		local player
		for i = 1, #all_players do
			player = lgi.Playerctl.Player.new_from_name(all_players[i])
			if mediaplayer.current_name == player['player-name'] then
				if condition_func(player) then
					action_func(player)
					naughty.notify({
						preset = naughty.config.presets.normal,
						title = "Playerctl: " .. player['player-name'],
						text = notification_message_text
					})
				else
					naughty.notify({
						preset = naughty.config.presets.critical,
						title = "Playerctl: " .. player['player-name'],
						text = "couldn't " .. notification_message_text
					})
				end
				return
			end
		end
	end
	function mediaplayer:toggle_play()
		local condition_func = function(player)
			return player['can-play'] and player['can-pause']
		end
		local action_func = function(player)
			return player:play_pause()
		end
		return mediaplayer:_control(
			condition_func,
			action_func,
			"Toggling Play / Pause"
		)
	end
	function mediaplayer:next()
		local condition_func = function(player)
			return player['can-go-next']
		end
		local action_func = function(player)
			return player:next()
		end
		return mediaplayer:_control(
			condition_func,
			action_func,
			"PLAYING next track"
		)
	end
	function mediaplayer:previous()
		local condition_func = function(player)
			return player['can-go-previous']
		end
		local action_func = function(player)
			return player:previous()
		end
		return mediaplayer:_control(
			condition_func,
			action_func,
			"PLAYING previous track"
		)
	end
	function mediaplayer:volume_up(step)
		local condition_func = function(player)
			return player['can-control']
		end
		local action_func = function(player)
			return player:set_volume(math.min(player.volume + step/100, 1))
		end
		return mediaplayer:_control(
			condition_func,
			action_func,
			"Raising volume level up"
		)
	end
	function mediaplayer:volume_down(step)
		local condition_func = function(player)
			return player['can-control']
		end
		local action_func = function(player)
			return player:set_volume(math.max(player.volume - step/100, 0.01))
		end
		return mediaplayer:_control(
			condition_func,
			action_func,
			"Lowering volume level down"
		)
	end
	return mediaplayer
end
