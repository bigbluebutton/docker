FROM python:3.15-alpine

ENV BBBCTL_VERSION=v0.5.1

RUN apk add curl
RUN curl -L -o /usr/local/bin/bbbctl \
        https://raw.githubusercontent.com/defnull/bbbctl/${BBBCTL_VERSION}/src/bbbctl.py && \
    chmod +x /usr/local/bin/bbbctl

CMD /usr/local/bin/bbbctl