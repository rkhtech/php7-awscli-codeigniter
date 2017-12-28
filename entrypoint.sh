#!/bin/bash

if [ -z "$DNS_NAME" ]; then
    echo "DOCKER environment variable 'DNS_NAME' is not defined."
    echo
    echo "It can be defined by adding the following to the docker run command:"
    echo "docker run -e DNS_NAME='example.com'"
    exit 1
fi

if [ -z "$MYSQL_PASSWORD" ]; then
MYSQL_PASSWORD=$(aws ssm get-parameters --names mysql-password-${STAGE} --with-decryption --query Parameters[0].Value --output text --region us-west-2)
fi
if [ -z "$MYSQL_HOSTNAME" ]; then
MYSQL_HOSTNAME=$(aws ssm get-parameters --names mysql-hostname-${STAGE} --with-decryption --query Parameters[0].Value --output text --region us-west-2)
fi
if [ -z "$AUTH_LOGIN_ID" ]; then
AUTH_LOGIN_ID=$(aws ssm get-parameters --names auth-login-id-${STAGE} --with-decryption --query Parameters[0].Value --output text --region us-west-2)
fi
if [ -z "$AUTH_TRANSACTION_KEY" ]; then
AUTH_TRANSACTION_KEY=$(aws ssm get-parameters --names auth-transaction-key-${STAGE} --with-decryption --query Parameters[0].Value --output text --region us-west-2)
fi

if [ -f /var/www/application/config/database.php.template ]; then
sed \
-e 's/MYSQL_PASSWORD/'${MYSQL_PASSWORD}'/' \
-e 's/MYSQL_HOSTNAME/'${MYSQL_HOSTNAME}'/' \
/var/www/application/config/database.php.template > /var/www/application/config/database.php
fi

sed -i -e 's/DNS_NAME/'${DNS_NAME}'/' /etc/apache2/sites-available/000-default.conf

#chown -R www-data:www-data /var/www/html &
mkdir -p /var/log/ductcerts
chown -R www-data:www-data /var/log/ductcerts

#echo "---------------------"
#cat /etc/apache2/sites-available/000-default.conf
#echo "---------------------"

apache2-foreground
