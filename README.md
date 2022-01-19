# Josh's dotfiles

My personal dotfiles repo, powered by [dotbot](https://github.com/jcwillox/dotbot).

[![asciicast](https://asciinema.org/a/462686.svg)](https://asciinema.org/a/462686)

## Install

This will install dotbot into `~/.local/bin` then clone this repo and run the default profile.

```bash
sh -c "$(curl -fsSL tinyurl.com/dotbot)" -- init --apply jcwillox
```

## Testing

There is a prebuilt docker container available based on the `full` profile.

```bash
docker run --rm -ti -e TZ=Australia/Sydney --name dotfiles ghcr.io/jcwillox/dotfiles:latest
```

You can also build/run the test docker container using:

```bash
# build & run dev container
task docker
# build & run full container
task docker-full
```
