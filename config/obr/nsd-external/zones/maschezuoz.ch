; external view of zone maschezuoz.ch

$TTL 60

@		IN	SOA	ns.maschezuoz.ch. admin.maschezuoz.ch. (
				2020121200	; serial
				3h		; refresh
				15m		; retry
				2w		; expire
				60		; minimum TTL
			)

	IN	NS		d.ns.buddyns.com.
	IN	NS		f.ns.buddyns.com.
	IN	NS		h.ns.buddyns.com.
	IN	MX	10	smtp.maschezuoz.ch.
maschezuoz.ch.	IN      A	83.150.2.48
	IN	TXT		"v=spf1 mx ip4:83.150.2.48/24 ~all"
mail._domainkey IN      TXT     ( "v=DKIM1; k=rsa; s=email; "
          "p=MIIBHTANBgkqhkiG9w0BAQEFAAOCAQoAMIIBBQKB/QL7dTJ8ID7j7EJapWXb1pPJNYIJVi7ZjGYUBvHt7Z3gZiYYMZzNld1lcyzlxVSWYsxdXgeDLc/o9Evfn7nXilneiT+c7gvipAVE9bMXmFMPkUuCbOXCRwAevRXZ13UFRcT7UQGnfdZA9kjiQjqKHCcmbMl+5MgYyVTX1xUMaKQwxGTbGhevwgm0YBBa7pWXPGaV0+4v0uCxjDaEAV"
          "q4zSuRrK/AqNoL/NweuWgCPkYVj5lyYB/Gi2tOM7Gkc1CHCNqFc7rWBr3g8uiYkuijPMfj+R4yXVy655YPwNAxOpoggW9D30NC4Mj2gm+LXpkL5K7OTVcMhAevwx84QJMCAwEAAQ==" )
_dmarc  IN	TXT		"v=DMARC1; p=none; adkim=s; aspf=r; fo=1; rua=mailto:postmaster@maschezuoz.ch; ruf=mailto:postmaster@maschezuoz.ch"

$ORIGIN maschezuoz.ch.

ns	IN	A		83.150.2.48

www	IN	A		83.150.2.48
imap	IN	A		83.150.2.48
smtp	IN	A		83.150.2.48
webmail	IN	A		83.150.2.48
