#!/bin/bash

# Start webserver
cd /var/www/html/django_project
sudo /var/www/html/django_project/.venv/bin/uwsgi --socket /var/run/uwsgi/app/socket --module sre_challenge.wsgi:application --daemonize /var/log/uwsgi/sre-challenge.log

# restart reverse proxy
sudo systemctl restart nginx.service
