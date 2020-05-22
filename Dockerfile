FROM nginx
COPY html_content/index.html /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
