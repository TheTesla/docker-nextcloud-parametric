FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive 

RUN apt update && apt install -y apache2 libapache2-mod-php7.4 php7.4-gd php7.4-pgsql php7.4-curl php7.4-mbstring php7.4-intl php7.4-gmp php7.4-bcmath php-imagick php7.4-xml php7.4-zip

RUN apt update && apt install -y wget unzip sudo postgresql-client-common

RUN wget -c https://download.nextcloud.com/server/releases/nextcloud-22.1.0.zip && unzip nextcloud-22.1.0.zip && cp -rf nextcloud /var/www/

RUN chown www-data:www-data -R /var/www

COPY nextcloud.conf /etc/apache2/sites-available/.

RUN a2ensite nextcloud.conf

RUN a2enmod rewrite headers env dir mime 

COPY entrypoint.sh /

COPY custom.config.php /

RUN chmod 0777 /entrypoint.sh

RUN apt update && apt install -y postgresql-client-12


#USER www-data

EXPOSE 80
CMD /entrypoint.sh



