#! /bin/sh
#chmod +x deploy.sh
# Stop tomcat
/usr/local/tomcat6/bin/./shutdown.sh
# Undeploy application
rm -rf /usr/local/tomcat6/webapps/${artifactId}
# Deploy application
cp target/${artifactId}.war /usr/local/tomcat6/webapps/
# Start tomcat
/usr/local/tomcat6/bin/./startup.sh