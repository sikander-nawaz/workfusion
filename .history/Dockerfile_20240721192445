# Use the official PHP 7.4 FPM image as a base
FROM php:7.4-fpm

# Install dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    git \
    unzip \
    libicu-dev \
    zlib1g-dev \
    libonig-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && docker-php-ext-install zip \
    && docker-php-ext-install intl

# Copy application files to the container
COPY . /var/www/html

# Set working directory
WORKDIR /var/www/html

# Ensure the PHP-FPM process runs as the correct user
RUN chown -R www-data:www-data /var/www/html

# Expose port 9000 for PHP-FPM
EXPOSE 9000

# Start PHP-FPM server
CMD ["php-fpm"]

# Optionally, add a custom configuration file if needed
# COPY custom-php.ini /usr/local/etc/php/conf.d/