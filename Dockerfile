FROM alpine:3.9

ENV http_proxy http://10.100.0.100:8080
ENV https_proxy http://10.100.0.100:8080

RUN apk update ; apk add perl perl-lwp-protocol-https perl-lwp-useragent-determined perl-json

COPY cachet_metrics.pl /cachet_metrics.pl

ENV http_proxy ""
ENV https_proxy ""

#CMD tail -f /etc/hosts
CMD perl /cachet_metrics.pl ; sleep 10
