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
use HTML::FromANSI (); # avoid exports if using OO

plugin 'Minion' => { SQLite  => 'db/minion.db'};

my $config = plugin Config => { file => '/etc/sparrowup.conf' };

require 'lib/db.pm';

helper sparrowdo_run => sub {
  
    my ($c, $project, $server, $check_id, $params) = @_;

    my $log = Mojo::Log->new();

    update_check_in_db($check_id, 'proccessing');

    if (-d "$config->{repo}/$project"){

      my $cmd = "mkdir -p $config->{reports_dir} && cd $config->{repo}/$project && timeout -s KILL 60";

      $cmd .= " sparrowdo --http_proxy=$ENV{http_proxy}" if $ENV{http_proxy};

      $cmd .= " sparrowdo --https_proxy=$ENV{https_proxy}" if $ENV{https_proxy};

      $cmd.=" --ssh_user=".($c->param('ssh_user')) if ($c->param('ssh_user')); 
  
      $cmd.=" --ssh_port=".($c->param('ssh_port')) if ($c->param('ssh_port')); 
  
      $cmd.=" --indentity_file=".($c->param('ssh_port')) if ($c->param('ssh_port')); 
  
      $cmd.=" --host=$server --bootstrap";

      $cmd.= " ssh_user=".($c->param('ssh_user')) if $c->param('ssh_user');

      $cmd.= " ssh_port=".($c->param('ssh_port')) if $c->param('ssh_port');

      $cmd.=" 1>$config->{reports_dir}/$check_id.txt 2>&1";

      $log->info("sparrowdo run scheduled ... : $cmd");

      my $st = system($cmd);

      $log->info("sparrowdo done");
  
      update_check_in_db($check_id, $st == 0 ? 'ok' : 'fail');

      $log->info("updated database entry");

  
    } else {

      $log->warn("project $config->{repo}/$project does not exist!");

      update_check_in_db($check_id,'not exist');

      $log->info("updated database entry");

    }



};

app->minion->add_task( check_task => sub { shift->app->sparrowdo_run(@_) } );

helper schedule_check => sub { shift->minion->enqueue( check_task => [@_]) };

# API

post '/job/:project'  => sub {

    my $c = shift;

    my $project = $c->stash('project');

    my $server = $c->param('server');

    my $web_ui = $c->param('web_ui');

    my $uid_obj  = Data::UUID->new;
    my $uid      = $uid_obj->create();
    my $check_id =  $uid_obj->to_string($uid);

    insert_check_into_db($check_id,$project,$server);

    my $params = {};

    $params->{ssh_user} = $c->param('ssh_user') if $c->param('ssh_user');

    $params->{ssh_port} = $c->param('ssh_port') if $c->param('ssh_port');

    $c->schedule_check($project, $server, $check_id);

    if ($web_ui){
      $c->flash( { message => "check for $project\@$server scheduled", level => 'success' })->redirect_to('/');
    }else{
      return $c->render(text => "check schedulled: $check_id\n", status => 200);
    }
};

get '/' => sub {

  my $c = shift;

  my $results = get_checks_from_db();

  $c->render( template => 'index' , results => $results  );

};


get '/report/:report'  => sub {

    my $c = shift;

    my $check_id = $c->stash('report');

    my $h = HTML::FromANSI->new(
        fill_cols   => 1, linewrap => 1, lf_to_crlf => 1, cols => 70
    );

    my $log = Mojo::Log->new();
    
    if (open REPORT, "$config->{reports_dir}/$check_id.txt"){

      $h->add_text(<REPORT>);

      close REPORT;

      return $c->render( 
        template => 'report',  
        out => $h->html, 
        check_id => $check_id  
      );
  
    } else {

      $log->error("can't open file $config->{reports_dir}/$check_id.txt to read : $!");
      return $c->render(text => "report $check_id not found", status => 404);
 
   }


    
};

sub startup {

    my $self = shift;

    $self->secret('sparrowup?');

}

app->start;

