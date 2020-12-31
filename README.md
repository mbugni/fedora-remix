# fedora-remix

## Purpose
This project is a [Fedora Remix][01] and aims to offer a complete system for multipurpose usage with localization support. You can build a live image and try the software, and then install it in your PC if you want.
Other goals of this remix are:

* common extra-repos
* multimedia apps
* office automation support (printers and scanners)
* and more...

## Why Fedora?
Fedora is a feature-rich operating system which offers a complete suite of sofware for many purposes. It is flexible enough to get a custom version by using the installer ([see here for more details][02]).  The build process can be described through Kickstart files and can be modified to get new variants.

## Prepare the build environment with mock
[See a detailed description][03] of how to build the live media.
Install mock for the chroot environment and add the group to your build user:

```
# dnf install mock

# usermod -a -G mock <builduser>
```

Install live media tools:

```
# dnf install pykickstart livecd-iso-to-mediums
```

Configure the chroot for your `<builduser>` by editing the `/etc/mock/fedora-<version>-remix-x86_64.cfg` file as follows:

```
include('/etc/mock/fedora-<version>-x86_64.cfg')

config_opts['root'] = 'fedora-{{ releasever }}-remix-{{ target_arch }}'
config_opts['chroot_setup_cmd'] = 'install lorax-lmc-novirt'
# build results go into /home/<builduser>/results/
config_opts['plugin_conf']['bind_mount_opts']['dirs'].append(('/home/<builduser>/results/','/results/'))
config_opts['rpmbuild_networking'] = True
config_opts['use_host_resolv'] = True
```

Prepare the chroot using your `<builduser>`:

```
$ mkdir ~/results

$ mock --root=fedora-<version>-remix-x86_64 --isolation=simple --init
```

## How to build the LiveCD
In a nutshell, you have to choose a version (eg: KDE with language support) and then create a single Kickstart file from the base code:

```
 $ ksflatten --config /<source-path>/kickstarts/<version>/l10n/kde-desktop-it_IT.ks --output ~/results/kde-desktop.ks
```

Then you can build the ISO image using the kickstart just obtained:

```
 $ mock --root=fedora-<version>-remix-x86_64 --isolation=simple --chroot -- \
 livemedia-creator --no-virt --nomacboot --tmp=/results --logfile=/results/logs/livemedia.log \
 --make-iso --project=Fedora --releasever=<version> --ks=/results/kde-desktop.ks
```

## Transferring the image to a bootable media
You can create a bootable USB/SD device (legacy BIOS) using the iso image:

```
 # livecd-iso-to-disk --format --reset-mbr --msods /home/<builduser>/results/lmc-work-<code>/images/boot.iso /dev/sd[X]
```

In order to get an EFI bootable media:

```
 # cp /home/<builduser>/results/lmc-work-<code>/images/boot.iso boot-efi.iso

 # cat /home/<builduser>/results/lmc-work-<code>/images/efiboot.img >> boot-efi.iso

 # livecd-iso-to-disk --format --reset-mbr --efi boot-efi.iso /dev/sd[X]
```

## Post-install tasks
The Anaconda installer does not remove itself after installation. You can remove it to get space by running this command:
```
# dnf remove anaconda\*
```

## ![Bandiera italiana][04] Per gli utenti italiani
Questo è un [Remix di Fedora][01] con il supporto in italiano per lingua e tastiera. Nell'immagine ISO che si ottiene sono già installati i pacchetti e le configurazioni per il funzionamento in italiano delle varie applicazioni (come l'ambiente grafico, la suite LibreOffice etc).
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
[03]: https://weldr.io/lorax/livemedia-creator.html#using-mock-and-no-virt-to-create-images
[04]: http://flagpedia.net/data/flags/mini/it.png
[05]: https://keepachangelog.com/
