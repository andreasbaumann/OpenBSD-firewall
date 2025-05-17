#!/bin/sh

DEVICE=vnd0
MOUNTPOINT=/mnt/fw
# depends on the hardware sdX for SCSI and wd0 for flashes/IDE/PATA
# (also adapt in template/etc/fstab for instance)
ROOT=sd0

if test X$1 = X"-h"; then
	print "Usage: build.sh [ <machine> [ <flash layout> ] ]"
	print "       the default for <flash layout> is <machine>"
	print "       the default for <machine> is 'firewall-test'"
	exit 0
fi

if test X$1 = X""; then
	HOSTNAME=firewall-test
else
	HOSTNAME=$1
fi

if test X$2 = X""; then
	HARDWARE_FILE=hardware/$HOSTNAME/flash_params
else
	HARDWARE_FILE=hardware/$2/flash_params
fi

. $HARDWARE_FILE

IMAGE_FILE=$HOSTNAME.img

nof_sectors=`expr $SECTORS_PER_TRACK \* $TRACKS_PER_CYLINDER \* $CYLINDERS`

echo "Using the following disk geometry:"
echo "Bytes/sector: $BYTES_PER_SECTOR"
echo "Sectors/track: $SECTORS_PER_TRACK"
echo "Tracks/cylinder: $TRACKS_PER_CYLINDER"
echo "Sectors/cylinder: $SECTORS_PER_CYLINDER"
echo "Cylinders: $CYLINDERS"
echo "Offset: $OFFSET"
echo "Number of sectors: $nof_sectors"

echo "Clean up from previous invocations."

umount $MOUNTPOINT
vnconfig -u $DEVICE
rm -f $IMAGE_FILE

echo "Using image $IMAGE_FILE as virtual device $DEVICE with $nof_sectors a $BYTES_PER_SECTOR bytes per sector."

dd if=/dev/zero of=$IMAGE_FILE bs=$BYTES_PER_SECTOR count=$nof_sectors

vnconfig $DEVICE $IMAGE_FILE
vnconfig -l

echo "Installing MBR and creating PC partition table."

fdisk -c $CYLINDERS -h $TRACKS_PER_CYLINDER -s $SECTORS_PER_TRACK -f /usr/mdec/mbr -e $DEVICE <<EOF
reinit
update
write
quit
EOF

echo "Setting up BSD disklabel."

# leave first cylinder empty for MBR and boot code
#astart=`expr $SECTORS_PER_TRACK`
astart=$OFFSET
asize=`expr $nof_sectors - $SECTORS_PER_TRACK - $astart`

cat > /tmp/disklabel.$$ <<EOF
type: ESDI
label: root
bytes/sector: $BYTES_PER_SECTOR
sectors/track: $SECTORS_PER_TRACK
tracks/cylinder: $TRACKS_PER_CYLINDER
sectors/cylinder: $SECTORS_PER_CYLINDER
cylinders: $CYLINDERS
total sectors: $nof_sectors

  a:           $asize                $astart     4.2BSD  1024    8192    16
  c:           $nof_sectors          0  unused
EOF

disklabel -R $DEVICE /tmp/disklabel.$$

echo "Making file system."

newfs -S $BYTES_PER_SECTOR /dev/r${DEVICE}a

mkdir $MOUNTPOINT
mount -o async /dev/${DEVICE}a $MOUNTPOINT

echo "Installing boot blocks."

# Blocks are written to the boot code and are used for bootstrapping
# Don't move the file after calling 'installboot' or call 'installboot' again.

cp -R /usr/mdec/boot $MOUNTPOINT/
installboot -v -r $MOUNTPOINT -v $DEVICE /usr/mdec/biosboot /boot

# eventually build a custom kernel first. Not for space reasons, but  
# maybe security (security patches)

echo "Installing kernel."

cp -R /bsd $MOUNTPOINT/

echo "Creating directory structure."

mkdir $MOUNTPOINT/{bin,etc,sbin,dev,usr,usr/libexec,usr/libexec/auth,usr/sbin,usr/bin,usr/lib,usr/share,usr/share/misc,usr/share/terminfo,root,etc/ssh}
chmod 0755 $MOUNTPOINT/{bin,etc,sbin,dev,usr,usr/libexec,usr/libexec/auth,usr/sbin,usr/bin,usr/lib,etc/ssh}
chmod 0700 $MOUNTPOINT/root

mkdir $MOUNTPOINT/tmp
chmod 0777 $MOUNTPOINT/tmp
chmod +t $MOUNTPOINT/tmp

echo "Populating /dev filesystem with minimal set up startup devices."

