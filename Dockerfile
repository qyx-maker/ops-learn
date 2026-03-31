FROM nginx:1.28.1

COPY nginx.conf /etc/nginx/nginx.conf

COPY tomcat.conf /etc/nginx/conf.d/

EXPOSE 80
