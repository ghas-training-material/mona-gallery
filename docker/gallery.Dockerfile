FROM golang:1.15

WORKDIR /code

COPY gallery /code
RUN go mod download

RUN go build -o gallery

CMD ["./gallery", "config.json"]