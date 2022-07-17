# Mostly-static setup
FROM ubuntu:latest
RUN apt-get update && \
	apt-get install -q -y --no-install-recommends apt-utils dialog && \
	apt-get update && \
    apt-get install -y -q sudo git jq curl

# Build args
ARG REPO=https://github.com/DonIsaac/.dotfiles.git

# Setup a user with its respective files and folders
WORKDIR /root
RUN git clone $REPO

# Dotfile setup
WORKDIR /root/.dotfiles
RUN pwd
RUN git submodule update --init --recursive
# RUN ./install.sh

# Start commands
CMD cd /root/.dotfiles && bash install.sh --install all && bash
# CMD ["/bin/bash"]

