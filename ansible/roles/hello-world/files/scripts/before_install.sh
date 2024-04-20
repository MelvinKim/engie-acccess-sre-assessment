#!/bin/bash

# create the working directory
sudo mkdir -p /var/www/html/django_project

# copy the application code to the working directory
cp -r /home/ubuntu/* /var/www/html/django_project

# Create uwsgi pid dir
sudo mkdir -p /var/run/uwsgi/app

# Create logging directory
sudo mkdir -p /var/log/uwsgi
