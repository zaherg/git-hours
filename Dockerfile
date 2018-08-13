FROM alpine:3.8

ARG BUILD_DATE
ARG VCS_REF

LABEL Maintainer="Zaher Ghaibeh <z@zah.me>" \
      Description="Lightweight version of git-hours based on alpine instead of ubuntu." \
      org.label-schema.name="zaherg/git-hours" \
      org.label-schema.description="Lightweight version of git-hours based on alpine instead of ubuntu." \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/linuxjuggler/git-hours.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0.0"


ENV VERSION=v6.14.3 NPM_VERSION=3

RUN set -ex \
  	&& apk update \
  	&& apk add --no-cache git curl make gcc g++ python linux-headers binutils-gold gnupg libstdc++ && \
  	for server in ipv4.pool.sks-keyservers.net keyserver.pgp.com ha.pool.sks-keyservers.net; do \
	    gpg --keyserver $server --recv-keys \
	      94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
	      FD3A5288F042B6850C66B31F09FE44734EB7990E \
	      71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
	      DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
	      C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
	      B9AE9905FFD7803F25714661B63B535A4C206CA9 \
	      56730D5401028683275BD23C23EFEFE93C4CFFFE \
	      77984A986EBC2AA786BC0F66B01FBB92821C587A && break; \
  	done && \
  	curl -sfSLO https://nodejs.org/dist/${VERSION}/node-${VERSION}.tar.xz && \
  	curl -sfSL https://nodejs.org/dist/${VERSION}/SHASUMS256.txt.asc | gpg --batch --decrypt | \
    grep " node-${VERSION}.tar.xz\$" | sha256sum -c | grep ': OK$' && \
  	tar -xf node-${VERSION}.tar.xz && \
  	cd node-${VERSION} && \
  	./configure --prefix=/usr && \
  	make -j$(getconf _NPROCESSORS_ONLN) && \
  	make install && \
  	cd / && \
	if [ -n "$NPM_VERSION" ]; then \
  		npm install -g npm@${NPM_VERSION}; \
	fi; \
	find /usr/lib/node_modules/npm -name test -o -name .bin -type d | xargs rm -rf; \
  	apk del curl make gcc g++ python linux-headers binutils-gold gnupg ${DEL_PKGS} && \
  	rm -rf ${RM_DIRS} /node-${VERSION}* /usr/share/man /tmp/* /var/cache/apk/* \
    /root/.npm /root/.node-gyp /root/.gnupg /usr/lib/node_modules/npm/man \
    /usr/lib/node_modules/npm/doc /usr/lib/node_modules/npm/html /usr/lib/node_modules/npm/scripts && \
  	npm install -g git-hours && \
    rm -rf /tmp/* 

WORKDIR /code

CMD ["git","hours"]