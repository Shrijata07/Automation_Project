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

#script to produce an HTML file book keeping

if [[ ! -f var/www/html/inventory.html ]];
then
        echo -e Log Type\ \Date Created\ \Type\ \Size > /var/www/html/inventory.html
fi

if [[ -f /var/www/html/inventory.html ]];

then
        size=$(du -h /tmp/"${name}-httpd-logs-${timestamp}.tar" | awk '{print $1}')

        echo -e "httpd-logs\t- \t$(date '+%d%m%Y-%H%M%S')\t- \ttar\t -\t${size}" >> /var/www/html/inventory.html

fi

#Cron job automation

if [[ ! -f /etc/cron.d/automation ]];
then
        echo "0 11 * * 1-5 root /root/Automation_Project/automation.sh" >> /etc/cron.d/automation
fi
