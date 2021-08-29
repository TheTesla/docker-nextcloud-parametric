<?php
$CONFIG = array (
  'trusted_domains' => explode(' ', getenv('NEXTCLOUD_TRUSTED_DOMAINS')),
  'datadirectory' => getenv('DATADIRECTORY'),
  'dbname' => trim(preg_replace('/\s\s+/', ' ', file_get_contents(getenv('POSTGRES_DB_FILE')))),
  'dbhost' => getenv('POSTGRES_HOST'),
  'dbuser' => trim(preg_replace('/\s\s+/', ' ', file_get_contents(getenv('POSTGRES_USER_FILE')))),
  'dbpassword' => trim(preg_replace('/\s\s+/', ' ', file_get_contents(getenv('POSTGRES_PASSWORD_FILE')))),
  'filesystem_check_changes' => getenv('FILESYSTEM_CHECK_CHANGES'),
);
