FROM python:3.7

ENV APP_HOME /app
ENV PORT=8080
WORKDIR $APP_HOME
COPY src /app
COPY Pipfile /app
COPY Pipfile.lock /app

RUN pip install pipenv
RUN pipenv install --system

# Run the web service on container startup. Here we use the gunicorn
# webserver, with one worker process and 8 threads.
# For environments with multiple CPU cores, increase the number of workers
# to be equal to the cores available.
CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 app:app