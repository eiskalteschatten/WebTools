#!/bin/sh

#  Jpegoptim.sh
#  WebTools
#
#  Created by Alex Seifert on 05.06.14.
#  Copyright (c) 2014 Alex Seifert. All rights reserved.

echo "Compressing images at $1"

cd $1
$2 *.jpg --strip-all