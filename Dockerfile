FROM ubuntu:23.10
RUN apt-get update && apt install fortune-mod cowsay -y
COPY wisecow.sh /usr/src/app/wisecow.sh
COPY health_monitor.sh /usr/src/app/health_monitor.sh
COPY backup_script.sh /usr/src/app/backup_script.sh
RUN chmod +x /usr/src/app/wisecow.sh
RUN chmod +x /usr/src/app/health_monitor.sh
RUN chmod +x /usr/src/app/backup_script.sh
WORKDIR /usr/src/app
EXPOSE 4499
CMD ["./wisecow.sh"]
