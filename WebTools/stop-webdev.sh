#!/bin/sh

/usr/local/mysql/support-files/mysql.server stop
wait

apachectl stop
wait

echo "Done"