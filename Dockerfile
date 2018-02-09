FROM docker:edge

RUN apk --update --no-cache add make git bash openssh jq

COPY build.sh /tmp/build.sh

ENV HOME /tmp

ENTRYPOINT ["/tmp/build.sh"]
