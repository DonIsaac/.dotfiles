.PHONY: clean run docker-stop

IMAGE_NAME := donisaac/dotfiles
CONTAINER_NAME := dotfiles

RUN_ARGS := -it --name $(CONTAINER_NAME) -v $(shell pwd):/root/.dotfiles

# ifdef $(LOCAL)
	# RUN_ARGS += -v $(shell pwd):/home/frank/.dotfiles
# endif


run: build.target docker-stop
	docker run $(RUN_ARGS) $(IMAGE_NAME)

build.target: Dockerfile
	docker build -t $(IMAGE_NAME) .
	@touch build.target


clean: docker-stop
	@echo ">>> cleaning artifacts"
	@rm -f build.target
	@docker image rm $(IMAGE_NAME)

docker-stop:
	@echo ">>> Stopping and removing containers"
	@# Do not cause script to fail if container doesn't exist or is already stopped
	@docker container stop $(CONTAINER_NAME) || true
	@docker container rm $(CONTAINER_NAME) || true
