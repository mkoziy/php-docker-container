FROM ubuntu:xenial

RUN apt-get update && apt-get install -y software-properties-common python-software-properties

RUN export LANG=C.UTF-8 && add-apt-repository -y ppa:ondrej/php && apt-get update

RUN apt-get install -y -f --no-install-recommends --no-install-suggests php7.3 php7.3-cli php7.3-pgsql php7.3-curl php7.3-json php7.3-mbstring php7.3-gd php7.3-intl php7.3-xml php7.3-imagick php7.3-redis php7.3-zip php7.3-dom php7.3-curl

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('sha384', 'composer-setup.php') === '48e3236262b34d30969dca3c37281b3b4bbe3221bda826ac6a9a62d6444cdb0dcd0615698a5cbe587c3f0fe57a54d8f5') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar "/usr/local/bin/composer" && \
    composer global require hirak/prestissimo

RUN apt-get autoremove -y && apt-get clean -y && \
    rm -rf "/var/lib/apt/lists/*"
