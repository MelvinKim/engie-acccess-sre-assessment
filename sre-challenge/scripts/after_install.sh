#!/bin/bash

# Set working directory
cd /var/www/html/django_project

# set up virtualenv
sudo /usr/bin/python3 -m venv .venv
source .venv/bin/activate

# Install python requirements
pip install -r requirements.txt

# Link Nginx configuration file
sudo ln -sf /var/www/html/django_project/config/nginx.conf /etc/nginx/nginx.conf

# sudo ln -sf /var/www/html/django_project/sre_challenge/ /etc/nginx/nginx.conf