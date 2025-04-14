# Build/Dockerfile

FROM wordpress:latest

COPY plugins/ /var/www/html/wp-content/plugins/
COPY themes/ /var/www/html/wp-content/themes/

RUN echo "upload_max_filesize=64M" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "post_max_size=64M" >> /usr/local/etc/php/conf.d/uploads.ini

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

COPY wp-setup.sh /docker-entrypoint-initwp.d/
RUN chmod +x /docker-entrypoint-initwp.d/wp-setup.sh

RUN chown -R www-data:www-data /var/www/html/wp-content

EXPOSE 80
