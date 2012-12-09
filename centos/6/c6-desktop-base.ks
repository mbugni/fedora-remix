lang it_IT.UTF-8
keyboard it
timezone Europe/Rome
auth --useshadow --enablemd5
selinux --enforcing
firewall --enabled --service=mdns
xconfig --startxonboot
part / --size 4096 --fstype ext4
services --enabled=NetworkManager --disabled=kdump,network,sshd

repo --name=centos-base --mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os
repo --name=centos-updates --mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=updates
repo --name=centos-extras --mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=extras

%packages

# Unwanted stuff
-NetworkManager-open*
-PackageKit-command*
-bash-completion*
-nano

syslinux
kernel
@base
@core
@dial-up
# @desktop-platform
# @fonts
# @general-desktop
@graphical-admin-tools
@legacy-x
@network-file-system-client
# @print-client
# @remote-desktop-clients
@x11

dejavu-sans-*
hunspell-it
liberation-mono-fonts
liberation-s*-fonts
vim-enhanced

# livecd bits to set up the livecd and be able to install
memtest86+
#livecd-tools
anaconda
device-mapper-multipath
isomd5sum

%end

%post
# FIXME: it'd be better to get this installed from a package
cat > /etc/rc.d/init.d/livesys << EOF
#!/bin/bash
#
# live: Init script for live image
#
# chkconfig: 345 00 99
# description: Init script for live image.

. /etc/init.d/functions

if ! strstr "\`cat /proc/cmdline\`" liveimg || [ "\$1" != "start" ]; then
    exit 0
fi

if [ -e /.liveimg-configured ] ; then
    configdone=1
fi

exists() {
    which \$1 >/dev/null 2>&1 || return
    \$*
}

touch /.liveimg-configured

