#!/bin/bash
read -p 'Your top-level domain name - do not include subdomains (e.g. example.com): ' topdomain
read -p 'Your A record name (e.g. grocy): ' subdomain
read -p 'Cloudflare API token with EDIT permission: ' edittoken
read -p 'Cloudflare API token with READ permission: ' readtoken

# Download updater script & blank config
mkdir /etc/ddns
cd /etc/ddns
wget -q https://raw.githubusercontent.com/Tallyrald/grocy-install/main/cloudflare/cloudflare-update-record_config.yaml
wget -q https://raw.githubusercontent.com/Tallyrald/grocy-install/main/cloudflare/update_dns_cloudflare.py

# Replace templates with actual data
sed -i "s/read_token_placeholder/$readtoken/g" /etc/ddns/cloudflare-update-record_config.yaml
sed -i "s/edit_token_placeholder/$edittoken/g" /etc/ddns/cloudflare-update-record_config.yaml
sed -i "s/zone_placeholder/$topdomain/g" /etc/ddns/cloudflare-update-record_config.yaml
sed -i "s/record_placeholder/$subdomain.$topdomain/g" /etc/ddns/cloudflare-update-record_config.yaml

# Run the script every 30 minutes
crontab -l > updatedcron
echo "*/30 * * * * /etc/ddns/update_dns_cloudflare.py" >> updatedcron
crontab updatedcron
rm updatedcron

echo "Done!"
