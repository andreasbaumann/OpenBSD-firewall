; internal view of zone maschezuoz.ch

$ORIGIN maschezuoz.ch.

$TTL 1h

@		IN	SOA	ns.maschezuoz.ch. admin.maschezuoz.ch. (
				2026110300	; serial
				3h		; refresh
				15m		; retry
				2w		; expire
				1h		; minimum TTL
			)

	IN	NS		ns.maschezuoz.ch.
	IN	MX	10	smtp.maschezuoz.ch.
	IN	TXT		"v=spf1 mx ip4:83.150.2.48/24 ~all"

	IN		A	192.168.1.48

ns			A	192.168.1.1

www			A	192.168.1.48
smtp			A	192.168.1.48
imap			A	192.168.1.48
webmail			A	192.168.1.48