cp -R /dev/MAKEDEV $MOUNTPOINT/dev/.
( cd $MOUNTPOINT/dev && ./MAKEDEV std $ROOT random pf bpf ttyC0 tty00 )

echo "Installing userland."

cp -R /sbin/init $MOUNTPOINT/sbin/.
cp -R /bin/cat $MOUNTPOINT/bin/.
cp -R /bin/chgrp $MOUNTPOINT/bin/.
cp -R /bin/chmod $MOUNTPOINT/bin/.
cp -R /bin/cp $MOUNTPOINT/bin/.
cp -R /bin/date $MOUNTPOINT/bin/.
cp -R /bin/df $MOUNTPOINT/bin/.
cp -R /bin/domainname $MOUNTPOINT/bin/.
cp -R /bin/echo $MOUNTPOINT/bin/.
cp -R /bin/expr $MOUNTPOINT/bin/.
cp -R /bin/hostname $MOUNTPOINT/bin/.
cp -R /bin/kill $MOUNTPOINT/bin/.
cp -R /bin/ksh $MOUNTPOINT/bin/.
cp -R /bin/ln $MOUNTPOINT/bin/.
cp -R /bin/ls $MOUNTPOINT/bin/.
cp -R /bin/mkdir $MOUNTPOINT/bin/.
cp -R /bin/mv $MOUNTPOINT/bin/.
cp -R /bin/ps $MOUNTPOINT/bin/.
cp -R /bin/pwd $MOUNTPOINT/bin/.
cp -R /bin/rm $MOUNTPOINT/bin/.
cp -R /bin/rmdir $MOUNTPOINT/bin/.
cp -R /bin/sh $MOUNTPOINT/bin/.
cp -R /bin/sleep $MOUNTPOINT/bin/.
cp -R /bin/stty $MOUNTPOINT/bin/.
cp -R /bin/sync $MOUNTPOINT/bin/.
cp -R /bin/tar $MOUNTPOINT/bin/.
cp -R /bin/test $MOUNTPOINT/bin/.

cp -R /sbin/chown $MOUNTPOINT/sbin/.
cp -R /sbin/dmesg $MOUNTPOINT/sbin/.
cp -R /sbin/fsck $MOUNTPOINT/sbin/.
cp -R /sbin/fsck_ffs $MOUNTPOINT/sbin/.
cp -R /sbin/halt $MOUNTPOINT/sbin/.
cp -R /sbin/ifconfig $MOUNTPOINT/sbin/.
cp -R /sbin/init $MOUNTPOINT/sbin/.
cp -R /sbin/ldconfig $MOUNTPOINT/sbin/.
cp -R /sbin/mkfifo $MOUNTPOINT/sbin/.
cp -R /sbin/mknod $MOUNTPOINT/sbin/.
cp -R /sbin/mount $MOUNTPOINT/sbin/.
cp -R /sbin/mount_ffs $MOUNTPOINT/sbin/.
cp -R /sbin/mount_mfs $MOUNTPOINT/sbin/.
cp -R /sbin/mount_tmpfs $MOUNTPOINT/sbin/.
cp -R /sbin/newfs $MOUNTPOINT/sbin/.
cp -R /sbin/nologin $MOUNTPOINT/sbin/.
cp -R /sbin/pfctl $MOUNTPOINT/sbin/.
cp -R /sbin/pflogd $MOUNTPOINT/sbin/.
cp -R /sbin/ping $MOUNTPOINT/sbin/.
cp -R /sbin/reboot $MOUNTPOINT/sbin/.
cp -R /sbin/route $MOUNTPOINT/sbin/.
cp -R /sbin/scan_ffs $MOUNTPOINT/sbin/.
cp -R /sbin/shutdown $MOUNTPOINT/sbin/.
cp -R /sbin/sysctl $MOUNTPOINT/sbin/.
cp -R /sbin/umount $MOUNTPOINT/sbin/.

# dynamic binaries from here, find libraries and copy them too
# at the end

cp -R /usr/libexec/getty $MOUNTPOINT/usr/libexec
cp -R /usr/libexec/ld.so $MOUNTPOINT/usr/libexec

