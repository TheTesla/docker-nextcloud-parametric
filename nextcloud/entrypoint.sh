#!/bin/bash

CONFIGDIR=/var/www/nextcloud/config



chown www-data:www-data -R $DATADIRECTORY $CONFIGDIR


echo "POSTGRES_DB_FILE $POSTGRES_DB_FILE"

while ! pg_isready -d "$(cat $POSTGRES_DB_FILE)"\
	    -h "${POSTGRES_HOST%%":"*}"\
	    -p "${POSTGRES_HOST#*":"}"\
	    -U "$(cat $POSTGRES_USER_FILE)" ;
do
  echo "Wait for database!"
  sleep 1

done


if test -n "$(find $CONFIGDIR -maxdepth 0 -empty)"; then
  echo "Initializing nextcloud config dir now!"
  cp -rf /nextcloud/config/* $CONFIGDIR/.
  chown www-data:www-data -R $CONFIGDIR 
fi
if test -f "$CONFIGDIR/CAN_INSTALL"; then 
  echo "Install nextcloud now!"
  sudo -u www-data php /var/www/nextcloud/occ  maintenance:install \
	  --database "pgsql" \
	  --database-host "$POSTGRES_HOST" \
	  --database-name "$(cat $POSTGRES_DB_FILE)" \
	  --database-user "$(cat $POSTGRES_USER_FILE)" \
	  --database-pass "$(cat $POSTGRES_PASSWORD_FILE)" \
	  --admin-user "$(cat $NEXTCLOUD_ADMIN_USER_FILE)" \
	  --admin-pass "$(cat $NEXTCLOUD_ADMIN_PASSWORD_FILE)"
  rm $CONFIGDIR/CAN_INSTALL
fi

#cp /custom.config.php $CONFIGDIR/.

cat > $CONFIGDIR/custom.config.php <<-EOF
<?php
\$CONFIG = array (
  'trusted_domains' => explode(' ', '$NEXTCLOUD_TRUSTED_DOMAINS'),
  'datadirectory' => '$DATADIRECTORY',
  'dbname' => '$(cat $POSTGRES_DB_FILE)',
  'dbhost' => '$POSTGRES_HOST',
  'dbuser' => '$(cat $POSTGRES_USER_FILE)',
  'dbpassword' => '$(cat $POSTGRES_PASSWORD_FILE)',
  'filesystem_check_changes' => '$FILESYSTEM_CHECK_CHANGES',
);
EOF


chown www-data:www-data -R $CONFIGDIR 

apachectl -D FOREGROUND

