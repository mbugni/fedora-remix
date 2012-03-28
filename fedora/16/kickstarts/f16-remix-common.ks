## fedora-remix-common.ks

%include f16-remix-base.ks

repo --name=rpmfusion-free --mirrorlist=http://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-$releasever&arch=$basearch
repo --name=rpmfusion-free-updates --mirrorlist=http://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-updates-released-$releasever&arch=$basearch
repo --name=rpmfusion-nonfree --mirrorlist=http://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-$releasever&arch=$basearch
repo --name=rpmfusion-nonfree-updates --mirrorlist=http://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-updates-released-$releasever&arch=$basearch


%packages

# RPM Fusion repositories
rpmfusion-free-release
rpmfusion-nonfree-release

# Drivers
# broadcom-wl

# Multimedia
gstreamer-ffmpeg
gstreamer-plugins-bad
gstreamer-plugins-bad-nonfree
gstreamer-plugins-ugly

%end


%post

# Antialiasing by default
ln -sf /etc/fonts/conf.avail/10-autohint.conf /etc/fonts/conf.d/
ln -sf /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d/

# Set Liberation Fonts as preferred family
cat > /etc/fonts/local.conf << EOF_FONTS
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
<!-- Local default fonts -->
<!-- Serif faces -->
        <alias>
                <family>Bitstream Vera Serif</family>
                <family>DejaVu Serif</family>
                <prefer><family>Liberation Serif</family></prefer>
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
                <family>DejaVu Sans</family>
                <prefer><family>Liberation Sans</family></prefer>
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
                <family>DejaVu Sans Mono</family>
                <prefer><family>Liberation Mono</family></prefer>
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

# OpenPrinting/Database/DriverPackages based on the LSB 3.2
cat > /etc/yum.repos.d/openprinting-drivers.repo << OPENPRINTING_EOF
[openprinting-drivers]
name=OpenPrinting LSB-based driver packages
baseurl=http://www.openprinting.org/download/printdriver/RPMS
enabled=1
gpgcheck=0
OPENPRINTING_EOF

# Disable ISCSI service: long time-out on boot
systemctl disable iscsi.service
systemctl disable iscsid.service

%end

