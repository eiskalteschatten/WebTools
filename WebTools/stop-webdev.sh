#!/bin/sh

sudo /usr/local/mysql/support-files/mysql.server stop
wait

sudo apachectl stop
wait

echo "Done"