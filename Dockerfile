FROM php:7.2-fpm

RUN apt-get update && apt-get install -y libfreetype6-dev libxml2-dev libpq-dev libjpeg62-turbo-dev libmcrypt-dev pkg-config && \
    apt-get install  -f -y libcurl4-openssl-dev

RUN docker-php-ext-install mbstring dom zip pdo_pgsql session intl json xml simplexml curl

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar "/usr/local/bin/composer" && \
    composer global require hirak/prestissimo

RUN apt-get purge -y -f libfreetype6-dev libxml2-dev libpq-dev libjpeg62-turbo-dev libmcrypt-dev libcurl4-openssl-dev && \
    apt-get autoremove -y && apt-get clean -y && \
    rm -rf "/var/lib/apt/lists/*"