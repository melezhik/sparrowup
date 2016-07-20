
use strict;
use Mojolicious::Lite;
use Carp;
use File::Basename;
use Mojo::Log;
use Mojo::SQLite;
use Minion::Backend;
use Minion;

use constant repo_root => 'public/';

plugin 'Minion' => { SQLite  => 'db/minion.db'};

helper sparrowdo_run => sub {
  
    my ($c, $project, $server, $params) = @_;

    die "check failed!" 
      unless system("cd $ENV{REPO}/$project && sparrowdo --http_proxy=$ENV{http_proxy} --https_proxy=$ENV{https_proxy}  --host=$server");

};

app->minion->add_task( check_task => sub { shift->app->sparrowdo_run(@_) } );

helper schedule_check => sub { shift->minion->enqueue( check_task => [@_]) };

# API

post '/check/:project/:server'  => sub {

    my $c = shift;

    my $project = $c->stash('project');

    my $server = $c->stash('server');

    $c->schedule_check
}

