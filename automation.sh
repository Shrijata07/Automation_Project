#!/bin/bash

sudo apt update -y

if dpkg -l | grep -i apache2

then

        echo "Apache is available"
else

        echo "Apache is unavailable"

        sudo apt install apache2
fi

#check for the word inactive in the result of status

STARTAPACHE="systemctl start apache2"

if systemctl status apache2 | grep -q inactive

then

        echo "starting apache at $(date)"

        $STARTAPACHE
else

        echo "apache is running at $(date)"
fi

sudo systemctl status apache2.service

sudo systemctl enable apache2

mkdir tmp
cd tmp

s3_bucket="upgrad-sujata"
name="sujata"

sudo tar -cvf "${name}-httpd-logs-$(date '+%d%m%Y-%H%M%S').tar" /var/log/apache2/*.log

aws s3 cp /root/Automation_Project/tmp/${name}-httpd-logs-$(date '+%d%m%Y-%H%M%S').tar s3://${s3_bucket}/${name}-httpd-logs-$(date '+%d%m%Y-%H%M%S').tar
