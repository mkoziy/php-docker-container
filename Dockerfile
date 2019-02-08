FROM ubuntu:xenial

RUN apt-get update && apt-get install -y software-properties-common python-software-properties

RUN export LANG=C.UTF-8 && add-apt-repository -y ppa:ondrej/php && apt-get update

RUN apt-get install -y -f --no-install-recommends --no-install-suggests php7.3 php7.3-cli php7.3-pgsql php7.3-curl php7.3-json php7.3-mbstring php7.3-gd php7.3-intl php7.3-xml php7.3-imagick php7.3-redis php7.3-zip php7.3-dom php7.3-curl

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar "/usr/local/bin/composer" && \
    composer global require hirak/prestissimo

RUN apt-get autoremove -y && apt-get clean -y && \
    rm -rf "/var/lib/apt/lists/*"
