# Josh's dotfiles

My personal dotfiles repo, powered by [dotbot](https://github.com/jcwillox/dotbot).

## Install

This will install dotbot into your `~/.local/bin` then clone and run the default profile

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
# run
./docker-test
# build & run
./docker-test build
```
