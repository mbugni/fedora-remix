# fedora-remix

## Purpose
This project is a [Fedora Remix][01] and aims to offer a complete system for multipurpose usage with localization support. You can build a live image and try the software, and then install it in your PC if you want.
Other goals of this remix are:

* common extra-repos
* multimedia apps
* office automation support (printers and scanners)
* and more...

## Why Fedora?
Fedora is a feature-rich operating system which offers a complete suite of sofware for many purposes. It is flexible enough to get a custom version by using the installer ([see here for more details][02]). The build process can be described through Kickstart files and can be modified to get new variants.

## How to build the LiveCD
[See a detailed description][03] of how to build the live media.

### Prepare the build target
Install kickstart tools:

```
# dnf install pykickstart
```

Prepare the target directory for build results:

```
# mkdir /results

# chmod ugo+rwx /results
```

Choose a version (eg: KDE workstation with italian support) and then create a single Kickstart file from the base code:

```
$ ksflatten --config /<source-path>/kickstarts/<version>/l10n/kde-workstation-it_IT.ks \
 --output /results/fedora-<version>-kde-workstation.ks
```

### Build the live image using Lorax
Install Lorax to create the virtual environment:

```
# dnf install lorax-lmc-virt
```

Create a bootable .iso for building environment:

```
# lorax --product='Fedora' --version=<version> --release=<version> --nomacboot \
 --source='https://dl.fedoraproject.org/pub/fedora/linux/releases/<version>/Everything/x86_64/os/' \
 --source='https://dl.fedoraproject.org/pub/fedora/linux/updates/<version>/Everything/x86_64/' \
 --logfile=/results/lorax-fedora-<version>/lorax.log /results/lorax-fedora-<version>
```

Build the .iso image using the kickstart:

```
# livemedia-creator --nomacboot --make-iso --project='Fedora' --releasever=<version> \
 --tmp=/results --logfile=/results/lmc-logs/livemedia.log \
 --iso=/results/lorax-fedora-<version>/images/boot.iso \
 --ks=/results/fedora-<version>-kde-workstation.ks
```

### Build the live image using Podman
Install Podman:

```
# dnf install podman
```

Create the container for building environment:

```
$ sudo podman build --file /<source-path>/tools/Dockerfile \
 --build-arg releasever=<version> --tag fedora/livebuild:<version>
```

Build the .iso image by running the container:

```
$ sudo podman run --privileged --volume=/dev:/dev --volume=/results:/results \
 -it fedora/livebuild:<version> livemedia-creator --no-virt --nomacboot \
 --make-iso --project='Fedora' --releasever=<version> \
 --tmp=/results --logfile=/results/lmc-logs/livemedia.log \
 --ks=/results/fedora-<version>-kde-workstation.ks
```

## Transferring the image to a bootable media
Install live media tools:

```
# dnf install livecd-iso-to-mediums
```

Create a bootable USB/SD device using the .iso image:

```
# livecd-iso-to-disk --format --reset-mbr /results/lmc-work-<code>/images/boot.iso /dev/sd[X]
```

## Post-install tasks
The Anaconda installer does not remove itself after installation. You can remove it to get space by running this command:

```
# dnf remove anaconda\*
```

## ![Bandiera italiana][04] Per gli utenti italiani
Questo è un [Remix di Fedora][01] con il supporto in italiano per lingua e tastiera. Nell'immagine .iso che si ottiene sono già installati i pacchetti e le configurazioni per il funzionamento in italiano delle varie applicazioni (come l'ambiente grafico, la suite LibreOffice etc).
Nel sistema sono presenti anche:

* repositori extra di uso comune
* supporto per le applicazioni multimediali
* supporto per l'ufficio (stampanti e scanner)
* e altre funzionalità ancora...

### Attività post-installazione
Il programma di installazione Anaconda non rimuove se stesso dopo l'installazione. E' possibile rimuoverlo per recuperare spazio utilizzando il seguente comando:

```
# dnf remove anaconda\*
```

## Change Log
All notable changes to this project will be documented in the [`CHANGELOG.md`](CHANGELOG.md) file.

The format is based on [Keep a Changelog][05].

[01]: https://fedoraproject.org/wiki/Remix
[02]: https://en.wikipedia.org/wiki/Anaconda_(installer)
[03]: https://weldr.io/lorax/lorax.html
[04]: http://flagpedia.net/data/flags/mini/it.png
[05]: https://keepachangelog.com/
