local lgi = require('lgi')
local mpd = require('mpd')
local mpd_host = os.getenv('MPD_HOST') or 'localhost'
local _, _, mpd_password, mpd_hostname = string.find(mpd_host, "([^@]+)@([a-zA-Z0-9.]+)")

return function()
	local mediaplayer = {}
	function mediaplayer:toggle_play()
		local player = lgi.Playerctl.Player()
		local mpc = mpd.new({password = mpd_password, hostname = mpd_hostname})
		if player['can-control'] then
			return player:play_pause()
		else
			return mpc:toggle_play()
		end
	end
	function mediaplayer:next()
		local player = lgi.Playerctl.Player()
		local mpc = mpd.new({password = mpd_password, hostname = mpd_hostname})
		if player['can-control'] then
			return player:next()
		else
			return mpc:next()
		end
	end
	function mediaplayer:previous()
		local player = lgi.Playerctl.Player()
		local mpc = mpd.new({password = mpd_password, hostname = mpd_hostname})
		if player['can-control'] then
			return player:previous()
		else
			return mpc:previous()
		end
	end
	function mediaplayer:seek(step)
		local player = lgi.Playerctl.Player()
		local mpc = mpd.new({password = mpd_password, hostname = mpd_hostname})
		if player['can-control'] then
			return player:seek(step * 1000000)
		else
			return mpc:seek(step)
		end
	end
	function mediaplayer:volume_up(step)
		local player = lgi.Playerctl.Player()
		local mpc = mpd.new({password = mpd_password, hostname = mpd_hostname})
		if player['can-control'] then
			return player:set_volume(math.min(player.volume + step/100, 1))
		else
			return mpc:volume_up(step)
		end
	end
	function mediaplayer:volume_down(step)
		local player = lgi.Playerctl.Player()
		local mpc = mpd.new({password = mpd_password, hostname = mpd_hostname})
		if player['can-control'] then
			return player:set_volume(math.max(player.volume - step/100, 0))
		else
			return mpc:volume_up(step)
		end
	end
	function mediaplayer:toggle_mute()
		local player = lgi.Playerctl.Player()
		local mpc = mpd.new({password = mpd_password, hostname = mpd_hostname})
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
		else
			return mpc:send('toggleoutput 0')
		end
	end
	return mediaplayer
end
