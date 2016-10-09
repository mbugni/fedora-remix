## f24-kde-base-it_IT.ks

%include f24-base-it_IT.ks

%packages --excludeWeakdeps

kde-l10n-Italian

%end

%post

echo ""
echo "POST KDE BASE it_IT **********************************"
echo ""

# Plasma locale settings
cat > /etc/skel/.config/plasma-localerc << PLASMALOCALE_EOF
[Formats]
LANG=it_IT.UTF-8

[Translations]
LANGUAGE=it
PLASMALOCALE_EOF

# KDE user locale settings
cat >> /etc/skel/.config/kdeglobals << GLOBALS_EOF
[Locale]
Country=it

[Translations]
LANGUAGE=it
GLOBALS_EOF

# KDE global locale settings
cat >> /etc/kde/kdeglobals << GLOBALS_EOF
[Locale]
Country=it

[Translations]
LANGUAGE=it
GLOBALS_EOF

%end
