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

You should checkout some sparrowdo scenarios:


    $ git clone $some-remote-repository /path/to/repo

And point it to the running whatsup service:

    $ cd whatsup REPO=/path/to/repo carton exec morbo app.pl

A structure of  repository should be:

    $ project-foo/sparrowfile
    $ project-bar/sparrowfile
    $ project-baz/sparrowfile

So on ...


# Whatsup api

All the API is exposed as http service API accessible by 0.0.0.0:3000. A bind adress / port number could be changed
when running service via [morbo](https://metacpan.org/pod/distribution/Mojolicious/script/morbo), follow morbo documentation.


## Schedule a server check

POST /check/$server/$project

where $server is ip adress or host-name, $project is project name ( a proper directory should exist in repository )  

Example:

    # Checks if nginx is running on 192.168.0.1

    $ cat /path/to/repo/nginx/sparrowdo

    task_run  %(
      task => 'check my nginx process',
      plugin => 'proc-validate',
      parameters => %(
        pid_file => '/var/run/nginx.pid',
        footprint => 'nginx.*master'
      )
    );
    
    $ curl -d '' 127.0.0.1:3000/check/192.168.0.0.1/nginx


# See also

* [Sparrowdo/Sparrow](https://sparrowhub.org)

* [Mojolicious](http://mojolicio.us)

* [morbo](https://metacpan.org/pod/distribution/Mojolicious/script/morbo)

# AUTHOR

[Alexey Melezhik](mailto:melezhik@gmail.com)



