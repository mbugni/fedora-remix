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

# Tools
htop
hunspell-it
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
                <family>Bitstream Vera Serif</family>
                <prefer><family>DejaVu Serif</family></prefer>
                <family>Liberation Serif</family>
                <family>Times New Roman</family>
                <family>Times</family>
                <family>Nimbus Roman No9 L</family>
                <family>Luxi Serif</family>
                <family>Thorndale AMT</family>
                <family>Thorndale</family>
                <family>serif</family>
        </alias>
<!-- Sans-serif faces -->
        <alias>
                <family>Bitstream Vera Sans</family>
                <prefer><family>DejaVu Sans</family></prefer>
                <family>Liberation Sans</family>
                <family>Arial</family>
                <family>Helvetica</family>
                <family>Verdana</family>
                <family>Albany AMT</family>
                <family>Albany</family>
                <family>Nimbus Sans L</family>
                <family>Luxi Sans</family>
                <family>sans-serif</family>
        </alias>
<!-- Monospace faces -->
        <alias>
                <family>Bitstream Vera Sans Mono</family>
                <prefer><family>DejaVu Sans Mono</family></prefer>
                <family>Liberation Mono</family>
                <family>Inconsolata</family>
                <family>Courier New</family>
                <family>Courier</family>
                <family>Andale Mono</family>
                <family>Luxi Mono</family>
                <family>Cumberland AMT</family>
                <family>Cumberland</family>
                <family>Nimbus Mono L</family>
                <family>monospace</family>
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

%end

