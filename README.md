# fedora-remix

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

### Prepare the build directories
Clone the project to get sources:

```shell
$ git clone https://github.com/mbugni/fedora-remix.git /<source-path>
```

Install kickstart tools:

```shell
$ sudo dnf -y install pykickstart
```

Prepare the target directory for building results:

```shell
$ sudo mkdir /result

$ sudo chmod ugo+rwx /result
```

Choose a version (eg: KDE workstation with italian support) and then create a single Kickstart file from the base code:

```shell
$ ksflatten --config /<source-path>/kickstarts/l10n/kde-workstation-it_IT.ks \
 --output /result/fedora-39-kde-workstation.ks
```

### Checking dependencies (optional)
Run the `ks-package-list.py` command if you need to check Kickstart dependencies:

```shell
$ /<source-path>/tools/ks-package-list.py --releasever 39 /result/fedora-39-kde-workstation.ks
```

Use the `--help` option to get more info about the tool:

```shell
$ /<source-path>/tools/ks-package-list.py --help
```

### Prepare the build enviroment using Podman
Install Podman:

```shell
$ sudo dnf -y install podman
```

Create the root of the build enviroment:

```shell
$ sudo dnf -y --setopt='tsflags=nodocs' --setopt='install_weak_deps=False' \
 --releasever=39 --installroot=/result/livebuild-f39 \
 --repo=fedora --repo=updates install lorax-lmc-novirt
```

Pack the build enviroment into a Podman container:

```shell
$ sudo sh -c 'tar -c -C /result/livebuild-f39 . | podman import - fedora/livebuild:39'
```

### Build the live image using Podman
Build the .iso image by running the `livemedia-creator` command inside the container:

```shell
$ sudo podman run --privileged --volume=/result:/result --volume=/dev:/dev:ro \
 -it fedora/livebuild:39 livemedia-creator --no-virt --nomacboot \
 --make-iso --project='Fedora' --releasever=39 \
 --tmp=/result --logfile=/result/lmc-logs/livemedia.log \
 --ks=/result/fedora-39-kde-workstation.ks
```

The build can take a while (40 minutes or more), it depends on your machine performances.

Remove unused containers when finished:

```shell
$ sudo podman container prune
```

## Transferring the image to a bootable media
Install live media tools:

```shell
$ sudo dnf install livecd-iso-to-mediums
```

Create a bootable USB/SD device using the .iso image:

```shell
$ sudo livecd-iso-to-disk --format --reset-mbr /result/lmc-work-<code>/images/boot.iso /dev/sd[X]
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
