FROM haproxy:1.8.4-alpine

USER root
RUN apk update && \
    apk upgrade && \
    apk add rsyslog

# Rsyslog configuration updates. Update /etc/rsyslog.conf and 
# uncomment the following lines:
#$ModLoad imudp.so  # provides UDP syslog reception
#$UDPServerRun 514 # start a UDP syslog server at standard port 514

RUN sed -i.bck -e 's/^#\(\$ModLoad\)/\1/' -e 's/^#\(\$UDPServerRun\)/\1/' /etc/rsyslog.conf

COPY ./entrypoint /entrypoint
RUN chmod a+x /entrypoint
RUN mkdir -p /usr/local/etc/ssl && \
    chmod 700 /usr/local/etc/ssl

ENTRYPOINT [ "/entrypoint" ]
