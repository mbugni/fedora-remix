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

### Prepare the build container
Install Podman:

```shell
$ sudo dnf --assumeyes install podman
```

Create the container for the build enviroment:

```shell
$ sudo podman build --file=/<source-path>/Containerfile --tag=livebuild:fc41
```

Initialize the container by running an interactive shell:

```shell
$ sudo podman run --privileged --network=host -it --volume=/dev:/dev:ro \
--volume=/<source-path>:/live/source:ro --volume=/<target-path>:/live/target \
--name=livebuild-fc41 --hostname=livebuild-fc41 livebuild:fc41 /usr/bin/bash
```

Exit from the build container. The container can be reused and upgraded multiple times.
See [Podman docs][06] for more details.

To enter again into the build container:

```shell
$ sudo podman start -ia livebuild-fc41
```

### Build the image
First, start the build container if not running:

```shell
$ sudo podman start livebuild-fc41
```

Choose a variant (eg: workstation with localization support) that corresponds to a profile (eg: `Workstation-l10n`).

Available profiles/variants are:
* `Console` (command line only, mainly for testing)
* `Desktop` (minimal KDE environment with basic tools)
* `Workstation` (KDE environment with more features like printing and scanning support)

For each variant you can append `-l10n` to get italian localization (eg: `Desktop-l10n`).

Build the .iso image by running the `kiwi-ng` command:

```shell
$ sudo podman exec livebuild-fc41 kiwi-ng --profile=Workstation-l10n --type=iso \
--debug --color-output --shared-cache-dir=/live/target/cache system build \
--description=/live/source/kiwi-descriptions --target-dir=/live/target
```

The build can take a while (30 minutes or more), it depends on your machine performances.

Remove unused resources when don't need anymore:

```shell
$ sudo podman container rm --force livebuild-fc41
$ sudo podman image rm livebuild:fc41
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
$ source /usr/local/libexec/remix/livesys-cleanup
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