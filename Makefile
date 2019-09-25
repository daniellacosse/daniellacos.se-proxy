-include .env

.PHONY: default setup

default:
	scp -rf ./server root@$(LINODE_IP):/etc/nginx/

setup:
	ssh root@$(LINODE_IP) "sudo apt-get update && sudo apt-get install nginx certbot python-certbot-nginx" ;\
	ssh root@$(LINODE_IP) "nginx" ;\
	ssh root@$(LINODE_IP) "certbot --nginx" ;\
	make
