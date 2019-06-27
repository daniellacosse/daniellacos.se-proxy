FROM nginx:alpine

COPY ./nginx/default.conf /etc/nginx/conf.d/

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
