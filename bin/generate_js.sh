#!/bin/bash

if [ -f /usr/lib/jvm/java-7-icedtea/jre/bin/java ]; then
  JAVA='/usr/lib/jvm/java-7-icedtea/jre/bin/java'
elif [ -f /usr/lib/jvm/java-6-sun/jre/bin/java ]; then
  JAVA='/usr/lib/jvm/java-6-sun/jre/bin/java'
elif [ -f /usr/lib/jvm/java-1.5.0-sun/jre/bin/java ]; then
  JAVA='/usr/lib/jvm/java-1.5.0-sun/jre/bin/java'
else
  echo '******** WARNING **********'
  echo 'Unable to find a supported Java runtime'
  echo 'Going to assume java is in your PATH'
  echo '****************************'
  JAVA='java'
fi

OLDPWD=$PWD
cd /usr/lib/beamr/aurita/main

echo "generating aurita_all.js ..."
sudo ./console_dispatch.rb Javascript include_all > ./public/inc/aurita_all.src.js 2>/dev/null

echo "compressing aurita_all.js ..."
$JAVA -jar bin/yuicompressor-2.3.4.jar ./public/inc/aurita_all.src.js > ./public/inc/aurita_all.js
echo "compressing lightboxEx.js ..."
# $JAVA -jar bin/yuicompressor-2.3.4.jar ./public/inc/lightboxEx/js/lightboxEx.js > ./public/inc/lightboxEx/js/lightboxEx_compress.js
echo "compressing prototype.js ..."
# $JAVA -jar bin/yuicompressor-2.3.4.jar ./public/inc/scriptaculous/lib/prototype.js > ./public/inc/scriptaculous/lib/prototype_compress.js
echo "compressing scriptaculous.js ..."
# $JAVA -jar bin/yuicompressor-2.3.4.jar ./public/inc/scriptaculous/src/scriptaculous.js > ./public/inc/scriptaculous/src/scriptaculous_compress.js

cd $OLDPWD
