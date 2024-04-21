#!/usr/bin/env bash
uwsgi --ini uwsgi.ini
# uwsgi --http 0.0.0.0:5000 --module sre_challenge.wsgi:application