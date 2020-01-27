LOGIN_CMD := "docker login $(REGISTRY)"
REGISTRY ?= fay3
NAME ?= go-api-app-demo

build: build-app

build-app:
	go build -o ./bin/api-app ./api-app

build-docker:
	docker build -t $(REGISTRY)/$(NAME):latest .

test:
	container-structure-test test --image $(REGISTRY)/$(NAME):$(BUMPED_VERSION) --config tests/container-structure-test.yaml

push:
	docker push $(REGISTRY)/$(NAME):latest