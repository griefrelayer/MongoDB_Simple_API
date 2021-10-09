FROM tiangolo/uwsgi-nginx-flask:python3.8

ENV LISTEN_PORT 8000

ENV UWSGI_INI /app/uwsgi.ini

EXPOSE 8000

WORKDIR /app

COPY Pipfile Pipfile.lock /app/

RUN pip install pipenv && pipenv install --system

COPY . /app/

