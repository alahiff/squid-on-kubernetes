FROM alpine:3.4

RUN apk add --update squid python supervisor
RUN rm -rf /var/cache/apk/*

COPY initialization.sh /usr/local/bin/
COPY squid.conf /etc/squid/

COPY supervisord.conf /etc/supervisor/conf.d/
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

# Log rotation
COPY squid-log-rotate.sh /usr/local/bin/
COPY squid /etc/crontabs/
RUN rm -f /etc/crontabs/root

EXPOSE 3128

VOLUME /var/cache/squid /var/log/squid