cp -R /usr/sbin/arp $MOUNTPOINT/usr/sbin/.
cp -R /usr/sbin/bgpctl $MOUNTPOINT/usr/sbin/.
cp -R /usr/sbin/bgpd $MOUNTPOINT/usr/sbin/.
cp -R /usr/sbin/cron $MOUNTPOINT/usr/sbin/.
cp -R /usr/sbin/config $MOUNTPOINT/usr/sbin/.
cp -R /usr/sbin/dev_mkdb $MOUNTPOINT/usr/sbin/.
cp -R /usr/sbin/dhcrelay $MOUNTPOINT/usr/sbin/.
cp -R /usr/bin/dig $MOUNTPOINT/usr/sbin/.
cp -R /usr/sbin/ftp-proxy $MOUNTPOINT/usr/sbin/.
cp -R /usr/sbin/ospfctl $MOUNTPOINT/usr/sbin/.
cp -R /usr/sbin/ospfd $MOUNTPOINT/usr/sbin/.
cp -R /usr/sbin/pwd_mkdb $MOUNTPOINT/usr/sbin/.
cp -R /usr/sbin/rdate $MOUNTPOINT/usr/sbin/.
cp -R /usr/sbin/sensorsd $MOUNTPOINT/usr/sbin/.
cp -R /usr/sbin/snmpd $MOUNTPOINT/usr/sbin/.
cp -R /usr/sbin/sshd $MOUNTPOINT/usr/sbin/.
cp -R /usr/libexec/sshd-session $MOUNTPOINT/usr/libexec/.
cp -R /usr/libexec/sshd-auth $MOUNTPOINT/usr/libexec/.
cp -R /usr/sbin/syslogc $MOUNTPOINT/usr/sbin/.
cp -R /usr/sbin/syslogd $MOUNTPOINT/usr/sbin/.
cp -R /usr/sbin/tcpdump $MOUNTPOINT/usr/sbin/.
cp -R /usr/sbin/tftp-proxy $MOUNTPOINT/usr/sbin/.
cp -R /usr/sbin/traceroute $MOUNTPOINT/usr/sbin/.
cp -R /usr/sbin/vipw $MOUNTPOINT/usr/sbin/.

cp -R /usr/bin/crontab $MOUNTPOINT/usr/bin/.
cp -R /usr/bin/du $MOUNTPOINT/usr/bin/.
cp -R /usr/bin/find $MOUNTPOINT/usr/bin/.
cp -R /usr/bin/grep $MOUNTPOINT/usr/bin/.
cp -R /usr/bin/gzip $MOUNTPOINT/usr/bin/.
# handy for debugging
#cp -R /usr/bin/ldd $MOUNTPOINT/usr/bin/.
cp -R /usr/bin/less $MOUNTPOINT/usr/bin/.
cp -R /usr/bin/logger $MOUNTPOINT/usr/bin/.
cp -R /usr/bin/login $MOUNTPOINT/usr/bin/.
cp -R /usr/bin/more $MOUNTPOINT/usr/bin/.
cp -R /usr/bin/netstat $MOUNTPOINT/usr/bin/.
cp -R /usr/bin/newsyslog $MOUNTPOINT/usr/bin/.
cp -R /usr/bin/passwd $MOUNTPOINT/usr/bin/.
cp -R /usr/bin/pkill $MOUNTPOINT/usr/bin/.
cp -R /usr/bin/scp $MOUNTPOINT/usr/bin/.
cp -R /usr/bin/sed $MOUNTPOINT/usr/bin/.
cp -R /usr/bin/sort $MOUNTPOINT/usr/bin/.
cp -R /usr/bin/ssh $MOUNTPOINT/usr/bin/.
cp -R /usr/bin/ssh-add $MOUNTPOINT/usr/bin/.
cp -R /usr/bin/ssh-agent $MOUNTPOINT/usr/bin/.
cp -R /usr/bin/ssh-keygen $MOUNTPOINT/usr/bin/.
cp -R /usr/bin/tail $MOUNTPOINT/usr/bin/.
cp -R /usr/bin/telnet $MOUNTPOINT/usr/bin/.
cp -R /usr/bin/top $MOUNTPOINT/usr/bin/.
cp -R /usr/bin/touch $MOUNTPOINT/usr/bin/.
cp -R /usr/bin/uname $MOUNTPOINT/usr/bin/.
cp -R /usr/bin/uniq $MOUNTPOINT/usr/bin/. 
cp -R /usr/bin/uptime $MOUNTPOINT/usr/bin/.
cp -R /usr/bin/vi $MOUNTPOINT/usr/bin/.
cp -R /usr/bin/wall $MOUNTPOINT/usr/bin/.   
cp -R /usr/bin/xargs $MOUNTPOINT/usr/bin/.
if test -f /usr/local/bin/wol; then
	cp -R /usr/local/bin/wol $MOUNTPOINT/usr/bin/.
fi
cp -R /usr/bin/zcat $MOUNTPOINT/usr/bin/.    

