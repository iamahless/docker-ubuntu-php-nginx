FROM ubuntu:20.10
MAINTAINER Friday Godswill <friday@hotels.ng>

ADD conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
# Install Environment
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install software-properties-common
RUN apt-get install nginx -y
RUN apt-get install \
	php7.4-dom \
	php7.4-bcmath \
	php7.4-bz2 \
	php7.4-intl \
	php7.4-gd \
	php7.4-mbstring \
	php7.4-mysql \
	php7.4-zip \
	php7.4-fpm \
	php7.4-json \
	php7.4-curl -y && service nginx start

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
RUN service php7.4-fpm start
EXPOSE 443 80
CMD ["bash", "/init.sh"]
