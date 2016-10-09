# fedora-livedvd-games.ks
#
# Maintainer(s):
# - Bruno Wolff III <bruno@wolff.to>
# - Formerly maintained by Rahul Sundaram

%include fedora-live-xfce.ks

# The recommended part size for DVDs is too close to use for the games spin
part / --size 10240

%packages

# Wine pulls in i386 libraries under x86_86 making that spin too big.
# Also the point is to show off Fedora games, not running windows games.

-wine

# Remove libreoffice since it just got added to livecd-desktop and
# will likely put the games spin over size and it is freeze time.
-libreoffice*

# Extra screensavers isn't much help for the games spin
-xscreensaver-extras

# Allow joysticks and game pads to work
joystick-support

# games

# traditional (big)

#alienarena #Cut for size
armacycles-ad
asc
asc-music
astromenace
# beneath-a-steel-sky-cd scummvm games cut for size
boswars
btanks
bzflag
crossfire-client
extremetuxracer
# flight-of-the-amazon-queen-cd scummvm games cut for size
freeciv
freecol
freedoom
freedroidrpg
frozen-bubble
gl-117
glob2
lincity-ng
tmw
maniadrive
maniadrive-music
megaglest
nethack-vultures
netpanzer
#neverball #cut for size
nogravity
pinball
scorched3d
supertux
#supertuxkart #remove for size
ultimatestunts
warzone2100
wesnoth
# worminator # Would pull in fluid-soundfont-lite-patches
warmux
xmoto

# traditional (small)

abe
# alex4 # Would pull in fluid-soundfont-lite-patches
# ballz # Would pull in fluid-soundfont-lite-patches
blobwars
bombardier
cdogs-sdl
clanbomber
colossus
foobillard
glaxium
gnubg
gnugo
haxima
hedgewars
kcheckers
knights
lbrickbuster2
# liquidwar # Would pull in fluid-soundfont-lite-patches
londonlaw
lordsawar
# lure scummvm games cut for size
# machineball # Would pull in fluid-soundfont-lite-patches
nethack
openlierox
pachi
pioneers
quarry
Ri-li
rogue
# scorchwentbonkers # Would pull in fluid-soundfont-lite-patches
seahorse-adventures
solarwolf
sopwith
stormbaancoureur
ularn
xblast

# arcade classics(ish) (big)

auriferous
alienblaster
# duel3 # Would pull in fluid-soundfont-lite-patches
lmarbles
powermanga
# raidem # Would pull in fluid-soundfont-lite-patches
# raidem-music # Would pull in fluid-soundfont-lite-patches
trackballs
trackballs-music

# arcade classics(ish) (small)

ballbuster
CriticalMass
dd2
KoboDeluxe
# lacewing # Would pull in fluid-soundfont-lite-patches
Maelstrom
methane
njam
seahorse-adventures
shippy
tecnoballz
wordwarvi
xgalaxy
# zasx # Would pull in fluid-soundfont-lite-patches

# falling blocks games (small) 

amoebax
crack-attack
# crystal-stacker # Would pull in fluid-soundfont-lite-patches
gemdropx
gweled

# puzzles (big)
enigma
fillets-ng
pingus

# puzzles (small)

escape
# gbrainy Removed for space - only game that pulls in mono
magicor
mirrormagic
pipenightdreams
pipepanic
pychess
rocksndiamonds
vodovod

# card games

#poker2d - dropped from F14 for being orphaned
PySolFC

# educational/simulation

bygfoot
celestia
childsplay
gcompris
planets
tuxpaint
tuxpaint-stamps
tuxtype2

# kde based games
taxipilot

# utilities

games-menus

# Note some stuff I don't want pulled into the games spin.

# No compilations of games as I want to only include games that at least
# someone thought were good within a genre.
-kdegames

# Nothing should be downloading data to play.
-autodownloader

%end
