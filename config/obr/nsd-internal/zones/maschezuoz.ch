; internal view of zone maschezuoz.ch

$TTL 60

@		IN	SOA	ns.maschezuoz.ch. admin.maschezuoz.ch. (
				2024012001	; serial
				3h		; refresh
				15m		; retry
				2w		; expire
				60		; minimum TTL
			)

	IN	NS		ns.maschezuoz.ch.
	IN	MX	10	smtp.maschezuoz.ch.
	IN	TXT		"v=spf1 mx ip4:83.150.2.48/24 ~all"

$ORIGIN maschezuoz.ch.

	IN		A	192.168.1.15

ns			A	192.168.1.1

www			A	192.168.1.15
smtp			A	192.168.1.15
imap			A	192.168.1.15
webmail			A	192.168.1.15