# mount live image
if [ -b \`readlink -f /dev/live\` ]; then
   mkdir -p /mnt/live
   mount -o ro /dev/live /mnt/live 2>/dev/null || mount /dev/live /mnt/live
fi

livedir="LiveOS"
for arg in \`cat /proc/cmdline\` ; do
  if [ "\${arg##live_dir=}" != "\${arg}" ]; then
    livedir=\${arg##live_dir=}
    break
  fi
done

# enable swaps unless requested otherwise
swaps=\`blkid -t TYPE=swap -o device\`
if ! strstr "\`cat /proc/cmdline\`" noswap && [ -n "\$swaps" ] ; then
  for s in \$swaps ; do
    action "Enabling swap partition \$s" swapon \$s
  done
fi
if ! strstr "\`cat /proc/cmdline\`" noswap && [ -f /mnt/live/\${livedir}/swap.img ] ; then
  action "Enabling swap file" swapon /mnt/live/\${livedir}/swap.img
fi

mountPersistentHome() {
  # support label/uuid
  if [ "\${homedev##LABEL=}" != "\${homedev}" -o "\${homedev##UUID=}" != "\${homedev}" ]; then
    homedev=\`/sbin/blkid -o device -t "\$homedev"\`
  fi

  # if we're given a file rather than a blockdev, loopback it
  if [ "\${homedev##mtd}" != "\${homedev}" ]; then
    # mtd devs don't have a block device but get magic-mounted with -t jffs2
    mountopts="-t jffs2"
  elif [ ! -b "\$homedev" ]; then
    loopdev=\`losetup -f\`
    if [ "\${homedev##/mnt/live}" != "\${homedev}" ]; then
      action "Remounting live store r/w" mount -o remount,rw /mnt/live
    fi
    losetup \$loopdev \$homedev
    homedev=\$loopdev
  fi

  # if it's encrypted, we need to unlock it
  if [ "\$(/sbin/blkid -s TYPE -o value \$homedev 2>/dev/null)" = "crypto_LUKS" ]; then
    echo
    echo "Setting up encrypted /home device"
    plymouth ask-for-password --command="cryptsetup luksOpen \$homedev EncHome"
    homedev=/dev/mapper/EncHome
  fi

  # and finally do the mount
  mount \$mountopts \$homedev /home
  # if we have /home under what's passed for persistent home, then
  # we should make that the real /home.  useful for mtd device on olpc
  if [ -d /home/home ]; then mount --bind /home/home /home ; fi
  [ -x /sbin/restorecon ] && /sbin/restorecon /home
  if [ -d /home/liveuser ]; then USERADDARGS="-M" ; fi
}

findPersistentHome() {
  for arg in \`cat /proc/cmdline\` ; do
    if [ "\${arg##persistenthome=}" != "\${arg}" ]; then
      homedev=\${arg##persistenthome=}
      return
    fi
  done
}

if strstr "\`cat /proc/cmdline\`" persistenthome= ; then
  findPersistentHome
elif [ -e /mnt/live/\${livedir}/home.img ]; then
  homedev=/mnt/live/\${livedir}/home.img
fi

# if we have a persistent /home, then we want to go ahead and mount it
if ! strstr "\`cat /proc/cmdline\`" nopersistenthome && [ -n "\$homedev" ] ; then
  action "Mounting persistent /home" mountPersistentHome
fi

# make it so that we don't do writing to the overlay for things which
# are just tmpdirs/caches
mount -t tmpfs -o mode=0755 varcacheyum /var/cache/yum
mount -t tmpfs tmp /tmp
mount -t tmpfs vartmp /var/tmp
[ -x /sbin/restorecon ] && /sbin/restorecon /var/cache/yum /tmp /var/tmp >/dev/null 2>&1

if [ -n "\$configdone" ]; then
  exit 0
fi

# add default user with no password
/usr/sbin/useradd -c "LiveCD user" liveuser
/usr/bin/passwd -d liveuser > /dev/null
# give default user sudo privileges
echo "liveuser     ALL=(ALL)     NOPASSWD: ALL" >> /etc/sudoers

# give back ownership to the default user
chown -R liveuser:liveuser /home/liveuser

## fix various bugs and issues
# unmute sound card
exists alsaunmute 0 2> /dev/null

# turn off firstboot for livecd boots
chkconfig --level 345 firstboot off 2>/dev/null
echo "RUN_FIRSTBOOT=NO" > /etc/sysconfig/firstboot

# turn off mdmonitor by default
chkconfig --level 345 mdmonitor off 2>/dev/null

# turn off setroubleshoot on the live image to preserve resources
chkconfig --level 345 setroubleshoot off 2>/dev/null

# don't start cron/at as they tend to spawn things which are
# disk intensive that are painful on a live image
chkconfig --level 345 auditd          off 2>/dev/null
chkconfig --level 345 crond           off 2>/dev/null
chkconfig --level 345 atd             off 2>/dev/null
chkconfig --level 345 readahead_early off 2>/dev/null
chkconfig --level 345 readahead_later off 2>/dev/null

# disable kdump service
chkconfig --level 345 kdump           off 2>/dev/null

# disable microcode_ctl service
chkconfig --level 345 microcode_ctl   off 2>/dev/null

# disable smart card services
chkconfig --level 345 openct          off 2>/dev/null
chkconfig --level 345 pcscd           off 2>/dev/null

# disable postfix service
chkconfig --level 345 postfix         off 2>/dev/null

# Stopgap fix for RH #217966; should be fixed in HAL instead
touch /media/.hal-mtab

# workaround clock syncing on shutdown that we don't want (#297421)
sed -i -e 's/hwclock/no-such-hwclock/g' /etc/rc.d/init.d/halt

## configure default user's desktop
# set up timed auto-login at 10 seconds
cat >> /etc/gdm/custom.conf << FOE
[daemon]
TimedLoginEnable=true
TimedLogin=liveuser
TimedLoginDelay=10
FOE

# give back ownership to the default user
chown -R liveuser:liveuser /home/liveuser

EOF

# bah, hal starts way too late
cat > /etc/rc.d/init.d/livesys-late << EOF
#!/bin/bash
#
# live: Late init script for live image
#
# chkconfig: 345 99 01
# description: Late init script for live image.

. /etc/init.d/functions

if ! strstr "\`cat /proc/cmdline\`" liveimg || [ "\$1" != "start" ] || [ -e /.liveimg-late-configured ] ; then
    exit 0
fi

exists() {
    which \$1 >/dev/null 2>&1 || return
    \$*
}

touch /.liveimg-late-configured

# read some variables out of /proc/cmdline
for o in \`cat /proc/cmdline\` ; do
    case \$o in
    ks=*)
        ks="\${o#ks=}"
        ;;
    xdriver=*)
        xdriver="\${o#xdriver=}"
        ;;
    esac
done

# if liveinst or textinst is given, start anaconda
if strstr "\`cat /proc/cmdline\`" liveinst ; then
   plymouth --quit
   /usr/sbin/liveinst \$ks
fi
if strstr "\`cat /proc/cmdline\`" textinst ; then
   plymouth --quit
   /usr/sbin/liveinst --text \$ks
fi

# configure X, allowing user to override xdriver
if [ -n "\$xdriver" ]; then
   cat > /etc/X11/xorg.conf.d/00-xdriver.conf <<FOE
Section "Device"
	Identifier	"Videocard0"
	Driver	"\$xdriver"
EndSection
FOE
fi

# Fix the "liveinst doesn't start in gui mode when not enough memory available" - switching to terminal mode
sed -i "s/Terminal=false/Terminal=true/" /home/liveuser/Desktop/liveinst.desktop

EOF

# workaround avahi segfault (#279301)
touch /etc/resolv.conf
/sbin/restorecon /etc/resolv.conf

chmod 755 /etc/rc.d/init.d/livesys
/sbin/restorecon /etc/rc.d/init.d/livesys
/sbin/chkconfig --add livesys

chmod 755 /etc/rc.d/init.d/livesys-late
/sbin/restorecon /etc/rc.d/init.d/livesys-late
/sbin/chkconfig --add livesys-late

# go ahead and pre-make the man -k cache (#455968)
/usr/sbin/makewhatis -w

# save a little bit of space at least...
rm -f /var/lib/rpm/__db*
rm -f /boot/initrd*
rm -f /boot/initramfs*
# make sure there aren't core files lying around
rm -f /core*

# convince readahead not to collect
rm -f /.readahead_collect
touch /var/lib/readahead/early.sorted

%end


%post --nochroot
cp $INSTALL_ROOT/usr/share/doc/centos-release-*/GPL $LIVE_ROOT/GPL

# add livecd-iso-to-disk utility on the LiveCD
# only works on x86, x86_64
if [ "$(uname -i)" = "i386" -o "$(uname -i)" = "x86_64" ]; then
  if [ ! -d $LIVE_ROOT/LiveOS ]; then mkdir -p $LIVE_ROOT/LiveOS ; fi
  cp /usr/bin/livecd-iso-to-disk $LIVE_ROOT/LiveOS
fi

# customize boot menu entries
grep -B4 'menu default'  $LIVE_ROOT/isolinux/isolinux.cfg > $LIVE_ROOT/isolinux/default.txt
grep -B3 'xdriver=vesa'  $LIVE_ROOT/isolinux/isolinux.cfg > $LIVE_ROOT/isolinux/basicvideo.txt
grep -A3 'label check0'  $LIVE_ROOT/isolinux/isolinux.cfg > $LIVE_ROOT/isolinux/check.txt
grep -A2 'label memtest' $LIVE_ROOT/isolinux/isolinux.cfg > $LIVE_ROOT/isolinux/memtest.txt
grep -A2 'label local'   $LIVE_ROOT/isolinux/isolinux.cfg > $LIVE_ROOT/isolinux/localboot.txt

sed "s/label linux0/label linuxtext0/"   $LIVE_ROOT/isolinux/default.txt > $LIVE_ROOT/isolinux/textboot.txt
sed -i "s/Boot/Boot (Text Mode)/"                                           $LIVE_ROOT/isolinux/textboot.txt
sed -i "s/liveimg/liveimg 3/"                                               $LIVE_ROOT/isolinux/textboot.txt
sed -i "/menu default/d"                                                    $LIVE_ROOT/isolinux/textboot.txt

sed "s/label linux0/label install0/"     $LIVE_ROOT/isolinux/default.txt > $LIVE_ROOT/isolinux/install.txt
sed -i "s/Boot/Install/"                                                    $LIVE_ROOT/isolinux/install.txt
sed -i "s/liveimg/liveimg liveinst noswap nolvmmount/"                      $LIVE_ROOT/isolinux/install.txt
sed -i "s/ quiet / /"                                                       $LIVE_ROOT/isolinux/install.txt
sed -i "s/ rhgb / /"                                                        $LIVE_ROOT/isolinux/install.txt
sed -i "/menu default/d"                                                    $LIVE_ROOT/isolinux/install.txt

sed "s/label linux0/label textinstall0/" $LIVE_ROOT/isolinux/default.txt > $LIVE_ROOT/isolinux/textinstall.txt
sed -i "s/Boot/Install (Text Mode)/"                                        $LIVE_ROOT/isolinux/textinstall.txt
sed -i "s/liveimg/liveimg textinst noswap nolvmmount/"                      $LIVE_ROOT/isolinux/textinstall.txt
sed -i "s/ quiet / /"                                                       $LIVE_ROOT/isolinux/textinstall.txt
sed -i "s/ rhgb / /"                                                        $LIVE_ROOT/isolinux/textinstall.txt
sed -i "/menu default/d"                                                    $LIVE_ROOT/isolinux/textinstall.txt

cat $LIVE_ROOT/isolinux/default.txt $LIVE_ROOT/isolinux/basicvideo.txt $LIVE_ROOT/isolinux/check.txt $LIVE_ROOT/isolinux/memtest.txt $LIVE_ROOT/isolinux/localboot.txt > $LIVE_ROOT/isolinux/current.txt
diff $LIVE_ROOT/isolinux/isolinux.cfg $LIVE_ROOT/isolinux/current.txt | sed '/^[0-9][0-9]*/d; s/^. //; /^---$/d' > $LIVE_ROOT/isolinux/cleaned.txt
cat $LIVE_ROOT/isolinux/cleaned.txt $LIVE_ROOT/isolinux/default.txt $LIVE_ROOT/isolinux/textboot.txt $LIVE_ROOT/isolinux/basicvideo.txt $LIVE_ROOT/isolinux/install.txt $LIVE_ROOT/isolinux/textinstall.txt $LIVE_ROOT/isolinux/memtest.txt $LIVE_ROOT/isolinux/localboot.txt > $LIVE_ROOT/isolinux/isolinux.cfg
rm -f $LIVE_ROOT/isolinux/*.txt

# Forcing plymouth to show the logo in vesafb 
sed -i "s/rhgb/rhgb vga=791/g"	$LIVE_ROOT/isolinux/isolinux.cfg

# Disabling auto lvm/disk mount (that will crash the "Install to Hard Drive feature")
sed -i "s/quiet/quiet nodiskmount nolvmmount/g"	$LIVE_ROOT/isolinux/isolinux.cfg

%end
