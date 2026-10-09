FROM php:8.1-apache
RUN docker-php-ext-install mysqli pdo pdo_mysql
RUN a2enmod rewrite
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
COPY src/ /var/www/html/
RUN chown -R www-data:www-data /var/www/html
EXPOSE 80