.PHONY: image container

container: image
	docker run --rm -d -p 80:80/tcp -p 8080:8080/tcp daniellacos.se-proxy:latest

image: default.conf Dockerfile
	docker build . -t daniellacos.se-proxy:latest
