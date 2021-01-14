FROM ubuntu:focal

RUN apt update && apt install -y sudo python3 unzip curl git zsh

# add user 'test' with password 'password'
RUN useradd -p $(openssl passwd -1 password) test -G sudo

USER test

COPY --chown=test:test . /home/test/dotfiles

ENV USER test
ENV TERM xterm-256color

WORKDIR /home/test/dotfiles