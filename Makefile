LOGIN_CMD := "docker login $(REGISTRY)"
REGISTRY ?= fay3
ECR_REGISTRY_URL ?= fay3
CIRCLE_SHA1 ?= 00000
NAME ?= go-rest-api-demo

build: build-app

build-app:
	go build -o ./bin/api-app ./api-app

build-local:
	docker-compose up

remove-local:
	docker-compose down --rmi local

test-local:
	docker-compose -f docker-compose-test.yaml up --exit-code-from cypress

remove-test-local:
	docker-compose -f docker-compose-test.yaml down --rmi local

build-docker:
	docker build -t $(REGISTRY)/$(NAME):${CIRCLE_SHA1} -t $(ECR_REGISTRY_URL)/$(NAME):${CIRCLE_SHA1} .

test-docker: build-docker
	container-structure-test test --image $(REGISTRY)/$(NAME):${CIRCLE_SHA1} --config tests/docker/container-structure-test.yaml

save:
	docker save $(REGISTRY)/$(NAME):${CIRCLE_SHA1} -o $(NAME)_latest.tar
	docker save $(ECR_REGISTRY_URL)/$(NAME):${CIRCLE_SHA1} -o $(NAME)_ECR_latest.tar

load:
	docker load -i $(NAME)_latest.tar && docker load -i $(NAME)_ECR_latest.tar

tag_docker: load
	docker tag $(REGISTRY)/$(NAME):${CIRCLE_SHA1} $(REGISTRY)/$(NAME):latest
	docker tag $(ECR_REGISTRY_URL)/$(NAME):${CIRCLE_SHA1} $(ECR_REGISTRY_URL)/$(NAME):latest

push_version:
	docker push $(REGISTRY)/$(NAME):${CIRCLE_SHA1} && docker push $(ECR_REGISTRY_URL)/$(NAME):${CIRCLE_SHA1}

push: push_version
	docker push $(REGISTRY)/$(NAME):latest && docker push $(ECR_REGISTRY_URL)/$(NAME):latest
