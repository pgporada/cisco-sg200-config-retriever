#!/bin/bash
# For: Cisco Small Business SG200 26/50 port switch
# v.0.0.1 09/29/2014

# Show help if first argv does not exist
IP=$1
if [ -z ${IP} ]; then
    echo "Error: IP missing on CLI"
    echo "Usage: ./$(basename $0) xxx.xxx.xxx.xxx"
    exit
fi

USERAGENT="'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.124 Safari/537.36'"

# Referer line
REF="'http://${IP}/cs34055c2b/config/log_off_page.htm'"

INITIALCOOKIE="'cisco_numberOfEntriesPerPage=50; pg=00000000000000000000000000000000000000000000000000000000000; isStackableDevice=false; userStatus=ok; activeLangId=English; firstWelcomeBanner=false'"

# Unencrypted login line. Encrypted uses some long convoluted RSA encryption scheme written in Javascript. I tried for hours to parse it but couldn't figure it out. Maybe another set of eyes will have better luck.
LOGIN="'http://${IP}/cs34055c2b/config/System.xml?action=login&user=cisco&password=XXXXXXXXXXXXXXXXXXXXXXXX&ssd=true&'"

# Get the headers for the session so we can parse the output and build our real session string
SESSION=$(eval curl -i -s -k -b ${INITIALCOOKIE} -A ${USERAGENT} -e ${REF} ${LOGIN} | grep "sessionID")

# UserID is the IP of the machine running this script
USERID=$(echo ${SESSION} | cut -d'&' -f1 | cut -d'=' -f2)
SESSIONID=$(echo ${SESSION} | cut -d'&' -f2)

# Newer cookie that gets set in the SG200 once authenticated
MYCOOKIE="'cisco_numberOfEntriesPerPage=50; pg=00000000000000000000000000000000000000000000000000000000000; isStackableDevice=false; userStatus=ok; sessionID=UserId=${USERID}&${SESSIONID}&; usernme=cisco; activeLangId=English; firstWelcomeBanner=false'"

# Set the referer line to a new value
REF="'http://${IP}/cs34055c2b/FileMgmt/maintenance_file_fileUpload_m.htm'"

# The rl options here get me an http download of the running config from the switch to my machine
INDEX=$(date +%H%M%S)
DLURL="'http://${IP}/cs34055c2b/FileMgmt/stupCfg.ber?rlCopyFreeHistoryIndex=${INDEX}&&rlCopyDestinationFileType=2&&rlCopyOptionsRequestedSsdAccess=3&&redirect=/device/copyfiles.xml'"

TSTAMP=$(date +%Y%m%d-%H%M%S)
FILENAME=${IP}-${TSTAMP}-running-config.txt

# Actually download the file
eval curl -s -k -b ${MYCOOKIE} -A ${USERAGENT} -e ${REF} ${DLURL} -o ${FILENAME}

# Check if the file got downloaded by searching the output for the redirection. If the redirection exists
# then the file was not downloaded and the output is garbage.
if grep -qi "This document has moved to" ${FILENAME}
then
    echo "Output was trash, try again in 15 minutes."
    rm -f ${FILENAME}
else
    echo "Saved the config for ${IP}"
fi
