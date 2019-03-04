FROM alpine:3.9

RUN apk update ; apk add perl perl-lwp-protocol-https perl-lwp-useragent-determined perl-json

COPY cachet_metrics.pl /cachet_metrics.pl

ENV http_proxy ""
ENV https_proxy ""

CMD perl /cachet_metrics.pl
