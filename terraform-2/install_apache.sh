#!/bin/bash
yum update -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd

echo "Hello everyone, my name is Tund from $(hostname -f)" > /var/www/html/index/html
