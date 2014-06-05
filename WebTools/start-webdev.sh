#!/bin/sh

/usr/local/mysql/support-files/mysql.server start
wait

apachectl start
wait

echo "Done"