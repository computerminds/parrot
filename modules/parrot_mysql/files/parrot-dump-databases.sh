#!/bin/sh

echo "Dumping databases to Parrot database folder."
echo ""
echo "This will overwrite any existing data."

BACKUP_DIR="/vagrant_databases"
MYSQL_USER="root"
MYSQL=/usr/bin/mysql
MYSQL_PASSWORD="root"
MYSQLDUMP=/usr/bin/mysqldump

databases=`$MYSQL --user=$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES;" | grep -Ev "(parrot|Database|information_schema|mysql)"`

for db in $databases; do
  echo "Dumping $db to $BACKUP_DIR/$db.sql"
  $MYSQLDUMP --force --user=$MYSQL_USER -p$MYSQL_PASSWORD --quick --single-transaction --databases $db > "$BACKUP_DIR/$db.sql"
done

echo "All databases exported."
