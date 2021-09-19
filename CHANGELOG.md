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