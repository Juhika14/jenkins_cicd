FROM ubuntu/apache2
ADD . /var/www/html
ENTRYPOINT apachectl -D FOREGROUND
