# base image
FROM python:3.11 AS base

# Install C compiler and other needed packages for uwsgi
RUN apt-get update && \
    apt-get install -y gcc python3-dev uwsgi uwsgi-plugin-python3

# set working directory
WORKDIR /app

# Copy source code
COPY sre-challenge/ .

# Installed required dependencies
RUN pip install -r requirements.txt

EXPOSE 80

# make the script executable
RUN chmod +x start.sh

# Entrypoint that will run when the container starts
CMD ["./start.sh"]