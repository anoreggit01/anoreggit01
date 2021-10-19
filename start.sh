#!/bin/bash
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export LANG=pt_BR.UTF-8
#sed -i "s/db_host\ =/db_host\ =\ $dbHost/g" "/var/www/anoregsp/.webconfig"
#sed -i "s/db_user\ =/db_user\ =\ $dbUser/g" "/var/www/anoregsp/.webconfig"
#sed -i "s/db_pass\ =/db_pass\ =\ $dbPass/g" "/var/www/anoregsp/.webconfig"
#sed -i "s/db_name\ =/db_name\ =\ $dbName/g" "/var/www/anoregsp/.webconfig"

# Start apache
/etc/init.d/apache2 start
tail -f /etc/passwd
