#!/bin/sh
# Run to send message to me every day to check the sms server.
# tony

HOZOM_LOG_FILE="/opt/scripts/logs/sms_check_`date +%Y%m`.log"

export JAVA_HOME=/opt/jdk1.5.0_15
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=$JAVA_HOME/jre/lib/rt.jar:.

# call hozom_deploy.sh to do deploy
cd /home/hozom/tool

java -cp "`ls -d *.jar | sed -n 'H;1h;${g;s/\n/:/g;p}'`:$CLASSPATH" com.hozom.server.tool.SendSmsByAlexSmsSender >> "$HOZOM_LOG_FILE" 2>&1
