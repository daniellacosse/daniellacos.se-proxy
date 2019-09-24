BUILDFILES=.buildfiles

-include $(BUILDFILES)/main.mk $(BUILDFILES)/commands/container.mk

override IMAGE_NAME=daniellacos.se-proxy

default: $(PROXY_FOLDER)
	make container

$(BUILDFILES):
	git clone git@github.com:daniellacosse/typescript-buildfiles.git $(BUILDFILES)