cp -R /sbin/disklabel $MOUNTPOINT/usr/sbin/.

echo "Installing additional files."

# authentication plugins (needed for logging into the machine)

cp -R /usr/libexec/auth/login_crypto $MOUNTPOINT/usr/libexec/auth/.
cp -R /usr/libexec/auth/login_lchpass $MOUNTPOINT/usr/libexec/auth/.
cp -R /usr/libexec/auth/login_passwd $MOUNTPOINT/usr/libexec/auth/.
cp -R /usr/libexec/auth/login_reject $MOUNTPOINT/usr/libexec/auth/.
cp -R /usr/libexec/auth/login_skey $MOUNTPOINT/usr/libexec/auth/.

# symlinking /var to /tmp/var (tmp is a MFS)

ln -s /tmp/var $MOUNTPOINT/var

cp -R /usr/share/misc/termcap $MOUNTPOINT/usr/share/misc/.
cp -R /usr/share/terminfo/* $MOUNTPOINT/usr/share/terminfo/.

echo "Installing common configuration."

cp -R template/etc/boot.conf $MOUNTPOINT/etc/.
cp -R template/etc/fstab $MOUNTPOINT/etc/.
cp -R template/etc/login.conf $MOUNTPOINT/etc/.
cp -R template/etc/protocols $MOUNTPOINT/etc/.
cp -R template/etc/services $MOUNTPOINT/etc/. 
cp -R template/etc/passwd $MOUNTPOINT/etc/.
cp -R template/etc/group $MOUNTPOINT/etc/.
cp -R template/etc/master.passwd $MOUNTPOINT/etc/.
cp -R template/etc/gettytab $MOUNTPOINT/etc/.
cp -R template/etc/ttys $MOUNTPOINT/etc/.
cp -R template/etc/termcap $MOUNTPOINT/etc/.
cp -R template/etc/pf.os $MOUNTPOINT/etc/.
cp -R template/etc/syslog.conf $MOUNTPOINT/etc/.
cp -R template/etc/tabs $MOUNTPOINT/etc/.
chmod 0600 $MOUNTPOINT/etc/tabs/*
cp -R template/etc/ssh/sshd_config $MOUNTPOINT/etc/ssh/.
cp -R template/etc/moduli $MOUNTPOINT/etc/.
cp -R /usr/share/zoneinfo/Europe/Zurich $MOUNTPOINT/etc/localtime

cp -R template/root/.profile $MOUNTPOINT/root/.

echo "Installing non-optional specific configuration for $HOSTNAME."

cp -R config/$HOSTNAME/hosts $MOUNTPOINT/etc/.
cp -R config/$HOSTNAME/networks $MOUNTPOINT/etc/.
cp -R config/$HOSTNAME/pf.conf $MOUNTPOINT/etc/.
cp -R config/$HOSTNAME/badhosts $MOUNTPOINT/etc/.
cp -R config/$HOSTNAME/resolv.conf $MOUNTPOINT/etc/.
cp -R config/$HOSTNAME/newsyslog.conf $MOUNTPOINT/etc/.
if test -f config/$HOSTNAME/boot.conf; then
	cp -R config/$HOSTNAME/boot.conf $MOUNTPOINT/etc/.
fi
m4 -DHOSTNAME=$HOSTNAME template/etc/rc >  $MOUNTPOINT/etc/rc

# depending on the existence of some config files for the specific build
# we copy the configuration and the binaries (and scripts) to the flash
# only if necessary

echo "Installing optional specific configuration for $HOSTNAME."

# when running a DHCP client for an uplink
if test -f config/$HOSTNAME/dhclient.conf; then
	cp -R config/$HOSTNAME/dhclient.conf $MOUNTPOINT/etc/.
	cp -R /sbin/dhclient $MOUNTPOINT/sbin/.
fi
if test -f config/$HOSTNAME/dhcpleased.conf; then
	cp -R config/$HOSTNAME/dhcpleased.conf $MOUNTPOINT/etc/.
	cp -R /sbin/dhcpleased $MOUNTPOINT/sbin/.
	cp -R /usr/sbin/dhcpleasectl $MOUNTPOINT/sbin/.
fi

# when running a DHCP server for the local network
if test -f config/$HOSTNAME/dhcpd.conf; then
	cp -R config/$HOSTNAME/dhcpd.conf $MOUNTPOINT/etc/.
	cp -R /usr/sbin/dhcpd $MOUNTPOINT/usr/sbin/.
	cp -R template/usr/sbin/restart_dhcpd $MOUNTPOINT/usr/sbin/.
fi

# synchronizing time is always a good idea
if test -f config/$HOSTNAME/ntpd.conf; then
	mkdir $MOUNTPOINT/etc/ssl
	cp -R /etc/ssl/cert.pem $MOUNTPOINT/etc/ssl/.
	cp -R config/$HOSTNAME/ntpd.conf $MOUNTPOINT/etc/.
	cp -R /usr/sbin/ntpctl $MOUNTPOINT/usr/sbin/.
	cp -R /usr/sbin/ntpd $MOUNTPOINT/usr/sbin/.
fi

# when we want joe instead of vi (I do)
if test -d config/$HOSTNAME/joe/; then
	cp -R config/$HOSTNAME/joe $MOUNTPOINT/etc/.
	cp -R /usr/local/bin/joe $MOUNTPOINT/usr/bin/jstar
fi

# when we run an authorative name server for local DNS spoofing,
# split horizon entries and we don't like to stuff data from
# zone files into unbound's configuration as local data
if test -d config/$HOSTNAME/nsd-internal/; then
	cp -R config/$HOSTNAME/nsd-internal $MOUNTPOINT/etc/.
	cp -R /usr/sbin/nsd $MOUNTPOINT/usr/sbin/.
	cp -R /usr/sbin/nsd-{checkconf,checkzone,control,control-setup} $MOUNTPOINT/usr/sbin/.
	nsd-control-setup -d $MOUNTPOINT/etc/nsd-internal/etc
	cp -R template/usr/sbin/restart_dns $MOUNTPOINT/usr/sbin/.
fi

# when we run an authorative name server for public zones (in this
# case one DNS master and buddyns as public slaves)
if test -d config/$HOSTNAME/nsd-external/; then
	cp -R config/$HOSTNAME/nsd-external $MOUNTPOINT/etc/.
	cp -R /usr/sbin/nsd $MOUNTPOINT/usr/sbin/.
	cp -R /usr/sbin/nsd-{checkconf,checkzone,control,control-setup} $MOUNTPOINT/usr/sbin/.
	nsd-control-setup -d $MOUNTPOINT/etc/nsd-external/etc
	cp -R template/usr/sbin/restart_dns $MOUNTPOINT/usr/sbin/.
fi

# when we run a DNS resolver
if test -d config/$HOSTNAME/unbound/; then
	cp -R config/$HOSTNAME/unbound $MOUNTPOINT/etc/.
	wget ftp://FTP.INTERNIC.NET/domain/named.cache -O config/$HOSTNAME/unbound/etc/root.hints
	/usr/sbin/unbound-anchor -a config/$HOSTNAME/unbound//etc/unbound/etc/root.key
	cp -R /usr/sbin/unbound $MOUNTPOINT/usr/sbin/.
	cp -R /usr/sbin/unbound-{checkconf,control-setup,anchor,control,host} $MOUNTPOINT/usr/sbin/.
	unbound-control-setup -d $MOUNTPOINT/etc/unbound/etc
	cp -R template/usr/sbin/restart_dns $MOUNTPOINT/usr/sbin/.
fi

# when we run a relayer
if test -f config/$HOSTNAME/relayd.conf; then
	cp -R config/$HOSTNAME/relayd.conf $MOUNTPOINT/etc/.
	cp -R /usr/sbin/relayd $MOUNTPOINT/usr/sbin/.
	cp -R /usr/sbin/relayctl $MOUNTPOINT/usr/sbin/.
fi

# autodetect shared libraries needed for all the binaries installed before, then
# copy them to the flash

echo "Installing required shared libraries."

for i in `ldd $MOUNTPOINT/{bin,sbin,usr/bin,usr/sbin}/* 2>/dev/null | grep /usr/lib | tr -s ' ' '\t' | cut -f 8 | sort | uniq`; do
	cp -R $i $MOUNTPOINT/usr/lib/.
done
rm $MOUNTPOINT/usr/lib/ld.so

echo "Generating databases."

# TODO: encrypt: changer master.passwd root password
pwd_mkdb -p -d $MOUNTPOINT/etc/ $MOUNTPOINT/etc/master.passwd 

echo "Generating SSH keys."

ssh-keygen -b 2048 -t rsa -f $MOUNTPOINT/etc/ssh/ssh_host_rsa_key -N ''
chmod 400 $MOUNTPOINT/etc/ssh/ssh_host_rsa_key

echo "Cleaning up."

find $MOUNTPOINT -name .gitkeep -exec rm {} \;

sync
sleep 2
umount $MOUNTPOINT
vnconfig -u $DEVICE

rm -f /tmp/disklabel.$$

echo "Done."
  
exit 0
