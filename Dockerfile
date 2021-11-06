# Mostly-static setup
FROM ubuntu:latest
RUN apt-get update && \
	apt-get install -y --no-install-recommends apt-utils && \
	apt-get update && \
    apt-get install -y git vim jq curl

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
CMD cd /root/.dotfiles && bash install.sh && bash
# CMD ["/bin/bash"]




# Backup code, just in case

# RUN apt-get update && \
	# apt-get -y install git vim python3 && \
	# alias python=python3
