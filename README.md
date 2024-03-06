# grocy-install

Scripts and configuration files that help with Grocy installation

Requirements:

- Ubuntu 22.04 (20.04 no longer supported with Grocy 4)
- SSH access
- Internet access on the machine

## setup_grocy_please.sh

This Bash shell script is responsible for semi-automatically installing everything an Ubuntu system needs in order to run Grocy.

A list of things it does:

- Installs the PHP repository for Ubuntu that has the needed PHP versions (courtesy of Ondřej Surý)
- Updates Ubuntu packages to their latest version
- Installs the following:
    nginx - A reverse proxy that handles the website - that is Grocy
    sqlite3 - Database driver
    php8.3-fpm and additional extensions needed for running Grocy
    unzip - Needed to unzip Grocy during installation
    certbot - Automated SSL certificate handler in order to enable HTTPS traffic
    python3-certbot-nginx - Extension to make certbot understand NGINX and vice-versa

- Downloads and installs Grocy, also provides a setting to change the currency (I believe you cannot change this in the UI)
- Fetches and copies NGINX configuration files from this repo to their place
- Generates an SSL certificate via Let's Encrypt, installs it and applies it to the NGINX configuration
- Creates a crontab record to run an auto-renewal task at 03:00 every day

## ddns_config_cloudflare.sh

Use this config set up automatic DNS record updates for a domain purchased or managed on Cloudflare.
The config file template & the updater script can be found in the Cloudflare folder.

Find Grocy at [https://github.com/grocy/grocy](https://github.com/grocy/grocy)

Tallyrald wrote a detailed [Reddit post](https://www.reddit.com/r/grocy/comments/qvckh7/free_googlehosted_httpssecured_grocy_installation) that explains how to set up a free, Google-hosted, HTTPS secured installation.
