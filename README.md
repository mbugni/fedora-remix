# fedora-remix

## Purpose
This project is a [Fedora Remix](https://fedoraproject.org/wiki/Remix) and aims to offer a complete system for multipurpose usage with localization support. You can build a LiveCD and try the software, and then install it in your PC if you want.

## Why Fedora?
Fedora is a feature-rich operating system which offers a complete suite of sofware for many purposes. It is flexible enough to get a custom version by using its installer ([see here for more details](https://en.wikipedia.org/wiki/Anaconda_(installer)).  The build process can be described through Kickstart files and can be modified to get new variants.

## How to build the LiveCD
[See a detailed description](https://fedoraproject.org/wiki/Livemedia-creator-_How_to_create_and_use_a_Live_CD) of how to build the live media.
In a nutshell you have to choose a version (eg: KDE with language support) and then create a single Kickstart file from the base code:

```
 # ksflatten --config kickstarts/24/l10n/f24-kde-remix-it_IT.ks --output f24-kde-remix.ks
```

Then you can build the ISO image using the kickstart just obtained:

```
 # livemedia-creator --resultdir=result-kde --make-iso --no-virt --ks=f24-kde-remix.ks
```

## ![Bandiera italiana](http://flagpedia.net/data/flags/mini/it.png) Per gli utenti italiani
Questo è un [Remix di Fedora](https://fedoraproject.org/wiki/Remix) con il supporto in italiano per lingua e tastiera. Nell'immagine ISO che si ottiene sono già installati i pacchetti e le configurazioni per il funzionamento in italiano delle varie applicazioni (come l'ambiente grafico, la suite LibreOffice etc).
Nel sistema sono presenti anche:

* repositori extra di uso comune
* supporto per le applicazioni multimediali
* configurazioni aggiuntive

... e altre funzionalità non contenute nelle immagini ufficiali.
