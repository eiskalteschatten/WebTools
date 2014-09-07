#!/bin/sh

#  closure-compiler.sh
#  WebTools
#
#  Created by Alex Seifert on 9/7/14.
#  Copyright (c) 2014 Alex Seifert. All rights reserved.

echo "Starting Google Closure"


ls -lh $2

java -jar $1 --js $2 --js_output_file $3

ls -lh $3

echo "Done\n\n"