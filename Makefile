include .env

USERNAME=app
USER_ID=$(shell id -u)
GROUP_ID=$(shell id -g)

DOCKLE_LATEST=`(curl --silent "https://api.github.com/repos/goodwithtech/dockle/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')`

build:
	DOCKER_BUILDKIT=1 docker buildx build --push --platform linux/arm64/v8,linux/amd64 -t sangheon/golang:$(VERSION) --no-cache .
	$(MAKE) pull

testbuild:
	docker build -t sangheon/go:$(VERSION)-build .

testrun:
	docker run -it --rm --name go_$(VERSION)-build -e HOST_UID=$(USER_ID) -e HOST_GID=$(GROUP_ID) sangheon/go:$(VERSION)-build /bin/zsh

init:
	docker buildx inspect --bootstrap
	docker buildx create --name multiarch-builder --use
	docker buildx use multiarch-builder

push:
	docker push sangheon/golang:$(VERSION)

pull:
	docker pull sangheon/golang:$(VERSION)

clean:
	-docker rm sangheon/golang_$(VERSION)
	-docker rmi sangheon/golang:$(VERSION)

shell:
	docker exec -it -u $(USERNAME) golang_$(VERSION) /bin/zsh

start:
	docker run -itd --name golang_$(VERSION) -e HOST_UID=$(USER_ID) -e HOST_GID=$(GROUP_ID) sangheon/golang:$(VERSION)
	$(MAKE) log

stop:
	docker stop golang_$(VERSION)

log:
	docker logs -f golang_$(VERSION)

workspace:
	docker run -itd --name golang_$(VERSION) -e HOST_UID=$(USER_ID) -e HOST_GID=$(GROUP_ID) --volume "$(PWD)":/app/ sangheon/golang:$(VERSION)
	$(MAKE) log

sandbox:
	docker run -it --rm --name golang_$(VERSION) -e HOST_UID=$(USER_ID) -e HOST_GID=$(GROUP_ID) --volume "$(PWD)":/app/ sangheon/golang:$(VERSION) /bin/zsh

lint:
	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock goodwithtech/dockle:v${DOCKLE_LATEST} sangheon/golang:$(VERSION)