server {
  location / {
#    proxy_pass https://www.trello.com
  }

  location /slot {
#    proxy_pass 0.0.0.0
  }
}
