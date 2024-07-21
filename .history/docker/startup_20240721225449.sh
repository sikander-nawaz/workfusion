#!/bin/sh

# Replace the placeholder LISTEN_PORT with the actual port from the environment variable
sed -i "s,LISTEN_PORT,$PORT,g" /etc/nginx/nginx.conf

# Start PHP-FPM in the background
php-fpm -D

# Wait until PHP-FPM is up and running
while ! nc -z 127.0.0.1 9000; do
    sleep 0.1
done

# Start Nginx
nginx -g "daemon off;"