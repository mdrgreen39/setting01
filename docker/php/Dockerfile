FROM php:8.2-fpm AS base

ENV TZ=Asia/Tokyo

RUN apt-get update \
    && apt-get install -y vim unzip git curl cron \
    libzip-dev libonig-dev libicu-dev libjpeg62-turbo-dev libpng-dev default-mysql-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


RUN docker-php-ext-install zip pdo_mysql mysqli mbstring gd iconv bcmath

FROM composer:2.5.8 AS composer

FROM base AS final

COPY --from=composer /usr/bin/composer /usr/bin/composer

COPY php.ini /usr/local/etc/php/php.ini

WORKDIR /var/www

# cronfileを追加
COPY ./cronfile /etc/cron.d/cronfile

# cronfileのパーミッションを設定し、cronサービスを起動
RUN chmod 0644 /etc/cron.d/cronfile

# cronサービスをリスタート
RUN crontab /etc/cron.d/cronfile

# cronサービスのスタートと php-fpmの同時起動を行うスクリプト
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
