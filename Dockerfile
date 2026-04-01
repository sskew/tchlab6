# syntax=docker/dockerfile:1
# ETAP 1
FROM scratch AS build-stage

ADD alpine-minirootfs-3.23.3-x86_64.tar / 

ARG VERSION
ARG MY_HOST
ARG MY_IP

RUN echo \
	"<html><body> \
	<h1>Raport Serwera</h1> \
	<p><b>IP:</b> ${MY_IP}</p> \
	<p><b>Hostname:</b> ${MY_HOST}</p> \
	<p><b>Wersja:</b> ${VERSION}</p> \
	</body></html>" \
	>> /index.html

# ETAP 2
FROM nginx:alpine

COPY --from=build-stage /index.html /usr/share/nginx/html/index.html

RUN apk add --update curl && rm -rf /var/cache/apk/*

HEALTHCHECK --interval=10s --timeout=1s CMD curl -f http://localhost:80/ || exit 1 

EXPOSE 80
