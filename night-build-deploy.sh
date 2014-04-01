#!/bin/bash

echo "Begin."

CODE_BASE=/opt/cruisecontrol-bin-2.7.3/projects/Hozom-Nightly-Build
TOMCAT_ROOT=/opt/apache-tomcat-6.0.18-8082
PORT=8082

cd "$CODE_BASE"
/opt/CollabNet_Subversion/bin/svn update
/opt/cruisecontrol-bin-2.7.3/apache-ant-1.7.0/bin/ant clean dist

rm -rf "$TOMCAT_ROOT"/webapps/ROOT/*
unzip "$CODE_BASE"/output/war/hozom.war -d "$TOMCAT_ROOT"/webapps/ROOT/
cp -f /home/hozom/database_dev.properties "$TOMCAT_ROOT"/webapps/ROOT/WEB-INF/classes/database.properties

# go to "$TOMCAT_ROOT"/bin
cd "$TOMCAT_ROOT"/bin

# stop tomcat server.
# get pid of the program listening $PORT
tomcat_pid=`netstat -nlp | grep $PORT | awk '{print $7}' | awk -F / '{print $1}'`
if [ -n "$tomcat_pid" ]; then
        if [ -r "$TOMCAT_ROOT"/bin/shutdown.sh ]; then
                sh "$TOMCAT_ROOT"/bin/shutdown.sh 
		wait
                kill -9 $tomcat_pid
        else    
                echo "Cannot find "$TOMCAT_ROOT"/bin/shutdown.sh"
                echo "This file is needed to run this program"
                exit 1
        fi      
fi      

#start tomcat server.
if [ -r "$TOMCAT_ROOT"/bin/startup.sh ]; then
        sh "$TOMCAT_ROOT"/bin/startup.sh
else
        echo "Cannot find "$TOMCAT_ROOT"/bin/startup.sh"
        echo "This file is needed to run this program"
        exit 1
fi

echo "successfully."
