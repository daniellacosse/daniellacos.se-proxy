SHELL:=/bin/bash

-include .env

DOMAIN=daniellacos.se

SERVER_FOLDER=./server
SSL_CERT_FOLDER=./letsencrypt
NGINX_ROOT=$(SERVER_FOLDER)/nginx.conf
NGINX_SITE_FOLDER=$(SERVER_FOLDER)/sites-enabled

REMOTE_SHELL=ssh root@$(LINODE_IP)
REMOTE_DEPENDENCIES=nginx certbot python3-certbot-nginx
NGINX_REMOTE_FOLDER=/etc/nginx/
NGINX_REMOTE_LOG_FOLDER=/var/log/nginx
NGINX_REMOTE_ACCESS_LOG=$(NGINX_REMOTE_LOG_FOLDER)/access.log
NGINX_REMOTE_ERROR_LOG=$(NGINX_REMOTE_LOG_FOLDER)/error.log
NGINX_STATIC_SERVER_ROOT=/usr/share/nginx/html
CERTBOT_REMOTE_HTTP_CHALLENGE_FOLDER=${NGINX_STATIC_SERVER_ROOT}/.well-known/acme-challenge

.PHONY: default shell logs renew setup challenge

upload=scp -r $(1) root@$(LINODE_IP):$(2)
execute=$(REMOTE_SHELL) "$(1)"

default:
	@$(call upload,$(NGINX_ROOT),$(NGINX_REMOTE_FOLDER)) ;\
	 $(call upload,$(NGINX_SITE_FOLDER),$(NGINX_REMOTE_FOLDER)) ;\
	 $(call execute,service nginx restart)

shell:
	@$(REMOTE_SHELL)

logs:
	@$(call execute,tail -f $(NGINX_REMOTE_ACCESS_LOG) $(NGINX_REMOTE_ERROR_LOG))

renew:
	@$(call execute,certbot renew)

# TODO: certbot dns linode - https://certbot-dns-linode.readthedocs.io/en/stable/
setup:
	@$(call execute,sudo apt-get update) ;\
	 $(call execute,sudo apt-get install $(REMOTE_DEPENDENCIES)) ;\
	 make challenge ;\
	 make

# will require you to create a DNS TXT record and muck about a bit in the box via `make shell`
challenge:
	@$(call execute,mkdir -p $(CERTBOT_REMOTE_HTTP_CHALLENGE_FOLDER)) ;\
	 $(call execute,certbot -d *.$(DOMAIN) -d $(DOMAIN) --manual -i nginx)
