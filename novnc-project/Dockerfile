FROM theasp/novnc

# For more information, please refer to https://aka.ms/vscode-docker-python
ENV VAR1=10

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

# tesseract
RUN apt-get update && apt-get install -y \
    tesseract-ocr

# grapical libraries
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libglib2.0-0

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip

# Install & use pipenv
COPY Pipfile Pipfile.lock ./
RUN python3 -m pip install --upgrade pip
RUN pip install pipenv 
RUN pipenv install --dev --system --deploy

# WORKDIR /app

# Creates a non-root user and adds permission to access the /app folder
# RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
# USER appuser

