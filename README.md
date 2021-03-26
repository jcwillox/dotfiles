# Josh's dotfiles

My personal dotfiles repo, powered by [dotbot](https://github.com/anishathalye/dotbot).

## Install

The `linux_base` config will link the `./install` file to the `dotbot` command in your `~/.local/bin`.

```bash
$ cd ~
$ git clone https://github.com/jcwillox/dotfiles
$ cd dotfiles
# ./install -U <profile>
$ ./install -U ubuntu
```

To install a specific config use:
```bash
# ./install -c <config>
$ ./install -c exa
```

## Testing

There is a prebuilt docker container available on docker hub.

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
