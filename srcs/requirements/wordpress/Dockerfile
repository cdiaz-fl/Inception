FROM alpine:3.18.5

ARG PHP_VERSION=82 \
    DB_NAME \
    DB_USER \
    DB_PASS \
    WP_USER \
    WP_PASS \
    WP_ADDR

ENV PHP_VERSION=${PHP_VERSION} \
    WP_USER=${WP_USER} \
    WP_PASS=${WP_PASS} \
    WP_ADDR=${WP_ADDR}

RUN apk update && apk upgrade && apk add --no-cache \
    php${PHP_VERSION} \
#Helps the server to run PHP websites more efficiently. It can handle several request from the server at the same time and it makes your page load faster
    php${PHP_VERSION}-fpm \
#Mysql Improved - Improved Object Oriented Interface to interact with a MYSQL Database
    php${PHP_VERSION}-mysqli \
    php${PHP_VERSION}-json \
#cURL - Allows to send and receive data with various protocols (HTTP, FTP...). It helps your server to comunicate with others
    php${PHP_VERSION}-curl \
#Document Object Model - Provides a way to interact with XML and HTML as objects
    php${PHP_VERSION}-dom \
#EXhchangeable Image File - To store metadata in an image
    php${PHP_VERSION}-exif \
#Determines the type of file by analysing its content, not just relaying on the extension
    php${PHP_VERSION}-fileinfo \
#Multi Byte String - Allows PHP to work with non ASCII characters (for instance Unicode). It is useful to perform other database operations too.
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-openssl \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-zip \
    php${PHP_VERSION}-redis \
    php${PHP_VERSION}-phar \
    wget \
    unzip && \
#String EDit - With the i flag, it will insert modifications in a file instead of printing in stdout. It will substitute |pattern|newPattern. The g indicates to replaces global (all) the occurrences
    sed -i "s|listen = 127.0.0.1:9000|listen = 9000|g" \
      /etc/php82/php-fpm.d/www.conf && \
    sed -i "s|;listen.owner = nobody|listen.owner = nobody|g" \
      /etc/php82/php-fpm.d/www.conf && \
    sed -i "s|;listen.group = nobody|listen.group = nobody|g" \
      /etc/php82/php-fpm.d/www.conf && \
    rm -f /var/cache/apk/*

#Creates a symbolic link (-s) forcing it (-f) in /usr/bin/php that points to /usr/bin/php82
RUN ln -sf /usr/bin/php${PHP_VERSION} /usr/bin/php

WORKDIR /var/www

RUN wget https://wordpress.org/latest.zip && \
    unzip latest.zip && \
    cp -rf wordpress/* . && \
    rm -rf wordpress latest.zip

COPY ./requirements/wordpress/conf/wp-config-create.sh .

RUN sh wp-config-create.sh && rm wp-config-create.sh && \
    chmod -R 0777 wp-content/

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

#The -F flag runs it Foreground (in the stdout), allowing Docker to read from it, this way it can be handle easily
CMD wp core install \
    --url=https://127.0.0.1 \
    --title="Inception" \
    --admin_user="$WP_USER" \
    --admin_password="$WP_PASS" \
    --admin_email="$WP_ADDR"; \
    /usr/sbin/php-fpm$PHP_VERSION -F
