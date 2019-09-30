SHELL:=/bin/bash

-include .env

.PHONY: default shell renew setup

DOMAIN=daniellacos.se

default:
	@scp ./server/nginx.conf root@$(LINODE_IP):/etc/nginx/ ;\
	scp -r ./server/sites-enabled root@$(LINODE_IP):/etc/nginx/ ;\
	ssh root@$(LINODE_IP) "service nginx restart"

shell:
	@ssh root@$(LINODE_IP)

renew:
	@ssh root@$(LINODE_IP) "certbot renew"

setup:
	@ssh root@$(LINODE_IP) "sudo apt-get update" ;\
	ssh root@$(LINODE_IP) "sudo apt-get install nginx certbot python3-certbot-nginx" ;\
	scp -r ./letsencrypt root@$(LINODE_IP):/etc/ ;\
	make

# will require you to create a DNS TXT record and muck about a bit in the box via `make shell`
challenge:
	@ssh root@$(LINODE_IP) "mkdir -p /var/www/html/.well-known/acme-challenge" ;\
	ssh root@$(LINODE_IP) "certbot -d *.$(DOMAIN) -d $(DOMAIN) --manual -i nginx"
