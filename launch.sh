#!/bin/bash
set -e

# POSTFIX_var env -> postconf -e var=$POSTFIX_var
for e in ${!POSTFIX_*} ; do postconf -e "${e:8}=${!e}" ; done
chown -R postfix:postfix /var/lib/postfix /var/mail /var/spool/postfix

service postfix start
rsyslogd -n &
wait
exit 0
