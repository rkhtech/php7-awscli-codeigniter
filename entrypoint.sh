#!/bin/bash

MYSQL_PASSWORD=$(aws ssm get-parameters --names mysql-hostname-${STAGE} --with-decryption --query Parameters[0].Value --output text --region us-west-2)
MYSQL_HOSTNAME=$(aws ssm get-parameters --names mysql-password-${STAGE} --with-decryption --query Parameters[0].Value --output text --region us-west-2)

sed -i \
-e 's/MYSQL_PASSWORD/'${MYSQL_PASSWORD}'/' \
-e 's/MYSQL_HOSTNAME/'${MYSQL_HOSTNAME}'/' \
/var/www/html/application/config/database.php

apache2-foreground