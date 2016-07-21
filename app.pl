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
use Cwd;

use constant repo_root => 'public/';

plugin 'Minion' => { SQLite  => 'db/minion.db'};

require 'lib/db.pm';

helper sparrowdo_run => sub {
  
    my ($c, $project, $server, $params) = @_;

    my $uid_obj  = Data::UUID->new;
    my $uid      = $uid_obj->create();
    my $check_id =  $uid_obj->to_string($uid);

    if (-d "$ENV{REPO}/$project"){

      my $cdir = getcwd;

      my $cmd = "cd $ENV{REPO}/$project && sparrowdo --http_proxy=$ENV{http_proxy} --https_proxy=$ENV{https_proxy}";
  
      $cmd.=" --ssh_user=".($c->param('ssh_user')) if ($c->param('ssh_user')); 
  
      $cmd.=" --ssh_port=".($c->param('ssh_port')) if ($c->param('ssh_port')); 
  
      $cmd.=" --indentity_file=".($c->param('ssh_port')) if ($c->param('ssh_port')); 
  
      $cmd.=" 1>$cdir/public/$check_id.txt 2>&1";
  
      insert_check_into_db($check_id);
  
      my $st = system($cmd);
  
      update_check_in_db($check_id,$st == 0 ? 'ok' : 'fail');
  
    } else {

      update_check_in_db($check_id,'not exist');

    }



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

