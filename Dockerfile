FROM bmoorman/ubuntu:focal

ARG DEBIAN_FRONTEND=noninteractive

ENV HTTPD_SERVERNAME=localhost \
    HTTPD_PORT=9357

WORKDIR /var/www

RUN apt-get update \
 && apt-get install --yes --no-install-recommends \
    apache2 \
    certbot \
    curl \
    git \
    libapache2-mod-php \
    php-curl \
    php-ldap \
    php-sqlite3 \
    php-xml \
    php-zip \
    ssl-cert \
 && a2enmod \
    remoteip \
    rewrite \
    ssl \
 && sed --in-place --regexp-extended \
    --expression 's|^(Include\s+ports\.conf)$|#\1|' \
    /etc/apache2/apache2.conf \
 && git clone --single-branch https://github.com/causefx/Organizr.git \
 && apt-get autoremove --yes --purge \
 && apt-get clean \
 && rm --recursive --force /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY apache2/ /etc/apache2/

VOLUME /config

EXPOSE ${HTTPD_PORT}

CMD ["/etc/apache2/start.sh"]

HEALTHCHECK --interval=60s --timeout=5s CMD /etc/apache2/healthcheck.sh || exit 1
