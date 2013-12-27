## f19-base-desktop.ks

%include f19-base.ks

%packages

# Unwanted stuff
-PackageKit-command*
-abrt*
-bash-completion*
-fedora-release-notes
-fpaste
-initial-setup
-prelink
-rsyslog
-sendmail

# Audio
alsa-plugins-pulseaudio
alsa-utils
pulseaudio
pulseaudio-module-x11
pulseaudio-utils

# Boot tools
cryptsetup
grub2
grub2-efi
grub2-tools
syslinux

# Fonts
dejavu-sans-*
dejavu-serif-*
liberation-mono-fonts
liberation-s*-fonts

# Input methods
ibus-m17n
ibus-rawcode

# System config
firewall-config
system-config-date
system-config-keyboard
system-config-users

# Tools
htop
hunspell-it
vim-enhanced
yum-plugin-fastestmirror

%end


%post

echo ""
echo "*****************"
echo "POST BASE DESKTOP"
echo "*****************"

# Enable journald storage persistency (instead of rsyslog)
# mkdir -p /var/log/journal

# Antialiasing by default
# ln -sf /usr/share/fontconfig/conf.avail/10-autohint.conf /etc/fonts/conf.d/

# Set DejaVu fonts as preferred family
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
			<family>DejaVu Serif</family>
			<family>Liberation Serif</family>
			<family>Bitstream Vera Serif</family>
			<family>Times New Roman</family>
			<family>Luxi Serif</family>
			<family>Nimbus Roman No9 L</family>
			<family>Times</family>
		</prefer>
	</alias>
<!-- Sans-serif faces -->
	<alias>
		<family>sans-serif</family>
		<prefer>
			<family>DejaVu Sans</family>
			<family>Liberation Sans</family>
			<family>Bitstream Vera Sans</family>
			<family>Verdana</family>
			<family>Arial</family>
			<family>Luxi Sans</family>
			<family>Nimbus Sans L</family>
			<family>Helvetica</family>
			<family>Tahoma</family>
		</prefer>
	</alias>
<!-- Monospace faces -->
	<alias>
		<family>monospace</family>
		<prefer>
			<family>DejaVu Sans Mono</family>
			<family>Liberation Mono</family>
			<family>Bitstream Vera Sans Mono</family>
			<family>Courier New</family>
			<family>Andale Mono</family>
			<family>Luxi Mono</family>
			<family>Nimbus Mono L</family>
			<family>Courier</family>
		</prefer>
	</alias>
</fontconfig>
EOF_FONTS

cat > /etc/profile.d/color-prompt.sh << EOF_SHELL
## Colored prompt
if [ -n "\$PS1" ]; then
        if [ \${UID} -eq 0 ]; then
                PS1='\[\e[31m\]\u@\h \[\e[33m\]\W\[\e[0m\]\\$ '
        else
                PS1='\[\e[32m\]\u@\h \[\e[33m\]\W\[\e[0m\]\\$ '
        fi
fi
EOF_SHELL

# Set a default grub config if not present (rhb #886502)
if [ ! -f "/etc/default/grub" ]; then
cat > /etc/default/grub << EOF_DEFAULT_GRUB
GRUB_TIMEOUT=3
GRUB_DISTRIBUTOR="\$(sed 's, release .*\$,,g' /etc/system-release)"
GRUB_DEFAULT=saved
GRUB_CMDLINE_LINUX="rd.md=0 rd.dm=0 rd.luks=0 rhgb quiet"
GRUB_DISABLE_RECOVERY="true"
EOF_DEFAULT_GRUB
fi

cat >> /etc/rc.d/init.d/livesys << EOF_LIVESYS

# Force italian keyboard layout (rhb #982394)
system-config-keyboard --noui it
EOF_LIVESYS

%end
