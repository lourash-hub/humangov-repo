# Use Python as a base image
FROM python:3.8-slim-buster

# set working directory
WORKDIR /app

# copy requirements and install dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# copy the flask application
COPY . /app

#start Gunicorn
CMD [ "gunicorn", "--workers", "1", "--bind", "0.0.0.0:8000", "humangov:app" ]