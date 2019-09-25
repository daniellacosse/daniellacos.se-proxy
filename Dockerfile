FROM nginx:alpine

COPY ./server /etc/nginx/
COPY ./certs /

CMD ["nginx"]
