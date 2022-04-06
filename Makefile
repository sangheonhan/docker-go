build:
	docker build . -t sangheon/golang --no-cache

push:
	docker push sangheon/golang

clean:
	-docker-compose down --rmi all
	-docker rm sangheon/golang
	-docker rmi sangheon/golang:latest

shell:
	docker exec -it golang /bin/zsh

start:
	docker run -itd --rm --name golang sangheon/golang:latest

stop:
	docker stop golang

up:
	docker-compose up -d

down:
	docker-compose down --rmi all
