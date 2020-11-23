#!/bin/bash

set -e

aws ecr get-login-password --region us-west-2 --profile archon | docker login --username AWS --password-stdin 142979589450.dkr.ecr.us-west-2.amazonaws.com


docker build -t ductcerts-base-php-56 .


docker tag ductcerts-base-php-56:latest 142979589450.dkr.ecr.us-west-2.amazonaws.com/ductcerts-base-php-56:latest


docker push 142979589450.dkr.ecr.us-west-2.amazonaws.com/ductcerts-base-php-56:latest

#docker build -t rkhtech/php7-awscli-codeigniter:latest .

