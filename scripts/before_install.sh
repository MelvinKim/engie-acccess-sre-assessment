#!/bin/bash

# create the working directory
sudo mkdir -p /var/www/html/django_project/sre_challenge

# copy the application code to the working directory
cp -r /home/ubuntu/sre-challenge/ /var/www/html/django_project/sre_challenge

# Create uwsgi pid dir
sudo mkdir -p /var/run/uwsgi/app

# Create logging directory
sudo mkdir -p /var/log/uwsgi
