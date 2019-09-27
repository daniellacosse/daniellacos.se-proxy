-include .env

.PHONY: default setup renew

default:
	@scp -rf server root@$(LINODE_IP):/etc/nginx/

# CREDS_PATH=~/.secrets/certbot/linode.ini
# DOMAIN=daniellacos.se
# SETUP_SCRIPT="
# 	sudo apt-get update
# 	sudo apt-get install \
# 		nginx \
# 		certbot \
# 		python3-certbot-nginx
# 	certbot -d *.$(DOMAIN) -d $(DOMAIN) --manual -i nginx
# "

setup: $(CREDS_PATH)
	@ssh root@$(LINODE_IP) "$(SETUP_SCRIPT)" ;\
	make

shell:
	@ssh root@$(LINODE_IP)

$(CREDS_PATH):
	# make dns-linode
	# restrict permissions w/ chmod 600

# mkdir /etc/systemd/system/nginx.service.d

renew:
	@ssh root@$(LINODE_IP) "certbot renew"
