## c6-desktop-common.ks

%include c6-desktop-base.ks

# Extra repositories
repo --name=atrpms --baseurl=http://ftp.tu-chemnitz.de/pub/linux/ATrpms/el$releasever-$basearch/atrpms/stable
repo --name=elrepo --baseurl=http://elrepo.reloumirrors.net/elrepo/el6/$basearch/
repo --name=epel --mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=$basearch
repo --name=rpmforge --baseurl=http://apt.sw.be/redhat/el6/en/$basearch/rpmforge

%packages

# Unwanted stuff
-*cups*
-*gstreamer*
-*sane*

# 3rd party repo
atrpms-repo
elrepo-release
epel-release
rpmforge-release

# Tools
yum-plugin-fastestmirror
unrar

%end


%post

echo -e "\n***********\nPOST COMMON\n***********\n"

# Import RPM-GPG keys
for key in $(ls /etc/pki/rpm-gpg/RPM-GPG-KEY-*) ; do
   rpm --import $key
done

# Antialiasing by default
ln -sf /etc/fonts/conf.avail/10-autohint.conf /etc/fonts/conf.d/
# ln -sf /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d/

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

%end

