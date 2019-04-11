local lgi = require('lgi')

return function()
	local mediaplayer = {}
	function mediaplayer:toggle_play()
		local player = lgi.Playerctl.Player()
		if player['can-control'] then
			return player:play_pause()
		end
	end
	function mediaplayer:next()
		local player = lgi.Playerctl.Player()
		if player['can-control'] then
			return player:next()
		end
	end
	function mediaplayer:previous()
		local player = lgi.Playerctl.Player()
		if player['can-control'] then
			return player:previous()
		end
	end
	function mediaplayer:seek(step)
		local player = lgi.Playerctl.Player()
		if player['can-control'] then
			return player:seek(step * 1000000)
		end
	end
	function mediaplayer:volume_up(step)
		local player = lgi.Playerctl.Player()
		if player['can-control'] then
			return player:set_volume(math.min(player.volume + step/100, 1))
		end
	end
	function mediaplayer:volume_down(step)
		local player = lgi.Playerctl.Player()
		if player['can-control'] then
			return player:set_volume(math.max(player.volume - step/100, 0))
		end
	end
	function mediaplayer:toggle_mute()
		local player = lgi.Playerctl.Player()
		if player['can-control'] then
			if player.volume == 0 then
				if not mediaplayer.last_volume then
					mediaplayer.last_volume = 1
				end
				return player:set_volume(mediaplayer.last_volume)
			else
				mediaplayer.last_volume = player.volume
				return player:set_volume(0)
			end
		end
	end
	return mediaplayer
end
