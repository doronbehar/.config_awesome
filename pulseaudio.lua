local pulseaudio_dbus = require("pulseaudio_dbus")

local function init(settings)
	local ret = {}
	ret.address = pulseaudio_dbus.get_address()
	ret.connection = pulseaudio_dbus.get_connection(ret.address, settings.connection.dont_assert)
	ret.core = pulseaudio_dbus.get_core(ret.connection)
	return ret
end

local pulseaudio = {}
pulseaudio = function(settings)
	if type(settings) ~= 'table' then
		settings = {}
	end
	setmetatable(settings, {
		__index = {
			sink_device = {},
			source_device = {},
			connection = {}
		}
	})
	local ret = {}
	ret.pulse = init(settings)
	ret.volume_up = function()
		for i = 1, #ret.pulse.core.Sinks do
			local device = pulseaudio_dbus.get_device(ret.pulse.connection, ret.pulse.core.Sinks[i], settings.sink_device.volume_step, settings.sink_device.volume_max)
			if device.object_path == ret.pulse.core.FallbackSink then
				return device:volume_up()
			end
		end
	end
	ret.volume_down = function()
		for i = 1, #ret.pulse.core.Sinks do
			local device = pulseaudio_dbus.get_device(ret.pulse.connection, ret.pulse.core.Sinks[i], settings.sink_device.volume_step, settings.sink_device.volume_max)
			if device.object_path == ret.pulse.core.FallbackSink then
				return device:volume_down()
			end
		end
	end
	ret.toggle_muted = function()
		for i = 1, #ret.pulse.core.Sinks do
			local device = pulseaudio_dbus.get_device(ret.pulse.connection, ret.pulse.core.Sinks[i], settings.sink_device.volume_step, settings.sink_device.volume_max)
			if device.object_path == ret.pulse.core.FallbackSink then
				return device:toggle_muted()
			end
		end
	end
	ret.cycle_sinks = function()
		for i = 1, #ret.pulse.core.Sinks do
			local device = pulseaudio_dbus.get_device(ret.pulse.connection, ret.pulse.core.Sinks[i], settings.sink_device.volume_step, settings.sink_device.volume_max)
			if device.object_path ~= ret.pulse.core.FallbackSink then
				ret.pulse.core:set_fallback_sink(device.object_path)
				for s = 1, #ret.pulse.core.PlaybackStreams do
					pulseaudio_dbus.get_stream(ret.pulse.connection, ret.pulse.core.PlaybackStreams[s]):Move(ret.pulse.core.FallbackSink)
				end
				return
			end
		end
	end

	ret.volume_up_mic = function()
		for i = 1, #ret.pulse.core.Sources do
			local device = pulseaudio_dbus.get_device(ret.pulse.connection, ret.pulse.core.Sources[i], settings.sink_device.volume_step, settings.sink_device.volume_max)
			if device.object_path == ret.pulse.core.FallbackSink then
				return device:volume_up_mic()
			end
		end
	end
	ret.volume_down_mic = function()
		for i = 1, #ret.pulse.core.Sources do
			local device = pulseaudio_dbus.get_device(ret.pulse.connection, ret.pulse.core.Sources[i], settings.sink_device.volume_step, settings.sink_device.volume_max)
			if device.object_path == ret.pulse.core.FallbackSink then
				return device:volume_down_mic()
			end
		end
	end
	ret.toggle_muted_mic = function()
		for i = 1, #ret.pulse.core.Sources do
			local device = pulseaudio_dbus.get_device(ret.pulse.connection, ret.pulse.core.Sources[i], settings.sink_device.volume_step, settings.sink_device.volume_max)
			if device.object_path == ret.pulse.core.FallbackSink then
				return device:toggle_muted_mic()
			end
		end
	end
	ret.cycle_sources = function()
		for i = 1, #ret.pulse.core.Sources do
			local device = pulseaudio_dbus.get_device(ret.pulse.connection, ret.pulse.core.Sources[i], settings.sink_device.volume_step, settings.sink_device.volume_max)
			if device.object_path ~= ret.pulse.core.FallbackSource then
				ret.pulse.core:set_fallback_source(device.object_path)
				for s = 1, #ret.pulse.core.RecordStreams do
					pulseaudio_dbus.get_stream(ret.pulse.connection, ret.pulse.core.RecordStreams[s]):Move(ret.pulse.core.FallbackSource)
				end
				return
			end
		end
	end
	return ret
end

return pulseaudio
