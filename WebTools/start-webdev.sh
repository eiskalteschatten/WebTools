#!/bin/sh

sudo /usr/local/mysql/support-files/mysql.server start
wait

echo "Starting Apache"

sudo apachectl start
wait

echo "Done\n\n"