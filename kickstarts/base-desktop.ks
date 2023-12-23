# base-desktop.ks
#
# Defines the basics for a basic desktop environment.

%include base.ks

repo --name=fedora-cisco-openh264 --metalink=https://mirrors.fedoraproject.org/metalink?repo=fedora-cisco-openh264-$releasever&arch=$basearch

firewall --enabled --service=mdns

%packages --excludeWeakdeps

# Common modules (see fedora-workstation-common.ks)
# Xorg modules (see @base-x)
xorg-x11-server-Xorg
xorg-x11-xauth
xorg-x11-xinit

# Xorg drivers (see @base-x)
libva-vdpau-driver
libvdpau-va-gl
mesa-dri-drivers
mesa-omx-drivers
mesa-vulkan-drivers
xorg-x11-drivers
xorg-x11-drv-amdgpu

# Xorg utils (see @base-x)
egl-utils
glx-utils
vulkan-tools
xdpyinfo
xprop
xrandr

# Core modules (see @core)
dnf
dnf-plugins-core
fwupd
grubby
sudo
# systemd-oomd-defaults
systemd-resolved
util-linux
zram-generator-defaults

# Common utilities
bash-completion
bind-utils
btrfs-progs
less
net-tools
psmisc

# Fonts
google-noto-sans-fonts
google-noto-sans-mono-fonts
google-noto-serif-fonts
google-noto-emoji-fonts

# Hardware support
@hardware-support
linux-firmware
microcode_ctl

# Multimedia
PackageKit-gstreamer-plugin
alsa-utils
gstreamer1-plugin-libav			# FFmpeg/LibAV GStreamer plugin
gstreamer1-plugin-openh264
gstreamer1-plugins-bad-free
gstreamer1-plugins-good
gstreamer1-plugins-ugly-free
libjxl							# Library files for JPEG-XL
pipewire-alsa
pipewire-gstreamer
pipewire-jack-audio-connection-kit
pipewire-pulseaudio
pipewire-utils

# Networking
NetworkManager-wifi
firewalld
firewall-config

# Software
flatpak

# System
plymouth-scripts
plymouth-theme-spinner
rpm-plugin-systemd-inhibit

# Tools
clinfo
exfatprogs
htop
nano-default-editor
neofetch
rsync
unar

%end


%post

echo ""
echo "POST BASE DESKTOP ************************************"
echo ""

# Antialiasing by default.
# Set Noto fonts as preferred family.
cat > /etc/fonts/local.conf << EOF_FONTS
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>

<!-- Settins for better font rendering -->
<match target="font">
	<edit mode="assign" name="rgba"><const>rgb</const></edit>
	<edit mode="assign" name="hinting"><bool>true</bool></edit>
	<edit mode="assign" name="hintstyle"><const>hintfull</const></edit>
	<edit mode="assign" name="antialias"><bool>true</bool></edit>
	<edit mode="assign" name="lcdfilter"><const>lcddefault</const></edit>
</match>

<!-- Local default fonts -->
<!-- Serif faces -->
	<alias>
		<family>serif</family>
		<prefer>
			<family>Noto Serif</family>
			<family>DejaVu Serif</family>
			<family>Liberation Serif</family>
		</prefer>
	</alias>
<!-- Sans-serif faces -->
	<alias>
		<family>sans-serif</family>
		<prefer>
			<family>Noto Sans</family>
			<family>DejaVu Sans</family>
			<family>Liberation Sans</family>
		</prefer>
	</alias>
<!-- Monospace faces -->
	<alias>
		<family>monospace</family>
		<prefer>
			<family>Noto Sans Mono</family>
			<family>DejaVu Sans Mono</family>
			<family>Liberation Mono</family>
		</prefer>
	</alias>
</fontconfig>
EOF_FONTS

# Set a colored prompt
cat > /etc/profile.d/color-prompt.sh << EOF_PROMPT
## Colored prompt
if [ -n "\$PS1" ]; then
	if [[ "\$TERM" == *256color ]]; then
		if [ \${UID} -eq 0 ]; then
			PS1='\[\e[91m\]\u@\h \[\e[93m\]\W\[\e[0m\]\\$ '
		else
			PS1='\[\e[94m\]\u@\h \[\e[93m\]\W\[\e[0m\]\\$ '
		fi
	else
		if [ \${UID} -eq 0 ]; then
			PS1='\[\e[31m\]\u@\h \[\e[33m\]\W\[\e[0m\]\\$ '
		else
			PS1='\[\e[34m\]\u@\h \[\e[33m\]\W\[\e[0m\]\\$ '
		fi
	fi
fi
EOF_PROMPT

# Sets a default grub config if not present (rhb #886502)
# Provides some reasonable defaults when the bootloader is not installed
if [ ! -f "/etc/default/grub" ]; then
cat > /etc/default/grub << EOF_DEFAULT_GRUB
GRUB_TIMEOUT=3
GRUB_DISTRIBUTOR="\$(sed 's, release .*\$,,g' /etc/system-release)"
GRUB_DEFAULT=saved
GRUB_CMDLINE_LINUX="rd.md=0 rd.dm=0 rd.luks=0 rhgb quiet"
GRUB_DISABLE_RECOVERY=false
# GRUB_DISABLE_OS_PROBER=true
EOF_DEFAULT_GRUB
fi

# Disable weak dependencies to avoid unwanted stuff
echo "install_weak_deps=False" >> /etc/dnf/dnf.conf

# Set default boot theme
/usr/sbin/plymouth-set-default-theme spinner

# Enable Cisco Open H.264 repository
dnf config-manager --set-enabled fedora-cisco-openh264

%end
