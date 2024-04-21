# base image
FROM python:3.11 AS base

# Install C compiler and other needed packages for uwsgi
RUN apt-get update && \
    apt-get install -y gcc python3-dev uwsgi uwsgi-plugin-python3

# set working directory
WORKDIR /app

# Copy source code
COPY sre-challenge/ .
# Allows docker to cache installed dependencies between builds
RUN pip install -r requirements.txt

# FROM python:3.11-alpine

# COPY --from=base /usr/local/lib/python3.11/site-packages/ /usr/local/lib/python3.11/site-packages/

EXPOSE 80

RUN chmod 755 start.sh
CMD ["./start.sh"]