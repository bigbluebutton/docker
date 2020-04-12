#!/bin/bash

FILE=/usr/local/tomcat/webapps/demo/bbb_api_conf.jsp
echo -n "<%" > $FILE
			echo "!
// This is the security salt that must match the value set in the BigBlueButton server
String salt = \"$SHARED_SECRET\";

// This is the URL for the BigBlueButton server
String BigBlueButtonURL = \"https://$DOMAIN/bigbluebutton/\";
%>
" >> $FILE

/usr/local/tomcat/bin/catalina.sh run