## f21-lxqt-remix.ks

%include f21-lxqt-desktop.ks
%include f21-base-remix.ks

part / --size 4096 --fstype ext4

%packages

# Unwanted stuff
-libreoffice-kde

# Graphics
guvcview

# Internet
pidgin

# Multimedia
clementine
vlc
npapi-vlc

# Office
@libreoffice
libreoffice-langpack-it

# Settings
system-config-printer

%end


%post

%end

