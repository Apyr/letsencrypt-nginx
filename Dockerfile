FROM ubuntu:16.04

WORKDIR /root

RUN apt update
RUN apt install -y nano nginx python-software-properties software-properties-common
RUN add-apt-repository ppa:certbot/certbot && apt update
RUN apt install -y --upgrade letsencrypt

ADD nginx/nginx.conf /etc/nginx/nginx.conf
ADD nginx/sites-available/default /etc/nginx/sites-available/default

ADD init.sh ./
RUN chmod +x init.sh

EXPOSE 80
EXPOSE 443

CMD ["bash", "-c", "/root/init.sh"]