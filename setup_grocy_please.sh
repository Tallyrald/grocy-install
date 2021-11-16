#!/bin/bash
read -p 'Please tell me the full domain name (e.g. grocy.example.com) you want to use for reaching Grocy: ' domain
read -p 'Grocy currency - ISO 4217 code (hit Return for default: USD): ' currency
currency=${currency:-USD}

# Add PHP repository for getting 8.X
add-apt-repository -y ppa:ondrej/php
# Update
apt-get update && sudo apt-get -y upgrade
# Install everything we'll need for Grocy, the webserver & HTTPS
apt-get install -y nginx sqlite3 php8.0-fpm php8.0-sqlite3 php8.0-gd php8.0-mbstring php8.0-intl unzip certbot python3-certbot-nginx
# Start Nginx
systemctl enable nginx

# Install the latest Grocy release
cd /var/www/html
wget -q https://releases.grocy.info/latest
unzip -fo latest -d /var/www/html && rm latest
# Make everything compliant with Nginx standards
chown -R www-data:www-data /var/www
# Set up the configuration file for Grocy
cp /var/www/html/config-dist.php /var/www/html/data/config.php
sed -i "s/Setting('CURRENCY', 'USD');/Setting('CURRENCY', '$currency');/g" /var/www/html/data/config.php

# Set up NGINX with PHP & configuration files
cd /etc/nginx/conf.d
wget -q https://raw.githubusercontent.com/Tallyrald/grocy-install/main/fastcgi_params.conf
mv fastcgi_params.conf fastcgi_params
wget -q https://raw.githubusercontent.com/Tallyrald/grocy-install/main/nginx_grocy.conf
sed -i "s/placeholder_domain/$domain/g" nginx_grocy.conf
mv nginx_grocy.conf "$domain.conf"
cd /etc/nginx
wget -q https://raw.githubusercontent.com/Tallyrald/grocy-install/main/nginx_main_config.conf
mv nginx.conf nginx.conf.original
mv nginx_main_config.conf nginx.conf

# Reload NGINX
nginx -s reload

# Set up SSL, make sure renewing takes place automatically
certbot --nginx --agree-tos --redirect -d "$domain"
crontab -l > updatedcron
echo "0 12 * * * /usr/bin/certbot renew --quiet" >> updatedcron
crontab updatedcron
rm updatedcron

echo "Done!"