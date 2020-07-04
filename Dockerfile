FROM ubuntu:18.04
MAINTAINER Friday Godswill <friday@hotels.ng>

# Install Environment
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install software-properties-common
RUN apt-get install nginx -y
RUN apt-get install \
	php7.2-dom \
	php7.2-xml \
	php7.2-bcmath \
	php7.2-bz2 \
	php7.2-intl \
	php7.2-gd \
	php7.2-mbstring \
	php7.2-mysql \
	php7.2-zip \
	php7.2-fpm \
	php7.2-json \
	php7.2-curl -y && service nginx start

#Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
php composer-setup.php --install-dir=/usr/bin --filename=composer && \
php -r "unlink('composer-setup.php');"
RUN apt-get install supervisor curl -y

WORKDIR /var/www
ADD conf/supervisord.conf /etc/supervisord.conf
ADD init.sh /init.sh
ADD conf/supervisord.conf /etc/supervisord.conf
ADD conf/nginx.conf /etc/nginx/nginx.conf
ADD conf/nginx-site.conf /etc/nginx/sites-available/default.conf
ADD conf/start.sh /start.sh
RUN rm -rf /etc/nginx/sites-enabled/default
RUN chmod 755 /start.sh
RUN chmod 755 /init.sh
RUN service php7.2-fpm start
EXPOSE 443 80
CMD ["bash", "/init.sh"]
