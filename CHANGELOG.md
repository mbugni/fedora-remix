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

[2601]: https://en.wikipedia.org/wiki/ExFAT
[2602]: https://www.google.com/get/noto/
[2501]: https://bugzilla.redhat.com/show_bug.cgi?id=1394148
[2502]: https://bugzilla.redhat.com/show_bug.cgi?id=1279057
[2503]: https://fedoraproject.org/wiki/QA:Testcase_dnf_langpacks_plugin
[2504]: https://lists.fedoraproject.org/archives/list/devel@lists.fedoraproject.org/message/BIV6Z2LN2LCO4I6LE636PPWOINUETV3S/
[2401]: https://app.assembla.com/spaces/fedora-remix/subversion/source