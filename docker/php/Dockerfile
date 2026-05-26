ARG PHP_VERSION=8.3
FROM php:${PHP_VERSION}-apache

ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    . /etc/os-release; \
    if [ "${VERSION_CODENAME:-}" = "buster" ]; then \
        sed -i 's|http://deb.debian.org/debian|http://archive.debian.org/debian|g' /etc/apt/sources.list; \
        sed -i 's|http://security.debian.org/debian-security|http://archive.debian.org/debian-security|g' /etc/apt/sources.list; \
        sed -i 's|http://deb.debian.org/debian-security|http://archive.debian.org/debian-security|g' /etc/apt/sources.list; \
        sed -i '/buster-updates/d' /etc/apt/sources.list; \
        printf 'Acquire::Check-Valid-Until "false";\n' > /etc/apt/apt.conf.d/99archive; \
    fi; \
    apt-get update -o Acquire::Check-Valid-Until=false; \
    apt-get install -y --no-install-recommends \
        bash \
        ca-certificates \
        curl \
        git \
        unzip \
        zip \
        expect \
        default-mysql-client \
        libcurl4-openssl-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libwebp-dev \
        libzip-dev \
        libicu-dev \
        libgmp-dev \
        libonig-dev \
        libxml2-dev \
    ; \
    if php -r 'exit(PHP_VERSION_ID < 70400 ? 0 : 1);'; then \
        docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/; \
    else \
        docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp; \
    fi; \
    docker-php-ext-install -j"$(nproc)" \
        mysqli \
        pdo_mysql \
        gd \
        intl \
        zip \
        gmp \
        exif \
        opcache \
        mbstring \
    ; \
    a2enmod rewrite headers; \
    rm -rf /var/lib/apt/lists/*

COPY docker/php/xenforo.ini /usr/local/etc/php/conf.d/zz-xenforo.ini
COPY tools/xf-auto-install.expect /usr/local/bin/xf-auto-install
RUN chmod +x /usr/local/bin/xf-auto-install

WORKDIR /var/www/html
