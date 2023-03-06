FROM alpine
LABEL org.opencontainers.image.authors="Tim Trense <me@timtrense.com>"
RUN apk add --update --no-cache bash openssh-client

RUN mkdir -p /bin/shutdown.d /root/.ssh

COPY shutdown-orchestrator.sh /bin/shutdown-orchestrator.sh
RUN chmod u=rx,g=r,o=r /bin/shutdown-orchestrator.sh

WORKDIR /root
ENTRYPOINT [ "/bin/shutdown-orchestrator.sh" ]
