## f18-common-desktop.ks

%include f18-common-base.ks

%packages

# Unwanted stuff
-PackageKit-command*
-bash-completion*

# Fonts
dejavu-sans-*
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
firstboot
htop
hunspell-it
vim-enhanced
yum-plugin-fastestmirror

%end


%post

echo ""
echo "*******************"
echo "POST COMMON DESKTOP"
echo "*******************"

# Antialiasing by default
ln -sf /etc/fonts/conf.avail/10-autohint.conf /etc/fonts/conf.d/

# Set DejaVu fonts as preferred family
cat > /etc/fonts/local.conf << EOF_FONTS
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
<!-- Local default fonts -->
<!-- Serif faces -->
	<alias>
		<family>serif</family>
		<prefer>
			<family>DejaVu Serif</family>
			<family>Bitstream Vera Serif</family>
			<family>Liberation Serif</family>
			<family>Times New Roman</family>
			<family>Thorndale AMT</family>
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
			<family>Bitstream Vera Sans</family>
			<family>Liberation Sans</family>
			<family>Verdana</family>
			<family>Arial</family>
			<family>Albany AMT</family>
			<family>Luxi Sans</family>
			<family>Nimbus Sans L</family>
			<family>Helvetica</family>
			<family>Lucida Sans Unicode</family>
			<family>BPG Glaho International</family>
			<family>Tahoma</family>
		</prefer>
	</alias>
<!-- Monospace faces -->
	<alias>
		<family>monospace</family>
		<prefer>
			<family>DejaVu Sans Mono</family>
			<family>Bitstream Vera Sans Mono</family>
			<family>Liberation Mono</family>
			<family>Inconsolata</family>
			<family>Andale Mono</family>
			<family>Courier New</family>
			<family>Cumberland AMT</family>
			<family>Luxi Mono</family>
			<family>Nimbus Mono L</family>
			<family>Courier</family>
		</prefer>
	</alias>
</fontconfig>
EOF_FONTS

cat > /etc/profile.d/remix-shell.sh << EOF_SHELL
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
GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR="\$(sed 's, release .*\$,,g' /etc/system-release)"
GRUB_DEFAULT=saved
GRUB_CMDLINE_LINUX="rd.md=0 rd.dm=0 rd.luks=0 rhgb quiet"
GRUB_DISABLE_RECOVERY="true"
GRUB_THEME="/boot/grub2/themes/system/theme.txt"
EOF_DEFAULT_GRUB
fi

# Set a default keymap if not present
if [ ! -f "/etc/vconsole.conf" ]; then
cat > /etc/vconsole.conf << EOF_VCONSOLE
KEYMAP="it"
EOF_VCONSOLE
fi

%end

