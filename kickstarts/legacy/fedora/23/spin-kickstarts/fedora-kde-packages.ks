%packages
@kde-apps
@kde-desktop
@kde-media
@kde-office
@kde-telepathy
@networkmanager-submodules

### The KDE-Desktop

### Browser
firefox

### fixes

# use kde-print-manager instead of system-config-printer
-system-config-printer
# make sure mariadb lands instead of MySQL (hopefully a temporary hack)
mariadb-embedded
mariadb-libs
mariadb-server

# minimal localization support - allows installing the kde-l10n-* packages
system-config-language
kde-l10n

%end

