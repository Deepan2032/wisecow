FROM alpine:3.16
RUN apk add --no-cache bash netcat-openbsd cowsay fortune
COPY wisecow.sh /usr/src/app/wisecow.sh
RUN chmod +x /usr/src/app/wisecow.sh
WORKDIR /usr/src/app
EXPOSE 4499
CMD ["./wisecow.sh"]
