FROM haproxy:1.8.4-alpine

USER root
COPY ./entrypoint /entrypoint
RUN chmod a+x /entrypoint
RUN mkdir -p /usr/local/etc/ssl && \
    chmod 700 /usr/local/etc/ssl

ENTRYPOINT [ "/entrypoint" ]
