# Mostly-static setup
FROM ubuntu:latest
RUN apt update && apt install git vim

# Build args
ARG REPO=https://github.com/DonIsaac/.dotfiles.git
ARG USER=frank

# Setup a user with its respective files and folders
RUN mkdir -p /home/$USER
WORKDIR /home/$USER
RUN git clone $REPO

# Dotfile setup
WORKDIR /home/$USER/.dotfiles
ENTRYPOINT ["/bin/bash"]
CMD ./install
