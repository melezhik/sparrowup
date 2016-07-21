#!/usr/bin/env perl

use strict;
use Mojolicious::Lite;
use Carp;
use Data::UUID;
use File::Basename;
use Mojo::Log;
use Mojo::SQLite;
use Minion::Backend;
use Minion;

use constant repo_root => 'public/';

plugin 'Minion' => { SQLite  => 'db/minion.db'};

helper sparrowdo_run => sub {
  
    my ($c, $project, $server, $params) = @_;

    my $uid_obj = Data::UUID->new;
    my $uid     = $uid_obj->create();
    my $token =  $uid_obj->to_string($uid);

    my $cmd = "cd $ENV{REPO}/$project && sparrowdo --http_proxy=$ENV{http_proxy} --https_proxy=$ENV{https_proxy}";

    $cmd.=" --host=$server 1>public/$token.txt 2>&1"

    $cmd.=" --ssh_user=".($c->param('ssh_user')) if ($c->param('ssh_user')); 

    $cmd.=" --ssh_port=".($c->param('ssh_port')) if ($c->param('ssh_port')); 

    $cmd.=" --indentity_file=".($c->param('ssh_port')) if ($c->param('ssh_port')); 

    $cmd.=" 1>public/$token.txt 2>&1"

    $st = system($cmd);


};

app->minion->add_task( check_task => sub { shift->app->sparrowdo_run(@_) } );

helper schedule_check => sub { shift->minion->enqueue( check_task => [@_]) };

# API

post '/check/:project'  => sub {

    my $c = shift;

    my $project = $c->stash('project');

    my $server = $c->param('server');

    $c->schedule_check($project, $server);

    return $c->render(text => "check schedulled\n", status => 200);

};



app->start;

