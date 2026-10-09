FROM php:8.1-apache
RUN a2enmod rewrite
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
COPY src/ /var/www/html/
RUN chown -R www-data:www-data /var/www/html
EXPOSE 80