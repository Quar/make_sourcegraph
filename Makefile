VERSION ?= 2.10.0

include VERSION

DOCKER_IMAGE_NAME = sourcegraph/server
CONTAINER_NAME = sourcegraph

.PHONY: run
run:
	docker run -d --publish 7080:7080 --rm \
	  --volume ~/.sourcegraph/config:/etc/sourcegraph \
	  --volume ~/.sourcegraph/data:/var/opt/sourcegraph \
	  --volume /var/run/docker.sock:/var/run/docker.sock \
	  --name $(CONTAINER_NAME) \
	  $(DOCKER_IMAGE_NAME):$(VERSION)


.PHONY: stop
stop:
	docker stop $(CONTAINER_NAME)


.PHONY: upgrade
upgrade:
	$(MAKE) stop || :
	docker image ls -aq --filter=reference='$(DOCKER_IMAGE_NAME)' | \
	  xargs docker rmi
	docker run -d --publish 7080:7080 --rm \
	  --volume ~/.sourcegraph/config:/etc/sourcegraph \
	  --volume ~/.sourcegraph/data:/var/opt/sourcegraph \
	  --volume /var/run/docker.sock:/var/run/docker.sock \
	  --name $(CONTAINER_NAME) \
	  $(DOCKER_IMAGE_NAME):latest


