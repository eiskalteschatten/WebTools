#!/bin/sh

sudo /usr/local/mysql/support-files/mysql.server start
wait

sudo apachectl start
wait

echo "Done"