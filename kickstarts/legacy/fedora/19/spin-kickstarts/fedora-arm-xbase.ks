%packages
@base-x
@fonts
@input-methods
@multimedia
@printing
%end

%post
# X on arm does not detect the driver needed correctly so we need a snippet to set something
# using fbdev as the lowest common denominator.

cat > /etc/X11/xorg.conf.d/fbdev.conf <<EOF
Section "Device"
    Identifier  "Display"
    Driver      "fbdev"
EndSection
EOF

%end
