#!/bin/sh

sudo /usr/local/mysql/support-files/mysql.server stop
wait

echo "Stopping Apache"

sudo apachectl stop
wait

echo "Done\n\n"