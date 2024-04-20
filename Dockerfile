# base image
FROM python:3.11 AS base


# Install C compiler needed to install uwsgi
RUN apt-get install gcc

# set working directory
WORKDIR /app

# Copy source code
COPY sre-challenge/ .
# Allows docker to cache installed dependencies between builds
RUN pip install --no-cache-dir -r requirements.txt

# FROM python:3.11-alpine

# COPY --from=base /usr/local/lib/python3.11/site-packages/ /usr/local/lib/python3.11/site-packages/

EXPOSE 80

RUN chmod 755 start.sh
CMD ["./start.sh"]