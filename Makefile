include .env

USER_ID=$(shell id -u)
GROUP_ID=$(shell id -g)

DOCKLE_LATEST=`(curl --silent "https://api.github.com/repos/goodwithtech/dockle/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')`

build:
	DOCKER_BUILDKIT=1 docker buildx build --push --platform linux/arm64/v8,linux/amd64 -t sangheon/golang:$(VERSION) --no-cache .

init:
	docker buildx inspect --bootstrap
	docker buildx create --name multiarch-builder --use
	docker buildx use multiarch-builder

push:
	docker push sangheon/golang:$(VERSION)

pull:
	docker pull sangheon/golang:$(VERSION)

clean:
	-docker-compose down --rmi all
	-docker rm sangheon/golang_$(VERSION)
	-docker rmi sangheon/golang:$(VERSION)

shell:
	docker exec -it golang_$(VERSION) /bin/zsh

start:
	docker run -itd --rm --name golang_$(VERSION) -e HOST_UID=$(USER_ID) -e HOST_GID=$(GROUP_ID) sangheon/golang:$(VERSION)

stop:
	docker stop golang_$(VERSION)

sandbox:
	docker run --interactive --tty --rm --name golang_$(VERSION) -e HOST_UID=$(USER_ID) -e HOST_GID=$(GROUP_ID) --volume $(PWD):/app/ sangheon/golang:$(VERSION) /bin/zsh

lint:
	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock goodwithtech/dockle:v${DOCKLE_LATEST} sangheon/golang:$(VERSION)
