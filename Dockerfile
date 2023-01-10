FROM php:7.2-apache
COPY laravel.conf /etc/apache2/sites-available/000-default.conf
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        zlib1g-dev \
        libxml2-dev \
        libzip-dev \
        libonig-dev \
        graphviz \
    && docker-php-ext-configure gd \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install zip \
    && docker-php-ext-install sockets \
    && docker-php-source delete \
    && curl -s$ https://getcomposer.org/installer | php -- \
    --install-dir=/usr/local/bin --filename=composer
WORKDIR /var/www/html/
COPY . /var/www/html/
COPY .env.backup /var/www/html/.env
RUN composer install
RUN php artisan key:generate
RUN chown www-data:www-data /var/www/html -R
EXPOSE 80