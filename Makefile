BUILDFILES=.buildfiles

-include $(BUILDFILES)/main.mk $(BUILDFILES)/commands/container.mk

override IMAGE_NAME=daniellacos.se-proxy

CERTIFICATES=certs

default: $(PROXY_FOLDER) $(CERTIFICATES)
	make container

$(CERTIFICATES):


$(BUILDFILES):
	git clone git@github.com:daniellacosse/typescript-buildfiles.git $(BUILDFILES)
