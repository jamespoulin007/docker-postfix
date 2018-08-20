FROM ubuntu:18.04

LABEL Maintainer="James Poulin"

RUN set -e \
    apt-get update \
    && apt-get -y --no-install-recommends install \
      procps \
      postfix \
      libsasl2-modules \
      rsyslog  \
    && apt-get clean  \
    && rm -rf /var/lib/apt/lists/*
# Default config:
# Open relay, trust docker links for firewalling.
# Try to use TLS when sending to other smtp servers.
# No TLS for connecting clients, trust docker network to be safe

ENV \
    POSTFIX_myhostname=mail.smtp \
    POSTFIX_inet_interfaces=all \
    POSTFIX_mydestination=localhost \
    POSTFIX_mynetworks=10.0.0.0/8 \
    POSTFIX_smtp_tls_security_level=may \
    POSTFIX_smtpd_tls_security_level=none \
    TINI_VERSION=v0.18.0

ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini

RUN chmod +x /tini

COPY rsyslog.conf /etc/rsyslog.conf

COPY launch.sh /

RUN chmod +x /launch.sh

ENTRYPOINT ["/tini", "--", "/launch.sh"]

