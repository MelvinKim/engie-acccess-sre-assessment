# base image
FROM python:3.11-slim

# Install C compiler and other needed packages for uwsgi
RUN apt-get update && \
    apt-get install -y gcc python3-dev uwsgi uwsgi-plugin-python3 && \
    # clean up the APT cache after package installation to build smaller image
    rm -rf /var/lib/apt/lists/*

# set working directory
WORKDIR /app

# Copy source code
COPY sre-challenge/ .

# Installed required dependencies
RUN pip install -r requirements.txt

# Entrypoint that will run when the container starts
ENTRYPOINT [ "uwsgi", "--ini", "uwsgi.ini"  ]
