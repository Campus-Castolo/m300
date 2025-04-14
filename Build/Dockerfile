# Start from the official WordPress image
FROM wordpress:latest

# Copy custom plugins/themes (Ensure these folders exist!)
COPY wp-build/plugins/ /var/www/html/wp-content/plugins/
COPY wp-build/themes/ /var/www/html/wp-content/themes/

# Set recommended PHP settings (optional)
RUN echo "upload_max_filesize=64M" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "post_max_size=64M" >> /usr/local/etc/php/conf.d/uploads.ini

# Install WP-CLI for plugin activation
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Copy helper script to pre-activate plugins (Ensure wp-setup.sh exists!)
COPY wp-build/wp-setup.sh /docker-entrypoint-initwp.d/

# Ensure script has execution permissions
RUN chmod +x /docker-entrypoint-initwp.d/wp-setup.sh

# Set correct permissions (optional, recommended)
RUN chown -R www-data:www-data /var/www/html/wp-content

# Expose Port
EXPOSE 80
