# TODO

## Get a pre-configured dockerfile or working image

* Alpine and Pandas seem not to go well with another.
* Furthermore the libraries have to be compiled from source, because Alpine musl seems to be different: * `'musl-libc is not compatible to Python's Wheels format, all packages installed with pip have to be built from source'.` See
[Installing pandas in docker Alpine](https://stackoverflow.com/a/54934050)
