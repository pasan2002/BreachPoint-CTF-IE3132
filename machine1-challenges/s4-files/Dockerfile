FROM php:8.1-apache
RUN apt-get update && apt-get install -y iputils-ping && rm -rf /var/lib/apt/lists/*
RUN a2enmod rewrite
COPY src/ /var/www/html/
# Move backup OUTSIDE the web root so it's only reachable via command injection
RUN mkdir -p /opt/backups
COPY src/backups/config_backup.enc /opt/backups/config_backup.enc
RUN rm -rf /var/www/html/backups
RUN chown -R www-data:www-data /var/www/html
EXPOSE 80