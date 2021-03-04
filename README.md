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
# $ ./install -c <config>
$ ./install -c exa
```

## Testing

You can build/run the test docker container using:

```bash
# run
./docker-test
# build & run
./docker-test build
```
