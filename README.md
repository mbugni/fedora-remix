# fedora-remix

## Purpose
This project is a [Fedora Remix][01] and aims to offer a complete system for multipurpose usage with localization support. You can build a LiveCD and try the software, and then install it in your PC if you want.

## Why Fedora?
Fedora is a feature-rich operating system which offers a complete suite of sofware for many purposes. It is flexible enough to get a custom version by using the installer ([see here for more details][02]).  The build process can be described through Kickstart files and can be modified to get new variants.

## How to build the LiveCD
[See a detailed description][03] of how to build the live media.
In a nutshell, you have to choose a version (eg: KDE with language support) and then create a single Kickstart file from the base code:

```
 # ksflatten --config kickstarts/28/l10n/f28-kde-desktop-it_IT.ks --output kde-desktop.ks
```

Then you can build the ISO image using the kickstart just obtained:

```
 # livemedia-creator --resultdir=result --make-iso --no-virt --project=Fedora --releasever=28 --ks=kde-desktop.ks
```

## Transferring the image to a bootable media
You can create a bootable USB/SD device (legacy BIOS) using the iso image:

```
 # livecd-iso-to-disk --format --reset-mbr --msods result/images/boot.iso /dev/sdX
```

In order to get an EFI bootable media:

```
 # cp result/images/boot.iso boot-efi.iso
 # cat result/images/efiboot.img >> boot-efi.iso
 # livecd-iso-to-disk --format --reset-mbr --efi boot-efi.iso /dev/sdX
```

## ![Bandiera italiana][04] Per gli utenti italiani
Questo è un [Remix di Fedora][01] con il supporto in italiano per lingua e tastiera. Nell'immagine ISO che si ottiene sono già installati i pacchetti e le configurazioni per il funzionamento in italiano delle varie applicazioni (come l'ambiente grafico, la suite LibreOffice etc).
Nel sistema sono presenti anche:

* repositori extra di uso comune
* supporto per le applicazioni multimediali
* configurazioni aggiuntive

... e altre funzionalità non contenute nelle immagini ufficiali.

## Change Log
All notable changes to this project will be documented in the [`CHANGELOG.md`](CHANGELOG.md) file.

The format is based on [Keep a Changelog][05].

[01]: https://fedoraproject.org/wiki/Remix
[02]: https://en.wikipedia.org/wiki/Anaconda_(installer)
[03]: https://fedoraproject.org/wiki/Livemedia-creator-_How_to_create_and_use_a_Live_CD
[04]: http://flagpedia.net/data/flags/mini/it.png
[05]: https://keepachangelog.com/
