SHELL:=/bin/bash

-include .env

.PHONY: default setup shell renew

DOMAIN=daniellacos.se

default:
	@scp -rf server root@$(LINODE_IP):/etc/nginx/

shell:
	@ssh root@$(LINODE_IP)

renew:
	@ssh root@$(LINODE_IP) "certbot renew"

setup: $(CREDS_PATH)
	@ssh root@$(LINODE_IP) "\
		sudo apt-get update \
		sudo apt-get install \\\
			nginx \\\
			certbot \\\
			python3-certbot-nginx \
		mkdir -p /var/www/html/.well-known/acme-challenge \
		certbot -d *.$(DOMAIN) -d $(DOMAIN) --manual -i nginx \
	" ;\
	make
