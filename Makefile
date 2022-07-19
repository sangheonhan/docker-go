include .env

DOCKLE_LATEST=`(curl --silent "https://api.github.com/repos/goodwithtech/dockle/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')`

build:
	DOCKER_BUILDKIT=1 docker build . -t sangheon/golang:$(VERSION) --no-cache

push:
	docker push sangheon/golang:$(VERSION)

clean:
	-docker-compose down --rmi all
	-docker rm sangheon/golang_$(VERSION)
	-docker rmi sangheon/golang:$(VERSION)

shell:
	docker exec -it golang_$(VERSION) /bin/zsh

start:
	docker run -itd --rm --name golang_$(VERSION) sangheon/golang:$(VERSION)

stop:
	docker stop golang_$(VERSION)

up:
	docker-compose up -d

down:
	docker-compose down --rmi local

lint:
	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock goodwithtech/dockle:v${DOCKLE_LATEST} sangheon/golang:$(VERSION)
