VERSION=1.18.3

build:
	docker build . -t sangheon/golang:$(VERSION) --no-cache

push:
	docker tag sangheon/golang:$(VERSION) sangheon/golang:latest
	docker push sangheon/golang:$(VERSION)
	docker push sangheon/golang:latest

clean:
	-docker-compose down --rmi all
	-docker rm sangheon/golang
	-docker rmi sangheon/golang:$(VERSION)
	-docker rmi sangheon/golang:latest

shell:
	docker exec -it golang /bin/zsh

start:
	docker run -itd --rm --name golang sangheon/golang:$(VERSION)

stop:
	docker stop golang

up:
	docker-compose up -d

down:
	docker-compose down --rmi all
