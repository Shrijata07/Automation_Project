#!/bin/bash

sudo apt update -y

# check if apache 2 is avaialble

s3_bucket="upgrad-sujata"
name="sujata"
timestamp=$(date '+%d%m%Y-%H%M%S')

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

#create tar files from the logs

sudo tar -cvf /tmp/"${name}-httpd-logs-${timestamp}.tar" /var/log/apache2/*.log
# Upload to S3 bucket
aws s3 cp /tmp/${name}-httpd-logs-${timestamp}.tar s3://${s3_bucket}/${name}-httpd-logs-${timestamp}.tar
