FROM debian:jessie
MAINTAINER Anderson Gavetti <anderson.gavetti@h2info.com.br>
RUN apt-get update
RUN apt-get -y install openssl libgnutls28-dev libssl-dev libssl-dev libcurl4-openssl-dev pkg-config libdb-dev build-essential apache2-dev libjpeg-dev libmysqlclient-dev libsnmp-dev libtidy-dev libxpm-dev libfreetype6-dev libpng-dev ca-certificates apt-transport-https curl gnupg lsb-release wget apache2 bzip2 gcc libxml2-dev libz-dev libbz2-dev libcurl4-openssl-dev libmcrypt-dev libpq-dev libxslt-dev vim build-essential
RUN cd /opt && wget https://www.php.net/distributions/php-5.6.37.tar.gz && tar -zxvf php-5.6.37.tar.gz && cd php-5.6.37 && ./configure --enable-dba=shared --with-openssl -with-apxs2=/usr/bin/apxs2 -with-mysql=/usr -with-mysqli=/usr/bin/mysql_config -with-pgsql=/usr -with-tidy=/usr -with-curl=/usr/bin -with-curlwrappers -with-openssl-dir=/usr -with-zlib-dir=/usr -enable-mbstring -with-xpm-dir=/usr -with-pdo-pgsql=/usr -with-pdo-mysql=/usr -with-xsl=/usr -with-xmlrpc -with-iconv-dir=/usr -with-snmp=/usr -enable-exif -enable-calendar -with-bz2=/usr -with-mcrypt=/usr -with-gd -with-jpeg-dir=/usr -with-png-dir=/usr -with-zlib-dir=/usr -with-freetype-dir=/usr -enable-mbstring -enable-zip -with-pear --with-config-file-path=/usr/local/lib --enable-sockets && make && make -i install

RUN rm /etc/apache2/mods-enabled/mpm_event.load && rm /etc/apache2/mods-enabled/mpm_event.conf
RUN ln -s /usr/lib/$ARCH-linux-gnu/libXpm.so.4 /usr/lib/libXpm.so
RUN ln -s /usr/lib/$ARCH-linux-gnu/libXpm.so.4 /usr/lib/libXpm.so.4
RUN ln -s /usr/lib/$ARCH-linux-gnu/libXpm.a /usr/lib/libXpm.a
RUN ln -s /usr/lib/$ARCH-linux-gnu/libmysqlclient.so /usr/lib/libmysqlclient.so
RUN ln -s /usr/lib/$ARCH-linux-gnu/libmysqlclient.so.18 /usr/lib/libmysqlclient.so.18
RUN ln -s /usr/lib/$ARCH-linux-gnu/libmysqlclient.a /usr/lib/libmysqlclient.a
RUN cd /opt/php-5.6.37/ && cp php.ini-development /usr/local/lib/php.ini
RUN cd /etc/apache2/mods-available && touch php5.load && echo "LoadModule php5_module /usr/lib/apache2/modules/libphp5.so" > php5.load && touch php5.conf && echo "AddType application/x-httpd-php .php .phtml .php3\n" > php5.conf && echo "AddType application/x-httpd-php-source .phps" >> php5.conf
RUN a2enmod php5


RUN sed -i "s/memory_limit\ =\ 8/memory_limit\ =\ 128/g" "/usr/local/lib/php.ini"
RUN sed -i "s/post_max_size\ =\ 8/post_max_size\ =\ 20/g" "/usr/local/lib/php.ini"
RUN sed -i "s/upload_max_filesize\ =\ 2/upload_max_filesize\ =\ 150/g" "/usr/local/lib/php.ini"
RUN sed -i "s/;date.timezone\ =/date.timezone\ =\ America\/Sao_Paulo/g" "/usr/local/lib/php.ini"
RUN sed -i "s/short_open_tag\ =\ Off/short_open_tag\ =\ On/g" "/usr/local/lib/php.ini"
RUN sed -i 's/default_charset\ =\ "UTF-8"/default_charset\ =\ "ISO-8859-1"/g' "/usr/local/lib/php.ini"
#RUN sed -i "s/error_reporting\ =\ E_ALL/error_reporting\ =\ 0/g" "/usr/local/lib/php.ini"
#RUN sed -i "s/display_errors\ =\ On/display_errors\ =\ Off/g" "/usr/local/lib/php.ini"
RUN sed -i 's/;session.save_path\ =\ "\/tmp"/session.save_path\ =\ "\/tmp"/g' "/usr/local/lib/php.ini"

RUN mkdir /var/www/anoregsp/ && mkdir /var/www/anoregsp/aplicacao && mkdir /var/www/anoregsp/aplicacao/tmp && chmod 777 /var/www/anoregsp/aplicacao/tmp
RUN rm /etc/apache2/sites-enabled/*
COPY anoregsp.org.br.conf /etc/apache2/sites-available/
COPY apache2.conf /etc/apache2/
COPY .webconfig /var/www/anoregsp/
COPY start.sh /opt/
COPY ./aplicacao /var/www/anoregsp/aplicacao/
RUN chmod +x /opt/start.sh
RUN chown -R www-data:www-data /var/www/anoregsp
RUN find /var/www/anoregsp -type d -exec chmod 755 {} \;
RUN find /var/www/anoregsp -type f -exec chmod 644 {} \;
RUN a2ensite anoregsp.org.br.conf
RUN a2enmod rewrite
RUN a2enmod mpm_prefork
RUN ls -la /var/www/anoregsp/
RUN ls -la /var/www/anoregsp/aplicacao/

ENV APACHE_RUN_USER=www-data
ENV APACHE_RUN_GROUP=www-data
ENV APACHE_LOG_DIR=/var/log/apache2
ENV APACHE_LOCK_DIR=/var/lock/apache2
ENV APACHE_PID_FILE=/var/run/apache2.pid
ENV APACHE_RUN_DIR=/var/run/apache2

EXPOSE 80
CMD ["bash", "/opt/start.sh"]
