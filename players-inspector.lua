#!/usr/bin/env lua
local lgi = require('lgi')
all_players = lgi.Playerctl.list_players()
for i = 1, #all_players do
	player = lgi.Playerctl.Player.new_from_name(all_players[i])
	print("Player named: " .. player['player-name'] .. " can:")
	print("- can-play: " .. tostring(player['can-play']))
	print("- can-go-next: " .. tostring(player['can-go-next']))
	print("- can-go-previous: " .. tostring(player['can-go-previous']))
	print("- can-control: " .. tostring(player['can-control']))
end
