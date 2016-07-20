# SYNOPSIS

A simple Sparrowdo based monitoring tool

# Prerequisites

Sparrowdo


# INSTALL

    $ panda install Sparrowdo
    $ git clone https://github.com/melezhik/whatsup.git
    $ cd whatsup
    $ carton


# Configuration

You sould checkout some sparrowdo scenarios:


    $ git clone $some-remote-repository /path/to/repo

And point it to the running wu service:

    $ cd whatsup REPO=/path/to/repo carton exec morbo app.pl

A structure of  reposiotory should be:

    $ project-foo/sparrowfile
    $ project-bar/sparrowfile
    $ project-baz/sparrowfile

So on ...


# Whatsup api

All the API is exposed as http service API accessible by 0.0.0.0:3000. A port number could be changed
when running service via morbo, follow morbo documentation.


## Schedule a server check

    $ curl 127.0.0.1:3000


# See also

* [Sparrowdo/Sparrow](https://sparrowhub.org)

* [Mojolicious](http://mojolicio.us)

# AUTHOR

[Alexey Melezhik](mailto:melezhik@gmail.com)



