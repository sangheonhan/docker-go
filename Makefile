include .env

DOCKLE_LATEST=`(curl --silent "https://api.github.com/repos/goodwithtech/dockle/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')`

build:
	DOCKER_BUILDKIT=1 docker buildx build --push --platform linux/arm64/v8,linux/amd64 -t sangheon/golang:$(VERSION) --no-cache .
	$(MAKE) pull

testbuild:
	docker build -t sangheon/go:$(VERSION)-build .

testrun:
	docker run -it --rm --name go_$(VERSION)-build sangheon/go:$(VERSION)-build /bin/zsh

init:
	docker buildx inspect --bootstrap
	docker buildx create --name multiarch-builder --use
	docker buildx use multiarch-builder

push:
	docker push sangheon/golang:$(VERSION)

pull:
	docker pull sangheon/golang:$(VERSION)

clean:
	-docker rm golang_$(VERSION)
	-docker rmi sangheon/golang:$(VERSION)

shell:
	docker exec -it golang_$(VERSION) /bin/zsh

start:
	docker run -itd --name golang_$(VERSION) sangheon/golang:$(VERSION)

stop:
	docker stop golang_$(VERSION)

log:
	docker logs -f golang_$(VERSION)

workspace:
	docker run -itd --name golang_$(VERSION) --volume "$(PWD)":/app/ sangheon/golang:$(VERSION)

sandbox:
	docker run -it --rm --name golang_$(VERSION) --volume "$(PWD)":/app/ sangheon/golang:$(VERSION) /bin/zsh

lint:
	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock goodwithtech/dockle:v${DOCKLE_LATEST} sangheon/golang:$(VERSION)
