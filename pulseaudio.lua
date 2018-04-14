local pulseaudio_dbus = require("pulseaudio_dbus")

local function init(settings)
	local ret = {}
	ret.address = pulseaudio_dbus.get_address()
	ret.connection = pulseaudio_dbus.get_connection(ret.address, settings.connection.dont_assert)
	ret.core = pulseaudio_dbus.get_core(ret.connection)
	ret.sink_devices = {}
	for i = 1, #ret.core.Sinks do
		ret.sink_devices[i] = pulseaudio_dbus.get_device(ret.connection, ret.core.Sinks[i], settings.sink_device.volume_step, settings.sink_device.volume_max)
	end
	ret.source_devices = {}
	for i = 1, #ret.core.Sources do
		ret.source_devices[i] = pulseaudio_dbus.get_device(ret.connection, ret.core.Sources[i], settings.sink_device.volume_step, settings.sink_device.volume_max)
	end
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
	ret.volume_up = function()
		local pulse = init(settings)
		for i = 1, #pulse.core.Sinks do
			if pulse.core.FallbackSink == pulse.sink_devices[i].object_path then
				return pulse.sink_devices[i]:volume_up()
			end
		end
	end
	ret.volume_down = function()
		local pulse = init(settings)
		for i = 1, #pulse.core.Sinks do
			if pulse.core.FallbackSink == pulse.sink_devices[i].object_path then
				return pulse.sink_devices[i]:volume_down()
			end
		end
	end
	ret.toggle_muted = function()
		local pulse = init(settings)
		for i = 1, #pulse.core.Sinks do
			if pulse.core.FallbackSink == pulse.sink_devices[i].object_path then
				return pulse.sink_devices[i]:toggle_muted()
			end
		end
	end
	ret.cycle_sinks = function()
		local pulse = init(settings)
		for i = 1, #pulse.core.Sinks do
			if pulse.core.FallbackSink ~= pulse.sink_devices[i].object_path then
				pulse.core:set_fallback_sink(pulse.sink_devices[i].object_path)
				for s = 1, #pulse.core.PlaybackStreams do
					pulseaudio_dbus.get_stream(pulse.connection, pulse.core.PlaybackStreams[s]):Move(pulse.core.FallbackSink)
				end
				return
			end
		end
	end

	ret.volume_up_mic = function()
		local pulse = init(settings)
		for i = 1, #pulse.core.Sources do
			if pulse.core.FallbackSink == pulse.source_devices[i].object_path then
				return pulse.source_devices[i]:volume_up_mic()
			end
		end
	end
	ret.volume_down_mic = function()
		local pulse = init(settings)
		for i = 1, #pulse.core.Sources do
			if pulse.core.FallbackSink == pulse.source_devices[i].object_path then
				return pulse.source_devices[i]:volume_down_mic()
			end
		end
	end
	ret.toggle_muted_mic = function()
		local pulse = init(settings)
		for i = 1, #pulse.core.Sources do
			if pulse.core.FallbackSink == pulse.source_devices[i].object_path then
				return pulse.source_devices[i]:toggle_muted_mic()
			end
		end
	end
	ret.cycle_sources = function()
		local pulse = init(settings)
		for i = 1, #pulse.core.Sources do
			if pulse.core.FallbackSource ~= pulse.source_devices[i].object_path then
				pulse.core:set_fallback_source(pulse.source_devices[i].object_path)
				for s = 1, #pulse.core.RecordStreams do
					pulseaudio_dbus.get_stream(pulse.connection, pulse.core.RecordStreams[s]):Move(pulse.core.FallbackSource)
				end
				return
			end
		end
	end
	return ret
end

return pulseaudio
