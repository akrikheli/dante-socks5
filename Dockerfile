FROM wernight/dante:latest

ARG SOCKS_USER
ARG SOCKS_PASS

RUN adduser -h /dev/null -s /sbin/nologin -D $SOCKS_USER

RUN echo "$SOCKS_USER:$SOCKS_PASS" | chpasswd
