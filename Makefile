LOGIN_CMD := "docker login $(REGISTRY)"
REGISTRY ?= fay3
NAME ?= go-api-app-demo

build: build-app

build-app:
	go build -o ./bin/api-app ./api-app

build-docker:
	docker build -t $(REGISTRY)/$(NAME):latest .

test-docker: build-docker
	container-structure-test test --image $(REGISTRY)/$(NAME):latest --config tests/docker/container-structure-test.yaml

save:
	docker save $(REGISTRY)/$(NAME):latest -o $(NAME)_latest.tar

load:
	docker load -i $(NAME)_latest.tar

push:
	docker push $(REGISTRY)/$(NAME):latest
