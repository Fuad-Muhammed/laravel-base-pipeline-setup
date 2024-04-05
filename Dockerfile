FROM php:8.3-fpm-alpine

# install composer
RUN curl -sLS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

# install dependencies
COPY composer.json composer.lock .
RUN composer install --no-scripts

# copy project files
WORKDIR /var/www/html
COPY . .

# laravel init processes
RUN composer run post-autoload-dump \
	&& php artisan key:generate \
	&& php artisan migrate

# Set permissions for Laravel
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache /var/www/html/database
RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache /var/www/html/database

EXPOSE 9000

CMD ["php-fpm"]

