sub insert_check_into_db {

    my $check_id = shift or confess 'usage: insert_check_into_db(*check_id,project,server)';
    my $project  = shift or confess 'usage: insert_check_into_db(check_id,*project,server)';
    my $server   = shift or confess 'usage: insert_check_into_db(check_id,project,*server)';

    my $sql = Mojo::SQLite->new('sqlite:db/main.db');

    my $db = $sql->db;

    $db->query( 
      'insert into checks ( check_id, project, server ) values ( ?, ?, ? )', 
      $check_id, $project, $server 
    );


    return;
}

sub update_check_in_db {

    my $check_id = shift or confess 'usage: update_check_in_db(*check_id,status)';

    my $status = shift or confess 'usage: update_check_in_db(check_id,*status)';

    my $sql = Mojo::SQLite->new('sqlite:db/main.db');

    my $db = $sql->db;

    $db->query('update checks set status = ? where  check_id = ?', $status, $check_id );

    return;
}

sub get_checks_from_db {

    my $sql = Mojo::SQLite->new('sqlite:db/main.db');

    my $db = $sql->db;

    my $db_results = $db->query('select check_id, project, server, status, t from checks order by t desc');

    my $list;

    while ( my $next = $db_results->array ){

        push @$list, {
            check_id   => $next->[0],
            project    => $next->[1],
            server     => $next->[2],
            status     => $next->[3],
            time       => $next->[4],
        };

    }

    return $list;
}

1;

