------------------------------------------------
--        	 Full Color Awesome 3.5       	  --
--               by Luca Manni                --
--     http://lucamanni88.deviantart.com/     --
--     https://github.com/lucamanni           --
------------------------------------------------


-- {{{ Required Libraries
awful           = require("awful")
awful.rules     = require("awful.rules")
awful.autofocus = require("awful.autofocus")
wibox           = require("wibox")
beautiful       = require("beautiful")
naughty         = require("naughty")
vicious         = require("vicious")
revelation      = require("revelation")
menubar         = require("menubar")
drop            = require("scratchdrop")
-- }}}
-- {{{ Variable Definitions
-- {{{ Keys
altkey           = "Mod1"
modkey           = "Mod4"
control          = "Control"
shift            = "Shift"
-- }}}
-- {{{ Commands
key     = awful.key
exec    = awful.util.spawn
execs   = awful.util.spawn_with_shell
font    = "Tamsyn 10"
-- }}}
-- {{{ Directories
home             = os.getenv("HOME")
confdir          = home .. "/.config/awesome"
themes           = confdir .. "/themes"
active_theme     = themes .. "/colored"
beautiful.init(active_theme .. "/theme.lua")
scripts          = " sh " .. home .. "/.scripts/"
-- }}}
-- {{{ Colors
coloff  = "</span>"
red     = "<span color='" .. beautiful.fg_red     .. "'>"
green   = "<span color='" .. beautiful.fg_green   .. "'>"
yellow  = "<span color='" .. beautiful.fg_yellow  .. "'>"
blue    = "<span color='" .. beautiful.fg_blue    .. "'>"
magenta = "<span color='" .. beautiful.fg_magenta .. "'>"
grey    = "<span color='" .. beautiful.fg_grey    .. "'>"
white   = "<span color='" .. beautiful.fg_white   .. "'>"
-- }}}
-- {{{ Apps
terminal         = " urxvt "
terminale        = terminal .. " -title Terminal "
root_terminal    = " sudo " .. terminal .. " -title 'Root Terminal' "
editor           = os.getenv("EDITOR") or "vim"
cli_editor       = terminal .. " -e " .. editor
gui_editor       = " geany "
browser2         = " firefox "
browser1         = " chromium "
player           = " mplayer "
fileman          = " thunar "
root_fileman     = " sudo " .. fileman .. "/root"
cli_fileman      = terminal .. " -title 'File Manager' -e ranger "
cli_root_fileman = terminal .. " -title 'Root File Manager' -e sudo ranger " 
music            = terminal .. " -geometry 199x57 -title Music -e ncmpcpp "
chat             = terminal .. " -title Chat -e " .. scripts .. "weechat"
torrent          = terminal .. " -title Torrent -e " .. scripts .. "torrent"
cli_browser      = terminal .. " -title Elinks -e elinks "
tasks            = terminal .. " -title Tasks -e sudo htop "
powertop         = terminal .. " -title Powertop -e sudo powertop "
update           = terminal .. " -title Updating -e yaourt -Syua --noconfirm "
mail             = terminal .. " -title Mail -e mutt " 
mail_gui         = " thunderbird "
feed             = terminal .. " -title Feed -e newsbeuter " 
mixer            = terminal .. " -title Mixer -e alsamixer " 
youtube          = terminal .. " -title Youtube -e youtube-viewer -C "
youtube2mp3      = terminal .. " -title Youtube2mp3 -e youtube2mp3 "
abook            = terminal .. " -title Abook -e abook "
saidar           = terminal .. " -geometry 80x18 -e saidar -c "
lock             = " i3lock -d -p default -i /home/luca/.antergos.png "
slimlock         = scripts .. "lock"
-- }}}
-- }}}
-- {{{ Autostart
-- os.execute("sh ~/.autostart/awesome.sh")

function run_once(cmd)
  findme = cmd
  firstspace = cmd:find(" ")
  if firstspace then
    findme = cmd:sub(0, firstspace-1)
  end
  awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

run_once("sh .autostart/awesome")
-- run_once("compton --backend glx --paint-on-overlay --vsync opengl-mswc -c -r 12 -l -15 -t -11 -G -b")
run_once("compton --backend glx --paint-on-overlay --vsync opengl-mswc -b")
run_once("udiskie -aNqs -f thunar")
run_once("pulseaudio --start")

-- }}}
-- {{{ Error Handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                        title = "Oops, an error happened!",
                        fg = beautiful.fg_yellow,
                        bg = beautiful.fg_black,
                        font = font,
                        border_width = 1,
                        border_color = beautiful.border_tooltip,
                        -- opacity = 0.94,
                        timeout = 0,
                        text = err })
        in_error = false
    end)
