# Start from the official WordPress image
FROM wordpress:latest

# Example: Copy custom plugins or themes (adjust paths as needed)
COPY ./plugins /var/www/html/wp-content/plugins/
COPY ./themes /var/www/html/wp-content/themes/
COPY wp-setup.sh /docker-entrypoint-initwp.d/


# Example: Set recommended PHP settings (optional)
RUN echo "upload_max_filesize=64M" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "post_max_size=64M" >> /usr/local/etc/php/conf.d/uploads.ini

# Install wp-cli for plugin activation (optional step if you want pre-activation)
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Copy a helper script to pre-activate plugins
COPY wp-setup.sh /docker-entrypoint-initwp.d/

# Ensure script has execution permissions
RUN chmod +x /docker-entrypoint-initwp.d/wp-setup.sh

# Set correct permissions (optional)
RUN chown -R www-data:www-data /var/www/html/wp-content

# Expose Port
EXPOSE 80
