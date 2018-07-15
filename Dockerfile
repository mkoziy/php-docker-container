FROM ubuntu:xenial

RUN apt-get update && apt-get install -y software-properties-common python-software-properties

RUN export LANG=C.UTF-8 && add-apt-repository -y ppa:ondrej/php && apt-get update

RUN apt-get install -y -f --no-install-recommends --no-install-suggests php7.2-fpm php7.2 curl php7.2-pgsql php7.2-curl php7.2-json php7.2-mbstring php7.2-gd php7.2-intl php7.2-xml php7.2-imagick php7.2-redis php7.2-zip php7.2-dom php7.2-curl supervisor

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar "/usr/local/bin/composer" && \
    composer global require hirak/prestissimo

RUN apt-get autoremove -y && apt-get clean -y && \
    rm -rf "/var/lib/apt/lists/*"

COPY supervisor.conf /etc/supervisor/conf.d/supervisor.conf

RUN sed -i '/^listen /c listen = 0.0.0.0:9000' /etc/php/7.2/fpm/pool.d/www.conf

CMD ["/usr/bin/supervisord"]