end
-- }}}
-- {{{ Layouts & Tags
layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
}

tags = {}
for s = 1, screen.count() do
    tags[s] = awful.tag({ "term ", "web ", "files ", "chat ", "media ", "work ", "kodi" }, s,
  		       { layouts[4], layouts[2], layouts[4],
 			  layouts[2], layouts[4], layouts[2], layouts[2]
 		       })
    
    -- awful.tag.seticon(active_theme .. "/widgets/cyan/arch_10x10.png", tags[s][1])
    -- awful.tag.seticon(active_theme .. "/widgets/red/cat.png", tags[s][2])
    -- awful.tag.seticon(active_theme .. "/widgets/magenta/dish.png", tags[s][3])
    -- awful.tag.seticon(active_theme .. "/widgets/green/mail.png", tags[s][4])
    -- awful.tag.seticon(active_theme .. "/widgets/yellow/phones.png", tags[s][5])
    -- awful.tag.seticon(active_theme .. "/widgets/blue/pacman.png", tags[s][6])
    
end
-- }}}
-- {{{ Menu

-- {{{ Menù di spegnimento
mypoweroffmenu = awful.menu({ items = {
                    { "Aggiorna", awesome.restart },
		            { "Blocca", lock },
                    { "Esci", awesome.quit }, 
                    -- { "Openbox", scripts .. "switchtoopenboxfromawesome" },
		            { "Riavvia", "sudo systemctl reboot" },
		            { "Spegni", "sudo systemctl poweroff" }},
                    theme = { width = 80, height = 17, font = "Tamsyn 9" }
                    })

mypoweroff = wibox.widget.imagebox()
mypoweroff:set_image(beautiful.widget_poweroff)
mypoweroff:buttons(awful.util.table.join(awful.button({ }, 1, function () mypoweroffmenu:toggle() end )))
-- }}}

-- {{{ Accessori
myacc = {
		{ "Geany", "geany"},
		{ "Keepass", "keepass"},
		{ "Marble Mobile", "marble-mobile" },
		{ "Marble Qt", "marble-qt" },
		{ "Thunar", "thunar" },
		{ "Thunar [#]", "sudo thunar /root" },
		{ "Urxvt", terminale },
		{ "Xarchiver", "xarchiver" }, theme = { width = 108, height = 17, font = "Tamsyn 9" }
}
-- }}}
-- {{{ Grafica
mygraph = {
	  { "Gimp", "gimp" },
	  { "Mypaint", "mypaint" },
	  { "Viewnior", "viewnior" }, theme = { width = 77, height = 17, font = "Tamsyn 9" }
}
-- }}}
-- {{{ Internet
myinternet = {
	     { "Chromium", "chromium" },
	     { "Dropbox", "dropbox" },
	     { "Google Earth", "/opt/google/earth/legacy/google-earth -fn -xos4-terminus-medium-r-normal--12-120-72-72-c-60-iso8859-9" },
	     { "IRC", chat },
	     { "MP3 Downloader", youtube2mp3 }, 
	     { "PopCornTime", "popcorntime" },
	     { "rTorrent", torrent },
         { "Skype", "skype -fn -xos4-terminus-medium-r-normal--12-120-72-72-c-60-iso8859-9" },
	     { "Streaming [MPlayer]", "nowvideo-mplayer" },
	     { "Streaming [VLC]", "nowvideo-vlc" },
	     { "Thunderbird", mail_gui },
	     { "Torrent Search", "torrent-search" },
	     { "Viber", "viber" },
	     { "Vimperator", "firefox" },
	     { "VNC Viewer", "vnc-E4_6_3-x64_linux_viewer" },
         { "YouTube", youtube }, theme = { width = 145, height = 17, font = "Tamsyn 9" }
}
-- }}}
-- {{{ Istruzione
myeducation = {
	  { "Celestia", "celestia" },
	  { "ConvertAll", "convertall" },
      { "Gelemental", "gelemental" }, 
	  { "Qalculate!", "qalculate-gtk" }, theme = { width = 92, height = 17, font = "Tamsyn 9" }
}
-- }}}
-- {{{ Multimedia
mymultimedia = {
	        { "Kodi", "kodi" },
            { "Mixer", terminal .. " -e alsamixer " },
	        { "Ncmpcpp", music },
	        { "Nuvola Player", "nuvolaplayer3" },
	        { "Pulseaudio", "pavucontrol" },
	        { "Qt V4L2 Test", "qv4l2" },
	        { "Radio", terminal .. " -e tmux new -s radio radio " },
	        { "Spotify", "spotify" },
	        { "Subtitles Downloader", "subdownloader" },
	        { "Subtitles Editor", "aegisub-3.2" },
	        { "Video4Linux Control", "v4l2ucp" },
	        { "VLC", "vlc" }, theme = { width = 150, height = 17, font = "Tamsyn 9" }
}
-- }}}
-- {{{ Sistema
mysystem = {
	  { "Aspetto", "lxappearance" },
	  { "Aspetto [#]", "sudo lxappearance" },
	  { "Bleachbit", "bleachbit" },
	  { "Bleachbit [#]", "sudo bleachbit" },
	  -- { "dconf Editor", "dconf-editor" },
	  { "Gparted", "sudo gparted" },
	  { "Grub", "sudo grub-customizer" },
	  { "HardInfo", "hardinfo" },
	  { "Htop", tasks }, theme = { width = 107, height = 17, font = "Tamsyn 9" },
	  { "I-Nex", "i-nex" },
	  { "Schermo", "lxrandr" }
}
-- }}}
-- {{{ Ufficio
myoffice = {
	   { "Libreoffice", "libreoffice" },
	   { "Libreoffice Base", "libreoffice --base" },
	   { "Libreoffice Calc", "libreoffice --calc" },
	   { "Libreoffice Draw", "libreoffice --draw" },
	   { "Libreoffice Impress", "libreoffice --impress" },
	   { "Libreoffice Math", "libreoffice --math" },
	   { "Libreoffice Writer", "libreoffice --writer" },
	   { "Master PDF Editor", "/opt/masterpdfeditor/master-pdf-editor" },
	   { "Zathura", "zathura" }, theme = { width = 142, height = 17, font = "Tamsyn 9" }
}
-- }}}

-- {{{ Cartelle
myfilemanager = {
		{"Home", "dolphin /home/anakin" },
		{"Images", "dolphin /home/anakin/Image" },
		{"Musics", "dolphin /home/anakin/Musics" },
                {"Documents", "dolphin /home/anakin/Documents" },
                {"Dropbox", "dolphin /home/anakin/Dropbox" },
                {"Desktop", "dolphin /home/anakin/Desktop" },
		{"Video", "dolphin /home/anakin/Videos" }
	}
-- }}}

-- {{{ Menù Principale
mymainmenu = awful.menu({ items = {
					{ "Accessori", myacc, },
					{ "Grafica", mygraph, },
					{ "Internet", myinternet, },
					{ "Istruzione", myeducation, },
					{ "Multimedia", mymultimedia, },
					{ "Sistema", mysystem, },
					{ "Ufficio", myoffice, }},
                    theme = { width = 107, height = 17, font = "Tamsyn 9" }
                    })
-- }}}

-- {{{ Launcher
mylauncher = wibox.widget.imagebox()
mylauncher:set_image(beautiful.widget_arch)
mylauncher:buttons(awful.util.table.join(awful.button({ }, 1, function () mymainmenu:toggle() end )))
-- }}}
--}}}
-- {{{ Widgets
-- {{{ Clock & Calendar

mytextclock = awful.widget.textclock(blue .. "%a %d %b %y" .. coloff .. grey .. " > " .. coloff .. red .. "%I:%M %p" .. coloff)
mytextclockicon = wibox.widget.imagebox()
mytextclockicon:set_image(beautiful.widget_clock)
mytextclockicon:buttons(awful.util.table.join(awful.button({ }, 1, function () exec(lock) end)))

local calendar = nil
local offset = 0

function remove_calendar()
    if calendar ~= nil then
        naughty.destroy(calendar)
        calendar = nil
        offset = 0
    end
end

function add_calendar(inc_offset)
    local save_offset = offset
    remove_calendar()
    offset = save_offset + inc_offset
    local datespec = os.date("*t")
    datespec = datespec.year * 12 + datespec.month - 1 + offset
    datespec = (datespec % 12 + 1) .. " " .. math.floor(datespec / 12)
    local cal = awful.util.pread("cal -m " .. datespec)
    cal = string.gsub(cal, "^%s*(.-)%s*$", "%1")
    calendar = naughty.notify({
        text = string.format('<span font_desc="%s">%s</span>', font, cal),
        position = "top_right",
        fg = beautiful.fg_red,
        bg = beautiful.fg_black,
        timeout = 0,
        hover_timeout = 0.5,
        border_color = beautiful.border_tooltip,
        border_width = 1,
        -- opacity = 0.94,                             
        -- width = 135,
        -- height = 110,
    })
end

mytextclock:connect_signal('mouse::enter', function () add_calendar(0) end)
mytextclock:connect_signal('mouse::leave', function () remove_calendar() end)

mytextclock:buttons(awful.util.table.join(
       awful.button({ }, 1, function() add_calendar(1) end), 
       awful.button({ }, 3, function() add_calendar(-1) end),
       awful.button({ 'Shift' }, 1, function() add_calendar(12) end),
       awful.button({ 'Shift' }, 3, function() add_calendar(-12) end)))

-- }}}
-- {{{ Kernel Info

sysicon = wibox.widget.imagebox()
sysicon:set_image(beautiful.widget_sys)
sysicon:buttons(awful.util.table.join(awful.button({ }, 1, awesome.restart)))

syswidget = wibox.widget.textbox()
vicious.register(syswidget, vicious.widgets.os, magenta .. "$2" .. coloff)
syswidget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () drop("urxvt -name urxvt_drop -e tmux", "top", "center", 0.99, 0.35) end),
    awful.button({ }, 3, function () exec(root_terminal) end)))

local function dispmemo()
	local f, infos
	local capi = {
		mouse = mouse,
		screen = screen
	}

	f = io.popen( "cat ~/.memo" )
	infos = f:read("*all")
	f:close()

	showmemo = naughty.notify( {
		text	= infos,
		font    = font,
		fg = beautiful.fg_magenta,
        bg = beautiful.fg_black,
        timeout	= 0,
        hover_timeout = 0.5,
        position = "bottom_right",
        -- margin = 4,
        -- height = 33,
        -- width = 120,
        border_color = beautiful.border_tooltip,
        border_width = 1,
        -- opacity = 0.94,
		screen	= capi.mouse.screen })
end

-- syswidget:connect_signal('mouse::enter', function () dispmemo(path) end)
-- syswidget:connect_signal('mouse::leave', function () naughty.destroy(showmemo) end)

-- }}}
-- {{{ Battery
baticon = wibox.widget.imagebox()
baticon:set_image(beautiful.widget_batt)

--powermenu = awful.menu({items = {
--			     { "Auto" , function () awful.util.spawn("sudo cpufreq-set -r -g ondemand", false) end },
--			     { "Ondemand" , function () awful.util.spawn("sudo cpufreq-set -r -g ondemand", false) end },
--			     { "Powersave" , function () awful.util.spawn("sudo cpufreq-set -r -g powersave", false) end },
--			     { "Performance" , function () awful.util.spawn("sudo cpufreq-set -r -g performance", false) end }
--			  }
--		       })

batwidget = wibox.widget.textbox()
vicious.register( batwidget, vicious.widgets.bat, yellow .. "$1$2" .. coloff , 1, "BAT0" )
--baticon:buttons(awful.util.table.join(
--					 awful.button({ }, 1, function () powermenu:toggle() end )
--				   ))

--batwidget:buttons(awful.util.table.join(
--					 awful.button({ }, 1, function () powermenu:toggle() end )
--				   ))

local function dispbat()
	local f, infos
	local capi = {
		mouse = mouse,
		screen = screen
	}

	f = io.popen( "acpi -a && acpi" )
	infos = f:read("*all")
	f:close()

	showbatinfo = naughty.notify( {
		text	= infos,
		font    = font,
        fg = beautiful.fg_yellow,
        bg = beautiful.fg_black,
        timeout	= 0,
        hover_timeout = 0.5,
        position = "top_right",
        margin = 8,
        -- height = 50,
        -- width = 355,
        border_color = beautiful.border_tooltip,
        border_width = 1,
        -- opacity = 0.94,
		screen	= capi.mouse.screen })
end

batwidget:connect_signal('mouse::enter', function () dispbat(path) end)
batwidget:connect_signal('mouse::leave', function () naughty.destroy(showbatinfo) end)

-- }}}
-- {{{ Uptime

uptimeicon = wibox.widget.imagebox()
uptimeicon:set_image(beautiful.widget_uptime)
uptimewidget = wibox.widget.textbox()
vicious.register( uptimewidget, vicious.widgets.uptime, blue .. "$2.$3'" .. coloff)

-- }}}
-- {{{ Temp

tempicon = wibox.widget.imagebox()
tempicon:set_image(beautiful.widget_temp)
-- tempicon:buttons(awful.util.table.join(awful.button({ }, 1, function () exec(powertop) end)))

-- tempwidget = wibox.widget.textbox()
-- vicious.register(tempwidget, vicious.widgets.thermal, yellow .. "$1" .. coloff, 1, { "coretemp.2", "sys"} )

local function disptemp()
	local f, infos
	local capi = {
		mouse = mouse,
		screen = screen
	}

	f = io.popen( "sh ~/.scripts/temp" )
	infos = f:read("*all")
	f:close()

	showtempinfo = naughty.notify( {
		text	= infos,
		-- title	= "Temperatures",
		font    = font,
        fg = beautiful.fg_yellow,
        bg = beautiful.fg_black,
        timeout	= 0,
        hover_timeout = 0.5,
        position = "bottom_right",
        margin = 8,
        height = 95,
        width = 360,
        border_color = beautiful.border_tooltip,
        border_width = 1,
        -- opacity = 0.94,
		screen	= capi.mouse.screen })
end

-- temp = wibox.widget.textbox()
-- temp:set_markup( yellow .. 'temp' .. coloff )

tempicon:connect_signal('mouse::enter', function () disptemp(path) end)
tempicon:connect_signal('mouse::leave', function () naughty.destroy(showtempinfo) end)

-- }}}
-- {{{ Cpu
 
cpuicon = wibox.widget.imagebox()
cpuicon:set_image(beautiful.widget_cpu)
cpuwidget = wibox.widget.textbox()
vicious.register( cpuwidget, vicious.widgets.cpu, green .. "$1" .. coloff, 3)
cpuicon:buttons(awful.util.table.join(awful.button({ }, 1, function () exec(tasks) end)))

-- }}}
-- {{{ Ram

memicon = wibox.widget.imagebox()
memicon:set_image(beautiful.widget_mem)
memwidget = wibox.widget.textbox()
vicious.register(memwidget, vicious.widgets.mem, blue .. "$2" .. coloff, 3)
memicon:buttons(awful.util.table.join(awful.button({ }, 1, function () exec( scripts .. "clear-cache.sh", false ) end)))

local function dispmem()
	local f, infos
	local capi = {
		mouse = mouse,
		screen = screen
	}

	f = io.popen("free -m | grep total && free -m | grep Mem")
	infos = f:read("*all")
	f:close()

	showmeminfo = naughty.notify( {
		text	= infos,
		font    = font,
        fg = beautiful.fg_blue,
        bg = beautiful.fg_black,
        timeout	= 0,
        hover_timeout = 0.5,
        position = "bottom_right",
        -- margin = 10,
        -- height = 61,
        -- width = 540,
        border_color = beautiful.border_tooltip,
        border_width = 1,
        -- opacity = 0.94,
		screen	= capi.mouse.screen })
end

memwidget:connect_signal('mouse::enter', function () dispmem(path) end)
memwidget:connect_signal('mouse::leave', function () naughty.destroy(showmeminfo) end)

-- }}}
-- {{{ Hard Drives

fsicon = wibox.widget.imagebox()
fsicon:set_image(beautiful.widget_fs)
-- vicious.cache(vicious.widgets.fs)
fswidget = wibox.widget.textbox()
vicious.register(fswidget, vicious.widgets.fs, green .. "${/ used_p}" .. coloff, 10)

local function dispdisk()
	local f, infos
	local capi = {
		mouse = mouse,
		screen = screen
	}

	f = io.popen("dfc -d | grep /dev/sda && dfc -d | grep /dev/sdb")
	infos = f:read("*all")
	f:close()

	showdiskinfo = naughty.notify( {
		text	= infos,
        font    = font,
        fg = beautiful.fg_green,
        bg = beautiful.fg_black,
        timeout	= 0,
        hover_timeout = 0.5,
        position = "top_right",
        margin = 8,
        -- height = 70,
        -- width = 612,
        border_color = beautiful.border_tooltip,
        border_width = 1,
        -- opacity = 0.94,
		screen	= capi.mouse.screen })
end

fswidget:connect_signal('mouse::enter', function () dispdisk(path) end)
fswidget:connect_signal('mouse::leave', function () naughty.destroy(showdiskinfo) end)

--fsmenu = awful.menu({items = {
                --{ "+ All",  function () exec( scripts .. "mount-all",   false) end },
                --{ "- All",  function () exec( scripts .. "umount-all",  false) end },
                --{ "+ Disk", function () exec( scripts .. "mount-disk",  false) end },
                --{ "- Disk", function () exec( scripts .. "umount-disk", false) end },
                --{ "+ Usb",  function () exec( scripts .. "mount-usb",   false) end },
                --{ "- Usb",  function () exec( scripts .. "umount-usb",  false) end }}
        --})

fsicon:buttons(awful.util.table.join(
    -- awful.button({ }, 1, function () fsmenu:toggle() end ),
    awful.button({ }, 1, function () exec(fileman) end),
    awful.button({ }, 3, function () exec(cli_fileman) end)))

-- }}}
-- {{{ Volume

volicon = wibox.widget.imagebox()
volicon:set_image(beautiful.widget_vol)
volicon:buttons(awful.util.table.join(awful.button({ }, 1, function () exec( "pavucontrol" ) end)))

volumewidget = wibox.widget.textbox()
vicious.register( volumewidget, vicious.widgets.volume, red .. "$1" .. coloff, 1, "Master" )
volumewidget:buttons(awful.util.table.join(
    -- awful.button({ }, 1, function () exec( "amixer -q -D pulse set Master toggle", false ) end),
    -- awful.button({ }, 4, function () exec( "amixer -q -D pulse set Master 5%+ unmute", false )   end),
    -- awful.button({ }, 5, function () exec( "amixer -q -D pulse set Master 5%- unmute", false )   end)))
    awful.button({ }, 1, function () exec( scripts .. "dvol -t", false )   end),
    awful.button({ }, 4, function () exec( scripts .. "dvol -i 5", false ) end),
    awful.button({ }, 5, function () exec( scripts .. "dvol -d 5", false ) end)))

-- }}}
-- {{{ Net

netdownicon = wibox.widget.imagebox()
netdownicon:set_image(beautiful.widget_netdown)
netupicon = wibox.widget.imagebox()
netupicon:set_image(beautiful.widget_netup)

wifidowninfo = wibox.widget.textbox()
-- vicious.register(wifidowninfo, vicious.widgets.net, green .. "${eth0 down_kb}" .. coloff, 1)
vicious.register(wifidowninfo, vicious.widgets.net, green .. "${wlp2s0 down_kb}" .. coloff, 1)

wifiupinfo = wibox.widget.textbox()
-- vicious.register(wifiupinfo, vicious.widgets.net, red .. "${eth0 up_kb}" .. coloff, 1)
vicious.register(wifiupinfo, vicious.widgets.net, red .. "${wlp2s0 up_kb}" .. coloff, 1)

local function dispip()
	local f, infos
	local capi = {
		mouse = mouse,
		screen = screen
	}

	f = io.popen( "sh ~/.scripts/ip" )
	infos = f:read("*all")
	f:close()

	showip = naughty.notify( {
		text	= infos,
		font    = font,
		fg = beautiful.fg_green,
        bg = beautiful.fg_black,
        timeout	= 0,
        hover_timeout = 0.5,
        position = "bottom_right",
        margin = 5,
        -- height = 33,
        -- width = 120,
        border_color = beautiful.border_tooltip,
        border_width = 1,
        -- opacity = 0.94,
		screen	= capi.mouse.screen })
end

-- wifidowninfo:connect_signal('mouse::enter', function () dispip(path) end)
-- wifidowninfo:connect_signal('mouse::leave', function () naughty.destroy(showip) end)

local function dispdns()
	local f, infos
	local capi = {
		mouse = mouse,
		screen = screen
	}

	f = io.popen("cat /etc/resolv.conf | cut -c 12-18")
	infos = f:read("*all")
	f:close()

	showdns = naughty.notify( {
		text	= infos,
		font    = font,
		fg = beautiful.fg_red,
        bg = beautiful.fg_black,
        timeout	= 0,
        hover_timeout = 0.5,
        position = "bottom_right",
        margin = 5,
        border_color = beautiful.border_tooltip,
        border_width = 1,
        -- opacity = 0.94,
		screen	= capi.mouse.screen })
end

-- wifiupinfo:connect_signal('mouse::enter', function () dispdns(path) end)
-- wifiupinfo:connect_signal('mouse::leave', function () naughty.destroy(showdns) end)

-- netdownicon:buttons(awful.util.table.join(awful.button({ }, 1, function () exec( scripts .. "restartwifi", false ) end)))
-- netupicon:buttons(awful.util.table.join(
    -- awful.button({ }, 1, function () exec( scripts .. "setdnsgoogle", false ) end),
    -- awful.button({ }, 3, function () exec( scripts .. "setdnstor", false ) end)))

-- }}}
-- {{{ Mail

mailicon = wibox.widget.imagebox()
mailicon:set_image(beautiful.widget_mail)
mailicon:buttons(awful.util.table.join(
    awful.button({ }, 1, function () exec(mail_gui) end)))
    -- awful.button({ }, 3, function () exec(feed) end)))


-- mymail = wibox.widget.textbox()
-- notify_shown = false
-- vicious.register(mymail, vicious.widgets.gmail,
-- function (widget, args)
  -- notify_title = "Hai un nuovo messaggio"
  -- notify_text = '"' .. args["{subject}"] .. '"'
  -- if (args["{count}"] > 0) then
    
    -- if (notify_shown == false) then
      -- if (args["{count}"] > 1) then 
          -- notify_title = "Hai " .. args["{count}"] .. " nuovi messaggi"
          -- notify_text = 'Ultimo: "' .. args["{subject}"] .. '"'
      -- end
	    -- naughty.notify({
		-- title = notify_title,
        -- text = notify_text,
		-- font = font,
		-- fg = beautiful.fg_red,
        -- bg = beautiful.fg_black,
        -- timeout	= 10,
        -- position = "bottom_right",
        -- margin = 5,
        -- border_color = beautiful.border_tooltip,
        -- border_width = 1,
        -- run = function () exec(mail) end,
        -- icon = beautiful.widget_mail_notify })
        -- notify_shown = true
    -- end
    
    -- return yellow .. args["{count}"] .. coloff
  -- else
    -- notify_shown = false
    -- return yellow .. "0" .. coloff
  -- end
-- end, 60)


-- }}}
-- {{{ Pacman Updates

pacicon = wibox.widget.imagebox()
pacicon:set_image(beautiful.widget_pac)
pacwidget = wibox.widget.textbox()
vicious.register(pacwidget, vicious.widgets.pkg, magenta .. "$1" .. coloff, 60, "Arch")

local function updates()
    local f, infos
    local capi = {
        mouse = mouse,
        screen = screen
    }

    f = io.popen("sudo pacman -Qu")
    infos = f:read("*all")
    if infos == "" then
        infos = "Non ci sono aggiornamenti"
    end
    f:close()

    showpac = naughty.notify ( {
        text = infos,
		font    = font,
        fg = beautiful.fg_magenta,
        bg = beautiful.fg_black,
        timeout = 0,
        hover_timeout = 0.5,
        position = "bottom_right",
        -- run = function () exec(terminal .. " -e sudo pacman -Su") end,
        border_color = beautiful.border_tooltip,
        border_width = 1,
        -- opacity = 0.94,
        screen = capi.mouse.screen })
end

pacicon:connect_signal('mouse::enter', function () updates(path) end)
pacicon:connect_signal('mouse::leave', function () naughty.destroy(showpac) end)

pacicon:buttons(awful.util.table.join(awful.button({ }, 1, function () exec(update) end)))

-- }}}
-- {{{ Spacers

rbracket = wibox.widget.textbox()
rbracket:set_text(']')
lbracket = wibox.widget.textbox()
lbracket:set_text('[')


rbrack = wibox.widget.textbox()
rbrack:set_markup( grey .. '(' .. coloff )
lbrack = wibox.widget.textbox()
lbrack:set_markup( grey .. ')' .. coloff )

line = wibox.widget.textbox()
line:set_text('|')
slash = wibox.widget.textbox()
slash:set_text('/')
space = wibox.widget.textbox()
space:set_text(' ')
space2 = wibox.widget.textbox()
space2:set_text('  ')

-- }}}
-- }}}
-- {{{ Bars
-- {{{ Set Bars

mywibox = {}
mybottomwibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end))

-- }}}
-- {{{ Tasklist

mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     -- awful.button({ }, 3, function ()
                     --                            if instance then
                     --                                instance:hide()
                     --                                instance = nil
                     --                            else
                     --                                instance = awful.menu.clients({ width=400 })
                     --                            end
                     --                      end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do

mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

-- }}}
-- {{{ Promptbox
   
   mypromptbox[s] = awful.widget.prompt(red .. "Exec " .. coloff)

-- }}}za
-- {{{ Layoutbox
    
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                            awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                            awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                            awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                            awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))

-- }}}
-- {{{ Taglist
    
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

-- }}}
-- {{{ Wibox
-- {{{ Top

    mywibox[s] = awful.wibox({ position = "top", screen = s, border_width = 0, height = 20 })

    -- Widgets that are aligned to the left
    left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mytaglist[s])
    left_layout:add(space)
    left_layout:add(space2)
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(netdownicon)
    right_layout:add(wifidowninfo)
    right_layout:add(space2)
    right_layout:add(wifiupinfo)
    right_layout:add(netupicon)
    right_layout:add(space)
    -- right_layout:add(mailicon)
    -- right_layout:add(mymail)
    -- right_layout:add(space2)
    right_layout:add(pacicon)
    right_layout:add(pacwidget)
    right_layout:add(space2)
    right_layout:add(memicon)
    right_layout:add(memwidget)
    right_layout:add(space2)
    right_layout:add(cpuicon)
    right_layout:add(cpuwidget)
    right_layout:add(space2)
    right_layout:add(baticon)
    right_layout:add(batwidget)
    right_layout:add(space)
    right_layout:add(rbrack)
    right_layout:add(tempicon)
    right_layout:add(lbrack)
    right_layout:add(space)
    right_layout:add(volicon)
    right_layout:add(volumewidget)
    right_layout:add(space)
    right_layout:add(uptimeicon)
    right_layout:add(uptimewidget)
    right_layout:add(space)
    right_layout:add(fsicon)
    right_layout:add(fswidget)
    right_layout:add(space2)
    right_layout:add(syswidget)
    right_layout:add(space)
    right_layout:add(mytextclockicon)
    right_layout:add(mytextclock)
    right_layout:add(space)

    -- Now bring it all together
    layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
    
-- }}}
-- {{{ Bottom

    mybottomwibox[s] = awful.wibox({ position = "bottom", screen = s, border_width = 0, height = 20 })
    mybottomwibox[s].visible = true
    
    -- Widgets that are aligned to the left
    bottom_left_layout = wibox.layout.fixed.horizontal()
    bottom_left_layout:add(mylauncher)
    bottom_left_layout:add(space2) 

    -- Widgets that are aligned to the right
    bottom_right_layout = wibox.layout.fixed.horizontal()
    bottom_right_layout:add(space) 
    if s == 1 then bottom_right_layout:add(wibox.widget.systray()) end
    bottom_right_layout:add(space) 
    bottom_right_layout:add(mylayoutbox[s])
    bottom_right_layout:add(space) 
    bottom_right_layout:add(mypoweroff)

    -- Now bring it all together (with the tasklist in the middle)
    bottom_layout = wibox.layout.align.horizontal()
    bottom_layout:set_left(bottom_left_layout)
    bottom_layout:set_middle(mytasklist[s])
    bottom_layout:set_right(bottom_right_layout)
    mybottomwibox[s]:set_widget(bottom_layout)

end

-- }}}
-- }}}
-- }}}
-- {{{ Mouse Bindings

root.buttons(awful.util.table.join(
    -- awful.button({ }, 3, function () mymainmenu:toggle() end ),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

-- }}}
-- {{{ Key Bindings

globalkeys = awful.util.table.join(
    key({ modkey, control },    "Left",   awful.tag.viewprev       ),
    key({ modkey, control },    "Right",  awful.tag.viewnext       ),
    key({ altkey }, "d", revelation),
    key({ modkey },             "Left",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    key({ modkey },             "Right",
        function ()
            awful.client.focus.byidx(1)
            if client.focus then client.focus:raise() end
        end),

    -- Show/Hide Wibox
    key({ modkey }, "b", function ()
    mywibox[mouse.screen].visible       = not mywibox[mouse.screen].visible         end),   key({ modkey, altkey }, "b", function ()
    mywibox[mouse.screen].visible       = not mywibox[mouse.screen].visible
    mybottomwibox[mouse.screen].visible = not mybottomwibox[mouse.screen].visible   end),   key({ altkey },         "b", function ()
    mybottomwibox[mouse.screen].visible = not mybottomwibox[mouse.screen].visible   end),
    
    -- Dropdown Terminal
    key({ }, "F12", function () drop("urxvt -name urxvt_drop -e tmux", "top", "center", 0.99, 0.35) end),
    key({ control, shift }, "-", function () drop("urxvt -name urxvt_drop", "bottom", "right", 0.20, 0.10) end),

    -- Layout manipulation
    key({ modkey, altkey },     "Right",            function () awful.client.swap.byidx(  1)                                        end),
    key({ modkey, altkey },     "Left",             function () awful.client.swap.byidx( -1)                                        end),
    key({ altkey },             "l",                function () awful.tag.incmwfact( 0.05)                                          end),
    key({ altkey },             "k",                function () awful.tag.incmwfact(-0.05)                                          end),
    key({ modkey, shift },      "h",                function () awful.tag.incnmaster( 1)                                            end),
    key({ modkey, shift },      "l",                function () awful.tag.incnmaster(-1)                                            end),
    key({ modkey, control },    "h",                function () awful.tag.incncol( 1)                                               end),
    key({ modkey, control },    "l",                function () awful.tag.incncol(-1)                                               end),
    key({ modkey },             "space",            function () awful.layout.inc(layouts,  1)                                       end),
    key({ modkey, shift },      "space",            function () awful.layout.inc(layouts, -1)                                       end),
    -- key({ control },            ",",                function () exec( "keynav start", false )                                       end),
    -- Volume control
    key({ modkey, altkey },     "Up",               function () exec( "amixer -q -D pulse set Master 5%+ unmute", false )                         end),
    key({ modkey, altkey },     "Down",             function () exec( "amixer -q -D pulse set Master 5%- unmute", false )                         end),
    key({ altkey },             "0",                function () exec( "amixer -q -D pulse set Master toggle", false )                       end),
    -- Music control
    key({ altkey },             "Up",               function () exec( "mpc toggle", false )                                         end),
    key({ altkey },             "Down",             function () exec( "mpc stop", false )                                           end),
    key({ altkey },             "Left",             function () exec( "mpc prev", false )                                           end),
    key({ altkey },             "Right",            function () exec( "mpc next", false )                                           end),
    key({ altkey },             ",",                function () exec( "mpc random", false )                                         end),
    key({ modkey },             "Up",               function () exec( "sudo systemctl start mpd", false )                           end),
    key({ modkey },             "Down",             function () exec( "sudo systemctl stop mpd", false )                            end),
    -- Control Brightness
    key({ control },            "9",                function () exec( " sudo " .. scripts .. "Brightness/brightness0", false )      end),
    key({ control },            "1",                function () exec( " sudo " .. scripts .. "Brightness/brightness1", false )      end),
    key({ control },            "2",                function () exec( " sudo " .. scripts .. "Brightness/brightness2", false )      end),
    key({ control },            "3",                function () exec( " sudo " .. scripts .. "Brightness/brightness3", false )      end),
    key({ control },            "4",                function () exec( " sudo " .. scripts .. "Brightness/brightness4", false )      end),
    key({ control },            "5",                function () exec( " sudo " .. scripts .. "Brightness/brightness5", false )      end),
    key({ control },            "6",                function () exec( " sudo " .. scripts .. "Brightness/brightness6", false )      end),
    key({ control },            "7",                function () exec( " sudo " .. scripts .. "Brightness/brightness7", false )      end),
    key({ control },            "8",                function () exec( " sudo " .. scripts .. "Brightness/brightness8", false )      end),
    -- Applications
    -- key({ modkey },             "j",                function () exec( " sudo " .. scripts .. "starttor", false )                    end),
    -- key({ modkey, altkey },     "j",                function () exec( " sudo " .. scripts .. "stoptor", false )                     end),
    -- key({ altkey },             "v",                function () exec( scripts .. "connect", false)                                  end),
    -- key({ altkey },             "g",                function () exec( scripts .. "disconnect", false)                               end),
    key({ modkey },             "j",                function () exec( " xfdesktop " )                                               end),
    key({ modkey, altkey },     "j",                function () exec( " sudo killall xfdesktop " )                                  end),
    key({ modkey, shift },      "x",                function () exec( scripts .. "xprop", false )                                   end),
    key({ modkey },             "m",                function () exec( scripts .. "start-motion", false )                            end),
    key({ modkey, altkey },     "m",                function () exec( scripts .. "stop-motion", false )                             end),
    key({ modkey },             "u",                function () exec( scripts .. "webcam", false )                                  end),
    key({ altkey },             "u",                function () exec( scripts .. "small-webcam", false )                            end),
    key({ modkey, altkey },     "u",                function () exec( scripts .. "wxcam", false )                                   end),
    key({ modkey, control },    "r",                function () exec( scripts .. "restartwifi", false )                             end),
    key({ modkey, shift },      "f",                function () exec( scripts .. "setsmallfont", false )                            end),
    key({ modkey, shift },      "g",                function () exec( scripts .. "setbigfont", false )                              end),
    key({ modkey },             "i",                function () exec( scripts .. "mount-usb", false )                               end),
    key({ modkey, altkey },     "i",                function () exec( scripts .. "umount-usb", false )                              end),
    key({ altkey },             "i",                function () exec( "udiskie -anqs", false )                                      end),
    key({ modkey },             "Return",           function () exec( terminale )                                                    end),
    -- key({ control },            "Return",           function () exec( small_terminal )                                              end),
    key({ modkey, altkey },     "Return",           function () exec( root_terminal )                                               end),
    key({ modkey },             "w",                function () exec( browser1 )                                                    end),
    -- key({ modkey },             "i",                function () exec( browser2 )                                                    end),
    key({ modkey, altkey },     "w",                function () exec( browser2 )                                                    end),
    key({ modkey },             "e",                function () exec( cli_browser )                                                 end),
    key({ modkey, control },    "u",                function () exec( update )                                                      end),
    key({ modkey },             "n",                function () exec( music )                                                       end),
    -- key({ modkey, altkey },     "n",                function () exec( musica )                                                      end),
    -- key({ modkey, shift },      "n",                function () exec( musicinfo )                                                   end),
    key({ altkey },             "p",                function () exec( "remotedroid-server", false )                                 end),
    key({ modkey, altkey },     "c",                function () exec( chat )                                                        end),
    key({ modkey },             "v",                function () exec( torrent )                                                     end),
    key({ modkey },             "h",                function () exec( tasks )                                                       end),
    key({ modkey, altkey },     "h",                function () exec( "ksysguard", false )                                          end),
    key({ modkey },             "t",                function () exec( mail_gui )                                                    end),
    -- key({ modkey, altkey },     "t",                function () exec( mail_gui )                                                    end),
    key({ modkey },             "y",                function () exec( youtube )                                                     end),
    key({ altkey },             "y",                function () exec( youtube2mp3 )                                                 end),
    key({ modkey },             "a",                function () exec( abook )                                                       end),
    key({ modkey },             "p",                function () exec( fileman .. home )                                             end),
    key({ modkey, altkey },     "p",                function () exec( root_fileman )                                                end),
    key({ altkey },             "p",                function () exec( "pavucontrol", false )                                        end),
    key({ modkey, control },    "p",                function () exec( "systemsettings", false )                                     end),
    key({ modkey },             "g",                function () exec( gui_editor )                                                  end),
    key({ altkey },             "e",                function () exec( cli_editor )                                                  end),
    key({ modkey },             "f",                function () exec( cli_fileman )                                                 end),
    key({ modkey, altkey },     "f",                function () exec( cli_root_fileman )                                            end),
    -- key({ altkey },             "p",                function () exec pandora )                                                     end),
    key({ control },            "space",            function () exec( cli_editor .. " /home/luca/.memo " )                          end),
    -- key({ control },            "c",                function () os.execute("xsel -p -o | xsel -i -b")                               end),
    key({ modkey },             "d",                function () exec( "dropbox start", false )                                      end),
    key({ modkey, altkey },     "d",                function () exec( "dropbox stop", false )                                       end),
    -- key({ modkey, altkey },     "h",                function () exec( "xfce4-taskmanager" )                                         end),
    key({ modkey },             "i",                function () exec( "xbmc", false )                                               end),
    key({ modkey, altkey },     "v",                function () exec( "torrent-search", false )                                     end),
    key({ altkey },             "Return",           function () exec( "mplayer dvd://1 -dvd-device /dev/sr0", false )               end),
    key({ control, altkey },    "Return",           function () exec( "vlc /dev/sr0", false )                                       end),
    key({ control },            "k",                function () exec( "keepass", false )                                            end),
    key({ modkey },             "k",                function () exec( "kodi", false )                                               end),
    key({ modkey, altkey },     "k",                function () exec( "nowvideo-vlc", false )                                       end),
    -- key({ modkey },             "s",                function () exec( "nitrogen", false )                                           end),
    key({ modkey, altkey },     "s",                function () exec( "sh .fehbg", false )                                          end),
    key({ modkey, altkey },     "g",                function () exec( "marble-mobile", false )                                      end),
    -- key({ modkey, altkey },     "g",                function () exec( "google-earth6 -fn -xos4-terminus-medium-r-normal--12-120-72-72-c-60-iso8859-9", false ) end),
    -- Take A Screenshot
    key({ },                    "Print",            function () exec( scripts .. "scrot", false ) end),
    -- Exit
    key({ modkey },             "x",                function () exec( "xkill", false )                                              end),
    
    -- key({ },                    "XF86PowerOff",     function () exec( "kshutdown -h", false )                                       end),
    -- key({ altkey },             "q",                function () exec( "kshutdown -r", false )                                       end),
    -- key({ modkey },             "q",                function () exec( "kshutdown -l", false )                                       end),
    
    key({ },                    "XF86PowerOff",     function () exec( "sudo systemctl poweroff", false )                            end),
    key({ altkey },             "q",                function () exec( "sudo systemctl reboot", false )                              end),
    -- key({ modkey, altkey },     "q",                function () exec( scripts .. "switchtoopenboxfromawesome", false )              end),
    key({ modkey },             "q",                awesome.quit),

    key({ modkey },             "r",                awesome.restart),
    
    key({ modkey },     "l",                        function () exec(lock)  end),
    -- key({ modkey },             "l",                function () exec(slimlock)                                           end),
    -- key({ control, altkey },    "l",                function () exec( "xset dpms force off", false )                                end),
    
    -- Prompt
    key({ altkey },             "r",                function () mypromptbox[mouse.screen]:run() end),
    key({ altkey },             "m",                function () exec( "dmenu_run -b -nb '#080808' -nf '#aaaaaa' -sf '#778baf' -sb '#080808' -fn '-*-tamsyn-medium-r-normal-*-14-*-*-*-*-*-*-*' -f -h 20 -p 'run application:'", false) end),
    key({ altkey },             "n",                function () exec( "sudo dmenu_run -b -nb '#080808' -nf '#aaaaaa' -sf '#ce5666' -sb '#080808' -fn '*-tamsyn-medium-r-normal-*-14-*-*-*-*-*-*-*' -f -h 20 -p 'run application as root:'", false) end),
    
    key({ altkey },             "w",
            function ()
                awful.prompt.run({ prompt = yellow .. "search " .. coloff},
                mypromptbox[mouse.screen].widget,
	            function (command) exec( browser1 .. " 'https://duckduckgo.com/?q=!"..command.."' " )
	        end)
        end)
)

clientkeys = awful.util.table.join(
    key({ altkey },             "f",                function (c) c.fullscreen = not c.fullscreen    end),
    key({ modkey },             "c",                function (c) c:kill()                           end),
    key({ modkey, control },    "space",            awful.client.floating.toggle                       ),
    key({ modkey, control },    "Return",           function (c) c:swap(awful.client.getmaster())   end),
    key({ control },            "t",                function (c) c.ontop = not c.ontop              end),
    key({ control },            ".",                function (c) c.sticky = not c.sticky            end),
    key({ control, shift },     "Down",             function (c) c.minimized = not c.minimized      end))
    -- key({ control },            ",",
        -- function (c)
            -- c.maximized_horizontal = not c.maximized_horizontal
            -- c.maximized_vertical   = not c.maximized_vertical
        -- end)
-- )

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        key({ modkey }, "#" .. i + 9,
                  function ()
                        screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        key({ modkey, control }, "#" .. i + 9,
                  function ()
                      screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        key({ modkey, shift }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        key({ modkey, control, shift }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)

-- }}}
-- {{{ Rules

awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     maximized_vertical = false,
                     maximized_horizontal = false,
                     buttons = clientbuttons,
	                 size_hints_honor = false
                    }
    },
    -- { rule = { class    = "URxvt" },                                     properties = { tag = tags[1][1], switchtotag = true, opacity = 0.94 } },
    { rule = { class    = "URxvt" },                                     properties = { tag = tags[1][1], switchtotag = true } },
    { rule = { class    = "URxvt", name = "Root File Manager"},          properties = { tag = tags[1][3], switchtotag = true } },
    { rule = { class    = "URxvt", name = "Terminal" },                  properties = { tag = tags[1][1], switchtotag = true } },
    { rule = { class    = "URxvt", name = "Root Terminal" },             properties = { tag = tags[1][1], switchtotag = true } },
    { rule = { class    = "URxvt", name = "saidar" },                    properties = { tag = tags[1][6], switchtotag = true,   floating = true } },
    { rule = { class    = "URxvt", name = "Music" },                     properties = { tag = tags[1][5], switchtotag = true } },
    { rule = { class    = "URxvt", name = "Mail" },                      properties = { tag = tags[1][4], switchtotag = false } },
    { rule = { class    = "URxvt", name = "Chat" },                      properties = { tag = tags[1][4], switchtotag = true } },
    { rule = { class    = "URxvt", name = "Torrent" },                   properties = { tag = tags[1][3], switchtotag = true } },
    { rule = { class    = "URxvt", name = "Feed" },                      properties = { tag = tags[1][4], switchtotag = true } },
    { rule = { class    = "URxvt", name = "File Manager" },              properties = { tag = tags[1][3], switchtotag = true } },
    { rule = { class    = "URxvt", name = "ranger:~" },                  properties = { tag = tags[1][3], switchtotag = true } },
    { rule = { class    = "URxvt", name = "Youtube" },                   properties = { tag = tags[1][3], switchtotag = true } },
    { rule = { class    = "URxvt", name = "Youtube2mp3" },               properties = { tag = tags[1][3], switchtotag = true } },
    { rule = { class    = "URxvt", name = "Abook" },                     properties = { tag = tags[1][4], switchtotag = true } },
    { rule = { class    = "URxvt", name = "Elinks" },                    properties = { tag = tags[1][2], switchtotag = true } },
    { rule = { class    = "URxvt", name = "Updating" },                  properties = { tag = tags[1][6], switchtotag = false } },
    { rule = { class    = "URxvt", instance = "urxvt_drop" },            properties = { tag = tags[1][6], switchtotag = false, sticky = true } },
    { rule = { class    = "URxvt", name = "http://duckduckgo.com/lite DuckDuckGo - ELinks" }, properties = { tag = tags[1][2], switchtotag = true } },
    { rule = { class    = "Firefox" },                                   properties = { tag = tags[1][2], floating = false } },
    { rule = { class    = "Firefox" , instance = "DTA" },                properties = { tag = tags[1][2], floating = true } },
    { rule = { class    = "Firefox" , instance = "Toplevel" },           properties = { tag = tags[1][2], floating = true, sticky = true, ontop = true } },
    { rule = { class    = "Firefox" , instance = "Browser" },            properties = { tag = tags[1][2], floating = true, sticky = true, ontop = true } },
    { rule = { class    = "Firefox" , instance = "Download" },           properties = { tag = tags[1][2], floating = true, sticky = true, ontop = true } },
    { rule = { class    = "Firefox" , instance = "Dialog" },             properties = { tag = tags[1][2], floating = true, sticky = true, ontop = true } },
    { rule = { instance = "plugin-container" },                          properties = { floating = true } },
    { rule = { class    = "Firefox" , name = "Install user style" },     properties = { tag = tags[1][2], floating = true } },
    { rule = { class    = "Firefox" , name = "Installazione software" }, properties = { tag = tags[1][2], floating = true } },
    { rule = { class    = "Firefox" , name = "Options" },                properties = { tag = tags[1][2], floating = true, sticky = true, ontop = true } },
    { rule = { class    = "Firefox" , name = "Nuovo stile" },            properties = { tag = tags[1][2], floating = true, ontop = true } },
    { rule = { class    = "Firefox" , name = "Libreria" },               properties = { tag = tags[1][2], floating = true, ontop = true } },
    { rule = { instance = "Foxmarks" },                                  properties = { tag = tags[1][2], floating = true, ontop = true } },
    { rule = { class    = "chromium" },                                  properties = { tag = tags[1][2], switchtotag = true, floating = false } },
    { rule = { class    = "chromium", name = "Dropbox Chooser - Chromium" }, properties = { tag = tags[1][2], floating = true } },
    { rule = { class    = "Thunar" },                                    properties = { tag = tags[1][3], switchtotag = true } },
    { rule = { class    = "Thunar", name = "Avanzamento delle operazione sui file" }, properties = { tag = tags[1][3], floating = true } },
    { rule = { class    = "libreoffice-impress" },                       properties = { tag = tags[1][6], switchtotag = true } },
    { rule = { class    = "libreoffice-startcenter" },                   properties = { tag = tags[1][6], switchtotag = true } },
    { rule = { class    = "libreoffice-writer" },                        properties = { tag = tags[1][6], switchtotag = true } },
    { rule = { class    = "libreoffice-math" },                          properties = { tag = tags[1][6], switchtotag = true } },
    { rule = { class    = "libreoffice-calc" },                          properties = { tag = tags[1][6], switchtotag = true } },
    { rule = { class    = "I-nex" },                                     properties = { tag = tags[1][6], switchtotag = true, floating = true } },
    { rule = { class    = "Hardinfo" },                                  properties = { tag = tags[1][6], switchtotag = true } },
    { rule = { class    = "Xmessage" },                                  properties = { tag = tags[1][1], switchtotag = false,  floating = true, sticky = true, ontop = true } },
    { rule = { class    = "XFontSel" },                                  properties = { tag = tags[1][1], switchtotag = false,  floating = true, sticky = true } },
    { rule = { class    = "Vlc" },                                       properties = { tag = tags[1][5], switchtotag = true } },
    { rule = { class    = "Vlc", name = "Playlist" },                    properties = { tag = tags[1][5], switchtotag = true,   floating = true } },
    { rule = { class    = "mplayer2" },                                  properties = { tag = tags[1][5], switchtotag = true } },
    { rule = { class    = "mplayer2", name = "Webcam" },                 properties = { tag = tags[1][5], switchtotag = true,   floating = true } },
    { rule = { class    = "mplayer2", name = "Small Webcam" },           properties = { tag = tags[1][5], switchtotag = false,  floating = true, sticky = true, ontop = true } },
    { rule = { class    = "Xfce4-notifyd" },                             properties = { tag = tags[1][5], switchtotag = false,  floating = true, sticky = true, ontop = false, border_width = 0 } },
    { rule = { class    = "nuvolaplayer3" },                             properties = { tag = tags[1][5], switchtotag = true,  floating = false } },
    { rule = { class    = "Spotify" },                                   properties = { tag = tags[1][5], switchtotag = true,  floating = false } },
    { rule = { class    = "Zathura" },                                   properties = { tag = tags[1][6], switchtotag = true,   floating = false } },
    { rule = { class    = "Lxappearance" },                              properties = { tag = tags[1][6], switchtotag = true,   floating = true } },
    { rule = { class    = "Viewnior" },                                  properties = { tag = tags[1][5], switchtotag = true } },
    { rule = { class    = "feh" },                                       properties = { tag = tags[1][5], switchtotag = true } },
    { rule = { class    = "Convertall.py" },                             properties = { tag = tags[1][6], switchtotag = true } },
    { rule = { class    = "Gelemental" },                                properties = { tag = tags[1][6], switchtotag = true, floating = true } },
    { rule = { class    = "Gpartedbin" },                                properties = { tag = tags[1][3], switchtotag = true } },
    { rule = { class    = "Geany" },                                     properties = { tag = tags[1][3], switchtotag = true } },
    { rule = { class    = "Exe", name = "exe" },                         properties = { tag = tags[1][2], floating    = true } },
    -- { rule = { instance = "sun-awt-X11-XFramePeer" },                    properties = { tag = tags[1][6], floating = true, minimized = true } },
    { rule = { class    = "Gimp" },                                      properties = { tag = tags[1][6] } },
    { rule = { class    = "MyPaint" },                                   properties = { tag = tags[1][6], switchtotag = true } },
    { rule = { class    = "MyPaint", name = "Colori" },                  properties = { tag = tags[1][6], floating = false } },
    { rule = { class    = "MyPaint", name = "Pennelli" },                properties = { tag = tags[1][6], floating = false } },
    { rule = { class    = "Marble-mobile" },                             properties = { tag = tags[1][6], switchtotag = true } },
    { rule = { class    = "Marble" },                                    properties = { tag = tags[1][6], switchtotag = true } },
    { rule = { class    = "Googleearth-bin" },                           properties = { tag = tags[1][6], switchtotag = true } },
    { rule = { class    = "Kodi" },                                      properties = { tag = tags[1][7], switchtotag = false, ontop = true, border = false } },
    { rule = { class    = "Qalculate-gtk" },                             properties = { tag = tags[1][6], switchtotag = true, floating = true } },
    { rule = { class    = "Pavucontrol" },                               properties = { tag = tags[1][6], switchtotag = true, floating = true } },
    { rule = { class    = "V4l2ucp" },                                   properties = { tag = tags[1][6], switchtotag = true, floating = true } },
    { rule = { class    = "Popcorntime" },                               properties = { tag = tags[1][6], switchtotag = true } },
    { rule = { class    = "Grub-customizer" },                           properties = { tag = tags[1][6], switchtotag = true } },
    { rule = { class    = "KeePass2" },                                  properties = { tag = tags[1][6], switchtotag = true } },
    { rule = { class    = "Skype" },                                     properties = { tag = tags[1][4], switchtotag = true, floating = true } },
    { rule = { class    = "ViberPC" },                                   properties = { tag = tags[1][4], switchtotag = true } },
    { rule = { class    = "Thunderbird" },                               properties = { tag = tags[1][4] } },
    { rule = { class    = "Torrent-search" },                            properties = { tag = tags[1][3] } },
    { rule = { class    = "Xfdesktop", instance = "xfdesktop", name = "Scrivania" }, properties = { tag = tags[1][8], maximized_vertical = true, border_width = 0, focus = false, switchtotag = false, ontop = false, sticky = true } },
    { rule = { class    = "Xfdesktop-settings", instance = "xfdesktop-settings", name = "Scrivania" }, properties = { tag = tags[1][6], maximized_vertical = false, border_width = 1, focus = true, switchtotag = true, ontop = false, sticky = false, floating = true } },
}

-- }}}
-- {{{ Signals

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog")
                         and not (c.instance == "urxvt_drop")
                         and not (c.class    == "Spotify")
                         and not (c.class    == "chromium")
                         and not (c.class    == "Thunderbird")
                         and not (c.class    == "Xfce4-notifyd")
                         and not (c.class    == "Marble-qt")
                         and not (c.class    == "Marble-mobile")
                         and not (c.class    == "Xmessage")
                         and not (c.class    == "Plugin-container")
                         and not (c.class    == "Firefox")
                         and not (c.name     == "Updating")
                         then
        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(space)
        -- left_layout:add(awful.titlebar.widget.iconwidget(c))

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local title = awful.titlebar.widget.titlewidget(c)
        title:buttons(awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                ))

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(title)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- }}}
