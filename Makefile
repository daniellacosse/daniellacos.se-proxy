DOMAIN=daniellacos.se
ENVIRONMENT_CONFIG=.env
SHELL:=/bin/bash

-include $(ENVIRONMENT_CONFIG)

REMOTE_USER=root
REMOTE_SHELL=ssh $(REMOTE_USER)@$(dns_linode_ip)

# dependencies
LOCAL_PYTHON_DEPENDENCIES=requirements.txt

REMOTE_SYSTEM_DEPENDENCIES=nginx python3 python3-pip
REMOTE_PYTHON_DEPENDENCIES=/$(REMOTE_USER)/$(LOCAL_PYTHON_DEPENDENCIES)

# configs
LOCAL_CONFIG_FOLDER=./config
LOCAL_NGINX_ROOT_CONFIG=$(LOCAL_CONFIG_FOLDER)/nginx.conf
LOCAL_NGINX_SITES=$(LOCAL_CONFIG_FOLDER)/sites-enabled

REMOTE_ENVIRONMENT_CONFIG=/$(REMOTE_USER)/$(ENVIRONMENT_CONFIG)

REMOTE_NGINX_FOLDER=/etc/nginx

REMOTE_NGINX_LOG_FOLDER=/var/log/nginx
REMOTE_NGINX_ACCESS_LOG=$(REMOTE_NGINX_LOG_FOLDER)/access.log
REMOTE_NGINX_ERROR_LOG=$(REMOTE_NGINX_LOG_FOLDER)/error.log

# recipes
UPLOAD=scp -r $(1) $(REMOTE_USER)@$(dns_linode_ip):$(2)
EXECUTE=$(dns_linode_ip) "$(1)"

CERTBOT_CONFIG_FLAGS= \
	--installer nginx \
	--dns-linode \
	--dns-linode-credentials=$(REMOTE_ENVIRONMENT_CONFIG)

.PHONY: default update shell logs setup credentials renew challenge

default:
	make update

update:
	@$(call UPLOAD,$(LOCAL_NGINX_ROOT_CONFIG),$(REMOTE_NGINX_FOLDER)) ;\
	 $(call UPLOAD,$(LOCAL_NGINX_SITES),$(REMOTE_NGINX_FOLDER)) ;\
	 $(call EXECUTE,service nginx restart)

shell:
	@$(REMOTE_SHELL)

logs:
	@$(call EXECUTE,tail -f $(REMOTE_NGINX_ACCESS_LOG) $(REMOTE_NGINX_ERROR_LOG))

setup:
	@$(call EXECUTE,sudo apt-get update) ;\
	 $(call EXECUTE,sudo apt-get install $(REMOTE_SYSTEM_DEPENDENCIES)) ;\
	 $(call UPLOAD,$(LOCAL_PYTHON_DEPENDENCIES),$(REMOTE_PYTHON_DEPENDENCIES)) ;\
	 $(call EXECUTE,pip3 install -r $(REMOTE_PYTHON_DEPENDENCIES)) ;\
	 make upload-config ;\
	 make challenge

credentials:
	@$(call UPLOAD,$(ENVIRONMENT_CONFIG),$(REMOTE_ENVIRONMENT_CONFIG))

renew: credentials
	 $(call EXECUTE,certbot renew $(CERTBOT_CONFIG_FLAGS))

challenge: credentials
	@$(call EXECUTE,certbot -d *.$(DOMAIN) -d $(DOMAIN) $(CERTBOT_CONFIG_FLAGS))
