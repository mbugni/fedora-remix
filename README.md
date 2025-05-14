# Fedora Remix

## Purpose
This project is a [Fedora Remix][01] and aims to be a complete system for personal computing with localization support.
You can [download a live image][02] and try the software, and then install it in your PC if you want.
You can also customize the image starting from available scripts.

Main goals of this remix are:
* Flatpak apps usage
* adding common extra-repos
* supporting external devices (like printers and scanners)

## How to build the LiveCD
[See a detailed description][03] about how to build a live media using kiwi-ng.

> [!NOTE]
>
> If `selinux` is on, [turn it off](https://osinside.github.io/kiwi/troubleshooting/security.html) during the build process.

### Prepare the working directories
Clone the project into your `<source-path>` to get sources:

```shell
$ git clone https://github.com/mbugni/fedora-remix.git /<source-path>
```

Choose or create a `<target-path>` folder where to put results.

### Prepare the build environment
Install Podman:

```shell
$ sudo dnf --assumeyes install podman podman-compose
```

### Build the image
Choose a variant (eg: workstation with localization support) that corresponds to a profile (eg: `Workstation-l10n`).

Available profiles/variants are:
* `Console` (command line only, mainly for testing)
* `Desktop` (minimal KDE environment with basic tools)
* `Workstation` (KDE environment with more features like printing and scanning support)

For each variant you can append `-l10n` to get italian localization (eg: `Desktop-l10n`).

Build the .iso image by running the `podman-compose` command from the project root directory:

```shell
$ sudo podman-compose run --rm --env KIWI_PROFILE=<variant> \
--env KIWI_TARGET_DIR=<target-path> live-build
```

The build can take a while (30 minutes or more), it depends on your machine performances.
Environment arguments are optional, available variables are:

| Variable        | Description             | Default value      |
|:---------------:|:-----------------------:|:------------------:|
| KIWI_PROFILE    | Image variant           | `Workstation-l10n` |
| KIWI_TARGET_DIR | Build target directory  | `.`                |

Remove unused images when finished:

```shell
$ sudo podman image prune
```

## Transferring the image to a bootable media
You can use a tool like [Ventoy][07] to build multiboot USB devices, or simply transfer the image to a single
USB stick using the `dd` command:

```shell
$ sudo dd if=/<target-path>/Fedora-Remix.x86_64-<version>.iso of=/dev/<stick-device>
```

## Post-install tasks
After installation, remove live system resources to save space by running:

```shell
$ /usr/local/libexec/remix/livesys-cleanup
```

## ![Bandiera italiana][04] Per gli utenti italiani
Questo è un [Remix di Fedora][01] per computer ad uso personale con il supporto in italiano. Nell'[immagine .iso][02] che si ottiene sono già installati i pacchetti e le configurazioni per il funzionamento in italiano del sistema (come l'ambiente grafico, i repo extra etc).

Il remix ha come obiettivi principali:
* utilizzo delle applicazioni Flatpak
* aggiunta dei repository comuni
* supporto per dispositivi esterni (come stampanti e scanner)

## Change Log
All notable changes to this project will be documented in the [`CHANGELOG.md`](CHANGELOG.md) file.

The format is based on [Keep a Changelog][05].

[01]: https://fedoraproject.org/wiki/Remix
[02]: https://github.com/mbugni/fedora-remix/releases
[03]: https://osinside.github.io/kiwi
[04]: http://flagpedia.net/data/flags/mini/it.png
[05]: https://keepachangelog.com/
[06]: https://docs.podman.io/
[07]: https://www.ventoy.net/