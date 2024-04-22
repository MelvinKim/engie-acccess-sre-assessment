#!/bin/bash

# create working directory folder
sudo mkdir -p /var/www/html/django_project

# copy the application code to the working directory
cp -R /home/ubuntu/sre-challenge/* /var/www/html/django_project

# change ownership of the folder to ubuntu:root
sudo chown -R ubuntu:root /var/www/html/django_project
sudo chown -R ubuntu:ubuntu /var/www/html/django_project/.venv/

# Create uwsgi pid dir
sudo mkdir -p /var/run/uwsgi/app

# Create logging directory
sudo mkdir -p /var/log/uwsgi
sudo chown -R ubuntu:root /var/log/uwsgi
