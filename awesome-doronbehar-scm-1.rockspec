package = "awesome-doronbehar"
version = "scm-1"
source = {
	url = "git://github.com/doronbehar/.config_awesome",
}
description = {
	summary = "My personal AwesomeWM configuration",
	homepage = "https://github.com/doronbehar/.config_awesome",
	license = "Apache v2.0"
}
supported_platforms = {
	"linux"
}
dependencies = {
	"lua >= 5.2",
	"awesomewm-autostart",
	"pulseaudio_cli"
}
build = {
	type = "none"
}
