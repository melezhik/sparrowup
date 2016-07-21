sub insert_check_into_db {

    my $check_id = shift or confess 'usage: insert_check_into_db(*check_id)';

    my $sql = Mojo::SQLite->new('sqlite:db/main.db');

    my $db = $sql->db;

    $db->query( 'insert into checks ( check_id ) values (?)', $check_id );


    return;
}

sub update_check_in_db {

    my $check_id = shift or confess 'usage: update_check_in_db(*check_id,state)';

    my $state = shift or confess 'usage: update_check_in_db(check_id,*state)';

    my $sql = Mojo::SQLite->new('sqlite:db/main.db');

    my $db = $sql->db;

    $db->query('update users set state = ? where  check_id = ?', $state, $check_id );

    return;
}

sub get_checks_from_db {

    my $sql = Mojo::SQLite->new('sqlite:db/main.db');

    my $db = $sql->db;

    my $db_results = $db->query('select check_id, status, t');

    my $list;

    while ( my $next = $db_results->array ){

        push @$list, {
            check_id   => $next->[0],
            status     => $next->[1],
            time       => $next->[2],
        };

    }

    return $list;
}

1;

