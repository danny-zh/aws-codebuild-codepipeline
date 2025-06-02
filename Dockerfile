FROM alpine:3.21
RUN apk update && apk add --no-cache apache2 && \ 
    echo "cmtr-9be1831a" > /var/www/localhost/htdocs/index.html 
EXPOSE 80
ENTRYPOINT [ "httpd","-D","FOREGROUND" ]