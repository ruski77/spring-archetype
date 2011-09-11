#! /bin/sh
#chmod +x deploy.sh
# Stop tomcat
/usr/local/tomcat7/bin/./shutdown.sh
# Undeploy application
rm -rf /usr/local/tomcat7/webapps/${artifactId}
# Deploy application
cp target/${artifactId}.war /usr/local/tomcat7/webapps/
# Start tomcat
/usr/local/tomcat7/bin/./startup.sh