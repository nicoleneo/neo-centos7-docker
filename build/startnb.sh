#!/bin/bash
echo 'Starting netbeans...'
/usr/local/netbeans-8.1/bin/netbeans -J-Xmx2048m -J-XX:+UseConcMarkSweepGC -J-XX:+UseParNewGC --jdkhome /usr/java/latest/ &
NBID=$!
echo 'NetBeans with PID ' $NBID
# Persist the env $NBID after this script runs
echo 'export NBID='$NBID > ~/.tmprc
