#!/bin/bash

if [ -f "/opt/Xeams/run.sh" ]; then
echo "Xeams files are in place"
else
mkdir -p /opt/Xeams
cp -r /root/temp/Xeams/*  /opt/Xeams/
fi

cd /opt/Xeams
CP=
for i in `ls lib/*.jar`
do
CP=$CP:$i
done
echo $CP
exec java -server -Xmx1024m -cp $CP -DLoggingConfigFile=logconfig.xml com.synametrics.xeams.ServerStarter &
