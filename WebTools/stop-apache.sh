#!/bin/sh

echo "Stopping Apache"

sudo apachectl stop
wait

echo "Done\n\n"