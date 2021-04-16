#!/bin/bash
baseDir=/usr/local/share/oaw/
export JAVA_HOME=$baseDir/jdk1.8.0_202
export PATH=$PATH:$JAVA_HOME/bin
export CATALINA_HOME=$baseDir/apache-tomcat-7.0.107
export CATALINA_BASE=$baseDir/apache-tomcat-7.0.107
$baseDir/apache-tomcat-7.0.107/bin/shutdown.sh