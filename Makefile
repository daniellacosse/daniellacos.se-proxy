MAKE_FOLDER=.make

PROJECT_DEPENDENCIES_PROXY_TARGETS=\
	$(MAKE_FOLDER)/Brewfile

.PHONY:\
	image \
	container \
	release! \
	reset

# -- image --

IMAGE_PROXY_TARGET=$(MAKE_FOLDER)/image

LOCAL_SERVER_IMAGE_NAME=daniellacos.se-proxy

SERVER_FOLDER=proxy
SERVER_DOCKERFILE=$(SERVER_FOLDER)/Dockerfile
SERVER_CONF=$(SERVER_FOLDER)/server.conf

image: $(MAKE_FOLDER)
	make $(IMAGE_PROXY_TARGET)

$(IMAGE_PROXY_TARGET): $(PROJECT_DEPENDENCIES_PROXY_TARGETS) $(SERVER_CONF) $(SERVER_DOCKERFILE)
	docker build $(SERVER_FOLDER) -t $(LOCAL_SERVER_IMAGE_NAME) \
		> $(IMAGE_PROXY_TARGET)

# -- container --

CONTAINER_PORT=8080
CONTAINER_LOCALHOST=http://localhost:$(CONTAINER_PORT)

container: image
	container_id=$$(docker ps -aqf "name=$(LOCAL_SERVER_IMAGE_NAME)") ;\
	\
	if [ $$container_id ]	;\
		then docker stop $$container_id ;\
	fi ;\
	\
	docker run --rm -dit \
		--name=$(LOCAL_SERVER_IMAGE_NAME) \
		-p $(CONTAINER_PORT):$(CONTAINER_PORT)/tcp \
		$(LOCAL_SERVER_IMAGE_NAME) ;\
	\
	open $(CONTAINER_LOCALHOST)

# -- release! --

GCP_URL=gcr.io
GCP_PROJECT_NAME=sublime-forest-145201
GCP_IMAGE_NAME=$(GCP_URL)/$(GCP_PROJECT_NAME)/$(LOCAL_SERVER_IMAGE_NAME):latest

# TODO

# -- reset --

reset:
	rm -rf $(MAKE_FOLDER)

# -- proxy --

$(MAKE_FOLDER):
	mkdir -p $(MAKE_FOLDER)

$(MAKE_FOLDER)/Brewfile:
	brew bundle --force \
		> $(MAKE_FOLDER)/Brewfile
