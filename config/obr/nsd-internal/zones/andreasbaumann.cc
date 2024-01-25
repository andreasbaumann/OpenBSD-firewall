; internal view of zone andreasbaumann.cc

$TTL 60

@		IN	SOA	ns.andreasbaumann.cc. root.andreasbaumann.cc. (
				2024012001	; serial
				3h		; refresh
				15m		; retry
				2w		; expire
				60		; minimum TTL
			)

	IN	NS		ns.andreasbaumann.cc.
	IN	MX	10	smtp.andreasbaumann.cc.
	IN	TXT		"v=spf1 mx ip4:83.150.2.48/24 ~all"

$ORIGIN andreasbaumann.cc.

	IN		A	192.168.1.15

ns			A	192.168.1.1

cloud			A	192.168.1.15
ftp			A	192.168.1.9
imap			A	192.168.1.15
pop			A	192.168.1.15
smtp			A	192.168.1.15
webmail			A	192.168.1.15
www			A	192.168.1.15
git			A	192.168.1.15
archlinux32		A	192.168.1.15
mon			A	192.168.1.15

