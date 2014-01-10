%packages
@kde-apps
@kde-desktop
@kde-media
@kde-telepathy

### The KDE-Desktop

### fixes
# sddm->kdm, (temporary) so don't have to wait on comps changes
-sddm
-sddm-kcm
kdm

# use kde-print-manager instead of system-config-printer
-system-config-printer
# make sure mariadb lands instead of MySQL (hopefully a temporary hack)
mariadb-embedded
mariadb-libs
mariadb-server

%end

