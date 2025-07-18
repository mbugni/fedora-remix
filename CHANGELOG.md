## 42.0.0 - 2025-07-06
### Added
- Sensors support
- Calamares installer
- system-create command to build an image based on the existing root
### Changed
- Filter out [unwanted EFI files from the embedded ESP](https://bugzilla.redhat.com/show_bug.cgi?id=2358785)
- EFI [partition mount options](https://github.com/OSInside/kiwi/issues/2201)
- Move clean up scripts to Calamares post-install
### Removed
- Anaconda installer
- xdg-desktop-portal-gnome

## 41.1.0 - 2025-05-14
### Added
- Image build using Podman compose
### Changed
- Switch the boot spinner theme to BGRT (Boot Graphics Resource Table)
- Reset the KDE preferred browser to fallback the default
- Improve power management

## 41.0.0 - 2025-03-16
### Added
- Realtime support
- Zip tools
### Removed
- Redundant localization configs
- Non-free multimedia plugins
### Changed
- One session setup for both console and graphical mode
- Switch to dnf5 package manager

## 40.0.0 - 2024-12-24
### Added
- Custom live scripts
- Calamares configs (experimental)
### Removed
- Package livesys-scripts provided by distro
### Changed
- Move to Plasma 6 and Wayland
- systemd-timesyncd instead of chrony

## 39.0.2 - 2024-10-14
### Added
- Custom user Flatpak setup
- Custom machine setup
### Changed
- Improve scan and print support
- Better live system cleanup
- Minimize dependencies

## 39.0.1 - 2024-08-10
### Changed
- Build container is based on fedora-minimal
- Falkon replaces Konqueror browser
- Discover uses Flatpak as default backend
- Minimize dependencies

## 39.0.0 - 2024-06-02
### Changed
- Adopt kiwi-ng for builing images
### Removed
- Kickstart scripts

## Fedora 39 - 2023-12-23
### Changed
- Minimize apps in favour of Flatpak
### Removed
- GNOME desktop environment remix
- Native apps (internet, multimedia, office)

## Fedora 38 - 2023-04-23
### Changed
- Adjust [livesys scripts][3801]
- Reduce kickstart files

## Fedora 37 - 2023-01-02
### Changed
- Reduced package dependencies.
- Featherpad editor replaces Kate.
- Thumbnailer for GNOME.
### Removed
- Totem from GNOME.
- Docker build file: use chroot instead.

## Fedora 36 - 2022-07-10
### Changed
- Back to GParted
### Removed
- Software managers.

## Fedora 35 - 2021-11-27
### Added
- Plasma Discover offline updates.

## Fedora 34 - 2021-05-30
### Added
- KDE Connect support.
### Changed
- Blivet-gui instead of GParted.
### Removed
- XFCE desktop environment remix.
- Wine fonts.

## Fedora 33 - 2020-11-10
### Added
- XFCE desktop environment remix.
- PAM integration with KWallet.
### Changed
- Kickstart packages organization.
- [LibreOffice VCL][3301] for each DE.
- [Nano as default editor][3302].

## Fedora 32 - 2020-07-11
### Added
- Emoji fonts support.
### Changed
- Desktop as basic box.
- Workstation with full office support.

## Fedora 31 - 2019-11-10
### Added
- GNOME desktop.
### Changed
- Adopt RPM Fusion "tainted" repos.
- Multimedia support improved.
### Removed
- Clementine audio player.

## Fedora 30 - 2019-05-24
### Changed
- Changes the [default fonts to Google Noto Fonts][3001].
- Package dependencies minimization.

## Fedora 29 - 2019-02-02
### Added
- Java 8 dependency for L.Office.

## Fedora 28 - 2018-10-22
### Changed
- Improve printing support.
- Improve audio support.
### Removed
- Favorites from KDE menu.
- digiKam from KDE.

## Fedora 27 - 2018-02-18
### Changed
- Improve bluetooth support.
- Improve fonts configuration.
- Improve flatpak support.

## Fedora 26 - 2017-12-16
### Added
- Support for [exFAT][2601] filesystem.
### Changed
- Default fonts installed ([eg Google Noto][2602]).
### Removed
- Instant messaging client.
- system-config-users tool.

## Fedora 25 - 2017-05-13
### Added
- `gstreamer1-plugin-mpg123` package as [mp3 playback plugin][2501].
- KDE - `plasma-user-manager` to modify user avatar ([see RHBG 1279057][2502]).
### Changed
- Adjust language dependency due `dnf-langpacks` package [removal][2503].
- Remove `system-config-date` bacause [orphaned][2504].
- KDE - Package manager `yumex-dnf` is replaced by Plasma Discover.

## Fedora 24 - 2016-10-09
### Changed
- Repository moved from [Assembla][2401].

[3801]: https://fedoraproject.org/wiki/Changes/ModernizeLiveMedia
[3301]: https://docs.libreoffice.org/vcl.html
[3302]: https://fedoraproject.org/wiki/Changes/UseNanoByDefault
[3001]: https://fedoraproject.org/wiki/Changes/DefaultFontsToNoto
[2601]: https://en.wikipedia.org/wiki/ExFAT
[2602]: https://www.google.com/get/noto/
[2501]: https://bugzilla.redhat.com/show_bug.cgi?id=1394148
[2502]: https://bugzilla.redhat.com/show_bug.cgi?id=1279057
[2503]: https://fedoraproject.org/wiki/QA:Testcase_dnf_langpacks_plugin
[2504]: https://lists.fedoraproject.org/archives/list/devel@lists.fedoraproject.org/message/BIV6Z2LN2LCO4I6LE636PPWOINUETV3S/
[2401]: https://app.assembla.com/spaces/fedora-remix/subversion/source