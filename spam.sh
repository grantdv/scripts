#!/bin/bash
makemap hash /etc/mail/access < /etc/mail/access

/etc/init.d/sendmail restart
