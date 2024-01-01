# Fedora Remix

## Purpose
This project is a [Fedora Remix][01] and aims to offer a complete system for multipurpose usage with localization support. You can [download a live image][02] and try the software, and then install it in your PC if you want.
You can also customize the image starting from available scripts.

Other goals of this remix are:
* common extra-repos
* multimedia apps support
* office automation support (printers and scanners)
* and more...

## How to build the LiveCD
[See a detailed description][03] of how to build the live media.

**NOTE**

If `selinux` is on, disable it during the build process:

```shell
$ sudo setenforce 0
```

### Prepare the working directories
Clone the project to get sources:

```shell
$ git clone https://github.com/mbugni/fedora-remix.git /<source-path>
```

Choose or create a `/<target-path>` where to put results.

### Prepare the build container
Install Podman:

```shell
$ sudo dnf --assumeyes install podman
```

Create the container for the build enviroment:

```shell
$ sudo podman build --file=/<source-path>/Containerfile --tag=livebuild:fc39
```

Initialize the container by running an interactive shell:

```shell
$ sudo podman run --privileged --network=host -it --volume=/dev:/dev:ro \
 --volume=/<source-path>:/live/source:ro --volume=/<target-path>:/live/target \
 --name=livebuild-fc39 --hostname=livebuild-fc39 livebuild:fc39 /usr/bin/bash
```

The container can be reused and upgraded multiple times. See [Podman docs][06] for more details.

To enter again into the build container:

```shell
$ sudo podman start -ia livebuild-fc39
```

### Build the image

Run build commands inside the container.

#### Prepare the kickstart file

Choose a version (eg: KDE workstation with italian support) and then create a single Kickstart file from the source code:

```shell
[] ksflatten --config /live/source/kickstarts/l10n/kde-workstation-it_IT.ks \
 --output /live/target/fc39-kde-workstation.ks
```

#### Check dependencies (optional)
Run the `ks-package-list` command if you need to check Kickstart dependencies:

```shell
[] ks-package-list --releasever 39 --format "{name}" --verbose \
 /live/target/fc39-kde-workstation.ks > /live/target/fc39-kde-packages.txt
```

Use the `--help` option to get more info about the tool:

```shell
[] ks-package-list --help
```

#### Create the live image
Build the .iso image by running the `livemedia-creator` command:

```shell
[] livemedia-creator --no-virt --nomacboot --make-iso --project='Fedora' \
 --releasever=39 --tmp=/live/target --logfile=/live/target/lmc-logs/livemedia.log \
 --ks=/live/target/fc39-kde-workstation.ks
```

The build can take a while (30 minutes or more), it depends on your machine performances.

Remove unused resources when don't need anymore:

```shell
$ sudo podman container rm --force livebuild-fc39
$ sudo podman image rm livebuild:fc39
```

## Transferring the image to a bootable media
Install live media tools:

```shell
$ sudo dnf install livecd-iso-to-mediums
```

Create a bootable USB/SD device using the .iso image:

```shell
$ sudo livecd-iso-to-disk --format --reset-mbr \
 /<target-path>/lmc-work-<code>/images/boot.iso /dev/sd<X>
```

## Post-install tasks
After installation, you can remove live system components to save space by running these commands:

```shell
$ sudo systemctl disable livesys.service
$ sudo systemctl disable livesys-late.service
$ sudo dnf remove anaconda\* livesys-scripts
```

## ![Bandiera italiana][04] Per gli utenti italiani
Questo è un [Remix di Fedora][01] con il supporto in italiano per lingua e tastiera. Nell'[immagine .iso][02] che si ottiene sono già installati i pacchetti e le configurazioni per il funzionamento in italiano delle varie applicazioni (come l'ambiente grafico, i repo extra etc).

Nel sistema sono presenti anche:
* repositori extra di uso comune
* supporto per le applicazioni multimediali
* supporto per l'ufficio (stampanti e scanner)
* e altre funzionalità ancora...

## Change Log
All notable changes to this project will be documented in the [`CHANGELOG.md`](CHANGELOG.md) file.

The format is based on [Keep a Changelog][05].

[01]: https://fedoraproject.org/wiki/Remix
[02]: https://github.com/mbugni/fedora-remix/releases
[03]: https://weldr.io/lorax/lorax.html
[04]: http://flagpedia.net/data/flags/mini/it.png
[05]: https://keepachangelog.com/
[06]: https://docs.podman.io/