NGINX_DFAULT_CONF=nginx/default.conf
CONTAINER_NAME=daniellacos.se-proxy
CONTAINER_PORT=8080
IMAGE_NAME=gcr.io/sublime-forest-145201/$(CONTAINER_NAME):latest

.PHONY: image container push

container: image
	container_id=$$(docker ps -apf "name=$(CONTAINER_NAME)") ;\
	\
	if [ $$container_id ]; then \
		docker stop $$container_id ;\ 
	fi ;\
	\
	docker run --rm -d --name=$(CONTAINER_NAME) -p $(CONTAINER_PORT):$(CONTAINER_PORT)/tcp $(IMAGE_NAME) ;\
	open localhost:$(CONTAINER_PORT)

image: $(NGINX_DFAULT_CONF) Dockerfile
	docker build . -t $(IMAGE_NAME)

push: image
	docker push $(IMAGE_NAME)
