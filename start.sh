#!/bin/bash
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export LANG=pt_BR.UTF-8
sed -i "s/db_host\ =/db_host\ =\ $dbHost/g" "/var/www/anoregsp/.webconfig"
sed -i "s/db_user\ =/db_user\ =\ $dbUser/g" "/var/www/anoregsp/.webconfig"
sed -i "s/db_pass\ =/db_pass\ =\ $dbPass/g" "/var/www/anoregsp/.webconfig"
sed -i "s/db_name\ =/db_name\ =\ $dbName/g" "/var/www/anoregsp/.webconfig"
sed -i 's/smtp_host\ =\ ""/smtp_host\ =\ "'$smtpHost'"/g' "/var/www/anoregsp/.webconfig"
sed -i 's/smtp_user\ =\ ""/smtp_user\ =\ "'$smtpUser'"/g' "/var/www/anoregsp/.webconfig"
sed -i 's/smtp_password\ =\ ""/smtp_password\ =\ "'$smtpPassword'"/g' "/var/www/anoregsp/.webconfig"
sed -i 's/smtp_porta\ =\ ""/smtp_porta\ =\ "'$smtpPort'"/g' "/var/www/anoregsp/.webconfig"
sed -i 's/mail_autenticado\ =\ ""/mail_autenticado\ =\ "'$mailAut'"/g' "/var/www/anoregsp/.webconfig"
sed -i 's/mail_autenticado_password\ =\ ""/mail_autenticado_password\ =\ "'$mailAutPass'"/g' "/var/www/anoregsp/.webconfig"

# Start apache
exec apache2-foreground
