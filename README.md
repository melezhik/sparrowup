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

    $ cd whatsup && REPO=/path/to/repo carton exec morbo app.pl

A structure of  repository should be:

    $ project-foo/sparrowfile
    $ project-bar/sparrowfile
    $ project-baz/sparrowfile

So on ...


# Running Job queue

A Minion asynchronous job executor should be launched to handle incoming check requests.

For example:

    $ cd whatsup 
    $ nohup carton exec ./app.pl minion worker -m production -I 15 -j 2 > /dev/null 2>&1 &

Follow Minion [documentation](https://metacpan.org/pod/Minion) for details on using job queue.

# Whatsup API

All the API is exposed as http service API accessible by 0.0.0.0:3000. A bind address / port number could be changed
when running service via [morbo](https://metacpan.org/pod/distribution/Mojolicious/script/morbo), follow morbo documentation.


## Schedule a server check

POST /check/$project/$server

where $server is ip address or hostname, $project is project name ( a proper directory should exist in repository )  

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
    
    $ curl -d '' 127.0.0.1:3000/check/nginx/192.168.0.0.1


Advanced usage. 

You may pass additional parameters to set up credentials to use when issuing ssh connect to target host:

### ssh-user

A ssh-user ID

### identity_file

Path to identity file

`man ssh` to know more about these parameters.

For example:

    $ curl -d ssh-user=admin -d identity_file=~/.ssh/admin.pem  127.0.0.1:3000/check/nginx/192.168.0.0.1

## Get a server status

GET /status/$server

Once check is scheduled it's queued and eventually will be executed.

For example:

    $ sleep 10
    $ curl 127.0.0.1:3000/status/192.168.0.0.1

## Reports

All generated reports are accessible as static pages.

    $ firefox 127.0.0.1:3000

# See also

* [Sparrowdo/Sparrow](https://sparrowhub.org)

* [Mojolicious](http://mojolicio.us)

* [morbo](https://metacpan.org/pod/distribution/Mojolicious/script/morbo)

* [Minion](https://metacpan.org/pod/Minion)

# AUTHOR

[Alexey Melezhik](mailto:melezhik@gmail.com)



