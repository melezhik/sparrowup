# SYNOPSIS

Launch sparrowdo scenarios on remote hosts.

# Prerequisites

Sparrowdo should be installed on the same hosts where sparrowup service gets run.

# INSTALL

    $ panda install Sparrowdo
    $ git clone https://github.com/melezhik/sparrowup.git
    $ cd sparrowup
    $ carton


# Configuration

## Set up sparrowdo repository

You should checkout some sparrowdo scenarios:

    $ git clone $some-remote-repository /path/to/repo

A structure of  repository should be:

    $ project-foo/sparrowfile
    $ project-bar/sparrowfile
    $ project-baz/sparrowfile

So on ...

## Set up sparrowup service configuration file. 

This is should be Mojolicious::Config file placed at /etc/sparrowup.conf path.

    $ cat /etc/sparrowup.conf

    {
      'repo' => '/home/sparrowup/sparrowup_repo',
      'reports_dir' => '/home/sparrowup/reports'
    }
    
Configuration parameters:

### repo

Path to the directory with sparrowdo scenarios

## reports_dir

A directory where reports data will be kept. Should be writable by sparrowup service.


## Populate database

    $ bash utils/populate_db.bash

## Run sparrowup service

This is a mojo application, thus:

    $ carton exec morbo app.pl

## Run job queue 

A minion asynchronous job executor should be launched to handle incoming job requests.

For example:

    $ carton exec ./app.pl minion worker 

Follow Minion [documentation](https://metacpan.org/pod/Minion) for details on minion job queue.

# sparrowup API

All the API is exposed as http service API accessible by 0.0.0.0:3000. A bind address / port number could be changed
when running service via [morbo](https://metacpan.org/pod/distribution/Mojolicious/script/morbo), follow morbo documentation.

## Schedule a job

POST $server /job/$project

where $server is ip address or hostname, $project is project name ( a proper directory should exist in repository )  

Example:

    # Checks if nginx is running on 192.168.0.1

    $ cat /path/to/repo/nginx/sparrowfile

    task_run  %(
      task => 'check my nginx process',
      plugin => 'proc-validate',
      parameters => %(
        pid_file => '/var/run/nginx.pid',
        footprint => 'nginx.*master'
      )
    );
    
    $ curl -d 'server=192.168.0.0.1' 127.0.0.1:3000/job/nginx


## Advanced usage. 

Setting sparrowdo client parameters.

You may pass additional parameters consuming by sparrowdo client:

### ssh_user

A ssh_user ID

### ssh_port

A server ssh port to connect to

Follow [sparrowdo documentation](https://github.com/melezhik/sparrowdo#sparrowdo-client-command-line-parameters)
to know more about sparrowdo client parameters.

For example:

    $ curl -d server=192.168.0.0.1 -d ssh_user=vagrant -d ssh_port=2222  127.0.0.1:3000/check/nginx

## Get a server status

GET /status/$server

Once job is scheduled it's queued and eventually will be executed.

For example:

    $ curl -d 'server=192.168.0.0.2' 127.0.0.1:3000/job/perl-app
    $ sleep 10
    $ curl -G -d server=192.168.0.2 127.0.0.1:3000/status?server=192.168.0.2

## Reports

All generated reports are accessible via service Web UI:

    $ firefox 127.0.0.1:3000

# See also

* [Sparrowdo/Sparrow](https://sparrowhub.org)

* [Mojolicious](http://mojolicio.us)

* [morbo](https://metacpan.org/pod/distribution/Mojolicious/script/morbo)

* [Minion](https://metacpan.org/pod/Minion)

# AUTHOR

[Alexey Melezhik](mailto:melezhik@gmail.com)



