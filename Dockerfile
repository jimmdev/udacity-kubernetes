FROM nginx:alpine
COPY html_content /usr/share/nginx/htlm
COPY nginx.conf /etc/nginx/nginx.conf