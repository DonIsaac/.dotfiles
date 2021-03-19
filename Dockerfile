# Mostly-static setup
FROM ubuntu:latest
RUN apt-get update && \
	apt-get -y install git vim

# Build args
ARG REPO=https://github.com/DonIsaac/.dotfiles.git
ARG USER=frank

# Setup a user with its respective files and folders
RUN mkdir -p /home/$USER
WORKDIR /home/$USER
RUN git clone $REPO

# Dotfile setup
WORKDIR /home/$USER/.dotfiles
RUN git submodule update --init --recursive
ENTRYPOINT ["/bin/bash"]
# CMD bash install


# Backup code, just in case

# RUN apt-get update && \
	# apt-get -y install git vim python3 && \
	# alias python=python3
