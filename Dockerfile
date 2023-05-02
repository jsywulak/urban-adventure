FROM golang:1.16-alpine
WORKDIR /app
COPY att.go /app

RUN go build -o bin/att att.go

EXPOSE 8080

CMD ["/app/bin/att"]
