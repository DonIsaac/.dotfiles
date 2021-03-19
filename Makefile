.PHONY: clean run docker-stop

IMAGE_NAME = donisaac/dotfiles
CONTAINER_NAME = dotfiles

run: build.target docker-stop
	docker run -it --name $(CONTAINER_NAME) $(IMAGE_NAME)

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
