FROM ubuntu:18.04

LABEL Maintainer="James Poulin"

RUN set -e \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update -y \
    && apt-get install -yq \
        procps \
        postfix \
        libsasl2-modules \
        rsyslog

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

ENTRYPOINT ["/tini", "--"]

CMD ["/launch.sh"]



