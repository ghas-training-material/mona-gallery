# syntax=docker/dockerfile:1.4
FROM python:3.10-bullseye

WORKDIR /code

COPY auth-ext /code

RUN apt-get update && \
    apt-get install -y \
    libcairo2-dev \
    pkg-config \
    python3-dev \
    libgirepository1.0-dev

RUN --mount=type=cache,target=/root/.cache/pip \
    pip3 install -r requirements.txt

ENTRYPOINT ["python3"]
CMD ["app.py"]
