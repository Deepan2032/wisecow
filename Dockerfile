FROM alpine:3.16
RUN apk add --no-cache bash netcat-openbsd cowsay fortune
RUN sudo apt install fortune-mod cowsay -y
RUN sudo apt install awscli -y
COPY wisecow.sh /usr/src/app/wisecow.sh
COPY health_monitor.sh /usr/src/app/health_monitor.sh
COPY backup_script.sh /usr/src/app/backup_script.sh
RUN chmod +x /usr/src/app/wisecow.sh
RUN chmod +x /usr/src/app/health_monitor.sh
RUN chmod +x /usr/src/app/backup_script.sh
RUN echo "*/10 * * * * /usr/src/app/health_monitor.sh >> /var/log/health_monitor.log 2>&1" >> /etc/crontabs/root \
    && echo "*/10 * * * * /usr/src/app/backup_script.sh >> /var/log/backup.log 2>&1" >> /etc/crontabs/root
WORKDIR /usr/src/app
EXPOSE 4499
CMD ["sh", "-c", "crond && ./wisecow.sh"]
