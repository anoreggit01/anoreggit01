FROM public.ecr.aws/m7n4r2p6/php5.6:latest
MAINTAINER Anderson Gavetti <anderson.gavetti@h2info.com.br>

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
RUN chmod +x /opt/start.sh
COPY ./aplicacao /var/www/anoregsp/aplicacao/ 
RUN chown -R www-data:www-data /var/www/anoregsp && find /var/www/anoregsp -type d -exec chmod 755 {} \; && find /var/www/anoregsp -type f -exec chmod 644 {} \;
RUN a2ensite anoregsp.org.br.conf && a2enmod rewrite && a2enmod mpm_prefork

RUN apt-get update && apt-get install -y cron
COPY update-ass.sh /etc/cron.d/update-ass.sh
RUN chmod 0644 /etc/cron.d/update-ass.sh && crontab /etc/cron.d/update-ass.sh

ENV APACHE_RUN_USER=www-data
ENV APACHE_RUN_GROUP=www-data
ENV APACHE_LOG_DIR=/var/log/apache2
ENV APACHE_LOCK_DIR=/var/lock/apache2
ENV APACHE_PID_FILE=/var/run/apache2.pid
ENV APACHE_RUN_DIR=/var/run/apache2

EXPOSE 80
CMD ["bash", "/opt/start.sh"]
