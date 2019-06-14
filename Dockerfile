FROM nginx:alpine

COPY ./default.conf /etc/nginx/conf.d/

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
