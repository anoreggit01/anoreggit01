FROM public.ecr.aws/m7n4r2p6/php5.6:latest
MAINTAINER Anderson Gavetti <anderson.gavetti@h2info.com.br>

RUN mkdir /var/www/anoregsp/ && mkdir /var/www/anoregsp/aplicacao && mkdir /var/www/anoregsp/aplicacao/tmp && chmod 777 /var/www/anoregsp/aplicacao/tmp && rm /etc/apache2/sites-enabled/*
COPY anoregsp.org.br.conf /etc/apache2/sites-available/
COPY apache2.conf /etc/apache2/
COPY .webconfig /var/www/anoregsp/
COPY start.sh /opt/
RUN chmod +x /opt/start.sh
COPY ./aplicacao /var/www/anoregsp/aplicacao/ 
RUN chown -R www-data:www-data /var/www/anoregsp && find /var/www/anoregsp -type d -exec chmod 755 {} \; && find /var/www/anoregsp -type f -exec chmod 644 {} \;
RUN a2ensite anoregsp.org.br.conf && a2enmod rewrite && a2enmod mpm_prefork

COPY update-ass6.sh /etc/cron.d/update-ass6.sh
COPY update-ass9.sh /etc/cron.d/update-ass9.sh
COPY update-ass10.sh /etc/cron.d/update-ass10.sh
COPY update-ass14.sh /etc/cron.d/update-ass14.sh
COPY update-ass15.sh /etc/cron.d/update-ass15.sh
COPY update-ass18.sh /etc/cron.d/update-ass16.sh
RUN chmod 0644 /etc/cron.d/update-ass6.sh && chmod 0644 /etc/cron.d/update-ass9.sh && chmod 0644 /etc/cron.d/update-ass10.sh && chmod 0644 /etc/cron.d/update-ass14.sh && chmod 0644 /etc/cron.d/update-ass15.sh && chmod 0644 /etc/cron.d/update-ass18.sh
RUN crontab /etc/cron.d/update-ass6.sh && crontab /etc/cron.d/update-ass9.sh && crontab /etc/cron.d/update-ass10.sh && crontab /etc/cron.d/update-ass14.sh && crontab /etc/cron.d/update-ass15.sh && crontab /etc/cron.d/update-ass18.sh

ENV APACHE_RUN_USER=www-data
ENV APACHE_RUN_GROUP=www-data
ENV APACHE_LOG_DIR=/var/log/apache2
ENV APACHE_LOCK_DIR=/var/lock/apache2
ENV APACHE_PID_FILE=/var/run/apache2.pid
ENV APACHE_RUN_DIR=/var/run/apache2

EXPOSE 80
CMD ["bash", "/opt/start.sh"]
