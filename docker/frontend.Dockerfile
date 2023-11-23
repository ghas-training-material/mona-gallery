FROM docker.io/node:18.16.0-buster

RUN npm install -g @vue/cli

WORKDIR /code
COPY frontend /code

RUN npm install

ENTRYPOINT ["npm"]
CMD ["run", "serve"]
