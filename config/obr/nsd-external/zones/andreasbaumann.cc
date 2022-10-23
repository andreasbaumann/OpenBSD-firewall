; external view of zone andreasbaumann.cc

$TTL 60

@		IN	SOA	ns.andreasbaumann.cc. admin.andreasbaumann.cc. (
				2022102300	; serial
				3h		; refresh
				15m		; retry
				2w		; expire
				60		; minimum TTL
			)

		IN	NS		uz588h0rhwuu3cc03gm9uckw0w42cqr459wn1nxrbzhym2wd81zydb.pro.ns.buddyns.com.
		IN	NS		uz5dkwpjfvfwb9rh1qj93mtup0gw65s6j7vqqumch0r9gzlu8qxx39.pro.ns.buddyns.com.
		IN	NS		uz5x36jqv06q5yulzwcblfzcrk1b479xdttdm1nrgfglzs57bmctl8.pro.ns.buddyns.com.
		IN	MX	10	smtp.andreasbaumann.cc.
andreasbaumann.cc.	IN	A	83.150.2.48
		IN	TXT		"v=spf1 mx ip4:83.150.2.48/24 ~all"
mail._domainkey	IN	TXT		( "v=DKIM1; k=rsa; s=email; "
					"p=MIIBHTANBgkqhkiG9w0BAQEFAAOCAQoAMIIBBQKB/QMA0ISSnOsDXLhKLdTRyMBvEaOWBAoxvPhL/ADfWdUzYbwZ6ueKKqaE4EdCa0TDdO53Qf93uAeLuFhLaCoZvVOF4TnclwmkYTEYVe/GS0u2rwZfmB+VuHG3ZMxvLRJbmaHM2b7oU5sNFF2uTjFPXFytgKGZ1Srp7yUsUvfnbgwF/1gB02tTqOnfxroDA10jsUo49fBsJ5G0OlXFYc"
					"Z4vIq/yHM8/az5peVoaaFA1A+RVMLvy+o1XbhMBsM7nOnDPcQxPyxBcDmedgbni6F3I8Vl2hYDvcjza5eJ8fJVxjLBVWMYAhRowWzl0TU9nyeHBbncCYW9QiNBicHQy88CAwEAAQ==" )
_dmarc		IN	TXT		"v=DMARC1; p=none; adkim=s; aspf=r; fo=1; rua=mailto:postmaster@andreasbaumann.cc; ruf=mailto:postmaster@andreasbaumann.cc"

$ORIGIN andreasbaumann.cc.

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
mon		IN	A		83.150.2.48
archlinux32	IN	A		83.150.2.48
