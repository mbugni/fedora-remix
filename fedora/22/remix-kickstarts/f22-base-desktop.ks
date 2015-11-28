## f22-base-desktop.ks

%include f22-base.ks

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

# Fonts
google-noto-sans-fonts
google-noto-serif-fonts
google-droid-sans-mono-fonts
liberation-mono-fonts
liberation-s*-fonts

# Tools
@networkmanager-submodules
fedora-release-workstation
htop
hunspell-it
vim-enhanced
system-config-date
system-config-users

# Package management
dnf-langpacks
dnf-plugins-core
dnf-yum
-yum*

%end


%post

echo ""
echo "*****************"
echo "POST BASE DESKTOP"
echo "*****************"

# Enable journald storage persistency (instead of rsyslog)
# mkdir -p /var/log/journal

# Antialiasing by default.
# Set DejaVu fonts as preferred family.
cat > /etc/fonts/local.conf << EOF_FONTS
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>

<!-- Settins for better font rendering -->
<match target="font">
	<edit mode="assign" name="rgba"><const>rgb</const></edit>
	<edit mode="assign" name="hinting"><bool>true</bool></edit>
	<edit mode="assign" name="hintstyle"><const>hintslight</const></edit>
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
			<family>Bitstream Vera Serif</family>
			<family>Luxi Serif</family>
			<family>Nimbus Roman No9 L</family>
			<family>Times</family>
		</prefer>
	</alias>
<!-- Sans-serif faces -->
	<alias>
		<family>sans-serif</family>
		<prefer>
			<family>Noto Sans</family>
			<family>DejaVu Sans</family>
			<family>Liberation Sans</family>
			<family>Bitstream Vera Sans</family>
			<family>Luxi Sans</family>
			<family>Nimbus Sans L</family>
			<family>Helvetica</family>
		</prefer>
	</alias>
<!-- Monospace faces -->
	<alias>
		<family>monospace</family>
		<prefer>
			<family>Droid Sans Mono</family>
			<family>DejaVu Sans Mono</family>
			<family>Liberation Mono</family>
			<family>Bitstream Vera Sans Mono</family>
			<family>Andale Mono</family>
			<family>Luxi Mono</family>
			<family>Nimbus Mono L</family>
		</prefer>
	</alias>
</fontconfig>
EOF_FONTS

cat > /etc/profile.d/color-prompt.sh << EOF_PROMPT
## Colored prompt
if [ -n "\$PS1" ]; then
	if [[ "\$TERM" == *256color ]]; then
		if [ \${UID} -eq 0 ]; then
			PS1='\[\e[91m\]\u@\h \[\e[93m\]\W\[\e[0m\]\\$ '
		else
			PS1='\[\e[92m\]\u@\h \[\e[93m\]\W\[\e[0m\]\\$ '
		fi
	else
		if [ \${UID} -eq 0 ]; then
			PS1='\[\e[31m\]\u@\h \[\e[33m\]\W\[\e[0m\]\\$ '
		else
			PS1='\[\e[32m\]\u@\h \[\e[33m\]\W\[\e[0m\]\\$ '
		fi
	fi
fi
EOF_PROMPT

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
localectl set-locale it_IT.UTF-8
localectl set-x11-keymap it
localectl set-keymap it
EOF_LIVESYS

%end
