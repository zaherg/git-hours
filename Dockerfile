FROM node:12.3.1-alpine

ARG BUILD_DATE
ARG VCS_REF
ARG IMAGE_NAME

LABEL Maintainer="Zaher Ghaibeh <z@zah.me>" \
      Description="Lightweight version of git-hours based on alpine instead of ubuntu." \
      org.label-schema.name=$IMAGE_NAME \
      org.label-schema.description="Lightweight version of git-hours based on alpine instead of ubuntu." \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/linuxjuggler/git-hours.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0.0"


# ENV NPM_VERSION=latest

RUN set -ex \
  	&& apk update \
  	&& apk add --no-cache tini git && \
  	rm -rf /usr/share/man /tmp/* /var/cache/apk/* && \
  	npm install -g git-hours && \
    rm -rf /tmp/* 

WORKDIR /code

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["git","hours"]