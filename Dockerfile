FROM python:buster

ENV USER test
ENV TERM xterm-256color
ENV DOTBOT_NO_UPDATE_REPO 1
ENV CI true

RUN apt update && apt install -y sudo zsh

RUN sh -c "$(curl -fsSL https://github.com/jcwillox/dotbot/raw/main/scripts/install/dotbot.sh)"
RUN dotbot completion zsh > /usr/share/zsh/vendor-completions/_dotbot

# disable sudo warning
RUN echo "Defaults	lecture=never" >> /etc/sudoers

# create user 'test' with password '1'
RUN useradd -p $(openssl passwd -1 "1") test -G sudo

USER test

COPY --chown=test:test . /home/test/dotfiles

RUN mkdir -p /home/test/.local/state/dotbot \
    && echo "{\"directory\": \"/home/test/dotfiles\"}" > /home/test/.local/state/dotbot/state.json

WORKDIR /home/test

CMD "bash"
