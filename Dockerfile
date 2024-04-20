FROM python:3.11.4-slim-buster

WORKDIR /app

COPY sre-challenge/ .

RUN pip install -r requirements.txt

EXPOSE 80

ENTRYPOINT [ "python", "manage.py", "runserver" ]

CMD [ "0.0.0.0:3000" ]