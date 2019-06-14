.PHONY: image

image: default.conf Dockerfile
	docker build . -t daniellacos.se-proxy:latest
