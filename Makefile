.PHONY: image container push

container: image
	docker run --rm -d -p 80:80/tcp -p 8080:8080/tcp gcr.io/sublime-forest-145201/daniellacos.se-proxy:latest

image: default.conf Dockerfile
	docker build . -t gcr.io/sublime-forest-145201/daniellacos.se-proxy:latest

push: image
	docker push gcr.io/sublime-forest-145201/daniellacos.se-proxy:latest
