; external view of zone andreasbaumann.cc

$TTL 60

@		IN	SOA	ns.andreasbaumann.cc. admin.andreasbaumann.cc. (
				2018102800	; serial
				3h		; refresh
				15m		; retry
				2w		; expire
				60		; minimum TTL
			)

		IN	NS		d.ns.buddyns.com.
		IN	NS		e.ns.buddyns.com.
		IN	NS		h.ns.buddyns.com.
		IN	MX	10	smtp.andreasbaumann.cc.
		IN	TXT		"v=spf1 mx ip4:83.150.2.48/24 ~all"

$ORIGIN andreasbaumann.cc.

		IN	A		83.150.2.48

ns		IN	A		83.150.2.48
smtp		IN	A		83.150.2.48

www		IN	A		83.150.2.48
cloud		IN	A		83.150.2.48
ftp		IN	A		83.150.2.48
imap		IN	A		83.150.2.48
pop		IN	A		83.150.2.48
smtp		IN	A		83.150.2.48
webmail		IN	A		83.150.2.48
git		IN	A		83.150.2.48
devel		IN	A		83.150.2.48
mon		IN	A		83.150.2.48
archlinux32	IN	A		83.150.2.48

; this is hosted at GoDaddy
backup		IN	A		192.186.235.194
