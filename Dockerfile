# Usar a imagem base Debian Jessie
FROM debian:jessie

# Informações do mantenedor
MAINTAINER Anderson Gavetti <anderson.gavetti@h2info.com.br>

# Configurar sources.list para usar os repositórios do archive.debian.org
RUN echo "deb http://archive.debian.org/debian/ jessie main non-free contrib" > /etc/apt/sources.list && \
    echo "deb-src http://archive.debian.org/debian/ jessie main non-free contrib" >> /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian-security/ jessie/updates main non-free contrib" >> /etc/apt/sources.list && \
    echo "deb-src http://archive.debian.org/debian-security/ jessie/updates main non-free contrib" >> /etc/apt/sources.list
# Atualizar os repositórios e instalar pacotes essenciais
RUN apt-get update && \
    apt-get -y install \
    cron openssl libgnutls28-dev curl libssl-dev libcurl4-openssl-dev pkg-config \
    libdb-dev build-essential apache2-dev libjpeg-dev libmysqlclient-dev \
    libsnmp-dev libtidy-dev libxpm-dev libfreetype6-dev libpng-dev \
    ca-certificates apt-transport-https curl gnupg lsb-release wget \
    apache2 bzip2 gcc libxml2-dev libz-dev libbz2-dev \
    libcurl4-openssl-dev libmcrypt-dev libpq-dev libxslt-dev vim build-essential \
    libmagickwand-6.q16-dev
# Baixar e extrair o código-fonte do PHP
RUN cd /opt && \
    wget https://www.php.net/distributions/php-5.6.37.tar.gz --no-check-certificate && \
    tar -zxvf php-5.6.37.tar.gz && \
    cd php-5.6.37 && \
    ./configure \
        --enable-dba=shared \
        --with-openssl \
        -with-apxs2=/usr/bin/apxs2 \
        -with-mysql=/usr \
        -with-mysqli=/usr/bin/mysql_config \
        -with-pgsql=/usr \
        -with-tidy=/usr \
        -with-curl=/usr/bin \
        -with-curlwrappers \
        -with-openssl-dir=/usr \
        -with-zlib-dir=/usr \
        -enable-mbstring \
        -with-xpm-dir=/usr \
        -with-pdo-pgsql=/usr \
        -with-pdo-mysql=/usr \
        -with-xsl=/usr \
        -with-xmlrpc \
        -with-iconv-dir=/usr \
        -with-snmp=/usr \
        -enable-exif \
        -enable-calendar \
        -with-bz2=/usr \
        -with-mcrypt=/usr \
        -with-gd \
        -with-jpeg-dir=/usr \
        -with-png-dir=/usr \
        -with-zlib-dir=/usr \
        -with-freetype-dir=/usr \
        -enable-mbstring \
        -enable-zip \
        -with-pear \
        --with-config-file-path=/usr/local/lib \
        --enable-sockets \
        --with-imagick=/usr/include/ImageMagick-6 && \
    make && \
    make -i install
# Configuração do Apache e PHP
RUN rm /etc/apache2/mods-enabled/mpm_event.load && \
    rm /etc/apache2/mods-enabled/mpm_event.conf && \
    ln -s /usr/lib/$ARCH-linux-gnu/libXpm.so.4 /usr/lib/libXpm.so && \
    ln -s /usr/lib/$ARCH-linux-gnu/libXpm.so.4 /usr/lib/libXpm.so.4 && \
    ln -s /usr/lib/$ARCH-linux-gnu/libXpm.a /usr/lib/libXpm.a && \
    ln -s /usr/lib/$ARCH-linux-gnu/libmysqlclient.so /usr/lib/libmysqlclient.so && \
    ln -s /usr/lib/$ARCH-linux-gnu/libmysqlclient.so.18 /usr/lib/libmysqlclient.so.18 && \
    ln -s /usr/lib/$ARCH-linux-gnu/libmysqlclient.a /usr/lib/libmysqlclient.a && \
    cd /opt/php-5.6.37/ && \
    cp php.ini-development /usr/local/lib/php.ini && \
    echo "extension=imagick.so" >> /usr/local/lib/php.ini && \
    cd /etc/apache2/mods-available && \
    touch php5.load && \
    echo "LoadModule php5_module /usr/lib/apache2/modules/libphp5.so" > php5.load && \
    touch php5.conf && \
    echo "AddType application/x-httpd-php .php .phtml .php3\n" > php5.conf && \
    echo "AddType application/x-httpd-php-source .phps" >> php5.conf
# Habilitar o módulo PHP no Apache
RUN a2enmod php5
# Limpar arquivos desnecessários
RUN rm /opt/php-5.6.37.tar.gz
# Configurações adicionais do PHP
RUN sed -i "s/memory_limit\ =\ 8/memory_limit\ =\ 128/g" "/usr/local/lib/php.ini" && \
    sed -i "s/post_max_size\ =\ 8/post_max_size\ =\ 150/g" "/usr/local/lib/php.ini" && \
    sed -i "s/upload_max_filesize\ =\ 2/upload_max_filesize\ =\ 150/g" "/usr/local/lib/php.ini" && \
    sed -i "s/;date.timezone\ =/date.timezone\ =\ America\/Bahia/g" "/usr/local/lib/php.ini" && \
    sed -i "s/short_open_tag\ =\ Off/short_open_tag\ =\ On/g" "/usr/local/lib/php.ini" && \
    sed -i 's/default_charset\ =\ "UTF-8"/default_charset\ =\ "ISO-8859-1"/g' "/usr/local/lib/php.ini" && \
    sed -i "s/error_reporting\ =\ E_ALL/error_reporting\ =\ E_ALL\ \&\ \~E_STRICT\ \&\ \~E_DEPRECATED/g" "/usr/local/lib/php.ini" && \
    sed -i "s/display_errors\ =\ On/display_errors\ =\ Off/g" "/usr/local/lib/php.ini" && \
    sed -i 's/;session.save_path\ =\ "\/tmp"/session.save_path\ =\ "\/tmp"/g' "/usr/local/lib/php.ini"
