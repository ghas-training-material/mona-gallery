FROM golang:1.20

WORKDIR /code

COPY auth /code
RUN go mod download

RUN go build -o server

CMD ["./server"]