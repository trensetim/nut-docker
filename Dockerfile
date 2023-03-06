FROM alpine
LABEL org.opencontainers.image.authors="Tim Trense <me@timtrense.com>"
RUN apk add --update --no-cache nut libcrypto1.1 libssl1.1 net-snmp-libs bash

RUN mkdir -p /var/run/nut /etc/nut
RUN chmod u=rwx,g=rx,o=rx /var/run/nut /etc/nut

# UPSd
COPY ups.conf /etc/nut/ups.conf
RUN chmod u=r,o=,g= /etc/nut/ups.conf
COPY upsd.conf /etc/nut/upsd.conf
RUN chmod u=r,o=,g= /etc/nut/upsd.conf
COPY upsd.users /etc/nut/upsd.users
RUN chmod u=rw,o=,g= /etc/nut/upsd.users
RUN touch /var/run/nut/upsd.pid
RUN chmod u=rw,o=r,g=r /var/run/nut/upsd.pid

# UPSmon
COPY upsmon.conf /etc/nut/upsmon.conf
RUN chmod u=rw,o=,g= /etc/nut/upsmon.conf

# NUT
COPY nut.conf /etc/nut/nut.conf
RUN chmod u=r,o=,g= /etc/nut/nut.conf

COPY entrypoint.sh /bin/entrypoint.sh
RUN chmod +x /bin/entrypoint.sh

EXPOSE 3493
ENTRYPOINT ["sh", "/bin/entrypoint.sh"]
